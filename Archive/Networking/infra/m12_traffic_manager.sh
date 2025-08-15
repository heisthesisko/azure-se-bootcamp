#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network traffic-manager profile create -g "${WORKSHOP_RG}" -n tmProfile --routing-method Priority   --unique-dns-name "workshop-tm-$RANDOM" --ttl 10 --protocol HTTP --port 80 --path "/"
APPGW_IP=$(az network public-ip show -g "${WORKSHOP_RG}" -n appgw-pip --query ipAddress -o tsv)
az network traffic-manager endpoint create -g "${WORKSHOP_RG}" --profile-name tmProfile -n primaryEndpoint   --type externalEndpoints --priority 1 --target "${APPGW_IP}"
LBPIP=$(az network public-ip show -g "${WORKSHOP_RG}" -n webLB-pip --query ipAddress -o tsv)
az network traffic-manager endpoint create -g "${WORKSHOP_RG}" --profile-name tmProfile -n secondaryEndpoint   --type externalEndpoints --priority 2 --target "${LBPIP}"
echo "Module 12 complete."
az network traffic-manager profile show -g "${WORKSHOP_RG}" -n tmProfile --query dnsConfig.fqdn -o tsv
