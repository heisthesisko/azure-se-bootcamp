#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/config/.env" || true
if [[ -z "${RG_NAME:-}" ]]; then
  echo "Set RG_NAME in config/.env to delete the resource group."
  exit 1
fi
az group delete -n "$RG_NAME" --yes --no-wait
echo "Deletion submitted for resource group $RG_NAME"
