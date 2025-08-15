#!/usr/bin/env bash
set -euo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${THIS_DIR}/common.sh"

ensure_rg
ensure_vnet
ensure_private_dns
echo "Resource Group, VNet, and Private DNS prepared."
