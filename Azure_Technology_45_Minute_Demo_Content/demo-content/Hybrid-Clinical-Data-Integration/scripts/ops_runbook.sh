#!/usr/bin/env bash
set -euo pipefail

RG="${1:-ClinDataIntegrationRG}"
DF="${2:-ClinicalDataFactory}"

echo "Arc servers:"
az connectedmachine list -g "$RG" -o table

echo "Pipelines:"
az datafactory pipeline list --factory-name "$DF" -g "$RG" -o table

echo "Recent pipeline runs (last 24h):"
now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
yest=$(date -u -d '1 day ago' +%Y-%m-%dT%H:%M:%SZ)
az datafactory pipeline-run query-by-factory --factory-name "$DF" -g "$RG" \
  --last-updated-after "$yest" --last-updated-before "$now" -o table
