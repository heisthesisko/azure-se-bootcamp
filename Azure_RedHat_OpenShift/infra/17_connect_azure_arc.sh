#!/usr/bin/env bash
set -euo pipefail
source config/.env
# Attach OpenShift to Azure Arc (requires az connectedk8s extension)
az extension add --name connectedk8s --yes || true
az group create -n "$ARC_RG" -l "$LOCATION"
az connectedk8s connect -g "$ARC_RG" -n "$ARC_K8S_CLUSTER_NAME"
echo "[OK] Cluster attached to Azure Arc (verify in Azure Portal)."
