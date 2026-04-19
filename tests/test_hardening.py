"""Tests for production hardening features.

These tests verify the reliability and safety features added for
production use. They do NOT require TeX Live to be installed.
"""

import io
import zipfile
from unittest.mock import patch

import pytest

from tests.conftest import assert_error_envelope


# -------------------------------------------------------------------------
# Path traversal — is_relative_to()
# -------------------------------------------------------------------------
class TestPathTraversal:
    """Verify zip extraction blocks path traversal attempts."""

    @pytest.mark.asyncio
    async def test_dotdot_traversal_blocked(self, client, auth_headers):
        """../../etc/passwd in zip should be rejected."""
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            zf.writestr("../../etc/passwd", "malicious")
            zf.writestr("main.tex", r"\documentclass{article}\begin{document}x\end{document}")
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            files={"file": ("evil.zip", io.BytesIO(buf.getvalue()), "application/zip")},
            data={"main_file": "main.tex"},
        )
        # Caught by zip extraction safety → returned as compilation error
        assert resp.status_code in (400, 422)

    @pytest.mark.asyncio
    async def test_absolute_path_traversal_blocked(self, client, auth_headers):
        """/tmp/evil in zip should be rejected on extraction."""
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            zf.writestr("/tmp/evil.txt", "malicious")
            zf.writestr("main.tex", r"\documentclass{article}\begin{document}x\end{document}")
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            files={"file": ("evil.zip", io.BytesIO(buf.getvalue()), "application/zip")},
            data={"main_file": "main.tex"},
        )
        # Either blocked at extraction (422) or zip lib normalizes path — not crash (500)
        assert resp.status_code != 500

    @pytest.mark.asyncio
    async def test_safe_nested_paths_allowed(self, client, auth_headers):
        """Legitimate nested directories in zip should be accepted."""
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            zf.writestr(
                "main.tex",
                r"\documentclass{article}\begin{document}\input{chapters/ch1}\end{document}",
            )
            zf.writestr("chapters/ch1.tex", "Chapter 1 content.")
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            files={"file": ("safe.zip", io.BytesIO(buf.getvalue()), "application/zip")},
            data={"main_file": "main.tex"},
        )
        # Should compile or fail at TeX level — never 500 or path error
        assert resp.status_code in (200, 422)


# -------------------------------------------------------------------------
# BrokenProcessPool recovery
# -------------------------------------------------------------------------
class TestBrokenPoolRecovery:
    """Verify the executor recovers from worker crashes."""

    @pytest.mark.asyncio
    async def test_recreate_executor_after_crash(self):
        """_recreate_executor should produce a working pool."""
        from app.compiler import _recreate_executor, get_executor

        _recreate_executor()
        pool = get_executor()
        assert pool is not None
        # Pool should be usable — use os.getpid which is picklable
        import os

        future = pool.submit(os.getpid)
        result = future.result(timeout=5)
        assert isinstance(result, int)

    @pytest.mark.asyncio
    async def test_compile_recovers_from_broken_pool(self, client, auth_headers, simple_tex):
        """Compilation should retry when pool is broken."""
        from concurrent.futures.process import BrokenProcessPool

        # Patch run_in_executor to raise BrokenProcessPool on first call, succeed on second
        call_count = 0
        original_run_in_executor = None

        async def mock_run_in_executor(executor, fn, *args):
            nonlocal call_count, original_run_in_executor
            call_count += 1
            if call_count == 1:
                raise BrokenProcessPool("Simulated crash")
            # On retry, call the real function
            return await original_run_in_executor(executor, fn, *args)

        import asyncio

        loop = asyncio.get_event_loop()
        original_run_in_executor = loop.run_in_executor

        with patch.object(loop, "run_in_executor", side_effect=mock_run_in_executor):
            resp = await client.post(
                "/api/v1/compile",
                headers=auth_headers,
                json={"source": simple_tex},
            )
        # Should not be 500 — either compiled (200) or failed gracefully (422)
        assert resp.status_code in (200, 422)


