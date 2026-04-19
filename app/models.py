"""Pydantic models for request/response schemas.

All models include ``json_schema_extra`` with realistic examples
so that Swagger UI / ReDoc renders actionable documentation for
frontend developers.
"""

from enum import StrEnum

from pydantic import BaseModel, Field


class Engine(StrEnum):
    """Supported LaTeX compilation engines.

    - **pdflatex** — Fastest, best for standard documents. No native Unicode.
    - **xelatex** — Full Unicode/OpenType support. Use for CJK, Arabic, Devanagari.
    - **lualatex** — Unicode + Lua scripting. Slower but most flexible.
    - **latexmk** — Meta-builder: auto-detects passes, BibTeX, etc. Hands-off.
    """

    PDFLATEX = "pdflatex"
    XELATEX = "xelatex"
    LUALATEX = "lualatex"
    LATEXMK = "latexmk"


class CompileRequest(BaseModel):
    """JSON request body for single-file LaTeX compilation.

    Send raw LaTeX source as a string. The API compiles it and returns
    PDF bytes directly in the response body.

    For multi-file projects (with images, bibliographies, etc.), use the
    **multipart form** endpoint variant with a zip archive instead.
    """

    source: str = Field(
        ...,
        description=(
            "Raw LaTeX source code. Must be a complete, compilable document "
            "including `\\documentclass` and `\\begin{document}...\\end{document}`."
        ),
        min_length=1,
        json_schema_extra={
            "example": (
                "\\documentclass{article}\n"
                "\\begin{document}\n"
                "Hello, World!\n"
                "\\end{document}"
            ),
        },
    )
    engine: Engine = Field(
        default=Engine.PDFLATEX,
        description=(
            "LaTeX engine to compile with. `pdflatex` is fastest for standard "
            "documents. Use `xelatex` or `lualatex` for Unicode/OpenType fonts. "
            "`latexmk` auto-detects the required number of passes."
        ),
    )
    main_file: str = Field(
        default="main.tex",
        description=(
            "Name of the main `.tex` file. Only relevant for zip uploads — for "
            "JSON mode this controls the output filename stem. Must be a relative "
            "path with `.tex`, `.ltx`, or `.latex` extension. Path traversal "
            "(`..`) is rejected."
        ),
        pattern=r"^[^/].*\.(tex|ltx|latex)$",
    )
    draft: bool = Field(
        default=False,
        description=(
            "Enable draft mode. Injects `\\PassOptionsToPackage{draft}{graphicx}` "
            "before compilation, replacing all images with placeholder boxes. "
            "Reduces compile time by 50-70%% on image-heavy documents. "
            "Ideal for live preview during editing."
        ),
    )
    enable_cache: bool = Field(
        default=True,
        description=(
            "Enable the in-memory LRU cache. When `true`, identical requests "
            "(same source + engine + main_file + draft) return a cached PDF in "
            "~10ms instead of recompiling. Cache entries expire after 30 minutes. "
            "Set to `false` to force a fresh compilation."
        ),
    )

    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "summary": "Minimal document",
                    "description": "Simplest possible LaTeX document with pdflatex",
                    "value": {
                        "source": (
                            "\\documentclass{article}\n"
                            "\\begin{document}\n"
                            "Hello, World!\n"
                            "\\end{document}"
                        ),
                        "engine": "pdflatex",
                        "draft": False,
                        "enable_cache": True,
                    },
                },
                {
                    "summary": "Math-heavy with XeLaTeX",
                    "description": "Document with equations compiled via xelatex",
                    "value": {
                        "source": (
                            "\\documentclass{article}\n"
                            "\\usepackage{amsmath}\n"
                            "\\begin{document}\n"
                            "Einstein: $E = mc^2$\n\n"
                            "Euler: $e^{i\\pi} + 1 = 0$\n"
                            "\\end{document}"
                        ),
                        "engine": "xelatex",
                        "draft": False,
                        "enable_cache": True,
                    },
                },
                {
                    "summary": "Draft mode preview",
                    "description": "Fast preview with images replaced by placeholders",
                    "value": {
                        "source": (
                            "\\documentclass{article}\n"
                            "\\usepackage{graphicx}\n"
                            "\\begin{document}\n"
                            "\\includegraphics[width=0.5\\textwidth]{diagram.png}\n"
                            "\\end{document}"
                        ),
                        "engine": "pdflatex",
                        "draft": True,
                        "enable_cache": False,
                    },
                },
            ]
        }
    }


class CacheStats(BaseModel):
    """In-memory LRU cache statistics.

    The cache is keyed by SHA-256 hash of (source + engine + main_file + draft).
    Entries expire after ``CACHE_TTL_SECONDS`` (default 30 minutes).
    """

    hits: int = Field(default=0, description="Total cache hits since startup")
    misses: int = Field(default=0, description="Total cache misses since startup")
    size: int = Field(default=0, description="Current number of cached entries")
    max_size: int = Field(
        default=200,
        description="Maximum cache capacity (configured via `CACHE_MAX_SIZE` env var)",
    )

    model_config = {
        "json_schema_extra": {
            "example": {"hits": 142, "misses": 58, "size": 47, "max_size": 200}
        }
    }


class HealthResponse(BaseModel):
    """Health check response.

    Returns server status, TeX Live version, available engines, uptime,
    and cache statistics. Use this endpoint for connection status indicators
    and monitoring dashboards.
    """

    status: str = Field(
        default="healthy", description="Server status. Always `healthy` if reachable."
    )
    texlive_version: str = Field(
        default="",
        description="Full TeX Live version string from `pdflatex --version`",
    )
    engines: list[str] = Field(
        default=[],
        description=(
            "List of available compilation engines. Only engines found on PATH "
            "are listed. Typically: `pdflatex`, `xelatex`, `lualatex`, `latexmk`."
        ),
    )
    uptime_seconds: float = Field(
        default=0.0,
        description="Seconds since the server process started",
    )
    cache_stats: CacheStats = Field(
        default_factory=CacheStats,
        description="Current state of the in-memory compilation cache",
    )

    model_config = {
        "json_schema_extra": {
            "example": {
                "status": "healthy",
                "texlive_version": "pdfTeX 3.141592653-2.6-1.40.29 (TeX Live 2026)",
                "engines": ["pdflatex", "xelatex", "lualatex", "latexmk"],
                "uptime_seconds": 3600.0,
                "cache_stats": {
                    "hits": 142,
                    "misses": 58,
                    "size": 47,
                    "max_size": 200,
                },
            }
        }
    }
