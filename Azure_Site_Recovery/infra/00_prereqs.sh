#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

log "Register providers and install extensions"
az provider register --namespace Microsoft.RecoveryServices --wait
az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.Compute --wait
az extension add --name site-recovery --only-show-errors || true
az extension add --name automation --only-show-errors || true
log "Create RG"
az group create -n "$RG_NAME" -l "$LOC_PRIMARY" --tags workshop=asr-hc >/dev/null
log "VNet + subnets"
az network vnet create -g "$RG_NAME" -n "$VNET_NAME" --address-prefix "$VNET_CIDR" --subnet-name "$SUBNET_APP_NAME" --subnet-prefix "$SUBNET_APP_CIDR" >/dev/null
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n GatewaySubnet --address-prefixes "$SUBNET_GATEWAY_CIDR" >/dev/null
log "DR VNet"
az network vnet create -g "$RG_NAME" -l "$LOC_SECONDARY" -n "$TARGET_VNET_NAME" --address-prefix "$TARGET_VNET_CIDR" --subnet-name "$TARGET_SUBNET_APP_NAME" --subnet-prefix "$TARGET_SUBNET_APP_CIDR" >/dev/null
log "Linux VM"
SSH_KEY="${SSH_PUBLIC_KEY_PATH/#\~/$HOME}"; if [ ! -f "$SSH_KEY" ]; then mkdir -p "$(dirname "$SSH_KEY")"; ssh-keygen -t rsa -b 4096 -N "" -f "${SSH_KEY%.*}"; SSH_KEY="${SSH_KEY%.*}.pub"; fi
az vm create -g "$RG_NAME" -n "$VM_NAME" --image Ubuntu2204 --size "$VM_SIZE" --admin-username "$ADMIN_USERNAME" --ssh-key-values "$SSH_KEY" --vnet-name "$VNET_NAME" --subnet "$SUBNET_APP_NAME" --public-ip-sku Standard >/dev/null
az vm open-port -g "$RG_NAME" -n "$VM_NAME" --port 80 --priority 1010 >/dev/null
log "Install Apache + PHP and deploy training site"
PUBLIC_IP=$(az vm list-ip-addresses -g "$RG_NAME" -n "$VM_NAME" --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)
scp -o StrictHostKeyChecking=no -r app/web/* "$ADMIN_USERNAME@$PUBLIC_IP:/home/$ADMIN_USERNAME/"
ssh -o StrictHostKeyChecking=no "$ADMIN_USERNAME@$PUBLIC_IP" 'sudo apt-get update -y && sudo apt-get install -y apache2 php libapache2-mod-php && sudo rm -rf /var/www/html/* && sudo cp -r ~/index.php /var/www/html/ && sudo systemctl restart apache2'
log "Cache storage account"
az storage account create -g "$RG_NAME" -l "$LOC_PRIMARY" -n "$CACHE_STORAGE_NAME" --sku Standard_LRS --kind StorageV2 --https-only true --min-tls-version TLS1_2 >/dev/null
ok "Prereqs ready"
