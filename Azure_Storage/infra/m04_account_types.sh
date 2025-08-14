#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa_std=$(sa_name)
sa_prem=$(sa_name)

echo "Creating Standard GPv2 account: $sa_std"
create_storage_account "$sa_std" "Standard_LRS" false

echo "Creating Premium BlockBlobStorage account: $sa_prem"
az storage account create -g "$RG_NAME" -n "$sa_prem" -l "$LOCATION"   --sku Premium_LRS --kind BlockBlobStorage --https-only true --min-tls-version TLS1_2 -o none

echo "Accounts created. Use az storage blob upload-batch to test throughput differences."
