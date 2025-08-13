#!/usr/bin/env bash
set -euo pipefail


source config/.env
WS_ID=$(az monitor log-analytics workspace show -g "$LA_WS_RG" -n "$LA_WS_NAME" --query customerId -o tsv || true)
echo "Workspace ID: $WS_ID"
echo "Install Azure Monitor Agent extension on each Arc server via Portal or CLI."
echo "Create metric/log alerts as needed in Azure Monitor."
