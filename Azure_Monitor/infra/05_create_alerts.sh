#!/usr/bin/env bash
set -euo pipefail
source config/.env
VM_ID=$(az vm show -g "$RG_NAME" -n "$VM_NAME" --query id -o tsv)
AG_ID=$(az monitor action-group create -g "$RG_NAME" -n "$ACTION_GROUP" --action email Notify "$CONTACT_EMAIL" --query id -o tsv)
az monitor metrics alert create -g "$RG_NAME" -n HighCpuAlert --scopes "$VM_ID"   --condition "avg Percentage CPU > 80" --window-size 5m --evaluation-frequency 1m   --severity 2 --action-groups "$AG_ID" --description "CPU > 80% for 5m"
echo "Alert and Action Group configured."
