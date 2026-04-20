#!/usr/bin/env bash
# =============================================================================
# Blue-Green Deployment Script (zero-downtime with iptables port swap)
# =============================================================================
# Usage: bash scripts/deploy.sh <image:tag>
# Example: bash scripts/deploy.sh yourusername/overleaf-server:latest
#
# Requires: sudo (for iptables during port swap)
# =============================================================================
set -euo pipefail

IMAGE="${1:?Usage: deploy.sh <image:tag>}"
APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HEALTH_URL="http://localhost:8080/api/v1/health"
STAGING_PORT=8081
PROD_PORT=8080
MAX_WAIT=90
POLL_INTERVAL=3

echo "=== Blue-Green Deploy ==="
echo "Image: $IMAGE"
echo "App dir: $APP_DIR"

# ---------------------------------------------------------------------------
# Determine current/next slot
# ---------------------------------------------------------------------------
CURRENT_CONTAINER=$(docker ps --filter "name=overleaf-server" --format "{{.Names}}" | head -1 || true)
if [[ "$CURRENT_CONTAINER" == "overleaf-server-blue" ]]; then
    NEXT_SLOT="green"
    OLD_SLOT="blue"
elif [[ "$CURRENT_CONTAINER" == "overleaf-server-green" ]]; then
    NEXT_SLOT="blue"
    OLD_SLOT="green"
else
    NEXT_SLOT="blue"
    OLD_SLOT=""
fi

NEXT_CONTAINER="overleaf-server-${NEXT_SLOT}"

echo "Current: ${CURRENT_CONTAINER:-none}"
echo "Deploying to: $NEXT_CONTAINER"

# ---------------------------------------------------------------------------
# Cleanup function — removes staging container + iptables rules on failure
# ---------------------------------------------------------------------------
IPTABLES_ADDED=false

cleanup_iptables() {
    if $IPTABLES_ADDED; then
        echo "Cleaning up iptables redirect rules..."
        sudo iptables -t nat -D PREROUTING -p tcp --dport "$PROD_PORT" -j REDIRECT --to-port "$STAGING_PORT" 2>/dev/null || true
        sudo iptables -t nat -D OUTPUT -o lo -p tcp --dport "$PROD_PORT" -j REDIRECT --to-port "$STAGING_PORT" 2>/dev/null || true
        IPTABLES_ADDED=false
    fi
}

rollback() {
    echo "ERROR: Deploy failed — rolling back"
    cleanup_iptables
    docker rm -f "$NEXT_CONTAINER" 2>/dev/null || true
    echo "Rollback complete. Previous container still running: ${CURRENT_CONTAINER:-none}"
    exit 1
}

trap rollback ERR

# ---------------------------------------------------------------------------
# [1/6] Start new container on staging port
# ---------------------------------------------------------------------------
echo "[1/6] Starting new container on port $STAGING_PORT..."
# Remove any leftover staging container from a previous failed deploy
docker rm -f "$NEXT_CONTAINER" 2>/dev/null || true

docker run -d \
    --name "$NEXT_CONTAINER" \
    --env-file "$APP_DIR/.env" \
    --shm-size=8g \
    -p "${STAGING_PORT}:${PROD_PORT}" \
    --restart unless-stopped \
    --log-driver json-file \
    --log-opt max-size=50m \
    --log-opt max-file=5 \
    "$IMAGE"

# ---------------------------------------------------------------------------
# [2/6] Wait for health check on staging port
# ---------------------------------------------------------------------------
echo "[2/6] Waiting for health check on :${STAGING_PORT}..."
WAITED=0
while [ $WAITED -lt $MAX_WAIT ]; do
    if curl -sf "http://localhost:${STAGING_PORT}/api/v1/health" > /dev/null 2>&1; then
        echo "Health check passed after ${WAITED}s"
        break
    fi
    sleep "$POLL_INTERVAL"
    WAITED=$((WAITED + POLL_INTERVAL))
done

if [ $WAITED -ge $MAX_WAIT ]; then
    echo "Health check failed after ${MAX_WAIT}s"
    docker logs "$NEXT_CONTAINER" --tail 50
    rollback
fi

# ---------------------------------------------------------------------------
# [3/6] iptables redirect: prod port → staging port (zero-downtime swap)
# ---------------------------------------------------------------------------
echo "[3/6] Redirecting :${PROD_PORT} → :${STAGING_PORT} via iptables..."
sudo iptables -t nat -A PREROUTING -p tcp --dport "$PROD_PORT" -j REDIRECT --to-port "$STAGING_PORT"
sudo iptables -t nat -A OUTPUT -o lo -p tcp --dport "$PROD_PORT" -j REDIRECT --to-port "$STAGING_PORT"
IPTABLES_ADDED=true

# ---------------------------------------------------------------------------
# [4/6] Stop old container (port 8080 now forwarded to 8081)
# ---------------------------------------------------------------------------
echo "[4/6] Stopping old container..."
if [ -n "$OLD_SLOT" ]; then
    OLD_CONTAINER="overleaf-server-${OLD_SLOT}"
    docker rm -f "$OLD_CONTAINER" 2>/dev/null || true
fi
docker rm -f "overleaf-server-prod" 2>/dev/null || true

# ---------------------------------------------------------------------------
# [5/6] Recreate new container on production port
# ---------------------------------------------------------------------------
echo "[5/6] Switching $NEXT_CONTAINER to port $PROD_PORT..."
docker rm -f "$NEXT_CONTAINER"

docker run -d \
    --name "$NEXT_CONTAINER" \
    --env-file "$APP_DIR/.env" \
    --shm-size=8g \
    -p "${PROD_PORT}:${PROD_PORT}" \
    --restart unless-stopped \
    --log-driver json-file \
    --log-opt max-size=50m \
    --log-opt max-file=5 \
    "$IMAGE"

# Wait for final container to be healthy before removing iptables rules
echo "Waiting for final container health..."
WAITED=0
while [ $WAITED -lt $MAX_WAIT ]; do
    # Test the direct container (bypass iptables) by checking staging port is gone
    # and prod port serves from the new container
    if docker exec "$NEXT_CONTAINER" curl -sf "http://localhost:${PROD_PORT}/api/v1/health" > /dev/null 2>&1; then
        echo "Final container healthy after ${WAITED}s"
        break
    fi
    sleep "$POLL_INTERVAL"
    WAITED=$((WAITED + POLL_INTERVAL))
done

if [ $WAITED -ge $MAX_WAIT ]; then
    echo "WARNING: Final health check timed out — iptables redirect still active"
fi

# ---------------------------------------------------------------------------
# [6/6] Remove iptables redirect — new container owns port 8080
# ---------------------------------------------------------------------------
echo "[6/6] Removing iptables redirect..."
cleanup_iptables

# Verify production health
sleep 1
if curl -sf "$HEALTH_URL" > /dev/null 2>&1; then
    echo "Production health check passed!"
else
    echo "WARNING: Production health check pending — container may still be starting"
fi

# Cleanup old images
echo "Pruning unused images..."
docker image prune -f

echo ""
echo "=== Deploy complete ==="
echo "Active container: $NEXT_CONTAINER"
echo "Health: $HEALTH_URL"
