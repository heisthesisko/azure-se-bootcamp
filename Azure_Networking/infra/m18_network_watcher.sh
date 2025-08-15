#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ ! -f "$ROOT_DIR/config/.env" ]]; then
  echo "config/.env not found. Copy config/env.sample -> config/.env and set values."
  exit 1
fi
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
echo "[M18] Enable NSG flow logs and Connection Monitor"
az extension add --name network-watcher || true
# Create storage for flow logs
az storage account create -g "$RG_NAME" -n "${PREFIX}flow$RANDOM" --sku Standard_LRS
SA_FLOW=$(az storage account list -g "$RG_NAME" --query "[?contains(name,'flow')].name" -o tsv | head -n1)
NSG_NAME="${PREFIX}-web-nsg"
az network watcher flow-log configure -g "$RG_NAME" --nsg "$NSG_NAME" --enabled true       --storage-account "$SA_FLOW" --retention 7 --traffic-analytics true --workspace "$LA_WORKSPACE"
# Connection monitor from VM1 to storage account endpoint (port 443)
SRC=$(az vm list-ip-addresses -g "$RG_NAME" -n "${PREFIX}-vm-web-1" --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
DST="${SA_NAME}.blob.core.windows.net"
az network watcher connection-monitor create -g "$RG_NAME" -n "${PREFIX}-cm1" --endpoint-source-address "$SRC" --endpoint-dest-address "$DST" --test-configs "Tcp" --protocol Tcp --port 443
echo "Network Watcher diagnostics configured."
