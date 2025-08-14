#!/usr/bin/env bash
set -euo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${THIS_DIR}/common.sh"

ensure_rg

echo "Creating Ubuntu VM ${LINUX_VM_NAME} if missing..."
az vm show -g "$RG_NAME" -n "$LINUX_VM_NAME" >/dev/null 2>&1 || az vm create -g "$RG_NAME" -n "$LINUX_VM_NAME"   --image Ubuntu2204 --admin-username "$LINUX_VM_ADMIN" --generate-ssh-keys -l "$LOCATION" -o none

echo "Creating managed disk and attaching to VM..."
disk_name="${LINUX_VM_NAME}-data1"
az disk create -g "$RG_NAME" -n "$disk_name" --size-gb 128 --sku Premium_LRS -l "$LOCATION" -o none
az vm disk attach -g "$RG_NAME" --vm-name "$LINUX_VM_NAME" --name "$disk_name" -o none

echo "Run on the VM (via SSH) to format and mount:"
echo "  sudo lsblk"
echo "  sudo mkfs.ext4 /dev/sdc"
echo "  sudo mkdir -p /data"
echo "  echo '/dev/sdc /data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab"
echo "  sudo mount -a && df -h"
