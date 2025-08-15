#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

ITEM="${VM_NAME}-a2a"
az site-recovery protected-item planned-failover -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_PRIMARY" --protection-container "A2A-${LOC_PRIMARY}-container" -n "$ITEM" --failover-direction PrimaryToRecovery --source-site-operations True || true
az site-recovery protected-item failover-commit -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_SECONDARY" --protection-container "A2A-${LOC_SECONDARY}-container" -n "$ITEM" || true
az site-recovery protected-item reprotect -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_SECONDARY" --protection-container "A2A-${LOC_SECONDARY}-container" -n "$ITEM" --failover-direction RecoveryToPrimary || true
ok "Failover/commit/reprotect submitted"
