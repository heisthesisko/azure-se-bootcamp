#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"

# Create Log Analytics workspace
az monitor log-analytics workspace create -g "$RG_NAME" -n "$LOG_ANALYTICS_NAME"

# (Example) Assign built-in policy initiative for HIPAA/HITRUST if available in your environment.
echo "Assign HIPAA/HITRUST policies via Azure Policy (portal or az)."
