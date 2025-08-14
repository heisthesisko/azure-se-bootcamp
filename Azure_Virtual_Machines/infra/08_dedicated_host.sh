#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
HOST_GROUP="hg-hcws"; HOST_NAME="host-hcws-01"
az vm host group create -g "$AZ_RG" -n "$HOST_GROUP" -l "$AZ_LOCATION"
az vm host create -g "$AZ_RG" --host-group "$HOST_GROUP" -n "$HOST_NAME" --sku "DSv5-Type1" --platform-fault-domain 1
az vm create -g "$AZ_RG" -n "dh-app-01" --image Ubuntu2204 --size Standard_D2s_v5   --host-group "$HOST_GROUP" --host "$HOST_NAME" --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH"   --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME" --public-ip-address ""
echo "VM created on a Dedicated Host."
