#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ ! -f "$ROOT_DIR/config/.env" ]]; then
  echo "config/.env not found. Copy config/env.sample -> config/.env and set values."
  exit 1
fi
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
echo "[00] Register providers and create RG + Log Analytics"
az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.Insights --wait
az provider register --namespace Microsoft.OperationalInsights --wait
az group create -n "$RG_NAME" -l "$LOCATION" --tags env="$TAG_ENV" workshop="azure-network-healthcare"
# Log Analytics
az monitor log-analytics workspace create -g "$RG_NAME" -n "$LA_WORKSPACE" --retention-time "$LAW_RETENTION_DAYS"
# Enable Network Watcher in region
az network watcher configure --locations "$LOCATION" --resource-group "$RG_NAME" --enabled true
echo "Prereqs complete."
