"""Health check endpoint."""

import functools
import subprocess
import time

import structlog
from fastapi import APIRouter

from app.cache import compile_cache
from app.compiler import ENGINE_PATHS
from app.models import CacheStats, HealthResponse

logger = structlog.get_logger()
router = APIRouter(prefix="/api/v1", tags=["health"])

_start_time = time.monotonic()


@functools.lru_cache(maxsize=1)
def _get_texlive_version() -> str:
    """Get TeX Live version string. Cached — only shells out once."""
    try:
        pdflatex = ENGINE_PATHS.get("pdflatex")
        if not pdflatex:
            return "unknown (pdflatex not found)"
        result = subprocess.run(
            [pdflatex, "--version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        return result.stdout.strip().split("\n")[0]
    except Exception:
        return "unknown"


@functools.lru_cache(maxsize=1)
def _get_available_engines() -> tuple[str, ...]:
    """List engines that are actually installed. Cached at first call."""
    return tuple(
        name
        for name in ("pdflatex", "xelatex", "lualatex", "latexmk")
        if ENGINE_PATHS.get(name) is not None
    )


@router.get("/health", response_model=HealthResponse)
async def health_check() -> HealthResponse:
    """Health check with TeX Live version, engines, uptime, and cache stats."""
    return HealthResponse(
        status="healthy",
        texlive_version=_get_texlive_version(),
        engines=list(_get_available_engines()),
        uptime_seconds=round(time.monotonic() - _start_time, 1),
        cache_stats=CacheStats(
            hits=compile_cache.hits,
            misses=compile_cache.misses,
            size=compile_cache.size,
            max_size=compile_cache.max_size,
        ),
    )
