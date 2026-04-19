"""Tests for unified error envelope across all error types."""

import io
import zipfile

import pytest

from tests.conftest import assert_error_envelope


class TestErrorEnvelopeConsistency:
    """Every error response should use the ErrorEnvelope format."""

    @pytest.mark.asyncio
    async def test_401_missing_api_key(self, client):
        """Missing API key → 401 with MISSING_API_KEY error code."""
        resp = await client.post(
            "/api/v1/compile",
            json={"source": "test"},
        )
        assert resp.status_code == 401
        assert_error_envelope(resp.json(), error_code="MISSING_API_KEY")

    @pytest.mark.asyncio
    async def test_403_invalid_api_key(self, client):
        """Invalid API key → 403 with INVALID_API_KEY error code."""
        resp = await client.post(
            "/api/v1/compile",
            headers={"X-API-Key": "wrong-key"},
            json={"source": "test"},
        )
        assert resp.status_code == 403
        assert_error_envelope(resp.json(), error_code="INVALID_API_KEY")

    @pytest.mark.asyncio
    async def test_400_empty_source(self, client, auth_headers):
        """Empty source → 400 with INVALID_REQUEST error code."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={"source": ""},
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_400_invalid_json(self, client, auth_headers):
        """Malformed JSON → 400 with INVALID_REQUEST error code."""
        resp = await client.post(
            "/api/v1/compile",
            headers={**auth_headers, "Content-Type": "application/json"},
            content=b"not json at all",
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_400_invalid_engine(self, client, auth_headers):
        """Invalid engine → 400 with INVALID_REQUEST and valid_engines hint."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={
                "source": r"\documentclass{article}\begin{document}x\end{document}",
                "engine": "notanengine",
            },
        )
        assert resp.status_code == 400
        data = resp.json()
        assert_error_envelope(data, error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_400_unsupported_content_type(self, client, auth_headers):
        """Unsupported Content-Type → 400 with INVALID_REQUEST."""
        resp = await client.post(
            "/api/v1/compile",
            headers={**auth_headers, "Content-Type": "text/plain"},
            content="some plain text",
        )
        assert resp.status_code == 400
        assert_error_envelope(resp.json(), error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_413_oversized_body(self, client, auth_headers):
        """Oversized Content-Length → 413 with UPLOAD_TOO_LARGE."""
        resp = await client.post(
            "/api/v1/compile",
            headers={
                **auth_headers,
                "Content-Length": str(100 * 1024 * 1024),
                "Content-Type": "application/json",
            },
            content=b'{"source": "small"}',
        )
        assert resp.status_code == 413
        assert_error_envelope(resp.json(), error_code="UPLOAD_TOO_LARGE")

    @pytest.mark.asyncio
    async def test_422_compilation_failure(self, client, auth_headers, invalid_tex):
        """Compilation failure → 422 with COMPILATION_FAILED and log detail."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={"source": invalid_tex},
        )
        assert resp.status_code == 422
        data = resp.json()
        assert_error_envelope(data, error_code="COMPILATION_FAILED")
        # Should include compilation detail
        if data.get("detail"):
            assert "log" in data["detail"]
            assert "engine" in data["detail"]

    @pytest.mark.asyncio
    async def test_400_multipart_invalid_engine(self, client, auth_headers):
        """Multipart with invalid engine → 400 with INVALID_REQUEST."""
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

    @pytest.mark.asyncio
    async def test_400_main_file_traversal(self, client, auth_headers):
        """Path traversal in main_file → 400 with INVALID_REQUEST."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={
                "source": r"\documentclass{article}\begin{document}x\end{document}",
                "main_file": "../../../etc/passwd.tex",
            },
        )
        assert resp.status_code == 400
        data = resp.json()
        assert_error_envelope(data, error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_400_main_file_invalid_extension(self, client, auth_headers):
        """Invalid main_file extension → 400 with INVALID_REQUEST."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={
                "source": r"\documentclass{article}\begin{document}x\end{document}",
                "main_file": "main.py",
            },
        )
        assert resp.status_code == 400
        data = resp.json()
        assert_error_envelope(data, error_code="INVALID_REQUEST")

    @pytest.mark.asyncio
    async def test_error_responses_always_have_request_id(self, client, auth_headers):
        """All error responses must include a request_id."""
        # Test multiple error types
        responses = [
            await client.post("/api/v1/compile", json={"source": "test"}),  # 401
            await client.post(
                "/api/v1/compile",
                headers={"X-API-Key": "bad-key"},
                json={"source": "test"},
            ),  # 403
            await client.post(
                "/api/v1/compile",
                headers=auth_headers,
                json={"source": ""},
            ),  # 400
        ]
        for resp in responses:
            data = resp.json()
            assert "request_id" in data, f"Status {resp.status_code} missing request_id: {data}"
            assert isinstance(data["request_id"], str)
            assert len(data["request_id"]) > 0
