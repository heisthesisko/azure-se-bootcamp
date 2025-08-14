#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
VMSS_NAME="vmss-app"
az vmss create -g "$AZ_RG" -n "$VMSS_NAME" --image Ubuntu2204 --upgrade-policy-mode automatic   --admin-username "$AZ_ADMIN_USER" --ssh-key-values "$AZ_SSH_KEY_PATH" --instance-count 2   --vnet-name "$AZ_VNET_NAME" --subnet "$AZ_SUBNET_APP_NAME"
# Autoscale rules via Monitor Autoscale
az monitor autoscale create -g "$AZ_RG" -n "${VMSS_NAME}-autoscale" --resource "${VMSS_NAME}" --resource-type "Microsoft.Compute/virtualMachineScaleSets" --min-count 2 --max-count 5 --count 2
echo "Scale set created with autoscale profile."
