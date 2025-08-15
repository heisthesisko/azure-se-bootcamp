#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

log "Create Recovery Services vault in secondary region"
az recovery-services vault create -g "$RG_NAME" -n "$VAULT_NAME" -l "$LOC_SECONDARY" >/dev/null
export AZURE_DEFAULTS_GROUP="$RG_NAME"; export AZURE_DEFAULTS_LOCATION="$LOC_SECONDARY"
log "A2A policy with multi-VM sync"
az site-recovery policy create -g "$RG_NAME" --vault-name "$VAULT_NAME" -n "$A2A_POLICY_NAME" --provider-specific-input "{a2a:{multi-vm-sync-status:Enable}}" >/dev/null || true
log "Create protection containers"
az site-recovery protection-container create -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_PRIMARY" -n "A2A-${LOC_PRIMARY}-container" --provider-input "[{instance-type:A2A}]" >/dev/null || true
az site-recovery protection-container create -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_SECONDARY" -n "A2A-${LOC_SECONDARY}-container" --provider-input "[{instance-type:A2A}]" >/dev/null || true
log "Map containers with policy"
POLICY_ID=$(az site-recovery policy show -g "$RG_NAME" --vault-name "$VAULT_NAME" -n "$A2A_POLICY_NAME" --query id -o tsv)
az site-recovery protection-container mapping create -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_PRIMARY" --protection-container "A2A-${LOC_PRIMARY}-container" -n "map-${LOC_PRIMARY}-to-${LOC_SECONDARY}" --target-container "A2A-${LOC_SECONDARY}-container" --policy-id "$POLICY_ID" >/dev/null || true
ok "Vault + policy configured"
