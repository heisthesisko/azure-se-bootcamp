#!/usr/bin/env bash
set -euo pipefail
source config/.env
az vm create -g "$RG_NAME" -n "$VM_NAME" --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys   --vnet-name "$VNET_NAME" --subnet "$SUBNET_NAME" --public-ip-sku Standard --size Standard_B1ms
echo "VM created. Metrics are collected automatically for Azure VMs."
