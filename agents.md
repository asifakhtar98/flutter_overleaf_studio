# 🤖 AI Agent Context — TeX Live Compilation API

> **Purpose**: This file provides complete project context for AI agents (Copilot, Gemini, Claude, etc.) working on this codebase. Read this first before making any changes.

---

## Product Brief

**Product**: TeX Live Full REST API Server
**Codename**: texlive-overleaf-minus-frontend
**One-liner**: A stateless REST API that accepts LaTeX source and returns compiled PDFs — the backend engine for an Overleaf-like editor.

### What It Does
- Accepts raw `.tex` source or zipped multi-file LaTeX projects via HTTP
- Compiles using `pdflatex`, `xelatex`, or `lualatex` (user's choice)
- Returns compiled PDF bytes with structured JSON metadata
- Handles BibTeX/Biber automatically when `.bib` files are detected
- Smart multi-pass compilation — only runs extra passes when actually needed
- In-memory result caching (hash-based, no DB) — identical inputs return instant results
- RAM-disk compilation (`/dev/shm`) — zero disk I/O during builds
- Draft mode for fast previews — skips image rendering

### What It Does NOT Do
- No frontend (a Flutter Overleaf-clone frontend will consume this API separately)
- No database
- No persistent file storage — every compilation is ephemeral
- No user management — auth is API-key-based only

---

## Architecture

### Infrastructure
| Component | Detail |
|-----------|--------|
| **Cloud** | Oracle Cloud Free Tier |
| **VM** | VM.Standard.A1.Flex — 4 OCPU, 24 GB RAM, ARM64 (Ampere) |
| **OS** | Ubuntu 22.04 LTS (aarch64) |
| **Container** | Docker (single container, no orchestrator) |
| **Port** | 8080 (HTTP, no TLS at app level) |
| **Architecture** | ARM64 throughout (local dev, CI, prod) |

### Application Stack
| Layer | Technology |
|-------|-----------|
| **Framework** | FastAPI (Python 3.11+) |
| **ASGI Server** | Uvicorn |
| **TeX Engine** | TeX Live (scheme-full, docs/sources stripped) |
| **Auth** | API key via `X-API-Key` header, multi-key allowlist from env |
| **Rate Limiting** | SlowAPI (in-memory, no Redis) |
| **Testing** | pytest + httpx (async) |
| **Containerization** | Docker multi-stage build |

### API Design
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/health` | GET | Health check + TeX Live version |
| `/api/v1/compile` | POST | Compile LaTeX → PDF |
| `/docs` | GET | Auto-generated OpenAPI/Swagger docs |

### Compilation Modes
1. **Single file**: JSON body with `source` field (raw `.tex` string)
2. **Multi-file project**: `multipart/form-data` with `.zip` upload

### Compile Request Parameters
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `engine` | string | `pdflatex` | One of: `pdflatex`, `xelatex`, `lualatex` |
| `main_file` | string | `main.tex` | Entry point `.tex` file (for zip uploads) |
| `source` | string | — | Raw LaTeX source (for single-file mode) |
| `file` | file | — | Zip archive (for multi-file mode) |
| `draft` | bool | `false` | Skip image rendering for fast preview |
| `enable_cache` | bool | `true` | Return cached PDF if identical input was compiled recently |

### Response Structure
**Success (200)**:
```json
{
  "success": true,
  "pdf": "<base64 or binary stream>",
  "engine": "pdflatex",
  "compilation_time": 4.2,
  "warnings_count": 3,
  "log_snippet": "..."
}
```
**Failure (422)**:
```json
{
  "success": false,
  "error": "Compilation failed",
  "exit_code": 1,
  "log": "full stdout+stderr from compiler",
  "engine": "pdflatex"
}
```

---

## Project Structure

```
texlive_overleaf_minus_frontend/
├── agents.md                    ← You are here
├── README.md
├── .env.example
├── .gitignore
├── docker-compose.yml           ← Local development
├── docker-compose.prod.yml      ← Production on Oracle VM
├── Dockerfile                   ← Production multi-stage build
├── Dockerfile.dev               ← Dev with hot-reload support
├── requirements.txt
├── pyproject.toml
├── app/
│   ├── __init__.py
│   ├── main.py                  ← FastAPI app entry point
│   ├── config.py                ← Settings from env vars
│   ├── auth.py                  ← API key auth dependency
│   ├── compiler.py              ← Core LaTeX compilation logic
│   ├── models.py                ← Pydantic request/response models
│   └── routers/
│       ├── __init__.py
│       ├── compile.py           ← /api/v1/compile endpoint
│       └── health.py            ← /api/v1/health endpoint
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_compile.py
│   ├── test_health.py
│   ├── test_auth.py
│   └── fixtures/
│       ├── simple.tex
│       └── multi_file.zip
├── scripts/
│   ├── server-setup.sh          ← One-time Oracle VM bootstrap
│   └── deploy.sh                ← Blue-green deploy script
├── .github/
│   └── workflows/
│       ├── ci.yml               ← Test + build + push
│       └── cd.yml               ← SSH deploy to Oracle VM
└── tests.http                   ← VS Code REST Client test file
```

---

## Key Design Decisions

### 1. Stateless Ephemeral Compilation
Every request creates a temp dir → compiles → returns PDF → deletes everything. No `/tmp` leaks. Cleanup runs in a `finally` block + a background sweeper.

### 2. Smart Multi-Pass Compilation
Does NOT blindly run 3 passes. Instead:
1. Run engine once
2. Parse `.aux` / `.bcf` output to detect if citations or cross-refs are unresolved
3. Run `bibtex` or `biber` ONLY if `.bib` referenced AND citations unresolved
4. Run engine again ONLY if aux file changed between passes
5. Maximum 3 passes, minimum 1 — no wasted CPU

This saves 30-50% compile time on simple documents that don't need extra passes.

### 3. Performance Architecture (MANDATORY)
All performance optimizations are **first-class architectural requirements**, not optional features.

#### 3a. RAM-Disk Compilation (`/dev/shm`)
- ALL temp directories are created in `/dev/shm` (tmpfs), not `/tmp`
- Zero disk I/O during compilation — everything in RAM
- On the Oracle VM (24 GB RAM), this is free and eliminates the biggest bottleneck
- Fallback to `/tmp` only if `/dev/shm` is unavailable
- **~40-60% speedup** on I/O-bound compilations

#### 3b. Pre-Compiled Format Files
- `fmtutil-sys --all` runs at Docker image build time
- Pre-dumps `.fmt` files for all engines (pdflatex, xelatex, lualatex)
- Avoids re-parsing LaTeX base classes on every request
- **~20-30% speedup** on first-pass compilation

#### 3c. In-Memory LRU Cache
- Input hash = `sha256(source_bytes + engine + main_file + draft_flag)`
- Cache stores: `{hash: (pdf_bytes, metadata, timestamp)}`
- `cachetools.TTLCache` — max 200 entries, 30-minute TTL
- Cache hit returns PDF in ~10-50ms instead of 2-30 seconds
- No database — pure in-process Python dict with eviction
- Controllable per-request via `enable_cache` parameter
- Cache is lost on container restart (by design — stateless)

#### 3d. Draft Mode
- `draft=true` adds `\PassOptionsToPackage{draft}{graphicx}` before `\documentclass`
- Skips image file reading and rendering entirely
- Replaces images with placeholder boxes (standard LaTeX draft behavior)
- **~50-70% speedup** for image-heavy documents
- Ideal for Flutter live preview while editing

#### 3e. Concurrent Compilation
- `asyncio` + `ProcessPoolExecutor(max_workers=4)` — matches 4 OCPUs
- Each compilation runs in its own process — true parallelism, no GIL
- 4 simultaneous compilations at full speed
- Request queuing when all workers busy

#### 3f. Engine Path Caching
- `shutil.which('pdflatex')` etc. resolved ONCE at startup
- Stored in module-level dict, reused for every request
- Eliminates PATH traversal overhead per-request

#### 3g. `latexmk` Support (Engine Option)
- `latexmk` as a fourth "engine" option — auto-detects optimal number of passes
- Smarter than manual pass logic for complex documents
- Uses same tmpfs + timeout + security boundaries

### 4. Security Boundaries
- Zip bomb protection: max uncompressed size enforced
- Path traversal prevention: all paths validated within temp dir
- Compilation timeout: 120 seconds max
- Max upload size: 50 MB
- Shell injection prevention: `subprocess.run()` with list args, no `shell=True`

### 5. CORS Configuration
- Dev: `*` (allow all origins)
- Prod: Configurable via `ALLOWED_ORIGINS` env var (for Flutter frontend)

### 6. ARM64 Throughout
- Local dev on Apple Silicon (M-series) = ARM64 native
- CI builds ARM64 via QEMU cross-compilation
- Production on Oracle Ampere = ARM64 native
- No architecture mismatch surprises

---

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_KEYS` | ✅ | — | Comma-separated valid API keys |
| `ALLOWED_ORIGINS` | ❌ | `*` | CORS allowed origins |
| `MAX_UPLOAD_SIZE_MB` | ❌ | `50` | Max upload size in MB |
| `COMPILATION_TIMEOUT` | ❌ | `120` | Max compilation time in seconds |
| `RATE_LIMIT` | ❌ | `30/minute` | Rate limit per API key |
| `LOG_LEVEL` | ❌ | `info` | Logging level |
| `WORKERS` | ❌ | `4` | Uvicorn worker count (prod) |
| `CACHE_MAX_SIZE` | ❌ | `200` | Max entries in LRU compile cache |
| `CACHE_TTL_SECONDS` | ❌ | `1800` | Cache entry time-to-live (30 min) |
| `USE_TMPFS` | ❌ | `true` | Use /dev/shm for temp dirs (RAM-disk) |
| `MAX_CONCURRENT_COMPILES` | ❌ | `4` | ProcessPoolExecutor max workers |

---

## Development Workflow

### Local Development
```bash
cp .env.example .env          # Configure secrets
docker compose up --build     # Start with hot-reload
# API available at http://localhost:8080
# Swagger docs at http://localhost:8080/docs
```

### Testing
```bash
docker compose exec api pytest -v              # Run all tests
docker compose exec api pytest tests/test_compile.py -v  # Specific test
```

### VS Code REST Client
Open `tests.http` in VS Code with the REST Client extension to test endpoints interactively.

### CI/CD
- Push to any branch → CI runs (test + build)
- Push to `main` → CI + CD (deploy to Oracle VM)

---

## Rules for AI Agents

### DO
- Keep the API stateless — never persist files between requests
- Use `subprocess.run()` with list args for all shell commands
- Add tests for any new endpoint or compiler feature
- Follow existing patterns in `app/routers/` for new endpoints
- Update this file when making architectural changes
- Use Pydantic models for all request/response schemas
- Handle cleanup in `finally` blocks
- **ALWAYS** create temp dirs in `/dev/shm` (tmpfs) with fallback to `/tmp`
- **ALWAYS** use the compile cache — hash inputs, check cache first
- **ALWAYS** use smart pass detection — never blindly run 3 passes
- **ALWAYS** run compilations via `ProcessPoolExecutor` — never block the async loop
- **ALWAYS** use pre-resolved engine paths from startup cache

### DON'T
- Don't add a database or ORM
- Don't add user registration/login — API keys only
- Don't use `shell=True` in subprocess calls
- Don't store files after compilation completes
- Don't add frontend code to this repo
- Don't change the port from 8080
- Don't install system packages outside Docker
- Don't use x86/amd64 base images — ARM64 only
- Don't compile in `/tmp` — use `/dev/shm` (tmpfs) only
- Don't run unnecessary compilation passes — parse `.aux` files first
- Don't resolve engine paths per-request — use cached paths from startup
- Don't run `subprocess` directly in async handlers — use `ProcessPoolExecutor`

### Performance Rules (STRICT)
- Temp dirs → `/dev/shm` always. Fallback `/tmp` only if tmpfs unavailable.
- Format files → pre-compiled at Docker build time via `fmtutil-sys --all`
- Compilation → `ProcessPoolExecutor` with max_workers matching OCPU count
- Caching → `cachetools.TTLCache`, keyed by SHA-256 of input, 30-min TTL
- Pass detection → parse `.aux`/`.bcf` between passes, skip if unchanged
- Draft mode → inject `\PassOptionsToPackage{draft}{graphicx}` when requested
- Engine paths → `shutil.which()` once at startup, cached in module-level dict

### Code Style
- Python 3.11+ with type hints everywhere
- Async FastAPI endpoints
- Google-style docstrings
- `ruff` for linting (configured in `pyproject.toml`)
- Structured logging with `structlog`

---

## Future Flutter Frontend Notes

This API is designed to be consumed by a Flutter Overleaf-clone frontend. Key integration points:
- **OpenAPI spec** at `/docs` can generate Dart client code
- **CORS** is pre-configured and configurable
- **JSON responses** are structured for easy Dart model mapping
- **Health endpoint** for connection status indicators
- **Streaming**: Future consideration — WebSocket for live compilation log streaming
