"""LaTeX compilation endpoint."""

import base64
from dataclasses import dataclass

import structlog
from fastapi import APIRouter, Depends, Request
from fastapi.responses import ORJSONResponse

from app.auth import require_api_key
from app.compiler import compile_latex
from app.config import settings
from app.errors import CompilationError, ErrorEnvelope, ValidationError
from app.limiter import limiter
from app.models import CompileRequest, Engine

logger = structlog.get_logger()
router = APIRouter(prefix="/api/v1", tags=["compile"])


# ---------------------------------------------------------------------------
# Request parsing — clean extraction from either JSON or multipart form
# ---------------------------------------------------------------------------
@dataclass
class _ParsedRequest:
    """Normalized compilation request from either JSON body or form upload."""

    content: bytes
    engine: str
    main_file: str
    draft: bool
    enable_cache: bool
    is_zip: bool


async def _parse_json(request: Request) -> _ParsedRequest:
    """Parse a JSON body compile request.

    Raises:
        ValidationError: On missing or empty source, or invalid fields.
    """
    try:
        raw = await request.json()
    except Exception:
        raise ValidationError("Invalid JSON body.") from None

    try:
        body = CompileRequest(**raw)
    except Exception as e:
        raise ValidationError(
            f"Invalid request fields: {e}",
            detail={"hint": f"Valid engines: {[e.value for e in Engine]}"},
        ) from None

    if not body.source or not body.source.strip():
        raise ValidationError("Empty source. Provide LaTeX source code.")

    return _ParsedRequest(
        content=body.source.encode("utf-8"),
        engine=body.engine.value,
        main_file=body.main_file,
        draft=body.draft,
        enable_cache=body.enable_cache,
        is_zip=False,
    )


async def _parse_multipart(request: Request) -> _ParsedRequest:
    """Parse a multipart form compile request.

    Raises:
        ValidationError: On missing file, oversized upload, or invalid engine.
    """
    form = await request.form()
    file = form.get("file")
    if file is None:
        raise ValidationError("Multipart form must include a 'file' field.")

    content = await file.read()
    if len(content) > settings.max_upload_size_bytes:
        raise ValidationError(f"File too large. Max {settings.max_upload_size_mb} MB.")

    engine_str = form.get("engine", Engine.PDFLATEX.value)
    try:
        engine = Engine(engine_str)
    except ValueError:
        raise ValidationError(
            f"Invalid engine '{engine_str}'.",
            detail={"valid_engines": [e.value for e in Engine]},
        ) from None

    main_file = form.get("main_file", "main.tex")
    draft = str(form.get("draft", "false")).lower() in ("true", "1", "yes")
    enable_cache = str(form.get("enable_cache", "true")).lower() in ("true", "1", "yes")

    return _ParsedRequest(
        content=content,
        engine=engine.value,
        main_file=main_file,
        draft=draft,
        enable_cache=enable_cache,
        is_zip=True,
    )


async def _parse_request(request: Request) -> _ParsedRequest:
    """Dispatch to JSON or multipart parser based on Content-Type.

    Raises:
        ValidationError: On unsupported content type.
    """
    content_type = request.headers.get("content-type", "")

    if "application/json" in content_type:
        return await _parse_json(request)

    if "multipart/form-data" in content_type:
        return await _parse_multipart(request)

    raise ValidationError("Provide either JSON body with 'source' or multipart form with 'file'.")


