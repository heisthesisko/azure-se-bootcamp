#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../config/env.sh"

# Create VMSS in the web subnet
az vmss create \
  --resource-group "$RG" \
  --name "$VMSS_NAME" \
  --image "$WEB_IMAGE" \
  --orchestration-mode Uniform \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys \
  --instance-count 3 \
  --vm-sku "$WEB_SKU" \
  --subnet "$SUBNET_WEB_NAME" --vnet-name "$VNET_NAME" \
  --upgrade-policy-mode automatic

# Install Apache/PHP on all instances
az vmss run-command invoke -g "$RG" -n "$VMSS_NAME" --command-id RunShellScript --scripts "
set -e
sudo apt-get update -y
sudo apt-get install -y apache2 php php-pgsql libapache2-mod-php unzip curl rsync
sudo systemctl enable apache2
sudo systemctl restart apache2
"
