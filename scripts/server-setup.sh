#!/usr/bin/env bash
# =============================================================================
# Oracle Cloud VM — One-Time Server Setup
# =============================================================================
# Usage: bash scripts/server-setup.sh
# Idempotent — safe to run multiple times.
# =============================================================================
set -euo pipefail

echo "=== Overleaf Server — Server Setup ==="

# --- System updates ---
echo "[1/7] Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# --- Install Docker ---
echo "[2/7] Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sudo bash
    sudo usermod -aG docker "$USER"
    echo "Docker installed. You may need to log out and back in for group changes."
else
    echo "Docker already installed: $(docker --version)"
fi

# --- Install Docker Compose plugin ---
echo "[3/7] Installing Docker Compose plugin..."
if ! docker compose version &> /dev/null; then
    sudo apt-get install -y docker-compose-plugin
else
    echo "Docker Compose already installed: $(docker compose version)"
fi

# --- Configure UFW firewall ---
echo "[4/7] Configuring UFW firewall..."
sudo apt-get install -y ufw
sudo ufw --force enable
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # API
sudo ufw status

# --- Oracle Cloud iptables (required in addition to UFW) ---
echo "[5/7] Configuring Oracle Cloud iptables..."
# Oracle Cloud Ubuntu images have restrictive iptables by default
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
sudo netfilter-persistent save 2>/dev/null || true

# --- Create app directory ---
echo "[6/7] Creating application directory..."
APP_DIR="$HOME/overleaf-server"
mkdir -p "$APP_DIR/scripts"
echo "App directory: $APP_DIR"

# --- Copy compose and deploy files ---
echo "[7/7] Setting up deployment structure..."
cat > "$APP_DIR/.env" << 'ENVEOF'
# Production environment — EDIT THESE VALUES
API_KEYS=CHANGE_ME_TO_REAL_API_KEYS
ALLOWED_ORIGINS=*
MAX_UPLOAD_SIZE_MB=50
COMPILATION_TIMEOUT=120
RATE_LIMIT=30/minute
LOG_LEVEL=info
WORKERS=4
CACHE_MAX_SIZE=200
CACHE_TTL_SECONDS=1800
USE_TMPFS=true
MAX_CONCURRENT_COMPILES=4
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
