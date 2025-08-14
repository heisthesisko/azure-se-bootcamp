#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
az vm create -g "$AZ_RG" -n "spot-worker" --image Ubuntu2204 --priority Spot --max-price -1   --eviction-policy Deallocate --size Standard_D2s_v5 --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH"   --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME" --public-ip-address ""
echo "Spot VM created (best effort capacity, can be evicted)."
