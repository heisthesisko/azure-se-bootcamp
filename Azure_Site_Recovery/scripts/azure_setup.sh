#!/usr/bin/env bash
set -euo pipefail
LOC_WEST="westus"
LOC_EAST="eastus"
RG_MAIN="asr-lab-rg"
RG_A2A="asr-a2a-rg"
VNET_WEST="asr-vnet-west"
VNET_EAST="asr-vnet-east"
VAULT="asr-workshop-vault"

az group create -n "$RG_MAIN" -l "$LOC_WEST"
az group create -n "$RG_A2A" -l "$LOC_WEST"
az network vnet create -g "$RG_MAIN" -n "$VNET_WEST" --address-prefixes 10.10.0.0/16 --subnet-name default --subnet-prefix 10.10.1.0/24 -l "$LOC_WEST"
az network vnet create -g "$RG_MAIN" -n "$VNET_EAST" --address-prefixes 10.20.0.0/16 --subnet-name default --subnet-prefix 10.20.1.0/24 -l "$LOC_EAST"

az network vnet peering create -g "$RG_MAIN" -n west-to-east --vnet-name "$VNET_WEST" --remote-vnet "$VNET_EAST" --allow-vnet-access
az network vnet peering create -g "$RG_MAIN" -n east-to-west --vnet-name "$VNET_EAST" --remote-vnet "$VNET_WEST" --allow-vnet-access

az backup vault create -g "$RG_MAIN" -n "$VAULT" -l "$LOC_WEST"
echo "Created vault $VAULT in $LOC_WEST"
