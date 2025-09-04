#!/usr/bin/env bash
set -euo pipefail

RG="${1:-ClinDataIntegrationRG}"
REGION="${2:-eastus}"
VNET="${3:-ClinicalVNet}"
SUBNET="${4:-SqlMISubnet}"
ADMIN_PW="${5:-<SecurePW>}"

az group create -n "$RG" -l "$REGION"

az network vnet create -g "$RG" -n "$VNET" -l "$REGION" \
  --address-prefixes 10.20.0.0/16

az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET" \
  --address-prefixes 10.20.1.0/24 \
  --delegations Microsoft.Sql/managedInstances

az deployment group create -g "$RG" -f "$(dirname "$0")/../iac/deploy_sqlmi.bicep" \
  -p administratorLoginPassword="$ADMIN_PW"
