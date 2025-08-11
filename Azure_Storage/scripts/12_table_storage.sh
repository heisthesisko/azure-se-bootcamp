
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ -f "$ROOT_DIR/config/env.sh" ]]; then
  source "$ROOT_DIR/config/env.sh"
else
  echo "Missing config/env.sh. Copy config/env.sample to config/env.sh and edit values." >&2
  exit 1
fi

az account set --subscription "${SUBSCRIPTION_ID}"
echo "Using subscription: $(az account show --query name -o tsv)"

ACCOUNT_KEY=$(az storage account keys list -g "$RG" -n "$SA_NAME" --query "[0].value" -o tsv)
az storage entity insert --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -t "$TABLE_NAME" --entity PartitionKey=lab RowKey=1 metric=latency value=15 -o table
az storage entity insert --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -t "$TABLE_NAME" --entity PartitionKey=lab RowKey=2 metric=throughput value=200 -o table
az storage entity query --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -t "$TABLE_NAME" --filter "PartitionKey eq 'lab'" -o jsonc
