#!/usr/bin/env bash
set -euo pipefail
source config/.env
LAW_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query id -o tsv)
az aks create -g "$RG_NAME" -n "$AKS_NAME" --node-count 2 --enable-addons monitoring   --workspace-resource-id "$LAW_ID" --generate-ssh-keys
az aks get-credentials -g "$RG_NAME" -n "$AKS_NAME" --overwrite-existing
kubectl create deployment hello-web --image=nginxdemos/hello || true
kubectl expose deployment hello-web --port 80 --type ClusterIP || true
echo "AKS with Container Insights ready."
