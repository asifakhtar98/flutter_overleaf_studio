# 📄 TeX Live Compilation API

> Stateless REST API — LaTeX in, PDF out. TeX Live Full, Docker, Oracle Cloud ARM64.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Features

- **4 engines**: `pdflatex`, `xelatex`, `lualatex`, `latexmk`
- **2 input modes**: raw `.tex` (JSON body) or zipped project (multipart form)
- **Smart multi-pass**: parses `.aux` logs, auto-runs BibTeX/Biber, max 3 passes, min 1
- **In-memory cache**: SHA-256 keyed `TTLCache` — identical inputs return in ~10ms
- **RAM-disk compilation**: all temp dirs in `/dev/shm` — zero disk I/O
- **Draft mode**: `draft=true` skips image rendering for fast live preview
- **Concurrent**: `ProcessPoolExecutor(4)` — 4 simultaneous compilations
- **Pre-compiled formats**: `fmtutil-sys --all` at Docker build time
- **Stateless**: no file persistence — every compilation is ephemeral, cleanup in `finally`
- **Secured**: API key auth (`X-API-Key`) + per-key rate limiting (SlowAPI)
- **ARM64 native**: Oracle Ampere prod, Apple Silicon dev — no arch mismatch

---

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/texlive-api.git && cd texlive-api
cp .env.example .env          # Set API_KEYS
docker compose up --build     # First build ~20-30 min (TeX Live)
# http://localhost:8080/docs  — Swagger UI
```

```bash
# Health check
curl http://localhost:8080/api/v1/health | python3 -m json.tool

# Compile
curl -X POST http://localhost:8080/api/v1/compile \
  -H "X-API-Key: dev-key-change-me-in-production" \
  -H "Content-Type: application/json" \
  -d '{"source": "\\documentclass{article}\\begin{document}Hello!\\end{document}"}' \
  -o hello.pdf
```

---

## API Reference

### `GET /api/v1/health`

No auth required.

```json
{
  "status": "healthy",
  "texlive_version": "pdfTeX 3.141592653-2.6-1.40.29 (TeX Live 2026)",
  "engines": ["pdflatex", "xelatex", "lualatex", "latexmk"],
  "uptime_seconds": 3600.0,
  "cache_stats": { "hits": 142, "misses": 58, "size": 47, "max_size": 200 }
}
```

### `POST /api/v1/compile`

Requires `X-API-Key` header.

**JSON body (single file):**
```json
{
  "source": "\\documentclass{article}\\begin{document}Hello!\\end{document}",
  "engine": "pdflatex",
  "draft": false,
  "enable_cache": true
}
```

**Multipart form (zip project):**
```
file=@project.zip  engine=xelatex  main_file=thesis.tex  draft=false  enable_cache=true
```

**Parameters:**

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `source` | string | — | Required for JSON mode |
| `file` | file | — | Required for multipart mode |
| `engine` | string | `pdflatex` | `pdflatex` / `xelatex` / `lualatex` / `latexmk` |
| `main_file` | string | `main.tex` | Entry point for zip projects |
| `draft` | bool | `false` | Skip image rendering |
| `enable_cache` | bool | `true` | Check/store in LRU cache |

**Success (200):** PDF bytes in body. Metadata in response headers:

| Header | Example |
|--------|---------|
| `X-Compilation-Time` | `4.20` |
| `X-Engine` | `pdflatex` |
| `X-Warnings-Count` | `3` |
| `X-Cached` | `false` |
| `X-Passes-Run` | `2` |
| `X-Request-ID` | `a1b2c3d4...` |

**All errors** use a unified `ErrorEnvelope` format:
```json
{
  "request_id": "a1b2c3d4e5f6...",
  "error_code": "COMPILATION_FAILED",
  "message": "Compilation failed",
  "detail": {
    "log": "! Undefined control sequence.\nl.42 \\badcommand",
    "engine": "pdflatex",
    "compilation_time": 2.31,
    "passes_run": 1
  }
}
```

| Error Code | HTTP Status | When |
|------------|-------------|------|
| `COMPILATION_FAILED` | 422 | LaTeX compilation failed |
| `INVALID_REQUEST` | 400 | Bad input, invalid engine/main_file |
| `MISSING_API_KEY` | 401 | No `X-API-Key` header |
| `INVALID_API_KEY` | 403 | Wrong API key |
| `UPLOAD_TOO_LARGE` | 413 | Body exceeds max upload size |
| `RATE_LIMITED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Unexpected server error |

