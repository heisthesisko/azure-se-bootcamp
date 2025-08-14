#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
az network public-ip create -g "$AZ_RG" -n "$AZ_PUBLIC_IP_BASTION" --sku Standard
az network bastion create -g "$AZ_RG" -n "$AZ_BASTION_NAME" --public-ip-address "$AZ_PUBLIC_IP_BASTION" --vnet-name "$AZ_VNET_NAME" --sku Basic
echo "Bastion created. Use Azure Portal to connect via browser to $AZ_VM1_NAME."
