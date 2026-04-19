"""Pydantic models for request/response schemas."""

from enum import StrEnum

from pydantic import BaseModel, Field


class Engine(StrEnum):
    """Supported LaTeX compilation engines."""

    PDFLATEX = "pdflatex"
    XELATEX = "xelatex"
    LUALATEX = "lualatex"
    LATEXMK = "latexmk"


class CompileRequest(BaseModel):
    """Request body for single-file LaTeX compilation."""

    source: str = Field(..., description="Raw LaTeX source code")
    engine: Engine = Field(default=Engine.PDFLATEX, description="LaTeX engine to use")
    main_file: str = Field(default="main.tex", description="Main .tex file name")
    draft: bool = Field(default=False, description="Skip image rendering for fast preview")
    enable_cache: bool = Field(default=True, description="Use compilation cache")


class CacheStats(BaseModel):
    """Cache statistics for health endpoint."""

    hits: int = 0
    misses: int = 0
    size: int = 0
    max_size: int = 200


class HealthResponse(BaseModel):
    """Health check response."""

    status: str = "healthy"
    texlive_version: str = ""
    engines: list[str] = []
    uptime_seconds: float = 0.0
    cache_stats: CacheStats = CacheStats()
