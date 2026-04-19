"""FastAPI application entry point."""

from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from slowapi.util import get_remote_address

from app.compiler import get_executor, shutdown_executor
from app.config import settings
from app.routers import compile as compile_router
from app.routers import health

structlog.configure(
    wrapper_class=structlog.make_filtering_bound_logger(
        structlog.get_level_from_name(settings.log_level)
    ),
)
logger = structlog.get_logger()


def _get_api_key_or_ip(request: Request) -> str:
    """Rate limit key function — use API key if present, else IP."""
    api_key = request.headers.get("X-API-Key")
    if api_key:
        return api_key
    return get_remote_address(request)


limiter = Limiter(key_func=_get_api_key_or_ip)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Application lifespan — startup and shutdown hooks."""
    logger.info(
        "startup",
        version="1.0.0",
        workers=settings.workers,
        cache_max_size=settings.cache_max_size,
        cache_ttl=settings.cache_ttl_seconds,
        max_concurrent=settings.max_concurrent_compiles,
        tmpfs=settings.use_tmpfs,
    )
    # Warm up the process pool
    get_executor()
    yield
    # Shutdown
    shutdown_executor()
    logger.info("shutdown")


app = FastAPI(
    title="TeX Live Compilation API",
    description="Stateless REST API for LaTeX → PDF compilation",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=[
        "X-Compilation-Time",
        "X-Engine",
        "X-Warnings-Count",
        "X-Cached",
        "X-Passes-Run",
    ],
)

# Rate limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Routers
app.include_router(health.router)
app.include_router(compile_router.router)


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Catch-all exception handler."""
    logger.error("unhandled_exception", error=str(exc), path=request.url.path)
    return JSONResponse(
        status_code=500,
        content={"success": False, "error": "Internal server error"},
    )
