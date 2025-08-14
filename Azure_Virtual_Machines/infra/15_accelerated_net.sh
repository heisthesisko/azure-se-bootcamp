#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# Show NIC acceleration status
NIC_ID=$(az vm show -g "$AZ_RG" -n "$AZ_VM1_NAME" --query "networkProfile.networkInterfaces[0].id" -o tsv)
az network nic show --ids "$NIC_ID" --query "enableAcceleratedNetworking"
