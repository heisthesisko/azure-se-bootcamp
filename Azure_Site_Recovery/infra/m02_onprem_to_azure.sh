#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

log "Create VPN gateway + local network gateway + S2S connection"
az network public-ip create -g "$RG_NAME" -n "${VPN_GW_NAME}-pip" --sku Standard --allocation-method Static --location "$LOC_PRIMARY" >/dev/null
az network vnet-gateway create -g "$RG_NAME" -n "$VPN_GW_NAME" --public-ip-address "${VPN_GW_NAME}-pip" --vnet "$VNET_NAME" --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --location "$LOC_PRIMARY" --no-wait
az network local-gateway create -g "$RG_NAME" -n "$VPN_LNG_NAME" --gateway-ip-address "$ONPREM_PUBLIC_IP" --local-address-prefixes "$ONPREM_ADDRESS_SPACE" --location "$LOC_PRIMARY" >/dev/null
az network vpn-connection create -g "$RG_NAME" -n "onprem-connection" --vnet-gateway1 "$VPN_GW_NAME" --local-gateway2 "$VPN_LNG_NAME" --shared-key "$SHARED_KEY" --enable-bgp false --location "$LOC_PRIMARY" >/dev/null
ok "Azure side hybrid connectivity requested. Configure VyOS per scripts/vyos_s2s_template.conf"
