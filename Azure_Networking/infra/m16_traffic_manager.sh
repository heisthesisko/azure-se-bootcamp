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
echo "[M16] Traffic Manager (weighted) between Front Door and App Gateway direct"
AFD_FQDN="${PREFIX}-afd-endpoint.azurefd.net"
APPGW_FQDN="$APPGW_DNS_LABEL.$LOCATION.cloudapp.azure.com"
az network traffic-manager profile create -g "$RG_NAME" -n "$TM_PROFILE"       --routing-method Weighted --unique-dns-name "${PREFIX}-tm" --ttl 30 --protocol HTTP --port 80 --path /
az network traffic-manager endpoint create -g "$RG_NAME" --profile-name "$TM_PROFILE" -n "afd" --type externalEndpoints --target "$AFD_FQDN" --weight 100
az network traffic-manager endpoint create -g "$RG_NAME" --profile-name "$TM_PROFILE" -n "appgw" --type externalEndpoints --target "$APPGW_FQDN" --weight 50
echo "Traffic Manager created. Resolve DNS name shown in output to test distribution."
