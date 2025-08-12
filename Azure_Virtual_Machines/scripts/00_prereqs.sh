#!/usr/bin/env bash
set -euo pipefail
# Load env
if [ -f .env ]; then source .env; elif [ -f config/.env ]; then source config/.env; elif [ -f config/env.sample ]; then source config/env.sample; fi

: "${LOCATION:=eastus}"
: "${PREFIX:=hlthwrk}"
: "${AZ_SUBSCRIPTION_ID:=}"

if [ -n "${AZ_SUBSCRIPTION_ID}" ]; then
  az account set --subscription "$AZ_SUBSCRIPTION_ID"
fi

RG="${PREFIX}-rg"
VNET="${PREFIX}-vnet"
SUBNET_WEB="${PREFIX}-snet-web"
SUBNET_AI="${PREFIX}-snet-ai"
SUBNET_ANF="${PREFIX}-snet-anf"

echo "==> Creating resource group"
az group create -n "$RG" -l "$LOCATION"

echo "==> Creating VNet and subnets"
az network vnet create -g "$RG" -n "$VNET" --address-prefixes 10.10.0.0/16   --subnet-name "$SUBNET_WEB" --subnet-prefixes 10.10.1.0/24

az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET_AI" --address-prefixes 10.10.2.0/24

# ANF subnet (delegated)
az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET_ANF" --address-prefixes 10.10.3.0/24   --delegations "Microsoft.NetApp/volumes" >/dev/null 2>&1 || true

echo "Pre-reqs complete."
