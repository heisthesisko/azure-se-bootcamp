#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

az site-recovery policy update -g "$RG_NAME" --vault-name "$VAULT_NAME" -n "$A2A_POLICY_NAME" --provider-specific-input "{a2a:{multi-vm-sync-status:Enable,app-consistent-snapshot-frequency-in-hours:4}}" >/dev/null || true
ok "App-consistent frequency set to 4 hours"
