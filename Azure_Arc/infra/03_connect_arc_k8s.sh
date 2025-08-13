#!/usr/bin/env bash
set -euo pipefail


source config/.env
echo "Adding Azure CLI extensions (idempotent)..."
az extension add --name connectedk8s || az extension update --name connectedk8s
az extension add --name k8s-extension || az extension update --name k8s-extension
az extension add --name k8s-configuration || az extension update --name k8s-configuration

echo "Connecting cluster: $ARC_K8S_NAME"
az connectedk8s connect -g "$ARC_RG_K8S" -n "$ARC_K8S_NAME" --tags Environment=OnPrem Purpose=EdgeAnalytics
