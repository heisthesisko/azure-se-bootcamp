#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network express-route circuit create -g "${WORKSHOP_RG}" -n MyExpressRoute --bandwidth 1000 --peering-location "Silicon Valley" --sku Premium_MeteredData
echo "Service Key:"
az network express-route circuit show -g "${WORKSHOP_RG}" -n MyExpressRoute --query serviceKey -o tsv
echo "Provide Service Key to your provider to complete provisioning."
