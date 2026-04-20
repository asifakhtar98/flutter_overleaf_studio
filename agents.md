#TeX Live Compilation Server (plus Flutter overlead clone)
-No backward compatibility needed as we don't have any user base yet.

> **Read this file in full before making any change.** It is the single source of truth for architecture, conventions, and constraints.

---

## Product Brief

**Product**: Overleaf Mvp (TeX Live Full REST API Server+Flutter thin frontend)
**Codename**: overleaf-server / flutter-overleaf
**One-liner**: Stateless REST API — LaTeX in, PDF out. No database,  file persistence only in frontend (drift sql).
**Frontend**: Flutter web & Flutter mobile only

### Scope

| In scope | Out of scope — do NOT add |
|----------|--------------------------|
| Raw `.tex` or `.zip` → PDF via HTTP | Frontend code of any kind |
| `pdflatex`, `xelatex`, `lualatex`, `latexmk` | Database, ORM, or persistent storage |
| API key auth (`X-API-Key` header) | User registration, login, or sessions |
| In-memory LRU cache (TTL, hash-keyed) | Redis, Memcached, or external cache |
| Rate limiting (SlowAPI, in-process) | Queue systems (Celery, RQ) |
| tmpfs compilation (`/dev/shm`) | Disk-backed temp dirs |
| `ProcessPoolExecutor` concurrency | Threading, `asyncio.subprocess`, or `shell=True` |
| ARM64 Docker images only | x86/amd64 images |

---

## Architecture (Immutable)

### Infrastructure — no deviations

| Component | Value | Non-negotiable |
|-----------|-------|----------------|
| Cloud | Oracle Cloud Free Tier | ✅ |
| VM | VM.Standard.A1.Flex — 4 OCPU, 24 GB RAM | ✅ |
| OS | Ubuntu 22.04 LTS (aarch64) | ✅ |
| Container | Single Docker container | ✅ |
| Port | 8080 | ✅ |
| Arch | ARM64 everywhere (dev, CI, prod) | ✅ |

### Stack — pinned, do not swap

| Layer | Technology |
|-------|-----------|
| Framework | FastAPI (Python 3.11+, async) |
| ASGI | Uvicorn |
| TeX | TeX Live scheme-full (no docs/sources) |
| Auth | `X-API-Key` header → `settings.api_keys_set` |
| Rate limit | SlowAPI (in-memory, keyed by API key or IP) |
| Cache | `cachetools.TTLCache` in `app/cache.py` |
| Compilation | `concurrent.futures.ProcessPoolExecutor` in `app/compiler.py` |
| Request ID | `asgi-correlation-id` — X-Request-ID header, structlog context |
| Errors | `app/errors.py` — `TexLiveError` hierarchy + `ErrorEnvelope` |
| Middleware | `app/middleware.py` — request ID, body limit, request logging |
| JSON | `orjson` — fast JSON rendering for logs + error responses |
| Tests | pytest + httpx (async), run inside container |
| Lint | ruff (configured in `pyproject.toml`) |
| Logging | structlog (structured, JSON via orjson, configured in `app/logging.py`) |
| Docker | Multi-stage build (`Dockerfile`), dev with `--reload` (`Dockerfile.dev`) |
| Python env | `venv` at `/opt/venv` — never `--break-system-packages` |

### API — exact endpoints

| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/v1/health` | GET | No | Status + TeX Live version + cache stats |
| `/api/v1/compile` | POST | Yes (`X-API-Key`) | LaTeX → PDF |
| `/docs` | GET | No | OpenAPI/Swagger |
| `/redoc` | GET | No | ReDoc |

### Request modes — two, no others

1. **JSON body**: `{"source": "...", "engine": "pdflatex", "draft": false, "enable_cache": true}`
2. **Multipart form**: `file` (zip) + `engine` + `main_file` + `draft` + `enable_cache`

### Response contract

**Success (200)**: JSON with base64-encoded PDF and log. Metadata in both body and headers:
```
Content-Type: application/json
X-Compilation-Time: 4.20
X-Engine: pdflatex
X-Warnings-Count: 3
X-Cached: false
X-Passes-Run: 2
X-Request-ID: <uuid-hex>
```

```json
{
  "pdf": "<base64-encoded-pdf>",
  "log": "LaTeX compiler output with warnings"
}
```

**All errors** — unified `ErrorEnvelope` format:
```json
{
  "request_id": "<uuid-hex>",
  "error_code": "COMPILATION_FAILED",
  "message": "Compilation failed",
  "detail": {
    "log": "full stdout+stderr",
    "engine": "pdflatex",
    "compilation_time": 2.31,
    "passes_run": 1
  }
}
```

**Error codes**: `COMPILATION_FAILED` (422), `INVALID_REQUEST` (400), `MISSING_API_KEY` (401), `INVALID_API_KEY` (403), `UPLOAD_TOO_LARGE` (413), `RATE_LIMITED` (429), `INTERNAL_ERROR` (500).

---

## Project Structure (canonical)

```
├── overleaf_server/
│   ├── app/
│   │   ├── __init__.py              # Package + __version__
│   │   ├── main.py                  # Thin wiring — CORS, lifespan, router mounts
│   │   ├── config.py                # pydantic-settings from env vars
│   │   ├── auth.py                  # API key dependency (raises TexLiveError)
│   │   ├── cache.py                 # CompileCache (TTLCache wrapper)
│   │   ├── compiler.py              # Core compilation: tmpfs, smart passes, pool, orphan cleanup
│   │   ├── errors.py                # TexLiveError hierarchy + ErrorEnvelope + handlers
│   │   ├── logging.py               # structlog configuration (orjson, contextvars)
│   │   ├── middleware.py            # Request ID (asgi-correlation-id), body limit, request logging
│   │   ├── models.py                # Pydantic schemas (Engine, CompileRequest, CacheStats, HealthResponse)
│   │   └── routers/
│   │       ├── __init__.py
│   │       ├── compile.py           # POST /api/v1/compile (Content-Type dispatch)
│   │       └── health.py            # GET /api/v1/health
│   ├── tests/
│   │   ├── __init__.py
│   │   ├── conftest.py              # Async client, fixtures, assert_error_envelope helper
│   │   ├── test_auth.py             # Auth error envelope tests
│   │   ├── test_compile.py          # Compilation + cache tests
│   │   ├── test_errors.py           # ErrorEnvelope consistency across all error types
│   │   ├── test_hardening.py        # Path traversal, pool recovery, orphan cleanup, main_file validation
│   │   ├── test_health.py           # Health endpoint + request ID
│   │   ├── test_middleware.py       # Request ID, body limit, request logging
│   │   └── fixtures/                # .tex, .bib test files
│   ├── test_samples/                # Sample .tex files for manual verification
│   │   ├── 01_hello_world.tex
│   │   ├── 02_multipage_toc.tex
│   │   ├── 03_math_heavy.tex
│   │   ├── 04_bibliography/        # Multi-file zip project
│   │   ├── 05_images_tikz.tex
│   │   └── 06_unicode_xelatex.tex
│   ├── test_outputs/                # ← gitignored, generated PDFs
│   ├── scripts/
│   │   ├── server-setup.sh          # One-time Oracle VM bootstrap
│   │   ├── deploy.sh                # Blue-green deploy
│   │   └── test_samples.sh          # Compiles all test_samples/ via API
│   ├── Dockerfile                   # Prod: multi-stage, venv, fontconfig
│   ├── Dockerfile.dev               # Dev: hot-reload, --reload-dir app
│   ├── docker-compose.yml           # Local dev
│   ├── docker-compose.prod.yml      # Production
│   ├── texlive.profile              # TeX Live installer profile (ARM64)
│   ├── requirements.txt             # Pinned prod deps
│   ├── requirements-dev.txt         # Extends requirements.txt + test/lint
│   ├── pyproject.toml               # ruff, pytest, coverage config
│   ├── .env.example                 # Template — copy to .env
│   ├── tests.http                   # VS Code REST Client tests
│   ├── README.md                    # Public docs
│   └── DEPLOY_GUIDE.md              # Step-by-step production deployment
├── flutter_overleaf/                # Flutter frontend code
├── .github/workflows/
│   ├── ci.yml                   # Lint → Test → Build ARM64 → Push
│   └── cd.yml                   # SSH deploy on main
├── .vscode/
│   ├── extensions.json
│   ├── settings.json
│   └── tasks.json               # Dev/test/deploy task runner
├── agents.md                    # ← This file
├── .gitignore
└── LICENSE                      # MIT
```


---

## Performance Architecture (MANDATORY — all are load-bearing)

These are **structural requirements**, not optimizations to toggle. Do not weaken, bypass, or make optional.

| # | Feature | Where | What it does | Impact |
|---|---------|-------|-------------|--------|
| 1 | **tmpfs** | `compiler.py:TMPFS_DIR` | All temp dirs in `/dev/shm` | ~40-60% speedup |
| 2 | **Pre-compiled `.fmt`** | `Dockerfile: fmtutil-sys --all` | Avoids format parsing per-request | ~20-30% speedup |
| 3 | **LRU cache** | `cache.py:compile_cache` | SHA-256 keyed `TTLCache(200, 1800s)` | ~10ms cache hits |
| 4 | **Smart passes** | `compiler.py:_compile_sync` | Parse log for rerun warnings, max 3 | ~30-50% fewer passes |
| 5 | **Draft mode** | `compiler.py:_compile_sync` | `\PassOptionsToPackage{draft}{graphicx}` | ~50-70% on image-heavy |
| 6 | **Process pool** | `compiler.py:get_executor` | `ProcessPoolExecutor(max_workers=4)` + crash recovery | True parallelism |
| 7 | **Engine paths** | `compiler.py:ENGINE_PATHS` | `shutil.which()` once at import | Zero per-request PATH lookup |
| 8 | **Health caching** | `health.py:_get_texlive_version` | `@lru_cache` — no shell-out per request | Instant health checks |
| 9 | **Fontconfig** | `Dockerfile: fc-cache` | TeX Live fonts registered with fontconfig | XeLaTeX/LuaLaTeX font discovery |
| 10 | **Body size limit** | `middleware.py` | Rejects oversized/malformed `Content-Length` | Prevents OOM |
| 11 | **Cache entry cap** | `compiler.py:MAX_CACHE_ENTRY_SIZE` | Skip caching PDFs > 10 MB | Protects cache budget |
| 12 | **Graceful shutdown** | `Dockerfile: --timeout-graceful-shutdown 30` | In-flight compiles finish on SIGTERM | No zombie temp dirs |
| 13 | **Pool crash recovery** | `compiler.py:_recreate_executor` | Catches `BrokenProcessPool`, rebuilds | Survives TeX segfaults |
| 14 | **Request ID** | `middleware.py` + `asgi-correlation-id` | UUID per request, bound to logs + response | Full request tracing |
| 15 | **Orphan cleanup** | `compiler.py:sweep_orphan_temp_dirs` | Startup sweep of stale `texlive_*` dirs | Prevents tmpfs leak |
| 16 | **Unified errors** | `errors.py:ErrorEnvelope` | All errors use same JSON shape with `request_id` | Consistent DX |
| 17 | **main_file validation** | `compiler.py:validate_main_file` | Blocks path traversal + invalid extensions | Security hardening |
| 18 | **File I/O hardening** | `compiler.py:_compile_sync` | All file ops wrapped in `try/except OSError` | No silent worker crashes |

---

## Environment Variables (complete list)

| Variable | Required | Default | Type | Description |
|----------|----------|---------|------|-------------|
| `API_KEYS` | **Yes** | — | CSV string | Comma-separated valid API keys |
| `ALLOWED_ORIGINS` | No | `*` | CSV string | CORS origins |
| `MAX_UPLOAD_SIZE_MB` | No | `50` | int | Max zip upload MB |
| `COMPILATION_TIMEOUT` | No | `120` | int (seconds) | Hard timeout per compilation |
| `RATE_LIMIT` | No | `30/minute` | SlowAPI format | Per-key rate limit |
| `LOG_LEVEL` | No | `info` | string | `debug`, `info`, `warning`, `error` |
| `WORKERS` | No | `4` | int | Uvicorn workers (prod CMD uses `$WORKERS`) |
| `CACHE_MAX_SIZE` | No | `200` | int | Max LRU cache entries |
| `CACHE_TTL_SECONDS` | No | `1800` | int (seconds) | Cache entry TTL |
| `USE_TMPFS` | No | `true` | bool | Use `/dev/shm` for temp dirs |
| `MAX_CONCURRENT_COMPILES` | No | `4` | int | ProcessPoolExecutor workers |

---

## Rules for AI Agents (STRICT)

### MUST

1. Keep the API **stateless** — never persist files between requests.
2. Use `subprocess.run()` with **list args** — never `shell=True`.
3. Create temp dirs via `tempfile.mkdtemp(dir=TMPFS_DIR)` — never raw `/tmp`.
4. Run compilation via `ProcessPoolExecutor` — never `subprocess` in async handlers.
5. Use `ENGINE_PATHS` dict for engine binaries — never call `shutil.which()` per-request.
6. Use `_error_result()` helper for failure `CompileResult` — never construct manually.
7. Use `_run_engine()` for subprocess calls in compiler — never inline `subprocess.run()`.
8. Use `_ParsedRequest` dataclass in compile router — never parse request in endpoint body.
9. Use `_parse_request(request)` with Content-Type dispatch — never mix FastAPI `Body` + `Form` defaults.
10. Add tests for any new endpoint or compiler feature — no untested code ships.
11. Use Pydantic `BaseModel` for all request/response schemas — no raw dicts.
12. Use `StrEnum` for enums — not `str, Enum`.
13. Clean up temp dirs in `finally` blocks — no cleanup-on-success-only.
14. Follow existing module structure — new endpoints go in `app/routers/`, new models in `app/models.py`.
15. Update this file and other `.md` files when making architectural or behavioral changes.
16. Register TeX Live fonts with fontconfig in Dockerfiles — XeLaTeX/LuaLaTeX need `fc-cache`.
17. Use `python3.11 -m venv /opt/venv` in Dockerfiles — never `pip install --break-system-packages`.
18. Use `Path.is_relative_to()` for path containment checks — never `str.startswith()`.
19. Catch `BrokenProcessPool` around `run_in_executor` calls — recreate pool on crash.
20. Skip caching PDFs larger than `MAX_CACHE_ENTRY_SIZE` — protect cache memory budget.
21. Use `TexLiveError` subclasses for domain errors — never raise `HTTPException` directly.
22. All error responses must use `ErrorEnvelope` format with `request_id`, `error_code`, `message`.
23. Use `validate_main_file()` before compilation — reject traversal/invalid extensions.
24. Wrap all file I/O in `_compile_sync` with `try/except OSError` — no silent worker crashes.
25. Use `configure_logging()` from `app/logging.py` — never inline `structlog.configure()` in main.
26. Register middleware via `register_middleware()` from `app/middleware.py` — never inline in main.
27. Register error handlers via `register_error_handlers()` from `app/errors.py` — never inline in main.

### MUST NOT

1. Add a database, ORM, or migration system.
2. Add user registration, login, OAuth, or JWT.
3. Use `shell=True` in any subprocess call.
4. Store files after compilation completes.
5. Add frontend code to this repo.
6. Change the port from 8080.
7. Install system packages outside Docker.
8. Use x86/amd64 base images.
9. Compile in `/tmp` when `/dev/shm` is available.
10. Run more than `MAX_PASSES` (3) compiler passes.
11. Resolve engine paths per-request.
12. Block the async event loop with synchronous compilation.
13. Duplicate logic — use existing helpers (`_error_result`, `_run_engine`, `_collect_output`, `_parse_request`).
14. Add `ENTRYPOINT` in Dockerfiles — use `CMD` (allows override for debugging).
15. Hardcode worker counts — always use `$WORKERS` env var.
16. Use `structlog.get_level_from_name()` — removed in v25.x. Use `logging.getLevelNamesMapping()` instead.
17. Use `pip install --break-system-packages` — Ubuntu 22.04's pip 22.x doesn't support it.
18. Construct error response dicts manually — use `ErrorEnvelope` and `TexLiveError` subclasses.
19. Raise `HTTPException` for domain errors — use `ValidationError`, `CompilationError`, `UploadTooLargeError`.
20. Put middleware or exception handlers inline in `main.py` — use `middleware.py` and `errors.py`.

### Code Conventions

| Rule | Standard |
|------|----------|
| Python version | 3.11+ with type hints on every function |
| Endpoints | `async def` in `app/routers/` |
| Docstrings | Google-style |
| Linter | `ruff` (config in `pyproject.toml`) |
| Formatter | `ruff format` |
| Logging | `structlog` structured logging |
| Enums | `StrEnum` (not `str, Enum`) |
| Config | `pydantic-settings` with `model_config` |
| Tests | `pytest` + `httpx` async, run inside container |
| Regex | Pre-compile at module level (`re.compile()`), never inline `re.search()` with string pattern |

### Commit & PR Rules

- Every PR must pass `ruff check app/ tests/` with zero errors.
- Every new endpoint must have corresponding tests in `tests/`.
- No `# TODO` or `# FIXME` in merged code — fix before merge or create a GitHub issue.

