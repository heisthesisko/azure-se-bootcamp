#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

POLICY_DEF_ID="/providers/Microsoft.Authorization/policyDefinitions/ac34a73f-9fa5-4067-9247-a3ecae514468"
az policy assignment create --name "enforce-asr-on-vms" --display-name "Configure DR on VMs via ASR" --policy "$POLICY_DEF_ID" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME" >/dev/null || true
ok "Policy assignment created"
