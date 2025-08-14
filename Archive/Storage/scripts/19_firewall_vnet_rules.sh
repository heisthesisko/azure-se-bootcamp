
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

az storage account update -g "$RG" -n "$SA_NAME" --default-action Deny --bypass AzureServices -o table
az storage account network-rule add -g "$RG" --account-name "$SA_NAME" --vnet-name "$VNET_NAME" --subnet "$SUBNET_NAME" -o table
MYIP=$(curl -s ifconfig.me || echo "0.0.0.0")
az storage account network-rule add -g "$RG" --account-name "$SA_NAME" --ip-address "$MYIP" -o table || true
az storage account network-rule list -g "$RG" --account-name "$SA_NAME" -o jsonc
