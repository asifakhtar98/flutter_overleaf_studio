"""FastAPI application entry point.

Thin wiring module — all logic is delegated to dedicated modules:
- ``errors.py`` — exception handlers
- ``middleware.py`` — request ID, logging, body limit
- ``logging.py`` — structlog configuration
- ``compiler.py`` — compilation logic + orphan cleanup
"""

from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse
from slowapi import Limiter
from slowapi.util import get_remote_address

from app import __version__
from app.compiler import get_executor, shutdown_executor, sweep_orphan_temp_dirs
from app.config import settings
from app.errors import register_error_handlers
from app.logging import configure_logging
from app.middleware import register_middleware
from app.routers import compile as compile_router
from app.routers import health

# --- Logging (must be first — before any logger is created) ---
configure_logging(settings.log_level)
logger = structlog.get_logger()


# --- Rate limiter ---
def _get_api_key_or_ip(request: object) -> str:
    """Rate limit key function — use API key if present, else IP."""
    api_key = request.headers.get("X-API-Key")
    if api_key:
        return api_key
    return get_remote_address(request)


limiter = Limiter(key_func=_get_api_key_or_ip)


# --- Lifespan ---
@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Application lifespan — startup and shutdown hooks."""
    logger.info(
        "startup",
        version=__version__,
        workers=settings.workers,
        cache_max_size=settings.cache_max_size,
        cache_ttl=settings.cache_ttl_seconds,
        max_concurrent=settings.max_concurrent_compiles,
        tmpfs=settings.use_tmpfs,
    )
    # Sweep orphan temp dirs from previous crashed processes
    sweep_orphan_temp_dirs()
    # Warm up the process pool
    get_executor()
    yield
    # Shutdown
    shutdown_executor()
    logger.info("shutdown")


# --- App Metadata & Tags ---
tags_metadata = [
    {
        "name": "compile",
        "description": "Core LaTeX compilation endpoints. Accepts JSON or Multipart.",
    },
    {
        "name": "health",
        "description": "Server diagnostics, installed engines, and cache performance.",
    },
]

# --- App ---
app = FastAPI(
    title="TeX Live Compilation API",
    description=(
        "Stateless, high-performance REST API for LaTeX → PDF compilation.\n\n"
        "### Features\n"
        "- **4 Engines**: `pdflatex`, `xelatex`, `lualatex`, `latexmk`\n"
        "- **RAM-disk compilation**: All compilation runs in `/dev/shm` for zero disk I/O.\n"
        "- **Smart multi-pass**: Auto-parses `.aux` to run BibTeX/Biber and extra passes only when needed.\n"
        "- **LRU Cache**: Unchanged inputs return instantly.\n"
        "- **Zip Support**: Multi-file projects with images and bibliographies.\n\n"
        "### Authentication\n"
        "All `/compile` requests require an `X-API-Key` header. "
        "Click the **Authorize** button below to set it for your Swagger UI session."
    ),
    version=__version__,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_tags=tags_metadata,
    contact={
        "name": "API Support",
        "url": "https://github.com/YOUR_USERNAME/texlive-api",
    },
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/licenses/MIT",
    },
    lifespan=lifespan,
    default_response_class=ORJSONResponse,
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
        "X-Request-ID",
    ],
)

# Rate limiting
app.state.limiter = limiter

# Middleware stack (request ID, body limit, request logging)
register_middleware(app)

# Exception handlers (unified error envelope)
register_error_handlers(app)

# Routers
app.include_router(health.router)
app.include_router(compile_router.router)
