# 📄 TeX Live Compilation API

> Stateless REST API — LaTeX in, PDF out. TeX Live Full, Docker, Oracle Cloud ARM64.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🚀 Quick Start (Run Locally)

The easiest way to get the API running on your machine is using Docker. 

**1. Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/texlive-api.git 
cd texlive-api
```

**2. Configure environment**
```bash
cp .env.example .env
```
*Open the `.env` file and set the `API_KEYS` variable if needed.*

**3. Start the server (Docker)**
```bash
# Note: The first build will take ~20-30 minutes as it installs TeX Live Full
docker compose up --build
```

**4. Test the API**

**Health check:**
```bash
curl http://localhost:8080/api/v1/health | python3 -m json.tool
```

**Compile a simple PDF:**
```bash
curl -X POST http://localhost:8080/api/v1/compile \
  -H "X-API-Key: dev-key-change-me-in-production" \
  -H "Content-Type: application/json" \
  -d '{"source": "\\documentclass{article}\\begin{document}Hello!\\end{document}"}' \
  -o hello.pdf
```
*(You should now have a `hello.pdf` file in your directory!)*

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
- **Secured**: API key auth, rate limiting, body size limits, path traversal protection
- **ARM64 native**: Oracle Ampere prod, Apple Silicon dev — no arch mismatch

---

## API Documentation

**Full, interactive API docs live on the running server:**

| Format | URL | Best for |
|--------|-----|----------|
| **Swagger UI** | [`/docs`](http://localhost:8080/docs) | Interactive testing, try-it-out |
| **ReDoc** | [`/redoc`](http://localhost:8080/redoc) | Reading, client generation |
| **OpenAPI JSON** | [`/openapi.json`](http://localhost:8080/openapi.json) | Code generation (`openapi-generator`) |

The Swagger UI includes request/response examples, error code tables,
multipart upload forms, and response header documentation — it is the
**single source of truth** for the API contract.

> **Frontend devs:** click the **Authorize** 🔒 button in Swagger UI to set your
> `X-API-Key` header, then use **Try it out** on any endpoint.

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
