#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
policy='{"rules":[{"enabled":true,"name":"tiering","type":"Lifecycle","definition":{"filters":{"blobTypes":["blockBlob"],"prefixMatch":["phi/"]},"actions":{"baseBlob":{"tierToCool":{"daysAfterModificationGreaterThan":30},"tierToArchive":{"daysAfterModificationGreaterThan":180},"delete":{"daysAfterModificationGreaterThan":365}}}}}]}'
echo "$policy" > /tmp/policy.json
az storage account management-policy create -g "$RG_NAME" -n "$sa" --policy "@/tmp/policy.json" -o none
echo "Lifecycle policy applied on $sa"
