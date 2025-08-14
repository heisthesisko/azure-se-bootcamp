#!/usr/bin/env bash
set -euo pipefail
source config/.env
az group create -n "$RESOURCEGROUP" -l "$LOCATION"
az network vnet create -g "$RESOURCEGROUP" -n "$VNET_NAME" --address-prefixes 10.0.0.0/22
az network vnet subnet create -g "$RESOURCEGROUP" --vnet-name "$VNET_NAME" -n master-subnet --address-prefixes 10.0.0.0/23
az network vnet subnet create -g "$RESOURCEGROUP" --vnet-name "$VNET_NAME" -n worker-subnet --address-prefixes 10.0.2.0/23
az network vnet subnet update -g "$RESOURCEGROUP" --vnet-name "$VNET_NAME" -n master-subnet --disable-private-link-service-network-policies true
echo "[OK] VNet and subnets created."
