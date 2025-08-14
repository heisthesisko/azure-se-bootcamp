#!/usr/bin/env bash
set -euo pipefail
source config/.env
: "${PULL_SECRET_FILE:?Set path to Red Hat pull secret file}"
az aro create -g "$RESOURCEGROUP" -n "$CLUSTER_NAME"   --vnet "$VNET_NAME" --master-subnet master-subnet --worker-subnet worker-subnet   --pull-secret @"$PULL_SECRET_FILE"
echo "[OK] ARO cluster create submitted."
