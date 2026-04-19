"""Tests for the health endpoint."""

import pytest


@pytest.mark.asyncio
async def test_health_returns_200(client):
    """Health endpoint should return 200."""
    resp = await client.get("/api/v1/health")
    assert resp.status_code == 200


@pytest.mark.asyncio
async def test_health_response_structure(client):
    """Health response should have all expected fields."""
    resp = await client.get("/api/v1/health")
    data = resp.json()
    assert data["status"] == "healthy"
    assert "texlive_version" in data
    assert "engines" in data
    assert "uptime_seconds" in data
    assert "cache_stats" in data


@pytest.mark.asyncio
async def test_health_lists_engines(client):
    """Health should list available engines."""
    resp = await client.get("/api/v1/health")
    engines = resp.json()["engines"]
    assert isinstance(engines, list)
    # At minimum pdflatex should be available in the container
    # (this test may show empty list on local machine without TeX Live)


@pytest.mark.asyncio
async def test_health_cache_stats(client):
    """Health should include cache statistics."""
    resp = await client.get("/api/v1/health")
    stats = resp.json()["cache_stats"]
    assert "hits" in stats
    assert "misses" in stats
    assert "size" in stats
    assert "max_size" in stats


@pytest.mark.asyncio
async def test_health_no_auth_required(client):
    """Health endpoint should not require API key."""
    resp = await client.get("/api/v1/health")
    assert resp.status_code == 200
