#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
DISK_NAME="${AZ_VM1_NAME}-data1"
az disk create -g "$AZ_RG" -n "$DISK_NAME" --size-gb 64 --sku Premium_LRS
VM_ID=$(az vm show -g "$AZ_RG" -n "$AZ_VM1_NAME" --query id -o tsv)
az vm disk attach --vm-name "$AZ_VM1_NAME" -g "$AZ_RG" --name "$DISK_NAME"
echo "Managed disk attached to $AZ_VM1_NAME."
