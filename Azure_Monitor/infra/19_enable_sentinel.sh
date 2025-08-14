#!/usr/bin/env bash
set -euo pipefail
source config/.env
# Create a dedicated Sentinel workspace
az monitor log-analytics workspace create -g "$RG_NAME" -n "$SENTINEL_WS" -l "$LOCATION" || true
WS_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$SENTINEL_WS" --query id -o tsv)
az security sentinel create --resource-group "$RG_NAME" --workspace-name "$SENTINEL_WS" || true
echo "Microsoft Sentinel enabled on workspace $SENTINEL_WS."
