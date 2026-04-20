"""Structured logging configuration using structlog.

Configures structlog with a proper processor chain including
context-variable merging (for request IDs from ``asgi-correlation-id``),
timestamps, log levels, and JSON rendering via ``orjson``.

Call ``configure_logging()`` once at application startup from ``main.py``.
"""

import logging
import sys

import orjson
import structlog


def _orjson_dumps(data: dict, **_kw: object) -> str:
    """Serialize log event dict to JSON string via orjson."""
    return orjson.dumps(data, option=orjson.OPT_NON_STR_KEYS).decode("utf-8")


def configure_logging(log_level: str) -> None:
    """Configure structlog with a production-ready processor chain.

    Features:
    - ``merge_contextvars``: merges request-scoped context (request_id from
      ``asgi-correlation-id``) into every log entry.
    - ``TimeStamper``: ISO-8601 timestamps.
    - ``add_log_level``: adds ``level`` key.
    - ``JSONRenderer``: fast JSON output via orjson.
    - ``ProcessorFormatter``: bridges stdlib logging → structlog so third-party
      library logs also get structured output.

    Args:
        log_level: Python log level name (e.g. ``"info"``, ``"debug"``).
    """
    level = logging.getLevelNamesMapping()[log_level.upper()]

    shared_processors: list[structlog.types.Processor] = [
        structlog.contextvars.merge_contextvars,
        structlog.stdlib.add_log_level,
        structlog.stdlib.add_logger_name,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.UnicodeDecoder(),
    ]

    # Choose renderer: human-readable for debug, JSON for everything else
    if log_level.lower() == "debug":
        renderer: structlog.types.Processor = structlog.dev.ConsoleRenderer()
    else:
        renderer = structlog.processors.JSONRenderer(serializer=_orjson_dumps)

    structlog.configure(
        processors=[
            *shared_processors,
            structlog.stdlib.ProcessorFormatter.wrap_for_formatter,
        ],
        logger_factory=structlog.stdlib.LoggerFactory(),
        wrapper_class=structlog.stdlib.BoundLogger,
        cache_logger_on_first_use=True,
    )

    # Bridge stdlib logging through structlog
    formatter = structlog.stdlib.ProcessorFormatter(
        processors=[
            structlog.stdlib.ProcessorFormatter.remove_processors_meta,
            renderer,
        ],
        foreign_pre_chain=shared_processors,
    )

    root_logger = logging.getLogger()
    root_logger.handlers.clear()

    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(formatter)
    root_logger.addHandler(handler)
    root_logger.setLevel(level)

    # Quieten noisy third-party loggers
    logging.getLogger("uvicorn.access").setLevel(logging.WARNING)
    logging.getLogger("uvicorn.error").setLevel(level)
