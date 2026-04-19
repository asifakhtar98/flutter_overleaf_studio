"""Shared test fixtures."""

import io
import os
import zipfile

import pytest
from httpx import ASGITransport, AsyncClient

# Set test API key before importing the app
os.environ["API_KEYS"] = "test-key-123,test-key-456"
os.environ["LOG_LEVEL"] = "warning"
os.environ["CACHE_TTL_SECONDS"] = "60"
os.environ["USE_TMPFS"] = "false"  # CI may not have /dev/shm

from app.cache import compile_cache  # noqa: E402
from app.main import app  # noqa: E402


@pytest.fixture(autouse=True)
def clear_cache():
    """Clear compilation cache before each test."""
    compile_cache.clear()
    yield
    compile_cache.clear()


@pytest.fixture
async def client():
    """Async HTTP test client."""
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


@pytest.fixture
def auth_headers():
    """Valid API key headers."""
    return {"X-API-Key": "test-key-123"}


@pytest.fixture
def simple_tex() -> str:
    """Minimal valid LaTeX source."""
    return r"""\documentclass{article}
\begin{document}
Hello, World!
\end{document}"""


@pytest.fixture
def invalid_tex() -> str:
    """Invalid LaTeX source that will fail compilation."""
    return r"""\documentclass{article}
\begin{document}
\undefinedcommand
\end{document}"""


@pytest.fixture
def multi_file_zip() -> bytes:
    """In-memory zip archive with main.tex + chapter.tex."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(
            "main.tex",
            r"""\documentclass{article}
\begin{document}
\input{chapter}
\end{document}""",
        )
        zf.writestr(
            "chapter.tex",
            r"""This is a chapter from a separate file.""",
        )
    return buf.getvalue()


@pytest.fixture
def zip_with_custom_main() -> bytes:
    """Zip archive with a non-default main file name."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(
            "thesis.tex",
            r"""\documentclass{article}
\begin{document}
Custom main file test.
\end{document}""",
        )
    return buf.getvalue()
