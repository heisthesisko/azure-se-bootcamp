#!/usr/bin/env bash
set -euo pipefail


source config/.env

echo "Enable Defender for Servers & Containers (subscription scope)"
az security pricing create -n VirtualMachines --tier Standard
az security pricing create -n KubernetesService --tier Standard

echo "Review recommendations in Defender for Cloud after ~15 minutes."