---

## Development Workflow (exact commands)

```bash
cd overleaf_server

# Setup
cp .env.example .env                    # Edit API_KEYS at minimum

# Start (first build ~20-30 min for TeX Live)
docker compose up --build

# Test
docker compose exec api python3 -m pytest tests/ -v --tb=short

# Lint
docker compose exec api python3 -m ruff check app/ tests/

# Format
docker compose exec api python3 -m ruff format app/ tests/

# Stop
docker compose down --remove-orphans
```

Or use VS Code: `Cmd+Shift+P → Tasks: Run Task` → pick from grouped task list.

---

## CI/CD (exact flow)

```
Push to any branch → CI: ruff check → pytest → build ARM64 image (QEMU)
Push to main       → CI + CD: above → push to Docker Hub → SSH deploy → health check
```

- CI: `.github/workflows/ci.yml`
- CD: `.github/workflows/cd.yml`
- Deploy script: `scripts/deploy.sh` (blue-green with health check)

---

## Flutter Frontend Integration (for reference only — no code here)

- OpenAPI spec at `/docs` → generate Dart client with `openapi-generator`
- CORS pre-configured via `ALLOWED_ORIGINS`
- Health endpoint → connection status indicator
- `draft=true` → fast preview mode for live editing
- `X-Cached` header → show cache badge in UI
- Future: WebSocket for live compilation log streaming
