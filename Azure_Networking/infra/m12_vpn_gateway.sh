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
echo "[M12] VPN Gateway (S2S)"
az network public-ip create -g "$RG_NAME" -n "${PREFIX}-pip-vpn" --sku Standard
az network vnet-gateway create -g "$RG_NAME" -n "${PREFIX}-vpngw" --public-ip-addresses "${PREFIX}-pip-vpn"       --vnet "$VNET_NAME" --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --asn 65010
# Local network gateway for on-prem
az network local-gateway create -g "$RG_NAME" -n "${PREFIX}-lng" --gateway-ip-address "$ONSITE_PUBLIC_IP" --local-address-prefixes "$ONSITE_ADDRESS_SPACE"
# Connection (shared key)
az network vpn-connection create -g "$RG_NAME" -n "${PREFIX}-s2s" --vnet-gateway1 "${PREFIX}-vpngw"       --shared-key "$SHARED_KEY" --local-gateway2 "${PREFIX}-lng"
echo "VPN Gateway and S2S connection created. Configure VyOS with scripts/vyos_s2s_config.txt"
