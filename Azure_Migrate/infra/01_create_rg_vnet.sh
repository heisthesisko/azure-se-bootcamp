#!/usr/bin/env bash
set -euo pipefail
source config/.env

az account set --subscription "$AZ_SUBSCRIPTION_ID"

az group create -n "$RG_NAME" -l "$AZ_LOCATION"

az network vnet create -g "$RG_NAME" -n "$VNET_NAME" --address-prefix "$VNET_CIDR"   --subnet-name "$SUBNET_NAME" --subnet-prefix "$SUBNET_CIDR"

# Gateway subnet
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n GatewaySubnet   --address-prefixes "$GATEWAY_SUBNET_CIDR"

echo "Resource Group and VNet created."
