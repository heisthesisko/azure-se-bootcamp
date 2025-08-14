
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

ACCOUNT_KEY=$(az storage account keys list -g "$RG" -n "$SA_NAME" --query "[0].value" -o tsv)
az storage share-rm create --resource-group "$RG" --storage-account "$SA_NAME" --name "$FILE_SHARE" -o table || az storage share create --name "$FILE_SHARE" --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o table

az vm create -g "$RG" -n "$VM_NAME" --image Ubuntu2204 --admin-username "$ADMIN_USER" --generate-ssh-keys --public-ip-address-dns-name "${VM_NAME//_/}-dns" --size "$VM_SIZE" -o table
VMIP=$(az vm list-ip-addresses -g "$RG" -n "$VM_NAME" --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)
echo "VM Public IP: $VMIP"

MOUNT_SCRIPT=$(cat <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y cifs-utils
sudo mkdir -p /mnt/azurefiles
credfile=/home/$USER/.smbcred
echo "username=$SA_NAME" > $credfile
echo "password=$ACCOUNT_KEY" >> $credfile
sudo chmod 600 $credfile
echo "//${SA_NAME}.file.core.windows.net/${FILE_SHARE} /mnt/azurefiles cifs vers=3.1.1,credentials=$credfile,dir_mode=0777,file_mode=0777,serverino" | sudo tee -a /etc/fstab
sudo mount -a
df -h | grep azurefiles || true
EOS
)
az vm run-command invoke -g "$RG" -n "$VM_NAME" --command-id RunShellScript --parameters "SA_NAME=$SA_NAME" "ACCOUNT_KEY=$ACCOUNT_KEY" "FILE_SHARE=$FILE_SHARE" --scripts "$MOUNT_SCRIPT" -o jsonc
