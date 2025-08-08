#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../config/env.sh"

az vm create -g "$RG" -n "$AI_VM_NAME" \
  --image "$AI_IMAGE" --size "$AI_SKU" \
  --subnet "$SUBNET_AI_NAME" --vnet-name "$VNET_NAME" \
  --admin-username "$ADMIN_USER" --generate-ssh-keys

echo "Next: VS Code Remote SSH to AI VM and run scripts/ai-setup.sh (see README)."
