#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network vnet subnet create -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_VNET_NAME}" -n appgw-subnet --address-prefixes 10.0.3.0/24
az network public-ip create -g "${WORKSHOP_RG}" -n appgw-pip --sku Standard --allocation-method Static
IP1=$(az vm list-ip-addresses -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM1_NAME}" --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
IP3=$(az vm list-ip-addresses -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM3_NAME}" --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
az network application-gateway create -g "${WORKSHOP_RG}" -n myAppGateway -l "${WORKSHOP_LOCATION}"   --sku WAF_v2 --vnet-name "${WORKSHOP_VNET_NAME}" --subnet appgw-subnet   --public-ip-address appgw-pip --capacity 2 --http-settings-protocol Http --http-settings-port 80   --servers $IP1 $IP3
echo "Module 09 complete."
