#!/usr/bin/env bash
set -euo pipefail

RG="${1:-ClinDataIntegrationRG}"
TENANT_ID="${2:-<TENANT_ID>}"
SUB_ID="${3:-<SUB_ID>}"
REGION="${4:-eastus}"

curl -sSL https://aka.ms/azcmagent -o Install_AzureArc.sh
sudo bash Install_AzureArc.sh

sudo azcmagent connect \
  --resource-group "$RG" \
  --tenant-id "$TENANT_ID" \
  --subscription-id "$SUB_ID" \
  --location "$REGION"

echo "Arc onboarding complete. Verify status: sudo azcmagent show"
