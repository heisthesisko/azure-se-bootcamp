#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Enable blob versioning and change feed (auditable history)."
az storage account blob-service-properties update --account-name "$sa"   --enable-versioning true --enable-change-feed true -o none

echo "Create a blob inventory policy (daily)."
cat > /tmp/inventory.json <<'JSON'
{
  "enabled": true,
  "destination": "$inventory",
  "rules": [
    {
      "name": "daily-inventory",
      "enabled": true,
      "destination": "$inventory",
      "definition": {
        "filters": { "blobTypes": [ "blockBlob" ] },
        "format": "Parquet",
        "schedule": "Daily",
        "objectType": "Blob",
        "include": [ "Name", "Creation-Time", "Last-Modified", "Content-Length", "ETag", "AccessTier" ]
      }
    }
  ]
}
JSON
az storage account blob-inventory-policy create -g "$RG_NAME" -n "$sa" --policy "@/tmp/inventory.json" -o none || true
echo "Versioning, change feed, and inventory configured."
