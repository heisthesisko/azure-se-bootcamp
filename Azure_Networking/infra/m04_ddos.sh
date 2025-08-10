#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
az network ddos-protection create -g "${WORKSHOP_RG}" -n workshop-ddos-plan
az network vnet update -g "${WORKSHOP_RG}" -n "${WORKSHOP_VNET_NAME}" --ddos-protection-plan workshop-ddos-plan --ddos-protection true
echo "Module 04 complete."
