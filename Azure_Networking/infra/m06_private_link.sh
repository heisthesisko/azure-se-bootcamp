#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
SA_NAME="workshop$RANDOM$RANDOM"
az storage account create -g "${WORKSHOP_RG}" -n "${SA_NAME}" -l "${WORKSHOP_LOCATION}" --sku Standard_LRS
az network private-dns zone create -g "${WORKSHOP_RG}" -n "privatelink.blob.core.windows.net"
az network private-dns link vnet create -g "${WORKSHOP_RG}" -z privatelink.blob.core.windows.net -n LinkToSpoke --virtual-network "${WORKSHOP_VNET_NAME}" -e true
SA_ID=$(az storage account show -g "${WORKSHOP_RG}" -n "${SA_NAME}" --query id -o tsv)
az network private-endpoint create -g "${WORKSHOP_RG}" -n storage-pe -l "${WORKSHOP_LOCATION}"   --vnet-name "${WORKSHOP_VNET_NAME}" --subnet "${WORKSHOP_SUBNET_WEB}"   --private-connection-resource-id "${SA_ID}" --group-id blob --connection-name "storage-blob-privlink"
az storage account update -g "${WORKSHOP_RG}" -n "${SA_NAME}" --public-network-access Disabled
echo "Module 06 complete. Storage account ${SA_NAME} has Private Endpoint."
