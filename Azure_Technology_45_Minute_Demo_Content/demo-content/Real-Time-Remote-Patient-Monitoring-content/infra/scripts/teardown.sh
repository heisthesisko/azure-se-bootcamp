#!/usr/bin/env bash
set -euo pipefail
RG=${RG:-"rg-rpm-dev-eus2"}
az group delete -n "$RG" --yes --no-wait
