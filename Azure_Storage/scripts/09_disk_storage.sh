
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ -f "$ROOT_DIR/config/env.sh" ]]; then
  source "$ROOT_DIR/config/env.sh"
else
  echo "Missing config/env.sh. Copy config/env.sample to config/env.sh and edit values." >&2
  exit 1
fi

az account set --subscription "${SUBSCRIPTION_ID}"
echo "Using subscription: $(az account show --query name -o tsv)"

az disk create -g "$RG" -n "${VM_NAME}-datadisk1" --size-gb 16 --sku StandardSSD_LRS -o table
az vm disk attach -g "$RG" --vm-name "$VM_NAME" --name "${VM_NAME}-datadisk1" -o table
SCRIPT=$(cat <<'EOS'
sudo parted /dev/sdc --script mklabel gpt mkpart primary ext4 0% 100%
sudo mkfs.ext4 -F /dev/sdc1
sudo mkdir -p /mnt/data
UUID=$(sudo blkid -s UUID -o value /dev/sdc1)
echo "UUID=$UUID /mnt/data ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
sudo mount -a
df -h | grep /mnt/data || true
EOS
)
az vm run-command invoke -g "$RG" -n "$VM_NAME" --command-id RunShellScript --scripts "$SCRIPT" -o jsonc
