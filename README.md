# 📄 TeX Live Compilation API

> A stateless REST API that compiles LaTeX source into PDF. Powered by TeX Live Full, containerized with Docker, deployed on Oracle Cloud ARM64.

[![CI](https://github.com/YOUR_USERNAME/texlive-api/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/texlive-api/actions/workflows/ci.yml)
[![CD](https://github.com/YOUR_USERNAME/texlive-api/actions/workflows/cd.yml/badge.svg)](https://github.com/YOUR_USERNAME/texlive-api/actions/workflows/cd.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## ✨ Features

- **Multiple engines**: `pdflatex`, `xelatex`, `lualatex`
- **Single file & multi-file**: Raw `.tex` source or zipped projects with images, `.bib`, custom `.sty`
- **Smart compilation**: Auto-detects BibTeX/Biber, runs multiple passes for cross-references
- **Stateless**: No file persistence — every compilation is ephemeral
- **Secured**: API key authentication + rate limiting
- **ARM64 native**: Built for Oracle Cloud Ampere (also runs natively on Apple Silicon)

---

## 🚀 Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)

### Run Locally

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/texlive-api.git
cd texlive-api

# Configure environment
cp .env.example .env
# Edit .env — at minimum set API_KEYS

# Start the server (with hot-reload)
docker compose up --build

# API available at http://localhost:8080
# Swagger docs at http://localhost:8080/docs
```

### Test It

```bash
# Health check
curl http://localhost:8080/api/v1/health

# Compile a simple LaTeX document
curl -X POST http://localhost:8080/api/v1/compile \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{"source": "\\documentclass{article}\\begin{document}Hello, World!\\end{document}"}' \
  --output hello.pdf
```

---

## 📡 API Reference

### `GET /api/v1/health`

Health check endpoint. No authentication required.

**Response:**
```json
{
  "status": "healthy",
  "texlive_version": "2025",
  "engines": ["pdflatex", "xelatex", "lualatex"],
  "uptime_seconds": 3600
}
```

### `POST /api/v1/compile`

Compile LaTeX source into PDF. Requires `X-API-Key` header.

#### Option A: Single File (JSON)

```http
POST /api/v1/compile HTTP/1.1
X-API-Key: your-api-key
Content-Type: application/json

{
  "source": "\\documentclass{article}\\begin{document}Hello!\\end{document}",
  "engine": "pdflatex"
}
```

#### Option B: Multi-File Project (Zip Upload)

```http
POST /api/v1/compile HTTP/1.1
X-API-Key: your-api-key
Content-Type: multipart/form-data

file: project.zip
engine: xelatex
main_file: thesis.tex
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `source` | string | ✅* | — | Raw LaTeX source code |
| `file` | file | ✅* | — | Zip archive of project |
| `engine` | string | ❌ | `pdflatex` | `pdflatex`, `xelatex`, or `lualatex` |
| `main_file` | string | ❌ | `main.tex` | Entry point file (zip mode) |

*One of `source` or `file` is required.

#### Success Response (200)

Returns PDF bytes with headers:
```
Content-Type: application/pdf
X-Compilation-Time: 4.2
X-Engine: pdflatex
X-Warnings-Count: 3
```

#### Error Response (422)

```json
{
  "success": false,
  "error": "Compilation failed",
  "exit_code": 1,
  "log": "! Undefined control sequence.\nl.42 \\badcommand",
  "engine": "pdflatex"
}
```

---

## 🛠 Development

### Project Structure

```
├── app/
│   ├── main.py              # FastAPI entry point
│   ├── config.py            # Settings from env vars
│   ├── auth.py              # API key authentication
│   ├── compiler.py          # Core LaTeX compilation logic
│   ├── models.py            # Pydantic models
│   └── routers/
│       ├── compile.py       # /api/v1/compile
│       └── health.py        # /api/v1/health
├── tests/
│   ├── test_compile.py      # Compilation tests
│   ├── test_health.py       # Health endpoint tests
│   ├── test_auth.py         # Auth tests
│   └── fixtures/            # Test .tex files
├── scripts/
│   ├── server-setup.sh      # One-time VM bootstrap
│   └── deploy.sh            # Blue-green deploy
├── docker-compose.yml       # Local development
├── docker-compose.prod.yml  # Production
├── Dockerfile               # Production image
├── Dockerfile.dev           # Dev image (hot-reload)
└── tests.http               # VS Code REST Client tests
```

### Running Tests

```bash
# All tests
docker compose exec api pytest -v

# With coverage
docker compose exec api pytest --cov=app --cov-report=term-missing

# Specific test
docker compose exec api pytest tests/test_compile.py -v
```

### VS Code Setup

**Recommended Extensions:**
- [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) — for Oracle VM development
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) — container management
- [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) — test API with `tests.http`
- [GitHub Actions](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions) — pipeline visibility
- [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python) — linting, debugging

### Hot Reload

In local dev mode, the `app/` directory is volume-mounted. Any code change triggers an automatic restart via `uvicorn --reload`.

---

## 🚢 Deployment

### Prerequisites

1. **Oracle Cloud VM** — `VM.Standard.A1.Flex` (ARM64, Ubuntu 22.04)
2. **Docker Hub account** — free tier, public repo
3. **GitHub repo** — with Actions enabled

### Initial Server Setup

```bash
# SSH into your Oracle VM, then:
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/texlive-api/main/scripts/server-setup.sh | bash
```

This script installs Docker, configures firewall, sets up the deploy user, and prepares the environment.

### GitHub Secrets

Configure these in your repo → Settings → Secrets → Actions:

| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |
| `ORACLE_HOST` | VM public IP address |
| `ORACLE_SSH_KEY` | ED25519 private key for SSH |
| `ORACLE_SSH_USER` | SSH user (e.g., `ubuntu`) |
| `API_KEYS` | Comma-separated API keys |

### CI/CD Pipeline

```
Push to any branch → CI (pytest + build ARM64 image + push to Docker Hub)
Push to main        → CI + CD (SSH → pull → blue-green restart)
```

---

## ⚙️ Configuration

All configuration is via environment variables. See `.env.example`:

| Variable | Default | Description |
|----------|---------|-------------|
| `API_KEYS` | — | Comma-separated API keys (required) |
| `ALLOWED_ORIGINS` | `*` | CORS origins for Flutter frontend |
| `MAX_UPLOAD_SIZE_MB` | `50` | Maximum zip upload size |
| `COMPILATION_TIMEOUT` | `120` | Max seconds per compilation |
| `RATE_LIMIT` | `30/minute` | Per-key rate limit |
| `LOG_LEVEL` | `info` | Logging verbosity |
| `WORKERS` | `4` | Uvicorn workers (prod only) |

---

## 🔒 Security

- **API key auth** — every `/compile` request requires `X-API-Key` header
- **Rate limiting** — in-memory per-key rate limiting via SlowAPI
- **Zip bomb protection** — max uncompressed size enforced
- **Path traversal prevention** — all extracted paths validated
- **Compilation timeout** — hard 120s limit prevents resource exhaustion
- **No shell injection** — `subprocess.run()` with list args, never `shell=True`
- **Ephemeral compilation** — temp dirs cleaned up in `finally` blocks

---

## 📋 License

MIT — see [LICENSE](LICENSE) for details.

---

## 🗺️ Roadmap

- [ ] WebSocket endpoint for live compilation log streaming
- [ ] Compilation caching (hash-based, optional)
- [ ] Support for `latexmk` as a meta-engine
- [ ] Prometheus metrics endpoint
- [ ] Multi-tenant rate limiting with Redis (when scaling)
