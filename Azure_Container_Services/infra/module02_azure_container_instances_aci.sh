#!/usr/bin/env bash
set -euo pipefail
source config/.env
az container create -g "$RESOURCE_GROUP" -n hc-aci-demo --image mcr.microsoft.com/azuredocs/aci-helloworld --cpu 1 --memory 1 --ports 80
