#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az group create -n "${WORKSHOP_RG}" -l "${WORKSHOP_LOCATION}"
az network vnet create -g "${WORKSHOP_RG}" -n "${WORKSHOP_VNET_NAME}"   --address-prefixes "${WORKSHOP_VNET_ADDR}"   --subnet-name "${WORKSHOP_SUBNET_WEB}" --subnet-prefixes "${WORKSHOP_SUBNET_WEB_ADDR}"
az network public-ip create -g "${WORKSHOP_RG}" -n vm1-pip --sku Basic
az vm create -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM1_NAME}" --image UbuntuLTS   --vnet-name "${WORKSHOP_VNET_NAME}" --subnet "${WORKSHOP_SUBNET_WEB}"   --public-ip-address vm1-pip --admin-username "${WORKSHOP_ADMIN}" --generate-ssh-keys
echo "Module 01 complete. VM1 public IP:"
az vm list-ip-addresses -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM1_NAME}" -o table
