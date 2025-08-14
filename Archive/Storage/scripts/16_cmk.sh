
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

az keyvault create -g "$RG" -n "$KV_NAME" -l "$LOCATION" --enable-purge-protection true -o table
SP=$(az ad sp list --display-name "Microsoft.Storage" --query "[0].appId" -o tsv || echo "")
if [[ -n "$SP" ]]; then
  az keyvault set-policy -n "$KV_NAME" --spn "$SP" --key-permissions get unwrapKey wrapKey -o table
fi
KEY_NAME="storws-cmk"
az keyvault key create --vault-name "$KV_NAME" -n "$KEY_NAME" --protection software -o jsonc
KV_URI=$(az keyvault show -n "$KV_NAME" --query "properties.vaultUri" -o tsv)
az storage account update -g "$RG" -n "$SA_NAME" --encryption-key-source Microsoft.Keyvault --encryption-key-vault "$KV_URI" --encryption-key-name "$KEY_NAME" -o table