---

## Configuration

All via environment variables. Copy `.env.example` → `.env`.

| Variable | Default | Description |
|----------|---------|-------------|
| `API_KEYS` | **(required)** | Comma-separated API keys |
| `ALLOWED_ORIGINS` | `*` | CORS origins |
| `MAX_UPLOAD_SIZE_MB` | `50` | Max zip upload |
| `COMPILATION_TIMEOUT` | `120` | Seconds per compilation |
| `RATE_LIMIT` | `30/minute` | Per-key rate limit |
| `LOG_LEVEL` | `info` | `debug` / `info` / `warning` / `error` |
| `WORKERS` | `4` | Uvicorn workers (prod) |
| `CACHE_MAX_SIZE` | `200` | LRU cache max entries |
| `CACHE_TTL_SECONDS` | `1800` | Cache TTL (30 min) |
| `USE_TMPFS` | `true` | Use `/dev/shm` for temp dirs |
| `MAX_CONCURRENT_COMPILES` | `4` | Process pool workers |

---

## Development

```bash
docker compose up --build                                      # Start
docker compose exec api python3 -m pytest tests/ -v --tb=short # Test
docker compose exec api python3 -m ruff check app/ tests/      # Lint
docker compose exec api python3 -m ruff format app/ tests/     # Format
docker compose down --remove-orphans                           # Stop
```

Or use VS Code: `Cmd+Shift+P → Tasks: Run Task` — 20 grouped tasks available.

**Project structure:** see `agents.md` for the full canonical file tree.

---

## Performance

All optimizations are **mandatory architectural features**, not toggles.

| Technique | Speedup | Mechanism |
|-----------|---------|-----------|
| tmpfs (`/dev/shm`) | ~40-60% | Zero disk I/O |
| Pre-compiled `.fmt` | ~20-30% | Built at image time |
| Smart multi-pass | ~30-50% | Skip passes if log has no rerun warning |
| LRU cache | ~99% (hit) | ~10ms dict lookup vs ~2-30s compile |
| Draft mode | ~50-70% | Skip image rendering |
| Process pool | ×4 throughput | 4 parallel compilations |
| Engine path cache | ~5% | Resolved once at startup |

---

## Security

| Protection | Implementation |
|-----------|---------------|
| Auth | `X-API-Key` header, multi-key allowlist from env |
| Rate limiting | SlowAPI, in-memory, per-key |
| Zip bomb | Max uncompressed size: 200 MB |
| Path traversal (zip) | `Path.is_relative_to()` validation on all extracted paths |
| Path traversal (main_file) | `validate_main_file()` — rejects `..`, absolute paths, non-TeX extensions |
| Body size limit | Middleware rejects oversized `Content-Length` before reading body |
| Timeout | 120s hard limit per compilation |
| Shell injection | `subprocess.run()` with list args, no `shell=True` |
| Ephemeral | Temp dirs cleaned in `finally` blocks |
| Orphan cleanup | Startup sweep of stale `texlive_*` dirs from crashed workers |
| Request tracing | UUID4 `X-Request-ID` on every request (auto-generated or client-provided) |

---

## Deployment

See [DEPLOY_GUIDE.md](DEPLOY_GUIDE.md) for step-by-step Oracle Cloud deployment.

**CI/CD flow:**
```
Push to any branch → Lint → Test → Build ARM64 → Push to Docker Hub
Push to main       → above + SSH deploy to Oracle VM (blue-green)
```

**GitHub secrets required:** `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `ORACLE_HOST`, `ORACLE_SSH_USER`, `ORACLE_SSH_KEY`

---

## License

MIT — see [LICENSE](LICENSE).
