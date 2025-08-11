
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

az storage account update -g "$RG" -n "$SA_NAME" --sku Standard_GRS -o table
az storage account update -g "$RG" -n "$SA_NAME" --sku Standard_RAGRS -o table || true
az storage account show -g "$RG" -n "$SA_NAME" --query "{sku:sku, secondaryLocation:secondaryLocation}" -o jsonc
