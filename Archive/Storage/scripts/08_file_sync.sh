
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

az vm create -g "$RG" -n "fsync-win" --image MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest --admin-username "$ADMIN_USER" --admin-password "P@ssw0rd12345!" --size "Standard_D2s_v5" -o table
az storage sync-service create -g "$RG" -n "storws-syncsvc" -l "$LOCATION" -o table
az storage sync-group create -g "$RG" --storage-sync-service "storws-syncsvc" -n "syncgroup1" -o table
az storage sync-cloud-endpoint create -g "$RG" --storage-sync-service "storws-syncsvc" --sync-group-name "syncgroup1" -n "cloud1" --storage-account "$SA_NAME" --azure-file-share-name "$FILE_SHARE" -o table || true
