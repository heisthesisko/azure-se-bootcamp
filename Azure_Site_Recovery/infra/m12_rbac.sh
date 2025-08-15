#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

VAULT_ID=$(az resource show -g "$RG_NAME" -n "$VAULT_NAME" --resource-type "Microsoft.RecoveryServices/vaults" --query id -o tsv)
USER_ID=$(az ad signed-in-user show --query id -o tsv 2>/dev/null || echo "")
[ -n "$USER_ID" ] && az role assignment create --assignee-object-id "$USER_ID" --assignee-principal-type User --role "Site Recovery Contributor" --scope "$VAULT_ID" || true
ok "RBAC assignment attempted"
