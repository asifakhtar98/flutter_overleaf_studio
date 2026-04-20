"""In-memory LRU compilation cache with TTL eviction."""

import threading
from dataclasses import dataclass

import cachetools

from app.config import settings


@dataclass
class CachedResult:
    """Cached compilation result."""

    pdf_bytes: bytes
    engine: str
    compilation_time: float
    warnings_count: int
    passes_run: int
    log_snippet: str


class CompileCache:
    """Thread-safe in-memory LRU cache for compiled PDFs.

    Uses cachetools.TTLCache for automatic time-based eviction.
    No external service required — pure in-process Python.
    """

    def __init__(self, maxsize: int, ttl: int) -> None:
        self._cache: cachetools.TTLCache = cachetools.TTLCache(maxsize=maxsize, ttl=ttl)
        self._lock = threading.Lock()
        self._hits = 0
        self._misses = 0

    def get(self, key: str) -> CachedResult | None:
        """Retrieve a cached result by input hash.

        Args:
            key: SHA-256 hash of the compilation input.

        Returns:
            CachedResult if found, None otherwise.
        """
        with self._lock:
            result = self._cache.get(key)
            if result is not None:
                self._hits += 1
            else:
                self._misses += 1
            return result

    def put(self, key: str, result: CachedResult) -> None:
        """Store a compilation result in the cache.

        Args:
            key: SHA-256 hash of the compilation input.
            result: The compilation result to cache.
        """
        with self._lock:
            self._cache[key] = result

    @property
    def hits(self) -> int:
        """Total cache hits."""
        return self._hits

    @property
    def misses(self) -> int:
        """Total cache misses."""
        return self._misses

    @property
    def size(self) -> int:
        """Current number of entries in the cache."""
        with self._lock:
            return len(self._cache)

    @property
    def max_size(self) -> int:
        """Maximum cache capacity."""
        return self._cache.maxsize

    def clear(self) -> None:
        """Clear all cached entries. Useful for testing."""
        with self._lock:
            self._cache.clear()
            self._hits = 0
            self._misses = 0


# Singleton cache instance
compile_cache = CompileCache(
    maxsize=settings.cache_max_size,
    ttl=settings.cache_ttl_seconds,
)
