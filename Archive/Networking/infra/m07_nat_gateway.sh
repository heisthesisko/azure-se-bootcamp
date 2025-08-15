#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network public-ip create -g "${WORKSHOP_RG}" -n natgw-pip --sku Standard --allocation-method static
az network nat gateway create -g "${WORKSHOP_RG}" -n workshop-natgw --public-ip-addresses natgw-pip --idle-timeout 4
az network vnet subnet create -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_VNET_NAME}" -n "${WORKSHOP_SUBNET_PRIVATE}" --address-prefixes "${WORKSHOP_SUBNET_PRIVATE_ADDR}"
az network vnet subnet update -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_VNET_NAME}" -n "${WORKSHOP_SUBNET_PRIVATE}" --nat-gateway workshop-natgw
az vm create -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM2_NAME}" --image UbuntuLTS   --vnet-name "${WORKSHOP_VNET_NAME}" --subnet "${WORKSHOP_SUBNET_PRIVATE}"   --public-ip-address "" --admin-username "${WORKSHOP_ADMIN}" --generate-ssh-keys
echo "Module 07 complete."
