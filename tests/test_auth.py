"""Tests for API key authentication."""

import pytest


@pytest.mark.asyncio
async def test_missing_api_key_returns_401(client):
    """Request without API key should return 401."""
    resp = await client.post(
        "/api/v1/compile",
        json={"source": "test"},
    )
    assert resp.status_code == 401


@pytest.mark.asyncio
async def test_invalid_api_key_returns_403(client):
    """Request with wrong API key should return 403."""
    resp = await client.post(
        "/api/v1/compile",
        headers={"X-API-Key": "wrong-key"},
        json={"source": "test"},
    )
    assert resp.status_code == 403


@pytest.mark.asyncio
async def test_valid_api_key_accepted(client, auth_headers, simple_tex):
    """Request with valid API key should not return 401/403."""
    resp = await client.post(
        "/api/v1/compile",
        headers=auth_headers,
        json={"source": simple_tex},
    )
    # Should be 200 (success) or 422 (compile error), not 401/403
    assert resp.status_code not in (401, 403)


@pytest.mark.asyncio
async def test_second_api_key_also_works(client, simple_tex):
    """Multiple API keys should all be valid."""
    resp = await client.post(
        "/api/v1/compile",
        headers={"X-API-Key": "test-key-456"},
        json={"source": simple_tex},
    )
    assert resp.status_code not in (401, 403)
