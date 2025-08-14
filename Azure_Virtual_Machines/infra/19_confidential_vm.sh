#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# Create a Confidential VM (availability depends on region/SKU)
az vm create -g "$AZ_RG" -n "cvmi-01" --image Ubuntu2204 --size Standard_DC2as_v5   --security-type ConfidentialVM --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH"   --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME" --public-ip-address ""
echo "Confidential VM requested (ensure region/SKU support)."
