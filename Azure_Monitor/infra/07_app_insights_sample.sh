#!/usr/bin/env bash
set -euo pipefail
source config/.env
LAW_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query id -o tsv)
az monitor app-insights component create -g "$RG_NAME" -a "$APPINSIGHTS_NAME" -l "$LOCATION" --workspace "$LAW_ID"
echo "Application Insights created (workspace-based)."
