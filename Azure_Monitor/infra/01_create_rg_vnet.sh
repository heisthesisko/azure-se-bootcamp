#!/usr/bin/env bash
set -euo pipefail
source config/.env
az group create -n "$RG_NAME" -l "$LOCATION"
az network vnet create -g "$RG_NAME" -n "$VNET_NAME" --address-prefix "$VNET_CIDR"   --subnet-name "$SUBNET_NAME" --subnet-prefix "$SUBNET_CIDR"
echo "RG and VNet ready."
