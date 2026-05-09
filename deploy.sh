#!/bin/bash
# ─────────────────────────────────────────────────────────────
# OTP Lookup API — Server Deploy Script (run on ptysrv11)
# Usage: ./deploy.sh <dockerhub-username> [tag]
# ─────────────────────────────────────────────────────────────

set -e

DOCKERHUB_USER="${1:-anfal11}"
TAG="${2:-latest}"
IMAGE_NAME="otp-lookup-api"
FULL_IMAGE="${DOCKERHUB_USER}/${IMAGE_NAME}:${TAG}"
CONTAINER_NAME="otp-lookup-api"
HOST_PORT=3500

echo "──────────────────────────────────────────"
echo " Deploying: ${FULL_IMAGE}"
echo "──────────────────────────────────────────"

# Pull latest image
docker pull "${FULL_IMAGE}"

# Stop & remove old container if exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Stopping old container..."
  docker stop "${CONTAINER_NAME}" && docker rm "${CONTAINER_NAME}"
fi

# Run new container
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${HOST_PORT}:3000" \
  -e DB_HOST=192.168.1.102 \
  -e DB_PORT=1433 \
  -e DB_USER=SA \
  -e "DB_PASS=W@letSimulation@2026" \
  -e DB_NAME=finify \
  "${FULL_IMAGE}"

echo ""
echo "✅ Container started!"
echo ""
echo " API is live at: http://$(hostname -I | awk '{print $1}'):${HOST_PORT}/otp/<msisdn>"
echo ""
echo " Check logs: docker logs -f ${CONTAINER_NAME}"