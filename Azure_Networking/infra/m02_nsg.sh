#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network nsg create -g "${WORKSHOP_RG}" -n webSubnet-nsg
MY_IP=$(curl -s ifconfig.me || echo "0.0.0.0/0")
az network nsg rule create -g "${WORKSHOP_RG}" --nsg-name webSubnet-nsg -n AllowSSH   --priority 100 --source-address-prefixes "$MY_IP" --destination-port-ranges 22   --direction Inbound --access Allow --protocol Tcp
az network nsg rule create -g "${WORKSHOP_RG}" --nsg-name webSubnet-nsg -n AllowWebHTTP   --priority 110 --source-address-prefixes "*" --destination-port-ranges 80   --direction Inbound --access Allow --protocol Tcp
az network vnet subnet update -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_VNET_NAME}"   --name "${WORKSHOP_SUBNET_WEB}" --network-security-group webSubnet-nsg
echo "Module 02 complete."
