#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
az group create -l "$AZ_LOCATION" -n "$AZ_RG"
az network vnet create -g "$AZ_RG" -n "$AZ_VNET_NAME" --address-prefix "$AZ_VNET_CIDR"   --subnet-name "$AZ_SUBNET_APP_NAME" --subnet-prefixes "$AZ_SUBNET_APP_CIDR"
az network vnet subnet create -g "$AZ_RG" --vnet-name "$AZ_VNET_NAME" -n "$AZ_SUBNET_MANAGEMENT_NAME" --address-prefixes "$AZ_SUBNET_MANAGEMENT_CIDR"
echo "Resource group and VNets created."
