#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
SSH_KEY=${AZ_SSH_KEY_PATH}
if [ ! -f "$SSH_KEY" ]; then echo "SSH key not found at $SSH_KEY"; exit 1; fi
az vm create -g "$AZ_RG" -n "$AZ_VM1_NAME" --image Ubuntu2204   --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$SSH_KEY"   --size "$AZ_VM1_SIZE" --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME"   --public-ip-address "" --nsg "" --enable-agent true $( [ "$ENABLE_ACCEL_NET" = "true" ] && echo "--accelerated-networking true" )
echo "VM deployed without public IP (intended to be accessed via Bastion in later module)."
