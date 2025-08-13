#!/usr/bin/env bash
set -euo pipefail
# Create a simple Dockerfile for the AI service and build/push to ACR
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"
az acr create -g "$RG_NAME" -n "$ACR_NAME" --sku Basic
az acr login -n "$ACR_NAME"

cat > app/ai/Dockerfile <<'DOCKER'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
DOCKER

IMAGE="$ACR_NAME.azurecr.io/hc-ai:latest"
az acr build -r "$ACR_NAME" -t "$IMAGE" app/ai
echo "Built and pushed $IMAGE"
