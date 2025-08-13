#!/usr/bin/env bash
set -euo pipefail


source config/.env

echo "Create VNet and subnets"
az network vnet create -g "$AZ_RG" -n "$AZ_VNET_NAME" --address-prefixes "$AZ_VNET_CIDR" \
  --subnet-name "$AZ_SUBNET_NAME" --subnet-prefixes "$AZ_SUBNET_CIDR"

echo "Add GatewaySubnet"
az network vnet subnet create -g "$AZ_RG" --vnet-name "$AZ_VNET_NAME" -n GatewaySubnet --address-prefixes "$AZ_GW_SUBNET_CIDR" || true

echo "Create Public IP for VPN Gateway"
az network public-ip create -g "$AZ_RG" -n "$AZ_VPN_GW_NAME-pip" --sku Standard --allocation-method Static

echo "Create Virtual Network Gateway (may take 30-45 min)"
az network vnet-gateway create -g "$AZ_RG" -n "$AZ_VPN_GW_NAME" --public-ip-addresses "$AZ_VPN_GW_NAME-pip" \
  --vnet "$AZ_VNET_NAME" --asn 65010 --sku VpnGw1 --vpn-type RouteBased --gateway-type Vpn

echo "Create Local Network Gateway (on-prem definition)"
az network local-gateway create -g "$AZ_RG" -n "$AZ_LOCAL_GW_NAME" --gateway-ip-address "$ONPREM_PUBLIC_IP" --local-address-prefixes "$ONPREM_ADDRESS_SPACE"

echo "Create S2S Connection"
az network vpn-connection create -g "$AZ_RG" -n "onprem-connection" --vnet-gateway1 "$AZ_VPN_GW_NAME" \
  --local-gateway2 "$AZ_LOCAL_GW_NAME" --shared-key "$AZ_VPN_SHARED_KEY"
