#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"
# Create storage account & Log Analytics (if not exists), link to Synapse placeholder
az storage account create -g "$RG_NAME" -n "$STORAGE_ACCOUNT_NAME" -l "$AZ_LOCATION" --sku Standard_LRS
echo "Set up Synapse/Fabric via portal or IaC templates (out of scope for CLI-only demo)."
