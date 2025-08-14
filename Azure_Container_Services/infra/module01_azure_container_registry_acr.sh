#!/usr/bin/env bash
set -euo pipefail
source config/.env
az group create -n "$RESOURCE_GROUP" -l "$LOCATION"
az acr create -g "$RESOURCE_GROUP" -n "$ACR_NAME" --sku Premium --public-network-enabled false
