#!/usr/bin/env bash
set -euo pipefail
source config/.env

az account set --subscription "$AZ_SUBSCRIPTION_ID"

az network public-ip create -g "$RG_NAME" -n "$PUBLIC_IP_NAME" --sku Standard

az network vnet-gateway create -g "$RG_NAME" -n "$VPN_GATEWAY_NAME" --public-ip-address "$PUBLIC_IP_NAME"   --vnet "$VNET_NAME" --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --no-wait

# Local Network Gateway for on-prem VyOS
az network local-gateway create -g "$RG_NAME" -n "$LOCAL_NETWORK_GATEWAY_NAME"   --gateway-ip-address "$ONPREM_PUBLIC_IP" --local-address-prefixes "$ONPREM_ADDRESS_PREFIXES"

# Connection (shared key)
az network vpn-connection create -g "$RG_NAME" -n onprem-connection --vnet-gateway1 "$VPN_GATEWAY_NAME"   --local-gateway2 "$LOCAL_NETWORK_GATEWAY_NAME" --shared-key "$SHARED_KEY"

echo "VPN Gateway deployment initiated and S2S connection created."
