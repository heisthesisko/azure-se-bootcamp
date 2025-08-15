#!/usr/bin/env bash
set -euo pipefail
source config/env.sh
echo "Deleting resource group: ${WORKSHOP_RG} (this will remove all resources created by modules)"
az group delete -n "${WORKSHOP_RG}" --yes --no-wait || true
echo "Cleanup requested."
