#!/usr/bin/env bash
set -euo pipefail
if ! command -v az >/dev/null; then
  echo "Azure CLI not found. Use Azure Cloud Shell or install AZ CLI locally."; exit 1
fi
if [ -f config/.env ]; then source config/.env; else source config/env.sample; fi
az account set --subscription "$AZ_SUBSCRIPTION_ID"
az provider register --namespace Microsoft.Compute --wait
az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.KeyVault --wait
az provider register --namespace Microsoft.Insights --wait
az provider register --namespace Microsoft.OperationalInsights --wait
echo "Providers registered and subscription set."
