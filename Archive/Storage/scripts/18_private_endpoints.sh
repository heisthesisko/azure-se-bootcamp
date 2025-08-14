
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

for zone in "privatelink.blob.core.windows.net" "privatelink.dfs.core.windows.net" "privatelink.file.core.windows.net"; do
  az network private-dns zone create -g "$DNS_RG" -n "$zone" -o table || true
  az network private-dns link vnet create -g "$DNS_RG" -n "link-$VNET_NAME-$zone" -z "$zone" -v "$VNET_NAME" -e true -o table || true
done

for group in "blob" "dfs" "file"; do
  az network private-endpoint create -g "$RG" -n "pe-$group" --vnet-name "$VNET_NAME" --subnet "$PE_SUBNET_NAME"     --private-connection-resource-id $(az storage account show -g "$RG" -n "$SA_NAME" --query id -o tsv)     --group-ids "$group" --connection-name "conn-$group" -o table
  az network private-endpoint dns-zone-group create -g "$RG" -n "zone-$group" --endpoint-name "pe-$group"     --private-dns-zone "privatelink.${group}.core.windows.net" --zone-name "zone-$group" -o table || true
done
