#!/usr/bin/env bash
set -euo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${THIS_DIR}/common.sh"

echo "[1/5] Ensuring resource group..."
ensure_rg

echo "[2/5] Registering resource providers (idempotent)..."
az provider register --namespace Microsoft.Storage -o none || true
az provider register --namespace Microsoft.Network -o none || true
az provider register --namespace Microsoft.KeyVault -o none || true
az provider register --namespace Microsoft.OperationalInsights -o none || true
az provider register --namespace Microsoft.HealthcareApis -o none || true

echo "[3/5] Installing Azure CLI extensions if needed..."
az extension add -n healthcareapis -y || true
az extension add -n storage-preview -y || true
az extension add -n storagesync -y || true
az extension add -n storage-mover -y || true

echo "[4/5] Creating network (VNet + subnets) ..."
ensure_vnet

echo "[5/5] Creating Log Analytics workspace and Key Vault ..."
ensure_log_analytics
ensure_kv

echo "Prereqs completed."
