#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
PPG="ppg-app"
az ppg create -g "$AZ_RG" -n "$PPG" -l "$AZ_LOCATION"
az vm create -g "$AZ_RG" -n "ppg-db" --image Ubuntu2204 --size Standard_D4s_v5   --ppg "$PPG" --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH"   --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME" --public-ip-address ""
az vm create -g "$AZ_RG" -n "ppg-web" --image Ubuntu2204 --size Standard_D2s_v5   --ppg "$PPG" --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH"   --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME" --public-ip-address ""
echo "Two VMs co-located in a Proximity Placement Group."
