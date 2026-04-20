# =============================================================================
# Stage 1: Builder — Install TeX Live + Python dependencies
# =============================================================================
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    perl \
    wget \
    xz-utils \
    fontconfig \
    libfontconfig1 \
    python3.11 \
    python3.11-venv \
    python3-pip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install TeX Live
COPY texlive.profile /tmp/texlive.profile
RUN wget -qO- "https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz" \
    | tar xz -C /tmp --strip-components=1 \
    && /tmp/install-tl --profile=/tmp/texlive.profile \
    && rm -rf /tmp/install-tl* /tmp/texlive.profile

# Add TeX Live to PATH
ENV PATH="/usr/local/texlive/bin/aarch64-linux:${PATH}"

# Pre-compile format files for all engines (20-30% speedup)
RUN fmtutil-sys --all

# Register TeX Live fonts with fontconfig (required for XeLaTeX/LuaLaTeX)
RUN ln -s /usr/local/texlive/texmf-dist/fonts/opentype /usr/share/fonts/texlive-opentype \
    && ln -s /usr/local/texlive/texmf-dist/fonts/truetype /usr/share/fonts/texlive-truetype \
    && fc-cache -fsv

# Install Python dependencies in a venv
COPY requirements.txt /tmp/requirements.txt
RUN python3.11 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt
ENV PATH="/opt/venv/bin:${PATH}"

# =============================================================================
# Stage 2: Runtime — Slim production image
# =============================================================================
FROM ubuntu:22.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    perl \
    fontconfig \
    libfontconfig1 \
    python3.11 \
    python3.11-venv \
    curl \
    ca-certificates \
    ghostscript \
    && rm -rf /var/lib/apt/lists/*

# Copy TeX Live from builder
COPY --from=builder /usr/local/texlive /usr/local/texlive
ENV PATH="/usr/local/texlive/bin/aarch64-linux:${PATH}"

# Register TeX Live fonts with fontconfig (required for XeLaTeX/LuaLaTeX)
RUN ln -s /usr/local/texlive/texmf-dist/fonts/opentype /usr/share/fonts/texlive-opentype \
    && ln -s /usr/local/texlive/texmf-dist/fonts/truetype /usr/share/fonts/texlive-truetype \
    && fc-cache -fsv

# Copy Python venv from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser -m appuser

# Set working directory
WORKDIR /app

# Copy application code
COPY app/ ./app/

# Ensure /dev/shm is usable (Docker provides it by default)
# Ownership for the app user
RUN chown -R appuser:appuser /app

USER appuser

# Environment defaults
ENV WORKERS=4
ENV LOG_LEVEL=info

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/api/v1/health || exit 1

CMD ["sh", "-c", "python3 -m uvicorn app.main:app --host 0.0.0.0 --port 8080 --workers ${WORKERS} --timeout-graceful-shutdown 30"]
