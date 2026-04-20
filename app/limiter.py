"""Centralized rate limiter configuration."""

from slowapi import Limiter
from slowapi.util import get_remote_address


def _get_api_key_or_ip(request: object) -> str:
    """Rate limit key function — use API key if present, else IP."""
    api_key = request.headers.get("X-API-Key")
    if api_key:
        return api_key
    return get_remote_address(request)


limiter = Limiter(key_func=_get_api_key_or_ip)
