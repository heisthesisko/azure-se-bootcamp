#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network vnet subnet create -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_HUB_VNET_NAME}" -n GatewaySubnet --address-prefixes 10.0.100.64/27
az network public-ip create -g "${WORKSHOP_RG}" -n vpngw-pip --allocation-method Dynamic
az network vnet-gateway create -g "${WORKSHOP_RG}" -n azureVpnGateway --vnet "${WORKSHOP_HUB_VNET_NAME}"   --public-ip-address vpngw-pip --sku VpnGw2 --gateway-type Vpn --vpn-type RouteBased --no-wait
echo "Gateway creation started (20-30 min). After ready, create LNG and connection as described in the module guide."
