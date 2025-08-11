
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
az storage fs directory create -n "raw" -f "$DATALAKE_FS" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
az storage fs directory create -n "raw/images" -f "$DATALAKE_FS" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
az storage fs access set --acl "user::rwx,group::r-x,other::---" -p "raw" -f "$DATALAKE_FS" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
echo "datalake-sample" > /tmp/dl.txt
az storage fs file upload -s /tmp/dl.txt -p "raw/images/dl.txt" -f "$DATALAKE_FS" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
