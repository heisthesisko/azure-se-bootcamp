#!/usr/bin/env bash
set -euo pipefail


source config/.env
echo "Create Log Analytics workspace (if not exists)"
az monitor log-analytics workspace create -g "$LA_WS_RG" -n "$LA_WS_NAME" -l "$AZ_LOCATION" || true
echo "Visit Azure Update Manager in Portal to onboard Arc machines and schedule patches using dynamic tag groups (Env=Prod/Dev)."
