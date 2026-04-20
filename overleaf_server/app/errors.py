"""Structured error hierarchy and exception handlers.

Provides a unified error envelope for all API error responses, custom
exception classes for domain-specific errors, and FastAPI exception
handler registrations that produce consistent JSON responses.

Every error response includes:
- ``request_id`` — from ``asgi-correlation-id`` context
- ``error_code`` — machine-readable enum member
- ``message`` — human-readable summary
- ``detail`` — optional extra context (compilation log, validation info, etc.)
"""

from enum import StrEnum
from typing import Any

import structlog
from asgi_correlation_id import correlation_id
from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import ORJSONResponse
from pydantic import BaseModel, Field
from slowapi.errors import RateLimitExceeded

logger = structlog.get_logger()


# ---------------------------------------------------------------------------
# Error codes — machine-readable identifiers
# ---------------------------------------------------------------------------
class ErrorCode(StrEnum):
    """Machine-readable error codes returned in every error response.

    Use these codes — not HTTP status codes — to programmatically
    distinguish error types in your frontend/client code.

    | Code | HTTP | Meaning |
    |------|------|---------|
    | COMPILATION_FAILED | 422 | LaTeX compilation produced errors |
    | INVALID_REQUEST | 400 | Malformed input, bad engine, empty source |
    | MISSING_API_KEY | 401 | No `X-API-Key` header provided |
    | INVALID_API_KEY | 403 | API key not in the server's allowlist |
    | UPLOAD_TOO_LARGE | 413 | Request body exceeds `MAX_UPLOAD_SIZE_MB` |
    | RATE_LIMITED | 429 | Too many requests — see `RATE_LIMIT` config |
    | INTERNAL_ERROR | 500 | Unexpected server error — file a bug report |
    """

    COMPILATION_FAILED = "COMPILATION_FAILED"
    INVALID_REQUEST = "INVALID_REQUEST"
    MISSING_API_KEY = "MISSING_API_KEY"
    INVALID_API_KEY = "INVALID_API_KEY"
    UPLOAD_TOO_LARGE = "UPLOAD_TOO_LARGE"
    RATE_LIMITED = "RATE_LIMITED"
    INTERNAL_ERROR = "INTERNAL_ERROR"


# ---------------------------------------------------------------------------
# Error envelope — unified response shape
# ---------------------------------------------------------------------------
class ErrorEnvelope(BaseModel):
    """Unified error response body.

    **Every** error response from this API — regardless of status code —
    uses this exact JSON shape. Parse it consistently in your frontend
    error handler.

    The ``request_id`` matches the ``X-Request-ID`` response header and
    can be used for log correlation and support requests.
    """

    request_id: str = Field(
        ...,
        description=(
            "UUID4 hex string identifying this request. Matches the "
            "`X-Request-ID` response header. Use for log correlation "
            "and when reporting issues."
        ),
        json_schema_extra={"example": "a1b2c3d4e5f647a8b9c0d1e2f3a4b5c6"},
    )
    error_code: ErrorCode = Field(
        ...,
        description=(
            "Machine-readable error code. Use this — not the HTTP status — "
            "to programmatically distinguish error types in your client."
        ),
        json_schema_extra={"example": "COMPILATION_FAILED"},
    )
    message: str = Field(
        ...,
        description="Human-readable error summary. Safe to display to end users.",
        json_schema_extra={"example": "Compilation failed"},
    )
    detail: dict[str, Any] | None = Field(
        default=None,
        description=(
            "Optional extra context. For `COMPILATION_FAILED`, contains "
            "`log` (full TeX output), `engine`, `compilation_time`, and "
            "`passes_run`. For `INVALID_REQUEST`, may contain `hint` or "
            "`valid_engines`. `null` for auth and rate limit errors."
        ),
        json_schema_extra={
            "example": {
                "log": "! Undefined control sequence.\nl.42 \\badcommand",
                "engine": "pdflatex",
                "compilation_time": 2.31,
                "passes_run": 1,
            }
        },
    )

    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "summary": "Compilation failure",
                    "value": {
                        "request_id": "a1b2c3d4e5f647a8b9c0d1e2f3a4b5c6",
                        "error_code": "COMPILATION_FAILED",
                        "message": "Compilation failed",
                        "detail": {
                            "log": "! Undefined control sequence.\nl.42 \\badcommand",
                            "engine": "pdflatex",
                            "compilation_time": 2.31,
                            "passes_run": 1,
                        },
                    },
                },
                {
                    "summary": "Invalid request",
                    "value": {
                        "request_id": "f1e2d3c4b5a647a8b9c0d1e2f3a4b5c6",
                        "error_code": "INVALID_REQUEST",
                        "message": "Invalid engine 'notanengine'.",
                        "detail": {
                            "valid_engines": [
                                "pdflatex",
                                "xelatex",
                                "lualatex",
                                "latexmk",
                            ]
                        },
                    },
                },
                {
                    "summary": "Missing API key",
                    "value": {
                        "request_id": "c3d4e5f6a7b847a8b9c0d1e2f3a4b5c6",
                        "error_code": "MISSING_API_KEY",
                        "message": "Missing API key. Provide X-API-Key header.",
                        "detail": None,
                    },
                },
            ]
        }
    }


# ---------------------------------------------------------------------------
# Custom exceptions
# ---------------------------------------------------------------------------
class TexLiveError(Exception):
    """Base exception for all TeX Live API errors.

    Attributes:
        status_code: HTTP status code to return.
        error_code: Machine-readable error code.
        message: Human-readable error summary.
        detail: Optional extra context dict.
    """

    def __init__(
        self,
        *,
        status_code: int,
        error_code: ErrorCode,
        message: str,
        detail: dict[str, Any] | None = None,
    ) -> None:
        self.status_code = status_code
        self.error_code = error_code
        self.message = message
        self.detail = detail
        super().__init__(message)


