#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Cross-region restore is enabled if vault is GRS and CRR is supported; demo steps in module.
echo "Ensure vault set to GRS. See module for CRR walkthrough."
