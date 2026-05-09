#!/bin/bash
# ─────────────────────────────────────────────────────────────
# OTP Lookup API — Docker Build & Push Script
# Usage: ./build-push.sh <dockerhub-username> [tag]
# Example: ./build-push.sh anfal11 latest
# ─────────────────────────────────────────────────────────────

set -e

DOCKERHUB_USER="${1:-anfal11}"
TAG="${2:-latest}"
IMAGE_NAME="otp-lookup-api"
FULL_IMAGE="${DOCKERHUB_USER}/${IMAGE_NAME}:${TAG}"

echo "──────────────────────────────────────────"
echo " Building: ${FULL_IMAGE}"
echo "──────────────────────────────────────────"

# Build image
docker build -t "${FULL_IMAGE}" .

echo ""
echo "✅ Build complete. Pushing to Docker Hub..."
echo ""

# Push image
docker push "${FULL_IMAGE}"

echo ""
echo "✅ Push complete!"
echo ""
echo "──────────────────────────────────────────"
echo " Deploy on ptysrv11 server:"
echo "──────────────────────────────────────────"
echo ""
echo "  docker pull ${FULL_IMAGE}"
echo ""
echo "  docker run -d \\"
echo "    --name otp-lookup-api \\"
echo "    --restart unless-stopped \\"
echo "    -p 3500:3000 \\"
echo "    -e DB_HOST=192.168.1.102 \\"
echo "    -e DB_PORT=1433 \\"
echo "    -e DB_USER=SA \\"
echo "    -e DB_PASS='W@letSimulation@2026' \\"
echo "    -e DB_NAME=finify \\"
echo "    ${FULL_IMAGE}"
echo ""
echo "  Then access: http://<server-ip>:3500/otp/<msisdn>"
echo "──────────────────────────────────────────"