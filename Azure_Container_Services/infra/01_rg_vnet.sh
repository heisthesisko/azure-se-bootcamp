#!/usr/bin/env bash
set -euo pipefail
source config/.env
az group create -n "$RESOURCE_GROUP" -l "$LOCATION"
az network vnet create -g "$RESOURCE_GROUP" -n "$VNET_NAME" --address-prefixes "$VNET_CIDR"   --subnet-name "$SUBNET_AKS_NAME" --subnet-prefixes "$SUBNET_AKS_CIDR"
az network vnet subnet create -g "$RESOURCE_GROUP" --vnet-name "$VNET_NAME"   -n "$SUBNET_INGRESS_NAME" --address-prefixes "$SUBNET_INGRESS_CIDR"
