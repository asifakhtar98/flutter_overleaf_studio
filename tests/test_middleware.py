"""Tests for middleware: request ID, body limit, request logging."""

import pytest

from tests.conftest import assert_error_envelope


class TestRequestID:
    """Verify X-Request-ID header propagation."""

    @pytest.mark.asyncio
    async def test_request_id_generated_when_not_sent(self, client):
        """Response should include a generated X-Request-ID."""
        resp = await client.get("/api/v1/health")
        assert resp.status_code == 200
        request_id = resp.headers.get("x-request-id")
        assert request_id is not None
        assert len(request_id) > 0

    @pytest.mark.asyncio
    async def test_request_id_echoed_when_sent(self, client):
        """Client-provided X-Request-ID should be echoed back."""
        import uuid

        # asgi-correlation-id validates UUID4 format, so generate a real one
        custom_id = uuid.uuid4().hex
        resp = await client.get(
            "/api/v1/health",
            headers={"X-Request-ID": custom_id},
        )
        assert resp.status_code == 200
        assert resp.headers.get("x-request-id") == custom_id

    @pytest.mark.asyncio
    async def test_request_id_in_error_responses(self, client):
        """Error responses should include X-Request-ID in both header and body."""
        resp = await client.post(
            "/api/v1/compile",
            json={"source": "test"},
        )
        # 401 — no API key
        assert resp.status_code == 401
        assert resp.headers.get("x-request-id") is not None

        data = resp.json()
        assert_error_envelope(data, error_code="MISSING_API_KEY")
        # request_id in body should match header
        assert data["request_id"] == resp.headers.get("x-request-id")

    @pytest.mark.asyncio
    async def test_request_id_on_compile_endpoint(self, client, auth_headers, simple_tex):
        """Compile endpoint should include X-Request-ID."""
        resp = await client.post(
            "/api/v1/compile",
            headers=auth_headers,
            json={"source": simple_tex},
        )
        assert resp.headers.get("x-request-id") is not None


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
        data = resp.json()
        assert_error_envelope(data, error_code="UPLOAD_TOO_LARGE")

    @pytest.mark.asyncio
    async def test_malformed_content_length_rejected(self, client, auth_headers):
        """Malformed Content-Length should return 400, not crash."""
        resp = await client.post(
            "/api/v1/compile",
            headers={
                **auth_headers,
                "Content-Length": "not-a-number",
                "Content-Type": "application/json",
            },
            content=b'{"source": "small"}',
        )
        assert resp.status_code == 400
        data = resp.json()
        assert_error_envelope(data, error_code="INVALID_REQUEST")

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
