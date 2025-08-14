#!/usr/bin/env bash
set -euo pipefail
source config/.env
az vm extension set -g "$RG_NAME" --vm-name "$VM_NAME" --publisher Microsoft.Azure.Monitoring.DependencyAgent --name DependencyAgentLinux
echo "VM Insights Dependency Agent deployed."
