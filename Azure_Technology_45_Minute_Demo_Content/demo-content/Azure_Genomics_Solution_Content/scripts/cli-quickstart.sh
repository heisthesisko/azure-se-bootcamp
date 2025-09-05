#!/usr/bin/env bash
set -euo pipefail

RG="GenomicsRG"
LOC="eastus"
VNET="GenomicsVNet"
STG="genomicsdatalake$RANDOM"
KV="GenomicsKeyVault$RANDOM"
BATCH="GenomicsBatchAcct$RANDOM"
SYN="GenomicsSynapse$RANDOM"
PG="genomicsdb$RANDOM"

az group create -n "$RG" -l "$LOC"
az network vnet create -g "$RG" -n "$VNET" --address-prefixes 10.100.0.0/16
az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n BatchSubnet --address-prefixes 10.100.1.0/24

az keyvault create -g "$RG" -n "$KV" -l "$LOC" --sku standard --enable-soft-delete true --enable-purge-protection true
az keyvault key create --vault-name "$KV" -n adls-cmk -p software

az storage account create -g "$RG" -n "$STG" -l "$LOC" \
  --sku Standard_RAGRS --kind StorageV2 --enable-hierarchical-namespace true \
  --encryption-key-source Microsoft.Keyvault \
  --encryption-key-name adls-cmk \
  --encryption-key-vault-key-uri "$(az keyvault key show --vault-name "$KV" -n adls-cmk --query key.kid -o tsv)" \
  --default-action Deny

az batch account create -g "$RG" -n "$BATCH" -l "$LOC" --storage-account "$STG"
az batch account login -g "$RG" -n "$BATCH" --shared-key-auth
az batch pool create --id genomicsPool1 --vm-size Standard_D8_v3 --target-dedicated-nodes 0 \
  --auto-scale-enabled true --auto-scale-formula "$$TargetDedicatedNodes=0" \
  --image canonical:0001-com-ubuntu-server-focal:20_04-lts --node-agent-sku-id "batch.node.ubuntu 20.04"

az synapse workspace create -g "$RG" -n "$SYN" -l "$LOC" \
  --storage-account "$STG" --file-system "genomics" \
  --sql-admin-login-user sqladminuser --sql-admin-login-password "Str0ng!Passw0rd" \
  --enable-managed-vnet true --key-name "adls-cmk" --key-vault-url "https://$KV.vault.azure.net/"

az postgres flexible-server create -g "$RG" -n "$PG" -l "$LOC" \
  --vnet "$VNET" --subnet BatchSubnet --administrator-login pgadmin \
  --administrator-login-password "AnotherStr0ngP@ss1" --storage-size 128 --yes

echo "✅ Deployment kicked off. Edit resources as needed and add Private Endpoints & Diagnostics per docs."
