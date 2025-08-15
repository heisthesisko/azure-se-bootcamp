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
echo "[M15] Azure Front Door (Standard) in front of App Gateway"
az extension add --name front-door || true
az afd profile create -g "$RG_NAME" -n "$AFD_PROFILE" --sku Standard_AzureFrontDoor
ENDPOINT="${PREFIX}-afd-endpoint"
az afd endpoint create -g "$RG_NAME" --profile-name "$AFD_PROFILE" -n "$ENDPOINT"
ORIG_GROUP="${PREFIX}-orig-group"
az afd origin-group create -g "$RG_NAME" --profile-name "$AFD_PROFILE" -n "$ORIG_GROUP" --probe-request-type GET --probe-protocol Http --probe-interval-in-seconds 60
APPGW_FQDN="$APPGW_DNS_LABEL.$LOCATION.cloudapp.azure.com"
az afd origin create -g "$RG_NAME" --profile-name "$AFD_PROFILE" --origin-group-name "$ORIG_GROUP" -n "appgw-origin"       --host-name "$APPGW_FQDN" --http-port 80 --https-port 443 --origin-host-header "$APPGW_FQDN"
az afd route create -g "$RG_NAME" --profile-name "$AFD_PROFILE" --endpoint-name "$ENDPOINT" -n "${PREFIX}-route"       --origin-group "$ORIG_GROUP" --supported-protocols Http Https --link-to-default-domain Enabled --https-redirect Enabled
echo "Front Door endpoint ready. Test with: https://${{ENDPOINT}}.azurefd.net/"