class CompilationError(TexLiveError):
    """Raised when LaTeX compilation fails (422)."""

    def __init__(
        self,
        message: str = "Compilation failed",
        *,
        detail: dict[str, Any] | None = None,
    ) -> None:
        super().__init__(
            status_code=422,
            error_code=ErrorCode.COMPILATION_FAILED,
            message=message,
            detail=detail,
        )


class ValidationError(TexLiveError):
    """Raised on malformed or invalid request input (400)."""

    def __init__(
        self,
        message: str = "Invalid request",
        *,
        detail: dict[str, Any] | None = None,
    ) -> None:
        super().__init__(
            status_code=400,
            error_code=ErrorCode.INVALID_REQUEST,
            message=message,
            detail=detail,
        )


class UploadTooLargeError(TexLiveError):
    """Raised when request body exceeds size limit (413)."""

    def __init__(
        self,
        message: str = "Upload too large",
        *,
        detail: dict[str, Any] | None = None,
    ) -> None:
        super().__init__(
            status_code=413,
            error_code=ErrorCode.UPLOAD_TOO_LARGE,
            message=message,
            detail=detail,
        )


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def _build_envelope(
    error_code: ErrorCode,
    message: str,
    detail: dict[str, Any] | None = None,
) -> dict[str, Any]:
    """Build a serialisable ``ErrorEnvelope`` dict with the current request ID."""
    return ErrorEnvelope(
        request_id=correlation_id.get() or "",
        error_code=error_code,
        message=message,
        detail=detail,
    ).model_dump(mode="json")


# ---------------------------------------------------------------------------
# Exception handlers
# ---------------------------------------------------------------------------
async def _handle_texlive_error(request: Request, exc: TexLiveError) -> ORJSONResponse:
    """Handle domain-specific TexLiveError subclasses."""
    logger.warning(
        "domain_error",
        error_code=exc.error_code,
        message=exc.message,
        status=exc.status_code,
        path=request.url.path,
    )
    return ORJSONResponse(
        status_code=exc.status_code,
        content=_build_envelope(exc.error_code, exc.message, exc.detail),
    )


async def _handle_http_exception(request: Request, exc: HTTPException) -> ORJSONResponse:
    """Handle FastAPI HTTPException with consistent envelope."""
    error_code = _map_http_status_to_code(exc.status_code)
    message = exc.detail if isinstance(exc.detail, str) else str(exc.detail)
    detail = exc.detail if isinstance(exc.detail, dict) else None

    logger.warning(
        "http_error",
        error_code=error_code,
        status=exc.status_code,
        path=request.url.path,
    )
    return ORJSONResponse(
        status_code=exc.status_code,
        content=_build_envelope(error_code, message, detail),
    )


async def _handle_validation_error(
    request: Request, exc: RequestValidationError
) -> ORJSONResponse:
    """Handle Pydantic request validation errors."""
    logger.warning(
        "validation_error",
        errors=exc.errors(),
        path=request.url.path,
    )
    return ORJSONResponse(
        status_code=400,
        content=_build_envelope(
            ErrorCode.INVALID_REQUEST,
            "Request validation failed",
            {"errors": exc.errors()},
        ),
    )


async def _handle_rate_limit(request: Request, exc: RateLimitExceeded) -> ORJSONResponse:
    """Handle SlowAPI rate limit exceeded."""
    logger.warning("rate_limited", path=request.url.path)
    return ORJSONResponse(
        status_code=429,
        content=_build_envelope(
            ErrorCode.RATE_LIMITED,
            f"Rate limit exceeded: {exc.detail}",
        ),
    )


async def _handle_unhandled(request: Request, exc: Exception) -> ORJSONResponse:
    """Catch-all for unhandled exceptions — log full traceback."""
    logger.exception(
        "unhandled_exception",
        error=str(exc),
        error_type=type(exc).__name__,
        path=request.url.path,
    )
    return ORJSONResponse(
        status_code=500,
        content=_build_envelope(ErrorCode.INTERNAL_ERROR, "Internal server error"),
    )


def _map_http_status_to_code(status: int) -> ErrorCode:
    """Map HTTP status codes to ``ErrorCode`` enum members."""
    mapping: dict[int, ErrorCode] = {
        401: ErrorCode.MISSING_API_KEY,
        403: ErrorCode.INVALID_API_KEY,
        413: ErrorCode.UPLOAD_TOO_LARGE,
        422: ErrorCode.COMPILATION_FAILED,
        429: ErrorCode.RATE_LIMITED,
    }
    return mapping.get(
        status, ErrorCode.INVALID_REQUEST if status < 500 else ErrorCode.INTERNAL_ERROR
    )


# ---------------------------------------------------------------------------
# Registration
# ---------------------------------------------------------------------------
def register_error_handlers(app: FastAPI) -> None:
    """Register all exception handlers on the FastAPI app.

    Call this once from ``main.py`` during app construction.
    """
    app.add_exception_handler(TexLiveError, _handle_texlive_error)
    app.add_exception_handler(HTTPException, _handle_http_exception)
    app.add_exception_handler(RequestValidationError, _handle_validation_error)
    app.add_exception_handler(RateLimitExceeded, _handle_rate_limit)
    app.add_exception_handler(Exception, _handle_unhandled)
