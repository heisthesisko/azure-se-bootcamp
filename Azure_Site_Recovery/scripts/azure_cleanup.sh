#!/usr/bin/env bash
set -euo pipefail
RG_MAIN="asr-lab-rg"
RG_A2A="asr-a2a-rg"
echo "WARNING: This will delete resource groups $RG_MAIN and $RG_A2A"
read -p "Type 'yes' to continue: " ans
[ "$ans" == "yes" ] || exit 1
az group delete -n "$RG_MAIN" --yes --no-wait
az group delete -n "$RG_A2A" --yes --no-wait
echo "Cleanup requested."
