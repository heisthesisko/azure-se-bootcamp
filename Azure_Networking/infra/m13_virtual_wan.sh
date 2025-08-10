#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network vwan create -g "${WORKSHOP_RG}" -n myVWAN --branch-to-branch-traffic true --location "${WORKSHOP_LOCATION}"
az network vhub create -g "${WORKSHOP_RG}" -n myVHub --vwan-name myVWAN --address-prefix 10.1.0.0/24 --sku Standard --location "${WORKSHOP_LOCATION}"
az network vhub connection create -g "${WORKSHOP_RG}" -n SpokeConn --vhub-name myVHub --remote-vnet "${WORKSHOP_VNET_NAME}" --internet-security false
echo "Module 13 complete."
