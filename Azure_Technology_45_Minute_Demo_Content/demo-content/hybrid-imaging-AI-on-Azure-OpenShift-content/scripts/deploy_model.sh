#!/usr/bin/env bash
set -euo pipefail
# deploy_model.sh — Register a model and deploy a private online endpoint
# Prereqs: az login; az extension add -n ml -y; AML workspace deployed with publicNetworkAccess=Disabled and private endpoints configured

RG=${RG:-ImagingRG}
WS=${WS:-ImagingMLWorkspace}
MODEL_NAME=${MODEL_NAME:-cxr-anomaly-model}
MODEL_PATH=${MODEL_PATH:-model.onnx}
ENDPOINT_NAME=${ENDPOINT_NAME:-cxr-anomaly-endpoint}
INSTANCE_TYPE=${INSTANCE_TYPE:-Standard_NC6}
INSTANCE_COUNT=${INSTANCE_COUNT:-1}

echo "[*] Registering model: $MODEL_NAME"
az ml model create -g "$RG" -w "$WS" -n "$MODEL_NAME" --path "$MODEL_PATH" --type custom

echo "[*] Creating endpoint: $ENDPOINT_NAME"
az ml online-endpoint create -g "$RG" -w "$WS" -n "$ENDPOINT_NAME" --auth-mode key

echo "[*] Creating deployment 'default'"
az ml online-deployment create -g "$RG" -w "$WS" --endpoint "$ENDPOINT_NAME" -n default \
  --model "$MODEL_NAME:1" --instance-type "$INSTANCE_TYPE" --instance-count "$INSTANCE_COUNT" --all-traffic

echo "[*] Done. Retrieve scoring URI and key:"
az ml online-endpoint show -g "$RG" -w "$WS" -n "$ENDPOINT_NAME" --query "{scoringUri:scoringUri}"
az ml online-endpoint get-credentials -g "$RG" -w "$WS" -n "$ENDPOINT_NAME"
