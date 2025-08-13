#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"
# Placeholder: Purview account creation (requires provider registrations and region availability)
echo "Create Purview account and register sources for scanning (portal or az)."