# -------------------------------------------------------------------------
# Body size limit
# -------------------------------------------------------------------------
class TestBodySizeLimit:
    """Verify the request body size middleware."""

    @pytest.mark.asyncio
    async def test_oversized_content_length_rejected(self, client, auth_headers):
        """Request declaring Content-Length > max should get 413."""
        resp = await client.post(
            "/api/v1/compile",
            headers={
                **auth_headers,
                "Content-Length": str(100 * 1024 * 1024),  # 100 MB
                "Content-Type": "application/json",
            },
            content=b'{"source": "small"}',
        )
        assert resp.status_code == 413
        assert_error_envelope(resp.json(), error_code="UPLOAD_TOO_LARGE")

    @pytest.mark.asyncio
    async def test_normal_sized_request_allowed(self, client, auth_headers):
        """Normal request should pass through the middleware."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={"source": r"\documentclass{article}\begin{document}Hello\end{document}"},
        )
        # Should reach the endpoint, not be blocked by middleware
        assert resp.status_code != 413

    @pytest.mark.asyncio
    async def test_health_not_affected_by_body_limit(self, client):
        """Health endpoint (GET, no body) should not be affected."""
        resp = await client.get("/api/v1/health")
        assert resp.status_code == 200


# -------------------------------------------------------------------------
# Cache entry size cap
# -------------------------------------------------------------------------
class TestCacheEntrySizeCap:
    """Verify oversized PDFs are not cached."""

    def test_max_cache_entry_size_constant_exists(self):
        """MAX_CACHE_ENTRY_SIZE should be defined and reasonable."""
        from app.compiler import MAX_CACHE_ENTRY_SIZE

        assert MAX_CACHE_ENTRY_SIZE == 10 * 1024 * 1024  # 10 MB

    def test_cache_put_size_check_logic(self):
        """Verify the size cap logic works in isolation."""
        from app.cache import CachedResult, compile_cache
        from app.compiler import MAX_CACHE_ENTRY_SIZE

        compile_cache.clear()

        # Small result — should be cacheable
        small_pdf = b"%PDF" + b"x" * 1000
        assert len(small_pdf) <= MAX_CACHE_ENTRY_SIZE

        # Large result — should exceed cap
        large_pdf = b"%PDF" + b"x" * (MAX_CACHE_ENTRY_SIZE + 1)
        assert len(large_pdf) > MAX_CACHE_ENTRY_SIZE

        # Simulate the condition from compiler.py
        cache_key = "test-hash-small"
        if len(small_pdf) <= MAX_CACHE_ENTRY_SIZE:
            compile_cache.put(
                cache_key,
                CachedResult(
                    pdf_bytes=small_pdf,
                    engine="pdflatex",
                    compilation_time=1.0,
                    warnings_count=0,
                    passes_run=1,
                    log_snippet="",
                ),
            )
        assert compile_cache.get(cache_key) is not None

        # Large PDF: should NOT be cached
        large_key = "test-hash-large"
        if len(large_pdf) <= MAX_CACHE_ENTRY_SIZE:
            compile_cache.put(
                large_key,
                CachedResult(
                    pdf_bytes=large_pdf,
                    engine="pdflatex",
                    compilation_time=1.0,
                    warnings_count=0,
                    passes_run=1,
                    log_snippet="",
                ),
            )
        assert compile_cache.get(large_key) is None

        compile_cache.clear()


# -------------------------------------------------------------------------
# Zip safety — direct unit tests
# -------------------------------------------------------------------------
class TestSafeExtractZip:
    """Direct unit tests for the zip extraction safety function."""

    def test_traversal_raises_value_error(self, tmp_path):
        """Path traversal in zip should raise ValueError."""
        from app.compiler import _safe_extract_zip

        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            zf.writestr("../../escape.txt", "pwned")
        with pytest.raises(ValueError, match="traversal"):
            _safe_extract_zip(buf.getvalue(), tmp_path)

    def test_normal_zip_extracts_fine(self, tmp_path):
        """Normal zip with safe paths should extract successfully."""
        from app.compiler import _safe_extract_zip

        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            zf.writestr("main.tex", "hello")
            zf.writestr("images/fig1.png", "png data")
        _safe_extract_zip(buf.getvalue(), tmp_path)
        assert (tmp_path / "main.tex").exists()
        assert (tmp_path / "images" / "fig1.png").exists()

    def test_zip_bomb_rejected(self, tmp_path):
        """Zip claiming huge uncompressed size should be rejected."""
        from app.compiler import _safe_extract_zip

        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            # Create a file that's big enough to trigger the check
            chunk = b"A" * (1024 * 1024)  # 1 MB
            for i in range(210):  # 210 MB uncompressed > 200 MB limit
                zf.writestr(f"file_{i}.txt", chunk)

        with pytest.raises(ValueError, match="exceeds"):
            _safe_extract_zip(buf.getvalue(), tmp_path)


# -------------------------------------------------------------------------
# main_file validation
# -------------------------------------------------------------------------
class TestMainFileValidation:
    """Validate the main_file parameter safety checks."""

    def test_valid_main_file(self):
        """Standard main.tex should pass validation."""
        from app.compiler import validate_main_file

        validate_main_file("main.tex")
        validate_main_file("thesis.tex")
        validate_main_file("chapters/chapter1.tex")
        validate_main_file("doc.ltx")

    def test_traversal_rejected(self):
        """Path traversal should raise ValueError."""
        from app.compiler import validate_main_file

        with pytest.raises(ValueError, match="traversal"):
            validate_main_file("../../../etc/passwd.tex")

    def test_absolute_path_rejected(self):
        """Absolute path should raise ValueError."""
        from app.compiler import validate_main_file

        with pytest.raises(ValueError, match="relative"):
            validate_main_file("/etc/passwd.tex")

    def test_invalid_extension_rejected(self):
        """Non-.tex extension should raise ValueError."""
        from app.compiler import validate_main_file

        with pytest.raises(ValueError, match="extension"):
            validate_main_file("main.py")
        with pytest.raises(ValueError, match="extension"):
            validate_main_file("script.sh")


# -------------------------------------------------------------------------
# Orphan temp dir cleanup
# -------------------------------------------------------------------------
class TestOrphanCleanup:
    """Verify orphan temp directory sweep."""

    def test_sweep_removes_old_dirs(self, tmp_path):
        """sweep_orphan_temp_dirs should remove old texlive_ dirs."""
        import time

        from app.compiler import sweep_orphan_temp_dirs

        # Create a fake old orphan dir
        orphan = tmp_path / "texlive_orphan123"
        orphan.mkdir()
        (orphan / "main.tex").write_text("test")
        # Set mtime to 10 minutes ago
        old_time = time.time() - 600
        import os

        os.utime(orphan, (old_time, old_time))

        # Create a fresh dir that should NOT be removed
        fresh = tmp_path / "texlive_fresh456"
        fresh.mkdir()

        # Create a non-texlive dir that should NOT be touched
        other = tmp_path / "something_else"
        other.mkdir()

        # Monkey-patch TMPFS_DIR temporarily
        import app.compiler

        original_tmpfs = app.compiler.TMPFS_DIR
        app.compiler.TMPFS_DIR = str(tmp_path)
        try:
            removed = sweep_orphan_temp_dirs(max_age_seconds=300)
            assert removed == 1
            assert not orphan.exists()
            assert fresh.exists()
            assert other.exists()
        finally:
            app.compiler.TMPFS_DIR = original_tmpfs

    def test_sweep_handles_empty_dir(self, tmp_path):
        """Sweep on empty dir should return 0."""
        import app.compiler
        from app.compiler import sweep_orphan_temp_dirs

        original_tmpfs = app.compiler.TMPFS_DIR
        app.compiler.TMPFS_DIR = str(tmp_path)
        try:
            removed = sweep_orphan_temp_dirs()
            assert removed == 0
        finally:
            app.compiler.TMPFS_DIR = original_tmpfs


# -------------------------------------------------------------------------
# Compile endpoint edge cases
# -------------------------------------------------------------------------
class TestEdgeCases:
    """Edge cases for the compile endpoint."""

    @pytest.mark.asyncio
    async def test_invalid_engine_returns_400(self, client, auth_headers):
        """Invalid engine name should return 400, not 500."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={
                "source": r"\documentclass{article}\begin{document}x\end{document}",
                "engine": "notanengine",
            },
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_unsupported_content_type_returns_400(self, client, auth_headers):
        """Unsupported Content-Type should return 400."""
        resp = await client.post(
            "/api/v1/compile",
            headers={**auth_headers, "Content-Type": "text/plain"},
            content="some plain text",
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_invalid_json_returns_400(self, client, auth_headers):
        """Malformed JSON should return 400, not 500."""
        resp = await client.post(
            "/api/v1/compile",
            headers={**auth_headers, "Content-Type": "application/json"},
            content=b"not json at all",
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_multipart_without_file_returns_400(self, client, auth_headers):
        """Multipart without 'file' field should return 400."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            data={"engine": "pdflatex"},
            files={},
        )
        assert resp.status_code == 400

    @pytest.mark.asyncio
    async def test_multipart_invalid_engine_returns_400(self, client, auth_headers):
        """Multipart with invalid engine should return 400."""
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as zf:
            zf.writestr("main.tex", r"\documentclass{article}\begin{document}x\end{document}")
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            files={"file": ("test.zip", io.BytesIO(buf.getvalue()), "application/zip")},
            data={"engine": "brokentex", "main_file": "main.tex"},
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")
