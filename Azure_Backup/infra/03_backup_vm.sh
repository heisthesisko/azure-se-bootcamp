#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Create a demo VM to protect
az vm create -g "$RG_NAME" -n "$VM_NAME" --image "$VM_IMAGE" --admin-username azureuser --generate-ssh-keys   --vnet-name "$VNET_NAME" --subnet "$SUBNET_NAME" --tags env=$TAG_ENV
# Enable backup for the VM
POLICY=$(az backup protection policy list -g "$RG_NAME" -v "$RSV_NAME" --query "[?name=='DefaultPolicy']|[0].name" -o tsv)
az backup protection enable-for-vm -g "$RG_NAME" -v "$RSV_NAME" --vm "$VM_NAME" --policy-name "$POLICY"
