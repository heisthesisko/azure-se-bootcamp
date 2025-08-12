#!/usr/bin/env bash
set -euo pipefail
if [ -f .env ]; then source .env; elif [ -f config/.env ]; then source config/.env; elif [ -f config/env.sample ]; then source config/env.sample; fi

: "${LOCATION:=eastus}"
: "${PREFIX:=hlthwrk}"
: "${ADMIN_USERNAME:=azureuser}"
: "${SSH_KEY_PATH:=~/.ssh/id_rsa.pub}"
: "${VM_SIZE_WEB:=Standard_B2s}"

RG="${PREFIX}-rg"
AS="${PREFIX}-avset"
VNET="${PREFIX}-vnet"
SUBNET_WEB="${PREFIX}-snet-web"
LB="${PREFIX}-ilb"
PROBE="${PREFIX}-ilb-probe"
RULE="${PREFIX}-ilb-rule"

echo "==> Ensure prereqs"
bash scripts/00_prereqs.sh

echo "==> Availability Set"
az vm availability-set create -g "$RG" -n "$AS" --platform-fault-domain-count 2 --platform-update-domain-count 5

create_vm () {
  local name=$1
  local nic="${name}-nic"
  az network nic create -g "$RG" -n "$nic" --vnet-name "$VNET" --subnet "$SUBNET_WEB" >/dev/null
  az vm create -g "$RG" -n "$name" --image Ubuntu2204 --size "$VM_SIZE_WEB"     --availability-set "$AS"     --admin-username "$ADMIN_USERNAME" --ssh-key-values "$SSH_KEY_PATH"     --nics "$nic" --custom-data infra/cloud-init-web.yaml     --tags "module=2" "tier=ehr-web"
  az vm open-port -g "$RG" -n "$name" --port 80 --priority 1001 >/dev/null
}

echo "==> Create two VMs in Availability Set"
create_vm "ehr-web-01"
create_vm "ehr-web-02"

echo "==> Internal Load Balancer"
az network lb create -g "$RG" -n "$LB" --sku Basic --vnet-name "$VNET" --subnet "$SUBNET_WEB" --backend-pool-name "${LB}-bepool" --frontend-ip-name "${LB}-fe" --private-ip-address-version IPv4

az network lb probe create -g "$RG" --lb-name "$LB" -n "$PROBE" --protocol tcp --port 80

az network lb rule create -g "$RG" --lb-name "$LB" -n "$RULE" --protocol tcp --frontend-port 80 --backend-port 80   --frontend-ip-name "${LB}-fe" --backend-pool-name "${LB}-bepool" --probe-name "$PROBE"

for NIC in ehr-web-01-nic ehr-web-02-nic; do
  az network nic ip-config address-pool add -g "$RG" --nic-name "$NIC" --ip-config-name ipconfig1 --lb-name "$LB" --address-pool "${LB}-bepool"
done

echo "==> ILB private IP:"
az network lb frontend-ip show -g "$RG" --lb-name "$LB" -n "${LB}-fe" --query "privateIpAddress" -o tsv
