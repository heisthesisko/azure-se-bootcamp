#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../config/env.sh"

# Availability set
az vm availability-set create -g "$RG" -n "$AS_NAME" --platform-fault-domain-count 2 --platform-update-domain-count 2

# Primary
az vm create -g "$RG" -n "$PG_PRIMARY" \
  --image "$PG_IMAGE" --size "$PG_SKU" \
  --availability-set "$AS_NAME" \
  --subnet "$SUBNET_DB_NAME" --vnet-name "$VNET_NAME" \
  --admin-username "$ADMIN_USER" --generate-ssh-keys

# Replica
az vm create -g "$RG" -n "$PG_REPLICA" \
  --image "$PG_IMAGE" --size "$PG_SKU" \
  --availability-set "$AS_NAME" \
  --subnet "$SUBNET_DB_NAME" --vnet-name "$VNET_NAME" \
  --admin-username "$ADMIN_USER" --generate-ssh-keys

echo "Next steps: use VS Code Remote SSH to both PG VMs and run scripts/db-setup.sh (see README)."
