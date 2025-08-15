#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ ! -f "$ROOT_DIR/config/.env" ]]; then
  echo "config/.env not found. Copy config/env.sample -> config/.env and set values."
  exit 1
fi
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
echo "[M10] Standard Load Balancer with 2 Linux web VMs"
# Create backend pool VMs
for i in 1 2; do
  az vm create -g "$RG_NAME" -n "${PREFIX}-vm-web-$i" --image "Ubuntu2204"         --size "Standard_B2s" --admin-username "$ADMIN_USERNAME" --ssh-key-values "$SSH_KEY_PATH"         --subnet "web" --vnet-name "$VNET_NAME" --public-ip-address "" --nsg ""
  az vm run-command invoke -g "$RG_NAME" -n "${PREFIX}-vm-web-$i" --command-id RunShellScript         --scripts "sudo apt-get update && sudo apt-get install -y apache2 php libapache2-mod-php && echo '<h1>Hello from ${PREFIX}-vm-web-$i</h1>' | sudo tee /var/www/html/index.php && sudo systemctl enable --now apache2"
done
# Create LB
PIP_LB_ID=$(az network public-ip show -g "$RG_NAME" -n "${PREFIX}-pip-lb" --query id -o tsv)
az network lb create -g "$RG_NAME" -n "${PREFIX}-slb" --sku Standard --public-ip-address "$PIP_LB_ID"       --frontend-ip-name "${PREFIX}-fe" --backend-pool-name "${PREFIX}-be"
# Add VMs to backend
for i in 1 2; do
  NIC_ID=$(az vm show -g "$RG_NAME" -n "${PREFIX}-vm-web-$i" --query "networkProfile.networkInterfaces[0].id" -o tsv)
  IP_CONFIG_NAME=$(az network nic show --ids "$NIC_ID" --query "ipConfigurations[0].name" -o tsv)
  az network nic ip-config address-pool add --address-pool "${PREFIX}-be" --ip-config-name "$IP_CONFIG_NAME" --nic-name "$(basename "$NIC_ID")" -g "$RG_NAME" --lb-name "${PREFIX}-slb"
done
# Probe + rule
az network lb probe create -g "$RG_NAME" --lb-name "${PREFIX}-slb" -n "http-probe" --protocol tcp --port 80
az network lb rule create -g "$RG_NAME" --lb-name "${PREFIX}-slb" -n "http-rule"       --protocol Tcp --frontend-port 80 --backend-port 80 --frontend-ip-name "${PREFIX}-fe" --backend-pool-name "${PREFIX}-be"       --probe-name "http-probe"
echo "Load Balancer deployed. Test via: http://$LB_DNS_LABEL.$LOCATION.cloudapp.azure.com/"
