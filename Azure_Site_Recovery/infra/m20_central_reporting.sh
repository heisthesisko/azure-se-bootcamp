#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

OUT="asr_jobs_$(date +%Y%m%d%H%M).tsv"; az site-recovery job list -g "$RG_NAME" --vault-name "$VAULT_NAME" --query "[].{name:name,status:properties.status,task:properties.scenarioName,start:properties.startTime,end:properties.endTime}" -o tsv > "$OUT" || true
echo "Jobs exported to $OUT"
ok "Central reporting sample complete"
