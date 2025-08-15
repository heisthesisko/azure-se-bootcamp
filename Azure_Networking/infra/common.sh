#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
az configure --defaults location="$LOCATION" group="$RG_NAME"
az config set extension.use_dynamic_install=yes_without_prompt >/dev/null
