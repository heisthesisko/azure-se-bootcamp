#!/usr/bin/env bash
set -euo pipefail
if [ -f config/.env ]; then source config/.env; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
az account set --subscription "$SUBSCRIPTION_ID"
az provider register --namespace Microsoft.ContainerService --wait
az provider register --namespace Microsoft.Network --wait
az extension add --name aks-preview --upgrade --yes || true
