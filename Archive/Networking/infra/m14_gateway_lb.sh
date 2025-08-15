#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network vnet subnet create -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_VNET_NAME}" -n nva-subnet --address-prefixes 10.0.4.0/24
az vm create -g "${WORKSHOP_RG}" -n firewallVM --image UbuntuLTS --vnet-name "${WORKSHOP_VNET_NAME}" --subnet nva-subnet   --public-ip-address "" --admin-username "${WORKSHOP_ADMIN}" --generate-ssh-keys
NIC=$(az vm show -g "${WORKSHOP_RG}" -n firewallVM --query "networkProfile.networkInterfaces[0].id" -o tsv | awk -F/ '{print $NF}')
az network nic update -g "${WORKSHOP_RG}" -n "$NIC" --ip-forwarding true
az network lb create -g "${WORKSHOP_RG}" -n gwlb --sku Gateway --frontend-ip-name gwFront --backend-pool-name nvaPool
az network lb frontend-ip update -g "${WORKSHOP_RG}" --lb-name gwlb -n gwFront --subnet nva-subnet
az network lb probe create -g "${WORKSHOP_RG}" --lb-name gwlb -n nvaHealth --protocol Tcp --port 80
az network lb rule create -g "${WORKSHOP_RG}" --lb-name gwlb -n allPorts --protocol All --frontend-port 0 --backend-port 0 --frontend-ip-name gwFront --backend-pool-name nvaPool --probe-name nvaHealth
az network nic ip-config address-pool add -g "${WORKSHOP_RG}" --nic-name "$NIC" --lb-name gwlb --pool-name nvaPool
echo "Module 14 complete (initial chaining setup)."
