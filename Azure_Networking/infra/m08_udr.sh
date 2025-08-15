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
echo "[M08] Create a route table and add a default route (to be used with Azure Firewall later)"
RT_NAME="${PREFIX}-rt-web"
az network route-table create -g "$RG_NAME" -n "$RT_NAME"
# Default route to Firewall IP (placeholder 10.10.254.4 - will be updated after Firewall creation)
az network route-table route create -g "$RG_NAME" --route-table-name "$RT_NAME" -n "DefaultToFirewall"       --address-prefix "0.0.0.0/0" --next-hop-type VirtualAppliance --next-hop-ip-address "10.10.254.4"
az network vnet subnet update -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "web" --route-table "$RT_NAME"
echo "UDR created and associated to 'web' subnet."
