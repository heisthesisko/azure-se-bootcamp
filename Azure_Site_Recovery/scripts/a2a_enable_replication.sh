#!/usr/bin/env bash
set -euo pipefail
RG="asr-lab-rg"
VAULT="asr-workshop-vault"
VM_NAME="${1:-a2a-linux-web}"

az extension add --name site-recovery >/dev/null 2>&1 || true

# Simplified enablement: assumes fabrics already initialized for West/East
az recoveryservices replication-protection enable   --resource-group "$RG"   --vault-name "$VAULT"   --source-vm-id "$(az vm show -g "$RG" -n "$VM_NAME" --query id -o tsv)"   --target-resource-group "$RG"   --target-network-id "$(az network vnet show -g "$RG" -n asr-vnet-east --query id -o tsv)"   --target-subnet-name default

echo "Requested A2A replication for VM $VM_NAME → East US"
