#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../config/env.sh"

az group create -n "$RG" -l "$LOCATION"

az network vnet create -g "$RG" -n "$VNET_NAME" --address-prefixes "$VNET_CIDR"

az network vnet subnet create -g "$RG" --vnet-name "$VNET_NAME" -n "$SUBNET_WEB_NAME" --address-prefixes "$SUBNET_WEB_CIDR"
az network vnet subnet create -g "$RG" --vnet-name "$VNET_NAME" -n "$SUBNET_DB_NAME"  --address-prefixes "$SUBNET_DB_CIDR"
az network vnet subnet create -g "$RG" --vnet-name "$VNET_NAME" -n "$SUBNET_AI_NAME"  --address-prefixes "$SUBNET_AI_CIDR"

az network nsg create -g "$RG" -n "$NSG_WEB"
az network nsg create -g "$RG" -n "$NSG_DB"
az network nsg create -g "$RG" -n "$NSG_AI"

az network nsg rule create -g "$RG" --nsg-name "$NSG_WEB" -n AllowHTTP --priority 100 --destination-port-ranges 80 --protocol Tcp --access Allow --direction Inbound
az network nsg rule create -g "$RG" --nsg-name "$NSG_WEB" -n AllowSSH  --priority 110 --destination-port-ranges 22 --protocol Tcp --access Allow --direction Inbound

az network nsg rule create -g "$RG" --nsg-name "$NSG_DB" -n AllowPGFromWeb --priority 100 --source-address-prefixes "$SUBNET_WEB_CIDR" --destination-port-ranges 5432 --protocol Tcp --access Allow --direction Inbound
az network nsg rule create -g "$RG" --nsg-name "$NSG_DB" -n AllowSSH      --priority 110 --destination-port-ranges 22 --protocol Tcp --access Allow --direction Inbound

az network nsg rule create -g "$RG" --nsg-name "$NSG_AI" -n AllowAIFromWeb --priority 100 --source-address-prefixes "$SUBNET_WEB_CIDR" --destination-port-ranges "$AI_PORT" --protocol Tcp --access Allow --direction Inbound
az network nsg rule create -g "$RG" --nsg-name "$NSG_AI" -n AllowSSH       --priority 110 --destination-port-ranges 22 --protocol Tcp --access Allow --direction Inbound

az network vnet subnet update -g "$RG" --vnet-name "$VNET_NAME" -n "$SUBNET_WEB_NAME" --network-security-group "$NSG_WEB"
az network vnet subnet update -g "$RG" --vnet-name "$VNET_NAME" -n "$SUBNET_DB_NAME"  --network-security-group "$NSG_DB"
az network vnet subnet update -g "$RG" --vnet-name "$VNET_NAME" -n "$SUBNET_AI_NAME"  --network-security-group "$NSG_AI"
