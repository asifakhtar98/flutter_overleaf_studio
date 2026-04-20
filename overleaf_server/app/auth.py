"""API key authentication dependency."""

from fastapi import Security
from fastapi.security import APIKeyHeader

from app.config import settings
from app.errors import ErrorCode, TexLiveError

api_key_header = APIKeyHeader(
    name="X-API-Key",
    auto_error=False,
    description="Enter your API key here to authenticate requests from Swagger UI.",
)


async def require_api_key(
    api_key: str | None = Security(api_key_header),
) -> str:
    """Validate the API key from the X-API-Key header.

    Args:
        api_key: The API key extracted from the request header.

    Returns:
        The validated API key string.

    Raises:
        TexLiveError: 401 if missing, 403 if invalid.
    """
    if api_key is None:
        raise TexLiveError(
            status_code=401,
            error_code=ErrorCode.MISSING_API_KEY,
            message="Missing API key. Provide X-API-Key header.",
        )
    if api_key not in settings.api_keys_set:
        raise TexLiveError(
            status_code=403,
            error_code=ErrorCode.INVALID_API_KEY,
            message="Invalid API key.",
        )
    return api_key
