#!/usr/bin/env bash
set -euo pipefail
source config/.env
# Creates Azure VPN gateway for private ARO (sample/placeholder values)
VNET_GW_SUBNET="GatewaySubnet"
az network vnet subnet create -g "$RESOURCEGROUP" --vnet-name "$VNET_NAME" -n $VNET_GW_SUBNET --address-prefixes 10.0.4.0/27
az network public-ip create -g "$RESOURCEGROUP" -n aro-vpn-pip --sku Standard
az network virtual-network-gateway create -g "$RESOURCEGROUP" -n aro-vpngw --public-ip-addresses aro-vpn-pip   --vnet "$VNET_NAME" --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --no-wait
echo "[OK] Azure VPN Gateway creation started."
