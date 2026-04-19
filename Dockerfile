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

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements.txt

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

# Copy Python packages from builder
COPY --from=builder /usr/lib/python3 /usr/lib/python3
COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=builder /usr/local/bin /usr/local/bin

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

CMD ["sh", "-c", "python3 -m uvicorn app.main:app --host 0.0.0.0 --port 8080 --workers ${WORKERS}"]
