#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Trigger on-demand backup so that an RP exists, then show how to restore files
az backup protection backup-now -g "$RG_NAME" -v "$RSV_NAME" --container-name "iaasvmcontainer;Compute;$RG_NAME;$VM_NAME"   --item-name "vm;$RG_NAME;$VM_NAME" --retain-until $(date -u -d '+7 days' +%Y-%m-%d)
# File-level restore would require mounting a recovery volume; documented in module.
