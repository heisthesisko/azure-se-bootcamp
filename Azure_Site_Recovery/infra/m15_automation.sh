#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

AUTO_NAME="asrhc-auto"; RUNBOOK="Start-ASR-PlannedFailover"
az automation account create -g "$RG_NAME" -n "$AUTO_NAME" -l "$LOC_SECONDARY" >/dev/null || true
RB="/tmp/${RUNBOOK}.ps1"; echo 'param([string]$VaultName,[string]$ResourceGroupName,[string]$FabricName,[string]$ProtectionContainerName,[string]$ProtectedItemName); Write-Output \"Planned Failover Triggered\"' > "$RB"
az automation runbook create -g "$RG_NAME" -n "$RUNBOOK" --automation-account-name "$AUTO_NAME" --type PowerShell --location "$LOC_SECONDARY" >/dev/null || true
az automation runbook replace-content -g "$RG_NAME" --automation-account-name "$AUTO_NAME" -n "$RUNBOOK" --content @"$RB" >/dev/null || true
az automation runbook publish -g "$RG_NAME" --automation-account-name "$AUTO_NAME" -n "$RUNBOOK" >/dev/null || true
ok "Automation runbook created (skeleton)"
