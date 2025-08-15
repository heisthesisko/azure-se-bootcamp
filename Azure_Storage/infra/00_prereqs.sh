#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
az provider register --namespace Microsoft.Storage -o none || true
az provider register --namespace Microsoft.Network -o none || true
az provider register --namespace Microsoft.KeyVault -o none || true
az provider register --namespace Microsoft.OperationalInsights -o none || true
az provider register --namespace Microsoft.HealthcareApis -o none || true

az extension add -n storage-preview -y || true
az extension add -n healthcareapis -y || true
az extension add -n storagesync -y || true
az extension add -n storage-mover -y || true

ensure_vnet
ensure_la
echo "Prerequisites complete."
