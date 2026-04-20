"""Application configuration from environment variables."""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    All settings follow the 12-factor app methodology.
    """

    # --- Required ---
    api_keys: str = "dev-key-4523636"

    # --- CORS ---
    allowed_origins: str = "*"

    # --- Limits ---
    max_upload_size_mb: int = 50
    compilation_timeout: int = 120
    rate_limit: str = "30/minute"

    # --- Logging ---
    log_level: str = "info"

    # --- Server ---
    workers: int = 4

    # --- Performance: Cache ---
    cache_max_size: int = 200
    cache_ttl_seconds: int = 1800

    # --- Performance: Compilation ---
    use_tmpfs: bool = True
    max_concurrent_compiles: int = 4

    @property
    def api_keys_set(self) -> set[str]:
        """Parse comma-separated API keys into a set."""
        return {k.strip() for k in self.api_keys.split(",") if k.strip()}

    @property
    def allowed_origins_list(self) -> list[str]:
        """Parse comma-separated CORS origins into a list."""
        return [o.strip() for o in self.allowed_origins.split(",") if o.strip()]

    @property
    def max_upload_size_bytes(self) -> int:
        """Max upload size in bytes."""
        return self.max_upload_size_mb * 1024 * 1024

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8", "extra": "ignore"}


settings = Settings()
