#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network dns zone create -g "${WORKSHOP_RG}" -n "contoso.example"
LBPIP=$(az network public-ip show -g "${WORKSHOP_RG}" -n webLB-pip --query ipAddress -o tsv || echo "1.1.1.1")
az network dns record-set a add-record -g "${WORKSHOP_RG}" -z "contoso.example" -n "www" -a "$LBPIP"
az network private-dns zone create -g "${WORKSHOP_RG}" -n "corp.internal"
az network private-dns link vnet create -g "${WORKSHOP_RG}" -z "corp.internal" -n LinkSpoke --virtual-network "${WORKSHOP_VNET_NAME}" -e true
az network private-dns record-set a add-record -g "${WORKSHOP_RG}" -z "corp.internal" -n "db" -a "10.0.1.5"
echo "Module 15 complete."
