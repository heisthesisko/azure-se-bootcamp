#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

log "Enable A2A replication for a VM"
PRIMARY_FABRIC="$LOC_PRIMARY"; RECOVERY_FABRIC="$LOC_SECONDARY"
SRC_CONTAINER="A2A-${LOC_PRIMARY}-container"; DST_CONTAINER="A2A-${LOC_SECONDARY}-container"
VM_ID=$(az vm show -g "$RG_NAME" -n "$VM_NAME" --query id -o tsv)
OS_DISK_ID=$(az vm show -g "$RG_NAME" -n "$VM_NAME" --query "storageProfile.osDisk.managedDisk.id" -o tsv)
POLICY_ID=$(az site-recovery policy show -g "$RG_NAME" --vault-name "$VAULT_NAME" -n "$A2A_POLICY_NAME" --query id -o tsv)
RECOVERY_RG_ID=$(az group show -n "$RG_NAME" --query id -o tsv)
RECOVERY_VNET_ID=$(az network vnet show -g "$RG_NAME" -n "$TARGET_VNET_NAME" --query id -o tsv)
PROTECTED_ITEM_NAME="${VM_NAME}-a2a"
set +e
az site-recovery protected-item create -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$PRIMARY_FABRIC" --protection-container "$SRC_CONTAINER" -n "$PROTECTED_ITEM_NAME" --policy-id "$POLICY_ID" --provider-details "{a2a:{fabric-object-id:\"$VM_ID\",vm-managed-disks:[{disk-id:\"$OS_DISK_ID\",recovery-resource-group-id:\"$RECOVERY_RG_ID\"}],recovery-container-id:\"/Subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$VAULT_NAME/replicationFabrics/$RECOVERY_FABRIC/replicationProtectionContainers/$DST_CONTAINER\",recovery-azure-network-id:\"$RECOVERY_VNET_ID\",recovery-subnet-name:\"$TARGET_SUBNET_APP_NAME\",recovery-resource-group-id:\"$RECOVERY_RG_ID\"}}"
if [ $? -ne 0 ]; then
  set -e
  log "Falling back to REST API"
  API="2025-02-01"
  URL="https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$VAULT_NAME/replicationFabrics/$PRIMARY_FABRIC/replicationProtectionContainers/$SRC_CONTAINER/replicationProtectedItems/$PROTECTED_ITEM_NAME?api-version=$API"
  BODY=$(cat <<JSON
{ "properties": { "policyId": "$POLICY_ID",
  "providerSpecificDetails": { "instanceType":"A2A", "fabricObjectId":"$VM_ID",
    "recoveryAzureNetworkId":"$RECOVERY_VNET_ID", "recoveryAzureSubnetName":"$TARGET_SUBNET_APP_NAME",
    "recoveryResourceGroupId":"$RECOVERY_RG_ID", "recoveryContainerId":"/Subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$VAULT_NAME/replicationFabrics/$RECOVERY_FABRIC/replicationProtectionContainers/$DST_CONTAINER",
    "vmManagedDisks":[{"diskId":"$OS_DISK_ID","recoveryResourceGroupId":"$RECOVERY_RG_ID"}] } } }
JSON
)
  az rest --method put --uri "$URL" --headers "Content-Type=application/json" --body "$BODY"
fi
ok "Enable replication request submitted. Track with 'az site-recovery job list'."
