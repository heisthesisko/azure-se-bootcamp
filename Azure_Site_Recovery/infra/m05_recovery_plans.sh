#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

RP_FILE="infra/tmp_recovery_plan.json"; RP_NAME="rp-a2a-${VM_NAME}"
PRIMARY_FABRIC_ID="/Subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$VAULT_NAME/replicationFabrics/$LOC_PRIMARY"
RECOVERY_FABRIC_ID="/Subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$VAULT_NAME/replicationFabrics/$LOC_SECONDARY"
RPI_ID="/Subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$VAULT_NAME/replicationFabrics/$LOC_PRIMARY/replicationProtectionContainers/A2A-${LOC_PRIMARY}-container/replicationProtectedItems/${VM_NAME}-a2a"
cat > "$RP_FILE" <<JSON
{"properties":{"primaryFabricId":"$PRIMARY_FABRIC_ID","recoveryFabricId":"$RECOVERY_FABRIC_ID","groups":[{"groupType":"Boot","replicatedProtectedItems":[{"id":"$RPI_ID"}]}]}}
JSON
az site-recovery recovery-plan create -g "$RG_NAME" --vault-name "$VAULT_NAME" -n "$RP_NAME" --properties @"$RP_FILE" >/dev/null || true
ok "Recovery plan created"
