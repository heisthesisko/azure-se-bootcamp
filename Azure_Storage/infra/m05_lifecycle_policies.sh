#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage container create -n "phi" --account-name "$sa" --account-key "$key" -o none

echo "Applying lifecycle policy: move to cool after 30 days, archive after 180 days, delete after 365..."
policy=$(cat <<'JSON'
{
  "rules": [
    {
      "enabled": true,
      "name": "tiering-policy",
      "type": "Lifecycle",
      "definition": {
        "filters": { "blobTypes": [ "blockBlob" ], "prefixMatch": [ "phi/" ] },
        "actions": {
          "baseBlob": {
            "tierToCool": { "daysAfterModificationGreaterThan": 30 },
            "tierToArchive": { "daysAfterModificationGreaterThan": 180 },
            "delete": { "daysAfterModificationGreaterThan": 365 }
          }
        }
      }
    }
  ]
}
JSON
)
echo "$policy" > /tmp/policy.json
az storage account management-policy create -g "$RG_NAME" -n "$sa" --policy "@/tmp/policy.json" -o none
echo "Lifecycle policy applied on $sa."
