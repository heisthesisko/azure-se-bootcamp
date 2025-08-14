#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# Example: list marketplace images (no purchase) and create a generalized image from existing VM
az vm image list --publisher Canonical --offer 0001-com-ubuntu-server-jammy --sku 22_04-lts --all --query "[?version=='latest']" -o table
# Create image from existing VM (as concept demo; VM must be generalized for real scenarios)
# az image create -g "$AZ_RG" -n "img-${AZ_VM1_NAME}" --source "$AZ_VM1_NAME"
echo "Marketplace images listed."
