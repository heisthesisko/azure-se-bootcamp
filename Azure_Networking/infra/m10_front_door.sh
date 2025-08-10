#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
PROFILE="fd-profile"
ENDPOINT="fd-endpoint-$RANDOM"
ORIG_GROUP="fd-orig-group"
ORIGIN1="fd-origin-appgw"
az afd profile create -g "${WORKSHOP_RG}" -n "${PROFILE}" --sku Standard_AzureFrontDoor
az afd endpoint create -g "${WORKSHOP_RG}" --profile-name "${PROFILE}" -n "${ENDPOINT}" -l Global
az afd origin-group create -g "${WORKSHOP_RG}" --profile-name "${PROFILE}" -n "${ORIG_GROUP}" --probe-request-type GET --probe-protocol Http --probe-interval-in-seconds 30 --sample-size 4 --successful-samples-required 3
APPGW_IP=$(az network public-ip show -g "${WORKSHOP_RG}" -n appgw-pip --query ipAddress -o tsv)
az afd origin create -g "${WORKSHOP_RG}" --profile-name "${PROFILE}" --origin-group-name "${ORIG_GROUP}" -n "${ORIGIN1}"   --host-name "${APPGW_IP}" --http-port 80 --https-port 443 --origin-host-header "${APPGW_IP}" --priority 1 --weight 100
az afd route create -g "${WORKSHOP_RG}" --profile-name "${PROFILE}" --endpoint-name "${ENDPOINT}" -n "route-all"   --https-redirect Disabled --origin-group "${ORIG_GROUP}" --supported-protocols Http Https --link-to-default-domain Enabled --forwarding-protocol HttpOnly --patterns-to-match "/*"
echo "Module 10 complete."
az afd endpoint show -g "${WORKSHOP_RG}" --profile-name "${PROFILE}" -n "${ENDPOINT}" --query hostName -o tsv
