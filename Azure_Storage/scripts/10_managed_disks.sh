
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

az disk create -g "$RG" -n "disk-std-hdd" --size-gb 8 --sku Standard_LRS -o table
az disk create -g "$RG" -n "disk-prem-ssd" --size-gb 8 --sku Premium_LRS -o table
az disk create -g "$RG" -n "disk-ultra-ssd" --size-gb 8 --sku UltraSSD_LRS --zone 1 || true
az disk list -g "$RG" -o table
