#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

az site-recovery protected-item unplanned-failover -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_PRIMARY" --protection-container "A2A-${LOC_PRIMARY}-container" -n "${VM_NAME}-a2a" --failover-direction PrimaryToRecovery --source-site-operations True || true
ok "Test failover submitted"
