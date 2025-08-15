#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
az vm create -g "$RG_NAME" -n "vm-conf" --image Ubuntu2204 --size Standard_DC2as_v5 --security-type ConfidentialVM --admin-username azureuser --generate-ssh-keys -o none
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az storage account blob-service-properties update --account-name "$sa" --enable-versioning true -o none
echo "Use app/ai/cse_upload.py for client-side encryption demo."
