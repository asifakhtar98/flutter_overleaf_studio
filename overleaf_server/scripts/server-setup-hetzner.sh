#!/usr/bin/env bash
# =============================================================================
# Hetzner Cloud (CAX11) — One-Time Server Setup
# =============================================================================
# Usage: bash scripts/server-setup-hetzner.sh
# Idempotent — safe to run multiple times.
#
# Differences from Oracle setup:
#   - No Oracle-specific iptables rules (Hetzner firewall is at network level)
#   - Defaults tuned for CAX11 (2 vCPU, 4GB RAM)
# =============================================================================
set -euo pipefail

echo "=== Overleaf Server — Hetzner Server Setup ==="

# --- System updates ---
echo "[1/6] Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# --- Install Docker ---
echo "[2/6] Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sudo bash
    sudo usermod -aG docker "$USER"
    echo "Docker installed. You may need to log out and back in for group changes."
else
    echo "Docker already installed: $(docker --version)"
fi

# --- Install Docker Compose plugin ---
echo "[3/6] Installing Docker Compose plugin..."
if ! docker compose version &> /dev/null; then
    sudo apt-get install -y docker-compose-plugin
else
    echo "Docker Compose already installed: $(docker compose version)"
fi

# --- Configure UFW firewall ---
echo "[4/6] Configuring UFW firewall..."
sudo apt-get install -y ufw
sudo ufw --force enable
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # API
sudo ufw allow 80/tcp    # HTTP (for nginx/TLS)
sudo ufw allow 443/tcp   # HTTPS (for nginx/TLS)
sudo ufw status

# Note: Hetzner's cloud firewall operates at the network level.
# UFW is the only host firewall needed — no Oracle-style iptables workaround.

# --- Create app directory ---
echo "[5/6] Creating application directory..."
APP_DIR="$HOME/overleaf-server"
mkdir -p "$APP_DIR/scripts"
echo "App directory: $APP_DIR"

# --- Set up deployment structure ---
echo "[6/6] Setting up deployment structure..."
cat > "$APP_DIR/.env" << 'ENVEOF'
# Production environment (Hetzner CAX11) — EDIT THESE VALUES
# ⚠️  CAX11 has 2 vCPU + 4GB RAM — these defaults are tuned accordingly
API_KEYS=CHANGE_ME_TO_REAL_API_KEYS
ALLOWED_ORIGINS=*
MAX_UPLOAD_SIZE_MB=50
COMPILATION_TIMEOUT=120
RATE_LIMIT=30/minute
LOG_LEVEL=info
WORKERS=2
CACHE_MAX_SIZE=100
CACHE_TTL_SECONDS=1800
USE_TMPFS=true
MAX_CONCURRENT_COMPILES=2
ENVEOF

# --- Configure log rotation ---
sudo tee /etc/logrotate.d/docker-containers > /dev/null << 'LOGEOF'
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    compress
    missingok
    delaycompress
    copytruncate
}
LOGEOF

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Next steps:"
echo "  1. Edit $APP_DIR/.env with your real API keys"
echo "  2. Copy docker-compose.prod.yml and scripts/deploy.sh to $APP_DIR"
echo "  3. Log out and back in (for Docker group membership)"
echo "  4. Push to main branch to trigger CI/CD"
echo ""
