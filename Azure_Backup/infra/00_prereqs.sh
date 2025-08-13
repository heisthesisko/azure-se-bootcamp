#!/usr/bin/env bash
set -euo pipefail
az account show >/dev/null 2>&1 || az login --use-device-code
if [ -f "$(dirname "$0")/../config/.env" ]; then
  set -a; source "$(dirname "$0")/../config/.env"; set +a
else
  set -a; source "$(dirname "$0")/../config/env.sample"; set +a
fi
az account set --subscription "$AZ_SUBSCRIPTION_ID"
echo "Using subscription: $(az account show --query name -o tsv)"
