#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network vnet create -g "${WORKSHOP_RG}" -n "${WORKSHOP_HUB_VNET_NAME}"   --address-prefixes "${WORKSHOP_HUB_VNET_ADDR}"   --subnet-name AzureFirewallSubnet --subnet-prefixes 10.0.100.0/26
az network vnet peering create -g "${WORKSHOP_RG}" -n HubToSpoke   --vnet-name "${WORKSHOP_HUB_VNET_NAME}" --remote-vnet "${WORKSHOP_VNET_NAME}" --allow-vnet-access
az network vnet peering create -g "${WORKSHOP_RG}" -n SpokeToHub   --vnet-name "${WORKSHOP_VNET_NAME}" --remote-vnet "${WORKSHOP_HUB_VNET_NAME}" --allow-vnet-access
az network public-ip create -g "${WORKSHOP_RG}" -n fw-pip --sku Standard --allocation-method static
az network firewall create -g "${WORKSHOP_RG}" -n "${WORKSHOP_FIREWALL_NAME}" -l "${WORKSHOP_LOCATION}" --enable-dns-proxy true --tier Standard --vnet-name "${WORKSHOP_HUB_VNET_NAME}"
az network firewall ip-config create -g "${WORKSHOP_RG}" -f "${WORKSHOP_FIREWALL_NAME}" -n fw-config --public-ip-address fw-pip --vnet-name "${WORKSHOP_HUB_VNET_NAME}"
FW_PRIV=$(az network firewall show -g "${WORKSHOP_RG}" -n "${WORKSHOP_FIREWALL_NAME}" --query "ipConfigurations[0].privateIpAddress" -o tsv)
az network route-table create -g "${WORKSHOP_RG}" -n spoke-udr
az network route-table route create -g "${WORKSHOP_RG}" --route-table-name spoke-udr -n DefaultRoute   --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address "$FW_PRIV"
az network vnet subnet update -g "${WORKSHOP_RG}" --vnet-name "${WORKSHOP_VNET_NAME}" --name "${WORKSHOP_SUBNET_WEB}" --route-table spoke-udr
VM1_PRIV=$(az vm list-ip-addresses -g "${WORKSHOP_RG}" -n "${WORKSHOP_VM1_NAME}" --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
az network firewall application-rule create -g "${WORKSHOP_RG}" -f "${WORKSHOP_FIREWALL_NAME}"   --collection-name AppRules --priority 100 --action allow   --rule-name allow_web_azure --source-addresses ${VM1_PRIV}/32   --protocols Http=80 Https=443 --target-fqdns "*.azure.com" "microsoft.com"
az network firewall network-rule create -g "${WORKSHOP_RG}" -f "${WORKSHOP_FIREWALL_NAME}"   --collection-name NetRules --priority 101 --action allow   --rule-name DNS_and_SSH --source-addresses ${VM1_PRIV}/32 --destination-addresses "*"   --destination-ports 53 22 --protocols UDP TCP
echo "Module 03 complete. Firewall IP: $FW_PRIV"
