#!/usr/bin/env bash
set -euo pipefail
# set_immutability.sh — Apply WORM immutability policy and optional legal hold to DICOM container
# Prereqs: az login; Owner/Contributor on Storage Account

SA_NAME=${SA_NAME:?Set SA_NAME}
CONTAINER=${CONTAINER:-dicom}
RETENTION_DAYS=${RETENTION_DAYS:-1825}

echo "[*] Setting immutability policy (Unlocked) for ${RETENTION_DAYS} days"
az storage container immutability-policy set -n "$CONTAINER" --account-name "$SA_NAME" --period "$RETENTION_DAYS" --allow-protected-append-writes true

echo "[*] (Optional) Locking the immutability policy — irreversible"
# Uncomment when ready to lock:
# az storage container immutability-policy lock -n "$CONTAINER" --account-name "$SA_NAME"

echo "[*] (Optional) Applying legal hold 'PHI'"
# az storage container legal-hold set -n "$CONTAINER" --account-name "$SA_NAME" --tags PHI
echo "[*] Done."
