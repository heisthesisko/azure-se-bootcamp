#!/usr/bin/env bash
set -euo pipefail
source config/.env
az security pricing create -n VirtualMachines --tier Standard
az security pricing create -n AppServices --tier Standard
echo "Defender for Cloud standard enabled for selected resources."
