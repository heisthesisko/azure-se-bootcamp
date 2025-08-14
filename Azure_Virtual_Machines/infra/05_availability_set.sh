#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
AS_NAME="as-hcws"
az vm availability-set create -g "$AZ_RG" -n "$AS_NAME" --platform-fault-domain-count 2 --platform-update-domain-count 5
# Deploy two VMs into availability set (simplified)
for i in 1 2; do
  az vm create -g "$AZ_RG" -n "app-as-${i}" --image Ubuntu2204 --size Standard_D2s_v5     --availability-set "$AS_NAME" --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH"     --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME" --public-ip-address "" --nsg ""
done
echo "Availability set and sample VMs created."
