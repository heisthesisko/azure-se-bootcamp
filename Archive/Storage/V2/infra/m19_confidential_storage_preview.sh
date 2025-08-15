#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg

echo "Provision a Confidential VM for 'encryption-in-use' scenarios (preview concept)."
az vm create -g "$RG_NAME" -n "vm-confidential" --image Ubuntu2204   --security-type "ConfidentialVM" --size Standard_DC2as_v5   --admin-username "$LINUX_VM_ADMIN" --generate-ssh-keys -o none

echo "Create a Storage Account with CMK and enforce HTTPS only (for client-side encryption demo)."
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Enable versioning for immutable-like recovery and integrate with CMK (see module 08)."
az storage account blob-service-properties update --account-name "$sa" --enable-versioning true -o none

echo "Use the Python client app (app/ai/cse_upload.py) to encrypt blobs client-side before upload."
