#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
vm="vm-hc-linux"
az vm show -g "$RG_NAME" -n "$vm" >/dev/null 2>&1 || az vm create -g "$RG_NAME" -n "$vm" --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys -l "$LOCATION" -o none
disk="${vm}-data"
az disk create -g "$RG_NAME" -n "$disk" --size-gb 128 --sku Premium_LRS -l "$LOCATION" -o none
az vm disk attach -g "$RG_NAME" --vm-name "$vm" --name "$disk" -o none
echo "SSH to the VM and run: sudo mkfs.ext4 /dev/sdc && sudo mkdir -p /data && echo '/dev/sdc /data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab && sudo mount -a"
