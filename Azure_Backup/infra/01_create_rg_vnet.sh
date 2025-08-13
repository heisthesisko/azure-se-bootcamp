#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
az group create -n "$RG_NAME" -l "$AZ_LOCATION" --tags env=$TAG_ENV owner="$TAG_OWNER"
az network vnet create -g "$RG_NAME" -n "$VNET_NAME" --address-prefixes "$AZURE_VNET_CIDR"   --subnet-name "$SUBNET_NAME" --subnet-prefixes "10.10.1.0/24"
