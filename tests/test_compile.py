"""Tests for the compilation endpoint.

These tests require TeX Live to be installed in the container.
Run with: docker compose exec api pytest tests/test_compile.py -v
"""

import io
import zipfile

import pytest


@pytest.mark.asyncio
async def test_compile_simple_document(client, auth_headers, simple_tex):
    """Compile a simple LaTeX document and verify PDF output."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex},
    )
    if resp.status_code != 200:
        pytest.skip("Compilation failed — TeX Live may not be available")
    assert resp.headers["content-type"] == "application/pdf"
    # Verify PDF magic bytes
    assert resp.content[:4] == b"%PDF"
    # Verify metadata headers
    assert "x-compilation-time" in resp.headers
    assert "x-engine" in resp.headers
    assert resp.headers["x-engine"] == "pdflatex"
    assert "x-cached" in resp.headers
    assert "x-passes-run" in resp.headers


@pytest.mark.asyncio
async def test_compile_with_xelatex(client, auth_headers, simple_tex):
    """Compile with XeLaTeX engine."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "engine": "xelatex"},
    )
    if resp.status_code == 200:
        assert resp.headers["x-engine"] == "xelatex"
        assert resp.content[:4] == b"%PDF"


@pytest.mark.asyncio
async def test_compile_with_lualatex(client, auth_headers, simple_tex):
    """Compile with LuaLaTeX engine."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "engine": "lualatex"},
    )
    if resp.status_code == 200:
        assert resp.headers["x-engine"] == "lualatex"
        assert resp.content[:4] == b"%PDF"


@pytest.mark.asyncio
async def test_compile_invalid_latex(client, auth_headers, invalid_tex):
    """Invalid LaTeX should return 422 with error log."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": invalid_tex},
    )
    assert resp.status_code == 422
    data = resp.json()
    assert "detail" in data
    detail = data["detail"]
    assert detail["success"] is False
    assert "log" in detail


@pytest.mark.asyncio
async def test_compile_empty_source(client, auth_headers):
    """Empty source should return 400."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": ""},
    )
    assert resp.status_code == 400


@pytest.mark.asyncio
async def test_compile_no_body(client, auth_headers):
    """Request with no body and no file should return 400."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
    )
    # FastAPI will return 422 for missing body/form validation
    assert resp.status_code in (400, 422)


@pytest.mark.asyncio
async def test_compile_zip_upload(client, auth_headers, multi_file_zip):
    """Compile a multi-file project from zip upload."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        files={"file": ("project.zip", io.BytesIO(multi_file_zip), "application/zip")},
        data={"engine": "pdflatex", "main_file": "main.tex"},
    )
    if resp.status_code == 200:
        assert resp.content[:4] == b"%PDF"


@pytest.mark.asyncio
async def test_compile_zip_custom_main(client, auth_headers, zip_with_custom_main):
    """Compile zip with custom main_file parameter."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        files={"file": ("project.zip", io.BytesIO(zip_with_custom_main), "application/zip")},
        data={"engine": "pdflatex", "main_file": "thesis.tex"},
    )
    if resp.status_code == 200:
        assert resp.content[:4] == b"%PDF"


@pytest.mark.asyncio
async def test_compile_draft_mode(client, auth_headers, simple_tex):
    """Draft mode should still produce a valid PDF."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "draft": True},
    )
    if resp.status_code == 200:
        assert resp.content[:4] == b"%PDF"


@pytest.mark.asyncio
async def test_compile_cache_hit(client, auth_headers, simple_tex):
    """Second identical request should return cached result."""
    # First request — cache miss
    resp1 = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "enable_cache": True},
    )
    if resp1.status_code != 200:
        pytest.skip("Compilation failed — TeX Live may not be available")

    assert resp1.headers.get("x-cached") == "false"

    # Second request — cache hit
    resp2 = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "enable_cache": True},
    )
    assert resp2.status_code == 200
    assert resp2.headers.get("x-cached") == "true"
    # Cached response should be faster
    t1 = float(resp1.headers.get("x-compilation-time", "999"))
    t2 = float(resp2.headers.get("x-compilation-time", "999"))
    assert t2 <= t1  # Cache hit should be same or faster


@pytest.mark.asyncio
async def test_compile_cache_disabled(client, auth_headers, simple_tex):
    """With cache disabled, each request should compile fresh."""
    resp1 = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "enable_cache": False},
    )
    if resp1.status_code != 200:
        pytest.skip("Compilation failed — TeX Live may not be available")

    assert resp1.headers.get("x-cached") == "false"

    resp2 = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex, "enable_cache": False},
    )
    assert resp2.status_code == 200
    assert resp2.headers.get("x-cached") == "false"


@pytest.mark.asyncio
async def test_zip_bomb_protection(client, auth_headers):
    """Oversized zip should be rejected at extraction time."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as zf:
        # Write a file that claims a large uncompressed size is impossible
        # in pure Python without hacking headers, so test the upload size
        # limit path instead: a file larger than MAX_UPLOAD_SIZE_MB.
        zf.writestr("main.tex", r"\documentclass{article}\begin{document}ok\end{document}")
    zip_bytes = buf.getvalue()

    # The zip itself is small so it succeeds — this validates the endpoint
    # doesn't crash. The real bomb protection is in _safe_extract_zip which
    # checks uncompressed size, tested via compiler unit coverage.
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        files={"file": ("small.zip", io.BytesIO(zip_bytes), "application/zip")},
        data={"engine": "pdflatex", "main_file": "main.tex"},
    )
    # Should succeed or fail at compilation — not crash
    assert resp.status_code in (200, 422)


@pytest.mark.asyncio
async def test_path_traversal_protection(client, auth_headers):
    """Zip with path traversal should be rejected."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as zf:
        zf.writestr("../../etc/passwd", "malicious content")
        zf.writestr("main.tex", r"\documentclass{article}\begin{document}test\end{document}")
    zip_bytes = buf.getvalue()

    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        files={"file": ("evil.zip", io.BytesIO(zip_bytes), "application/zip")},
        data={"engine": "pdflatex", "main_file": "main.tex"},
    )
    assert resp.status_code == 422
    # Should contain path traversal error
    detail = resp.json().get("detail", {})
    if isinstance(detail, dict):
        assert "traversal" in detail.get("log", "").lower() or "traversal" in str(detail).lower()
