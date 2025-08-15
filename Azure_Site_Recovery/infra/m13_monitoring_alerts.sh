#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

ACTION_NAME="asrhc-actiongrp"; RCPT="${ADMIN_USERNAME}@example.org"
az monitor action-group create -g "$RG_NAME" -n "$ACTION_NAME" --short-name ASRHC --action email asrhc "$RCPT" >/dev/null || true
az monitor activity-log alert create -n "asr-jobs-failed" -g "$RG_NAME" --scopes "/subscriptions/$SUBSCRIPTION_ID" --condition "category=Administrative and (operationNameValue=Microsoft.RecoveryServices/locations/replicationJobs/write and status=Failed)" --action-group "$ACTION_NAME" >/dev/null || true
ok "Alert created"
