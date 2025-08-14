#!/usr/bin/env bash
set -euo pipefail
if [ -f .env ]; then source .env; elif [ -f config/.env ]; then source config/.env; elif [ -f config/env.sample ]; then source config/env.sample; fi

: "${LOCATION:=eastus}"
: "${PREFIX:=hlthwrk}"
: "${ADMIN_USERNAME:=azureuser}"
: "${SSH_KEY_PATH:=~/.ssh/id_rsa.pub}"
: "${VM_SIZE_WEB:=Standard_B2s}"

RG="${PREFIX}-rg"
VM="vm-web-01"
VNET="${PREFIX}-vnet"
SUBNET_WEB="${PREFIX}-snet-web"
IP="${PREFIX}-pip-web"

echo "==> Ensure network pre-reqs"
bash scripts/00_prereqs.sh

echo "==> Creating Public IP (training-only; prefer private)"
az network public-ip create -g "$RG" -n "$IP" --sku Basic --allocation-method Dynamic >/dev/null

echo "==> Creating NIC"
NIC="${VM}-nic"
az network nic create -g "$RG" -n "$NIC" --vnet-name "$VNET" --subnet "$SUBNET_WEB" --public-ip-address "$IP" >/dev/null

echo "==> Creating VM"
az vm create -g "$RG" -n "$VM" --image Ubuntu2204 --size "$VM_SIZE_WEB"   --admin-username "$ADMIN_USERNAME" --ssh-key-values "$SSH_KEY_PATH"   --nics "$NIC"   --custom-data infra/cloud-init-web.yaml   --tags "module=1" "purpose=patient-intake"

echo "==> Opening HTTP (training-only; prefer WAF/Private)"
az vm open-port -g "$RG" -n "$VM" --port 80 --priority 1000

echo "==> Output"
az vm show -g "$RG" -n "$VM" -d --query "{publicIp:publicIps,privateIp:privateIps}" -o table
