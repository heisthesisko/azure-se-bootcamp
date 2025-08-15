#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

az site-recovery network mapping create -g "$RG_NAME" --vault-name "$VAULT_NAME" --fabric-name "$LOC_PRIMARY" -n "map-net-${LOC_PRIMARY}-${LOC_SECONDARY}" --network "$VNET_NAME" --recovery-fabric-name "$LOC_SECONDARY" --recovery-network "$TARGET_VNET_NAME" >/dev/null || true
ok "Network mapping submitted"
