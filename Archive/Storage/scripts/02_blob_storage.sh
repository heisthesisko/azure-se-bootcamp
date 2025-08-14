
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
echo "sample-one" > /tmp/sample1.txt
echo "sample-two" > /tmp/sample2.txt
az storage blob upload -f /tmp/sample1.txt -c "$CONTAINER" -n sample1.txt --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
az storage blob upload -f /tmp/sample2.txt -c "$CONTAINER" -n sample2.txt --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
az storage blob list -c "$CONTAINER" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
