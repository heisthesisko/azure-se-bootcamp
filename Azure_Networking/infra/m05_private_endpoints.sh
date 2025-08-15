#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ ! -f "$ROOT_DIR/config/.env" ]]; then
  echo "config/.env not found. Copy config/env.sample -> config/.env and set values."
  exit 1
fi
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
echo "[M05] Deploy Storage + Postgres Flexible Server with Private Endpoints"
az storage account create -g "$RG_NAME" -n "$SA_NAME" --sku Standard_LRS --kind StorageV2       --min-tls-version TLS1_2
# Private DNS zones
az network private-dns zone create -g "$RG_NAME" -n "privatelink.blob.core.windows.net"
az network private-dns zone create -g "$RG_NAME" -n "privatelink.postgres.database.azure.com"
VNET_ID=$(az network vnet show -g "$RG_NAME" -n "$VNET_NAME" --query id -o tsv)
az network private-dns link vnet create -g "$RG_NAME" -n "${PREFIX}-blobdnslink"       --zone-name "privatelink.blob.core.windows.net" --virtual-network "$VNET_ID" --registration-enabled false
az network private-dns link vnet create -g "$RG_NAME" -n "${PREFIX}-pgdnslink"       --zone-name "privatelink.postgres.database.azure.com" --virtual-network "$VNET_ID" --registration-enabled false
# Storage Private Endpoint
SUBNET_WEB_ID=$(az network vnet subnet show -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "web" --query id -o tsv)
az network private-endpoint create -g "$RG_NAME" -n "${PREFIX}-pe-blob" --subnet "$SUBNET_WEB_ID"       --private-connection-resource-id "$(az storage account show -g "$RG_NAME" -n "$SA_NAME" --query id -o tsv)"       --group-id "blob"
# DNS A record for blob PE
PE_NIC_ID=$(az resource list -g "$RG_NAME" --resource-type "Microsoft.Network/privateEndpoints" --query "[?name=='${PREFIX}-pe-blob'].id" -o tsv)
PE_IP=$(az network nic show --ids "$PE_NIC_ID/networkInterfaces/0" --query "ipConfigurations[0].privateIpAddress" -o tsv || echo "")
az network private-dns record-set a add-record -g "$RG_NAME" -z "privatelink.blob.core.windows.net" -n "$SA_NAME" -a "$PE_IP"
# Postgres Flexible Server
az postgres flexible-server create -g "$RG_NAME" -n "$PG_NAME" -l "$LOCATION"       --tier "$PG_TIER" --sku-name "$PG_SKU" --storage-size "$PG_STORAGE_SIZE_GB"       --version "$PG_VERSION" --admin-user "$PG_ADMIN" --admin-password "$PG_PASSWORD"       --vnet "$VNET_NAME" --subnet "db" --yes
# PG Private Endpoint
PG_ID=$(az postgres flexible-server show -g "$RG_NAME" -n "$PG_NAME" --query id -o tsv)
az network private-endpoint create -g "$RG_NAME" -n "${PREFIX}-pe-pg" --subnet "$SUBNET_WEB_ID"       --private-connection-resource-id "$PG_ID" --group-id "postgresqlServer"
# Private DNS record for PG
PG_FQDN=$(az postgres flexible-server show -g "$RG_NAME" -n "$PG_NAME" --query fqdn -o tsv)
PG_HOST="${PG_FQDN%%.*}"
PE_PG_NIC_ID=$(az resource list -g "$RG_NAME" --resource-type "Microsoft.Network/privateEndpoints" --query "[?name=='${PREFIX}-pe-pg'].id" -o tsv)
PE_PG_IP=$(az network nic show --ids "$PE_PG_NIC_ID/networkInterfaces/0" --query "ipConfigurations[0].privateIpAddress" -o tsv || echo "")
az network private-dns record-set a add-record -g "$RG_NAME" -z "privatelink.postgres.database.azure.com" -n "$PG_HOST" -a "$PE_PG_IP"
echo "Private Endpoints configured for Storage and Postgres."
