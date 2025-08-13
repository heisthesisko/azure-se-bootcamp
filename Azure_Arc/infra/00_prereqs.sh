#!/usr/bin/env bash
set -euo pipefail


# Load config
source config/.env

echo "Logging into Azure (interactive if needed)..."
az account set -s "$AZ_SUBSCRIPTION_ID" || az login --tenant "$AZ_TENANT_ID" && az account set -s "$AZ_SUBSCRIPTION_ID"

echo "Registering providers..."
for p in Microsoft.HybridCompute Microsoft.Kubernetes Microsoft.KubernetesConfiguration Microsoft.ExtendedLocation Microsoft.ScVmm Microsoft.AzureArcData Microsoft.PolicyInsights; do
  az provider register --namespace $p || true
done

echo "Creating resource group..."
az group create -n "$AZ_RG" -l "$AZ_LOCATION"
