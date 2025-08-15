#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az vm create -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM3_NAME}" --image UbuntuLTS   --vnet-name "${WORKSHOP_VNET_NAME}" --subnet "${WORKSHOP_SUBNET_WEB}"   --public-ip-address "" --admin-username "${WORKSHOP_ADMIN}" --generate-ssh-keys
for VM in "${WORKSHOP_VM1_NAME}" "${WORKSHOP_VM3_NAME}"; do
  az vm run-command invoke -g "${WORKSHOP_RG}" -n "$VM" --command-id RunShellScript --scripts "sudo apt-get update && sudo apt-get -y install apache2 && echo Hello from $VM | sudo tee /var/www/html/index.html"
done
az network lb create -g "${WORKSHOP_RG}" -n webLB --sku Standard -l "${WORKSHOP_LOCATION}"   --frontend-ip-name webLBFront --public-ip-address webLB-pip --backend-pool-name webPool
for VM in "${WORKSHOP_VM1_NAME}" "${WORKSHOP_VM3_NAME}"; do
  NIC=$(az vm show -g "${WORKSHOP_RG}" -n "$VM" --query "networkProfile.networkInterfaces[0].id" -o tsv | awk -F/ '{print $NF}')
  az network nic ip-config address-pool add -g "${WORKSHOP_RG}" --nic-name "$NIC" --lb-name webLB --pool-name webPool
done
az network lb probe create -g "${WORKSHOP_RG}" --lb-name webLB -n httpProbe --protocol tcp --port 80
az network lb rule create -g "${WORKSHOP_RG}" --lb-name webLB -n httpRule   --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name webLBFront --backend-pool-name webPool --probe-name httpProbe
echo "Module 08 complete."
