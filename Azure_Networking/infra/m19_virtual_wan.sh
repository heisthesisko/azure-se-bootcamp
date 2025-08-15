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
echo "[M19] Virtual WAN + Virtual Hub + VPN Site (represent on-prem)"
az network vwan create -g "$RG_NAME" -n "${PREFIX}-vwan"
az network vhub create -g "$RG_NAME" -n "${PREFIX}-vhub" --address-prefix "10.100.0.0/23" --vwan "${PREFIX}-vwan"
az network vpn-site create -g "$RG_NAME" -n "${PREFIX}-vpns" --ip-address "$ONSITE_PUBLIC_IP" --address-space "$ONSITE_ADDRESS_SPACE"
az network vpn-gateway create -g "$RG_NAME" -n "${PREFIX}-vhub-vpngw" --vhub-name "${PREFIX}-vhub" --scale-unit 1
az network vpn-gateway connection create -g "$RG_NAME" -n "${PREFIX}-vhub-conn1" --gateway-name "${PREFIX}-vhub-vpngw"       --remote-vpn-site "${PREFIX}-vpns" --shared-key "$SHARED_KEY"
echo "Virtual WAN hub and connection created."
