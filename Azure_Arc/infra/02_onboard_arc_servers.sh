#!/usr/bin/env bash
set -euo pipefail


source config/.env

echo "Ensure azcmagent will be installed on target machines manually or via config mgmt."
echo "This script prints the non-interactive connect command you can run on each server:"
cat <<EOF
sudo azcmagent connect \
  --resource-group "$ARC_RG_SERVERS" \
  --tenant-id "$ARC_SP_TENANT_ID" \
  --location "$AZ_LOCATION" \
  --subscription-id "$AZ_SUBSCRIPTION_ID" \
  --resource-name "OnPrem-\$(hostname)" \
  --service-principal-id "$ARC_SP_CLIENT_ID" \
  --service-principal-secret "$ARC_SP_CLIENT_SECRET"
EOF
