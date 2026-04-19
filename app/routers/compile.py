"""LaTeX compilation endpoint."""

from dataclasses import dataclass

import structlog
from fastapi import APIRouter, Depends, Request
from fastapi.responses import Response

from app.auth import require_api_key
from app.compiler import compile_latex
from app.config import settings
from app.errors import CompilationError, ErrorEnvelope, ValidationError
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
        200: {"content": {"application/pdf": {}}},
        400: {"model": ErrorEnvelope},
        422: {"model": ErrorEnvelope},
    },
    summary="Compile LaTeX → PDF",
    description="Accepts raw .tex source (JSON) or a zipped project (multipart form). "
    "Returns PDF bytes on success with metadata headers.",
)
async def compile_endpoint(
    request: Request,
    api_key: str = Depends(require_api_key),
) -> Response:
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

    return Response(
        content=result.pdf_bytes,
        media_type="application/pdf",
        headers={
            "X-Compilation-Time": f"{result.compilation_time:.2f}",
            "X-Engine": result.engine,
            "X-Warnings-Count": str(result.warnings_count),
            "X-Cached": str(result.cached).lower(),
            "X-Passes-Run": str(result.passes_run),
        },
    )
