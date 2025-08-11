
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

az network vnet subnet create -g "$RG" --vnet-name "$VNET_NAME" -n "anf-subnet" --address-prefixes "10.30.3.0/24" --delegations "Microsoft.Netapp/volumes" -o table || true
az netappfiles account create -g "$RG" -a "anf-acct1" -l "$LOCATION" -o table || true
az netappfiles pool create -g "$RG" -a "anf-acct1" -p "pool1" -l "$LOCATION" --size 4 --service-level Premium -o table || true
az netappfiles volume create -g "$RG" -a "anf-acct1" -p "pool1" -v "vol1" -l "$LOCATION" --service-level Premium --usage-threshold 100 --file-path "vol1" --vnet "$VNET_NAME" --subnet "anf-subnet" -o table || true
