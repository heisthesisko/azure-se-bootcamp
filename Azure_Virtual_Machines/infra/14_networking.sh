#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# NSG basics
NSG="nsg-app"
az network nsg create -g "$AZ_RG" -n "$NSG"
az network nsg rule create -g "$AZ_RG" --nsg-name "$NSG" -n AllowSSH --priority 100   --source-address-prefixes "$ALLOW_IP" --destination-port-ranges 22 --direction Inbound --access Allow --protocol Tcp
# Associate NSG to subnet
az network vnet subnet update -g "$AZ_RG" --vnet-name "$AZ_VNET_NAME" --name "$AZ_SUBNET_APP_NAME" --network-security-group "$NSG"
echo "NSG created and associated to app subnet."
