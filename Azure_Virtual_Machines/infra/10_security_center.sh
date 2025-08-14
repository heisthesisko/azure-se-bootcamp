#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# Enable Defender for Cloud standard plan for Servers (may incur cost)
az security pricing create -n VirtualMachines --tier 'standard'
# Just-In-Time VM access example (requires a public IP typically, shown for concept)
echo "Defender for Cloud plan enabled for VMs."
