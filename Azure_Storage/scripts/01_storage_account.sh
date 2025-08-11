
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

az network vnet create -g "$RG" -n "$VNET_NAME" --address-prefixes "$VNET_CIDR"   --subnet-name "$SUBNET_NAME" --subnet-prefixes "$SUBNET_CIDR" -o table

az network vnet subnet create -g "$RG" --vnet-name "$VNET_NAME" -n "$PE_SUBNET_NAME"   --address-prefixes "$PE_SUBNET_CIDR" --delegations Microsoft.Network/privatelinkService -o table || true

az storage account create -g "$RG" -n "$SA_NAME" -l "$LOCATION"   --sku Standard_LRS --kind StorageV2 --enable-hierarchical-namespace true   --https-only true --min-tls-version TLS1_2 --tags env="$TAG_ENV" workshop="azure-storage-networking" -o table

az storage account blob-service-properties update --account-name "$SA_NAME"   --enable-versioning true --enable-delete-retention true --delete-retention-days 7 -o table

ACCOUNT_KEY=$(az storage account keys list -g "$RG" -n "$SA_NAME" --query "[0].value" -o tsv)

az storage container create -n "$CONTAINER" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" --auth-mode key -o table
az storage queue create -n "$QUEUE_NAME" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
az storage table create -n "$TABLE_NAME" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table
az storage fs create -n "$DATALAKE_FS" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table

echo "Module 01 complete."
