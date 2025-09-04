#!/usr/bin/env bash
set -euo pipefail
# azcopy_sync.sh — Sync a local PACS export folder to Azure Blob securely
# Prereqs: azcopy installed; SAS or Azure AD auth configured

SRC_DIR=${SRC_DIR:-/data/pacs/export}
DST=${DST:?Set DST like 'https://<account>.blob.core.windows.net/dicom'}
# For Azure AD auth, ensure 'az login' and 'azcopy login --tenant-id <tenant>' have been done.

echo "[*] Syncing $SRC_DIR to $DST"
azcopy sync "$SRC_DIR" "$DST" --recursive
