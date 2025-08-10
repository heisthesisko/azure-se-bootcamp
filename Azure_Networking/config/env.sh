#!/usr/bin/env bash
# Workshop environment variables. Customize before running modules.
export WORKSHOP_RG="AzureNetWorkshop"
export WORKSHOP_LOCATION="eastus"
export WORKSHOP_VNET_NAME="workshop-vnet"
export WORKSHOP_VNET_ADDR="10.0.0.0/16"
export WORKSHOP_SUBNET_WEB="web-subnet"
export WORKSHOP_SUBNET_WEB_ADDR="10.0.1.0/24"
export WORKSHOP_SUBNET_PRIVATE="private-subnet"
export WORKSHOP_SUBNET_PRIVATE_ADDR="10.0.2.0/24"
export WORKSHOP_HUB_VNET_NAME="hub-vnet"
export WORKSHOP_HUB_VNET_ADDR="10.0.100.0/24"
export WORKSHOP_FIREWALL_NAME="workshop-firewall"
export WORKSHOP_VM1_NAME="vm1"
export WORKSHOP_VM2_NAME="vm2"
export WORKSHOP_VM3_NAME="vm3"
export WORKSHOP_ADMIN="azureuser"
# On-prem (VyOS) sample values for VPN (adjust to your lab):
export WORKSHOP_ONPREM_PREFIX="192.168.0.0/24"
export WORKSHOP_VYOS_PUBLIC_IP="1.2.3.4"   # replace with your actual public IP
export WORKSHOP_VPN_SHARED_KEY="P@ssw0rd123"
