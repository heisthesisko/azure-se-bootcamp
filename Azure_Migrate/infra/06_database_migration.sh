#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"

# Deploy Azure Database for PostgreSQL Flexible Server (for demo)
az postgres flexible-server create -g "$RG_NAME" -n "$POSTGRES_FLEX_SERVER" -l "$AZ_LOCATION"   --admin-user "$POSTGRES_ADMIN_USER" --admin-password "$POSTGRES_ADMIN_PASS"   --tier Burstable --sku-name Standard_B1ms --storage-size 32 --version 14   --yes

# Create DB and firewall to VNet (simplified; consider private DNS)
az postgres flexible-server db create -g "$RG_NAME" -s "$POSTGRES_FLEX_SERVER" -d "$POSTGRES_DB"
echo "PostgreSQL Flexible Server created. Use DMS (portal) for online migration."
