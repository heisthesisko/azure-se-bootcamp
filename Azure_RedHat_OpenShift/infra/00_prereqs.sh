#!/usr/bin/env bash
set -euo pipefail
: "${AZ_SUBSCRIPTION_ID:?Set in config/.env}"
az account set -s "$AZ_SUBSCRIPTION_ID"
az provider register -n Microsoft.RedHatOpenShift --wait
az provider register -n Microsoft.Compute --wait
az provider register -n Microsoft.Network --wait
az provider register -n Microsoft.Storage --wait
echo "[OK] Providers registered."
