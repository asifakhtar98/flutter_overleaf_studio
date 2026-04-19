"""LaTeX compilation endpoint."""

from dataclasses import dataclass

import structlog
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from fastapi.responses import Response

from app.auth import require_api_key
from app.compiler import compile_latex
from app.config import settings
from app.models import CompileRequest, Engine, ErrorResponse

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


async def _parse_request(
    body: CompileRequest | None,
    file: UploadFile | None,
    engine: Engine,
    main_file: str,
    draft: bool,
    enable_cache: bool,
) -> _ParsedRequest:
    """Parse and validate the incoming compile request.

    Supports two modes:
    1. JSON body with ``source`` field → single-file compilation.
    2. Multipart form with ``file`` field → zip project upload.

    Raises:
        HTTPException: 400 on missing input or oversized upload.
    """
    if file is not None:
        content = await file.read()
        if len(content) > settings.max_upload_size_bytes:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"File too large. Max {settings.max_upload_size_mb} MB.",
            )
        return _ParsedRequest(
            content=content,
            engine=engine.value,
            main_file=main_file,
            draft=draft,
            enable_cache=enable_cache,
            is_zip=True,
        )

    if body is not None:
        if not body.source or not body.source.strip():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Empty source. Provide LaTeX source code.",
            )
        return _ParsedRequest(
            content=body.source.encode("utf-8"),
            engine=body.engine.value,
            main_file=body.main_file,
            draft=body.draft,
            enable_cache=body.enable_cache,
            is_zip=False,
        )

    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="Provide either JSON body with 'source' or multipart form with 'file'.",
    )


# ---------------------------------------------------------------------------
# Endpoint
# ---------------------------------------------------------------------------
@router.post(
    "/compile",
    responses={
        200: {"content": {"application/pdf": {}}},
        400: {"model": ErrorResponse},
        422: {"model": ErrorResponse},
    },
    summary="Compile LaTeX → PDF",
    description="Accepts raw .tex source (JSON) or a zipped project (multipart form). "
    "Returns PDF bytes on success with metadata headers.",
)
async def compile_endpoint(
    # JSON body (single file)
    body: CompileRequest | None = None,
    # Multipart form (zip upload)
    file: UploadFile | None = File(default=None),  # noqa: B008
    engine: Engine = Form(default=Engine.PDFLATEX),  # noqa: B008
    main_file: str = Form(default="main.tex"),  # noqa: B008
    draft: bool = Form(default=False),  # noqa: B008
    enable_cache: bool = Form(default=True),  # noqa: B008
    # Auth
    api_key: str = Depends(require_api_key),
) -> Response:
    """Compile LaTeX source into PDF."""
    req = await _parse_request(body, file, engine, main_file, draft, enable_cache)

    result = await compile_latex(
        content=req.content,
        engine=req.engine,
        main_file=req.main_file,
        draft=req.draft,
        enable_cache=req.enable_cache,
        is_zip=req.is_zip,
    )

    if not result.success:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "success": False,
                "error": "Compilation failed",
                "exit_code": 1,
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
