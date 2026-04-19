#!/usr/bin/env bash
# =============================================================================
# Blue-Green Deployment Script
# =============================================================================
# Usage: bash scripts/deploy.sh <image:tag>
# Example: bash scripts/deploy.sh yourusername/texlive-api:latest
# =============================================================================
set -euo pipefail

IMAGE="${1:?Usage: deploy.sh <image:tag>}"
APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HEALTH_URL="http://localhost:8080/api/v1/health"
MAX_WAIT=60

echo "=== Blue-Green Deploy ==="
echo "Image: $IMAGE"
echo "App dir: $APP_DIR"

# Determine current/next slot
CURRENT_CONTAINER=$(docker ps --filter "name=texlive-api" --format "{{.Names}}" | head -1 || true)
if [[ "$CURRENT_CONTAINER" == "texlive-api-blue" ]]; then
    NEXT_SLOT="green"
    OLD_SLOT="blue"
elif [[ "$CURRENT_CONTAINER" == "texlive-api-green" ]]; then
    NEXT_SLOT="blue"
    OLD_SLOT="green"
else
    NEXT_SLOT="blue"
    OLD_SLOT=""
fi

NEXT_CONTAINER="texlive-api-${NEXT_SLOT}"
NEXT_PORT=8081  # Temp port for new container

echo "Current: ${CURRENT_CONTAINER:-none}"
echo "Deploying to: $NEXT_CONTAINER"

# Start new container on temp port
echo "[1/5] Starting new container..."
docker run -d \
    --name "$NEXT_CONTAINER" \
    --env-file "$APP_DIR/.env" \
    --shm-size=8g \
    -p "${NEXT_PORT}:8080" \
    --restart unless-stopped \
    --log-driver json-file \
    --log-opt max-size=50m \
    --log-opt max-file=5 \
    "$IMAGE"

# Wait for health check
echo "[2/5] Waiting for health check..."
WAITED=0
while [ $WAITED -lt $MAX_WAIT ]; do
    if curl -sf "http://localhost:${NEXT_PORT}/api/v1/health" > /dev/null 2>&1; then
        echo "Health check passed after ${WAITED}s"
        break
    fi
    sleep 2
    WAITED=$((WAITED + 2))
done

if [ $WAITED -ge $MAX_WAIT ]; then
    echo "ERROR: Health check failed after ${MAX_WAIT}s"
    docker logs "$NEXT_CONTAINER" --tail 50
    docker rm -f "$NEXT_CONTAINER"
    exit 1
fi

# Stop old container
echo "[3/5] Stopping old container..."
if [ -n "$OLD_SLOT" ]; then
    OLD_CONTAINER="texlive-api-${OLD_SLOT}"
    docker rm -f "$OLD_CONTAINER" 2>/dev/null || true
fi
# Also remove any non-slot container
docker rm -f "texlive-api-prod" 2>/dev/null || true

# Reconfigure new container to use port 8080
echo "[4/5] Switching to production port..."
docker rm -f "$NEXT_CONTAINER"
docker run -d \
    --name "$NEXT_CONTAINER" \
    --env-file "$APP_DIR/.env" \
    --shm-size=8g \
    -p "8080:8080" \
    --restart unless-stopped \
    --log-driver json-file \
    --log-opt max-size=50m \
    --log-opt max-file=5 \
    "$IMAGE"

# Wait for final health check
sleep 3
if curl -sf "$HEALTH_URL" > /dev/null 2>&1; then
    echo "[5/5] Production health check passed!"
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
