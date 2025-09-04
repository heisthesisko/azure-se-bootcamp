#!/usr/bin/env bash
set -euo pipefail

RG="${1:-ClinDataIntegrationRG}"
REGION="${2:-eastus}"
DF_NAME="${3:-ClinicalDataFactory}"

az datafactory create -n "$DF_NAME" -g "$RG" -l "$REGION" --identity-type SystemAssigned

echo "Create a Self-hosted Integration Runtime from ADF Studio -> Manage -> Integration runtimes."
