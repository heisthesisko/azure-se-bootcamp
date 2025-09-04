#!/usr/bin/env bash
set -euo pipefail
# connect_openshift.sh — Onboard an OpenShift cluster to Azure Arc
# Prereqs: az login; kubeconfig pointing to the target OpenShift cluster; cluster outbound to Azure endpoints

RG=${RG:-ImagingRG}
CLUSTER_NAME=${CLUSTER_NAME:-OnPrem-OpenShift}

az extension add --name connectedk8s -y >/dev/null
echo "[*] Connecting cluster '$CLUSTER_NAME' in resource group '$RG' to Azure Arc..."
az connectedk8s connect -g "$RG" -n "$CLUSTER_NAME" --distribution OpenShift
echo "[*] Connected. Consider adding monitoring and policy extensions via 'az k8s-extension create'."
