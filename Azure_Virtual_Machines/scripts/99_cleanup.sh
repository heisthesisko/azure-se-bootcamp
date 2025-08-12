#!/usr/bin/env bash
set -euo pipefail
if [ -f .env ]; then source .env; elif [ -f config/.env ]; then source config/.env; elif [ -f config/env.sample ]; then source config/env.sample; fi

: "${PREFIX:=hlthwrk}"

RG="${PREFIX}-rg"
echo "==> Deleting resource group $RG"
az group delete -n "$RG" --yes --no-wait || true
