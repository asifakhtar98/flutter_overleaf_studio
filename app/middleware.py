"""ASGI middleware stack for request lifecycle management.

- **Request ID**: uses ``asgi-correlation-id`` to read or generate an
  ``X-Request-ID`` header on every request, binding it to structlog context.
- **Request logging**: logs method, path, status, and duration for every
  request.
- **Body size limit**: rejects requests declaring a ``Content-Length``
  exceeding the configured maximum.

Call ``register_middleware(app)`` once from ``main.py``.
"""

import time

import structlog
from asgi_correlation_id import CorrelationIdMiddleware
from fastapi import FastAPI, Request
from fastapi.responses import ORJSONResponse

from app.config import settings
from app.errors import ErrorCode, _build_envelope

logger = structlog.get_logger()


def register_middleware(app: FastAPI) -> None:
    """Register all ASGI middleware on the FastAPI app.

    Middleware is applied in reverse registration order, so the first
    registered middleware is the *outermost* wrapper. We want:

    1. CorrelationIdMiddleware (outermost — generates request ID first)
    2. BodySizeLimitMiddleware
    3. RequestLoggingMiddleware (innermost — logs after response)

    Since FastAPI applies middleware LIFO (last added = outermost), we
    register in reverse order.

    Args:
        app: The FastAPI application instance.
    """
    # Innermost — runs last, logs after response
    app.middleware("http")(_request_logging_middleware)

    # Middle — rejects oversized requests before they hit the endpoint
    app.middleware("http")(_body_size_limit_middleware)

    # Outermost — generates/reads X-Request-ID before anything else
    app.add_middleware(
        CorrelationIdMiddleware,
        header_name="X-Request-ID",
    )


async def _body_size_limit_middleware(request: Request, call_next: object) -> object:
    """Reject requests that declare a body larger than ``max_upload_size_bytes``.

    Safely parses ``Content-Length`` and returns 413 with an ``ErrorEnvelope``
    on oversized requests. Malformed ``Content-Length`` values are ignored
    (the actual body reader will handle them).
    """
    content_length = request.headers.get("content-length")
    if content_length is not None:
        try:
            length = int(content_length)
        except ValueError:
            return ORJSONResponse(
                status_code=400,
                content=_build_envelope(
                    ErrorCode.INVALID_REQUEST,
                    "Malformed Content-Length header.",
                ),
            )
        if length > settings.max_upload_size_bytes:
            return ORJSONResponse(
                status_code=413,
                content=_build_envelope(
                    ErrorCode.UPLOAD_TOO_LARGE,
                    f"Request body too large. Max {settings.max_upload_size_mb} MB.",
                ),
            )
    return await call_next(request)


async def _request_logging_middleware(request: Request, call_next: object) -> object:
    """Log every request with method, path, status code, and duration."""
    start = time.perf_counter()
    response = await call_next(request)
    duration_ms = (time.perf_counter() - start) * 1000

    logger.info(
        "request_completed",
        method=request.method,
        path=request.url.path,
        status=response.status_code,
        duration_ms=round(duration_ms, 2),
    )
    return response
