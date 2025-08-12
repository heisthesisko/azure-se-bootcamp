#!/usr/bin/env bash
set -euo pipefail
if [ -f .env ]; then source .env; elif [ -f config/.env ]; then source config/.env; elif [ -f config/env.sample ]; then source config/env.sample; fi

: "${LOCATION:=eastus}"
: "${PREFIX:=hlthwrk}"
: "${ADMIN_USERNAME:=azureuser}"
: "${SSH_KEY_PATH:=~/.ssh/id_rsa.pub}"
: "${VM_SIZE_AI:=Standard_D2s_v5}"
: "${VMSS_INSTANCE_COUNT:=2}"
: "${VMSS_MIN_COUNT:=2}"
: "${VMSS_MAX_COUNT:=5}"

RG="${PREFIX}-rg"
VNET="${PREFIX}-vnet"
SUBNET_AI="${PREFIX}-snet-ai"
LB="${PREFIX}-vmss-lb"

echo "==> Ensure prereqs"
bash scripts/00_prereqs.sh

echo "==> Create VM Scale Set with load balancer"
az vmss create -g "$RG" -n "${PREFIX}-vmss-ai"   --image Ubuntu2204 --admin-username "$ADMIN_USERNAME" --ssh-key-values "$SSH_KEY_PATH"   --instance-count "$VMSS_INSTANCE_COUNT" --vm-sku "$VM_SIZE_AI"   --vnet-name "$VNET" --subnet "$SUBNET_AI"   --upgrade-policy-mode automatic   --lb "$LB"   --custom-data infra/cloud-init-ai.yaml   --tags "module=3" "tier=ai"

echo "==> Autoscale settings"
az monitor autoscale create -g "$RG" -n "${PREFIX}-vmss-ai-scale" --resource "${PREFIX}-vmss-ai" --resource-group "$RG" --resource-type "Microsoft.Compute/virtualMachineScaleSets"   --min-count "$VMSS_MIN_COUNT" --max-count "$VMSS_MAX_COUNT" --count "$VMSS_INSTANCE_COUNT"

az monitor autoscale rule create -g "$RG" --autoscale-name "${PREFIX}-vmss-ai-scale"   --condition "Percentage CPU > 60 avg 5m" --scale out 1

az monitor autoscale rule create -g "$RG" --autoscale-name "${PREFIX}-vmss-ai-scale"   --condition "Percentage CPU < 30 avg 10m" --scale in 1

echo "==> Output public IP for VMSS LB"
az network public-ip list -g "$RG" --query "[?contains(name, '${LB}')].ipAddress" -o tsv
