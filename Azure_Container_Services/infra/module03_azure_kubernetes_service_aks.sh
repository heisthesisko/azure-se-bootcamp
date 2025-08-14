#!/usr/bin/env bash
set -euo pipefail
source config/.env
SUBNET_ID=$(az network vnet subnet show -g "$RESOURCE_GROUP" --vnet-name "$VNET_NAME" -n "$SUBNET_AKS_NAME" --query id -o tsv)
az aks create -g "$RESOURCE_GROUP" -n "$AKS_NAME" --node-count 3 --network-plugin azure --vnet-subnet-id "$SUBNET_ID" --enable-managed-identity --generate-ssh-keys --kubernetes-version "$AKS_VERSION" --attach-acr "$ACR_NAME"
az aks get-credentials -g "$RESOURCE_GROUP" -n "$AKS_NAME" --overwrite-existing
