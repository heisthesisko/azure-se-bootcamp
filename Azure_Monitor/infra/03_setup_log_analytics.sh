#!/usr/bin/env bash
set -euo pipefail
source config/.env
az monitor log-analytics workspace create -g "$RG_NAME" -n "$LAW_NAME" -l "$LOCATION"
LAW_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query id -o tsv)
LAW_CUST=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query customerId -o tsv)
LAW_KEY=$(az monitor log-analytics workspace get-shared-keys -g "$RG_NAME" -n "$LAW_NAME" --query primarySharedKey -o tsv)
az vm extension set -g "$RG_NAME" --vm-name "$VM_NAME" --publisher Microsoft.EnterpriseCloud.Monitoring   --name OmsAgentForLinux --version 1.0   --protected-settings "{"workspaceKey": "$LAW_KEY"}" --settings "{"workspaceId": "$LAW_CUST"}"
echo "Workspace and VM agent configured."