# ---------------------------------------------------------------------------
# Endpoint
# ---------------------------------------------------------------------------
@router.post(
    "/compile",
    responses={
        200: {
            "description": "Compilation successful. Returns JSON with base64-encoded PDF and compilation log.",
            "content": {"application/json": {}},
            "headers": {
                "X-Compilation-Time": {
                    "description": "Time taken to compile in seconds",
                    "schema": {"type": "string", "example": "2.31"},
                },
                "X-Engine": {
                    "description": "Engine used (e.g. pdflatex)",
                    "schema": {"type": "string", "example": "pdflatex"},
                },
                "X-Warnings-Count": {
                    "description": "Number of LaTeX warnings found in the log",
                    "schema": {"type": "string", "example": "3"},
                },
                "X-Cached": {
                    "description": "true if served from LRU cache, false if freshly compiled",
                    "schema": {"type": "string", "example": "false"},
                },
                "X-Passes-Run": {
                    "description": "Number of multi-pass iterations run (1-3)",
                    "schema": {"type": "string", "example": "2"},
                },
                "X-Request-ID": {
                    "description": "Request correlation ID",
                    "schema": {"type": "string", "example": "a1b2c3d4..."},
                },
            },
        },
        400: {"model": ErrorEnvelope, "description": "Invalid input"},
        401: {"model": ErrorEnvelope, "description": "Missing API Key"},
        403: {"model": ErrorEnvelope, "description": "Invalid API Key"},
        413: {"model": ErrorEnvelope, "description": "Zip upload too large"},
        422: {"model": ErrorEnvelope, "description": "LaTeX compilation failed"},
        429: {"model": ErrorEnvelope, "description": "Rate limited"},
    },
    response_model_exclude_unset=True,
    summary="Compile LaTeX → PDF",
    description=(
        "Compiles LaTeX source code into a PDF document.\n\n"
        "### Input Modes\n"
        "1. **Single File (JSON)**: Send `application/json` with the raw `source` code. "
        "Best for simple text documents.\n"
        "2. **Multi-File Project (Multipart)**: Send `multipart/form-data` with a zip archive "
        "in the `file` field. Best for documents with images, custom `.cls` files, "
        "or BibTeX `.bib` files.\n\n"
        "### Optimization\n"
        "- Use `enable_cache=true` to get ~10ms responses for unchanged inputs.\n"
        "- Use `draft=true` to replace images with fast-rendering placeholder boxes "
        "during live preview editing.\n\n"
        "**Note:** To test the multipart upload mode via Swagger UI, expand the endpoint "
        "and select `multipart/form-data` in the dropdown below."
    ),
    openapi_extra={
        "requestBody": {
            "content": {
                "application/json": {
                    "schema": {"$ref": "#/components/schemas/CompileRequest"}
                },
                "multipart/form-data": {
                    "schema": {
                        "type": "object",
                        "properties": {
                            "file": {
                                "type": "string",
                                "format": "binary",
                                "description": "ZIP archive containing your LaTeX project (.tex, images, .bib, etc.)",
                            },
                            "engine": {
                                "type": "string",
                                "enum": ["pdflatex", "xelatex", "lualatex", "latexmk"],
                                "default": "pdflatex",
                                "description": "Compilation engine",
                            },
                            "main_file": {
                                "type": "string",
                                "default": "main.tex",
                                "description": "Entry point .tex file inside the zip archive",
                            },
                            "draft": {
                                "type": "boolean",
                                "default": False,
                                "description": "Skip image rendering for faster previews",
                            },
                            "enable_cache": {
                                "type": "boolean",
                                "default": True,
                                "description": "Use LRU compilation cache",
                            },
                        },
                        "required": ["file"],
                    }
                },
            },
            "required": True,
        }
    },
)
@limiter.limit(settings.rate_limit)
async def compile_endpoint(
    request: Request,
    api_key: str = Depends(require_api_key),
) -> ORJSONResponse:
    """Compile LaTeX source into PDF."""
    req = await _parse_request(request)

    logger.info(
        "compile_request_parsed",
        engine=req.engine,
        main_file=req.main_file,
        draft=req.draft,
        is_zip=req.is_zip,
    )

    try:
        result = await compile_latex(
            content=req.content,
            engine=req.engine,
            main_file=req.main_file,
            draft=req.draft,
            enable_cache=req.enable_cache,
            is_zip=req.is_zip,
        )
    except ValueError as e:
        # main_file validation or zip extraction errors
        raise ValidationError(str(e)) from None

    if not result.success:
        raise CompilationError(
            detail={
                "log": result.log,
                "engine": result.engine,
                "compilation_time": result.compilation_time,
                "passes_run": result.passes_run,
            },
        )

    return ORJSONResponse(
        content={
            "pdf": base64.b64encode(result.pdf_bytes).decode("utf-8"),
            "log": result.log,
            "synctex": base64.b64encode(result.synctex_bytes).decode("utf-8") if result.synctex_bytes else None,
        },
        headers={
            "X-Compilation-Time": f"{result.compilation_time:.2f}",
            "X-Engine": result.engine,
            "X-Warnings-Count": str(result.warnings_count),
            "X-Cached": str(result.cached).lower(),
            "X-Passes-Run": str(result.passes_run),
        },
    )
