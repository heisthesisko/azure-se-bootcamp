# Environment variables for the deployment
# Usage: source config/env.sh

# ===== GLOBAL =====
export LOCATION="westus3"
export RG="WebAIResourceGroup"

# ===== NETWORK =====
export VNET_NAME="webai-vnet"
export VNET_CIDR="10.10.0.0/16"
export SUBNET_WEB_NAME="snet-web"
export SUBNET_WEB_CIDR="10.10.1.0/24"
export SUBNET_DB_NAME="snet-db"
export SUBNET_DB_CIDR="10.10.2.0/24"
export SUBNET_AI_NAME="snet-ai"
export SUBNET_AI_CIDR="10.10.3.0/24"

export NSG_WEB="nsg-web"
export NSG_DB="nsg-db"
export NSG_AI="nsg-ai"

# ===== WEB (VMSS) =====
export VMSS_NAME="ApacheScaleSet"
export WEB_SKU="Standard_DS2_v2"
export WEB_IMAGE="Ubuntu2204"
export ADMIN_USER="azureuser"

# ===== DB (PG) =====
export AS_NAME="PGAvailabilitySet"
export PG_IMAGE="Ubuntu2204"
export PG_SKU="Standard_DS2_v2"
export PG_PRIMARY="PGPrimary"
export PG_REPLICA="PGReplica"

# ===== AI VM =====
export AI_VM_NAME="AIModelVM"
export AI_IMAGE="OpenLogic:CentOS:8_5-gen2:latest"
export AI_SKU="Standard_D4s_v5"
export AI_PORT="5000"

# ===== Optional: Set this to your repo's public ZIP URL =====
# Example: https://codeload.github.com/<ORG>/<REPO>/zip/refs/heads/main
export REPO_ZIP_URL=""
