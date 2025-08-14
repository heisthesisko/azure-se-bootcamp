#!/usr/bin/env bash
set -euo pipefail
source config/.env
DASH_NAME="Healthcare Monitor Dashboard"
DASH_JSON='{"properties":{"lenses":{},"metadata":{"model":{"timeRange":{"value":{"relative":{"duration":24}}}}}}}'
az portal dashboard create -g "$RG_NAME" -n "$DASH_NAME" --input "$DASH_JSON"
echo "Blank dashboard created. Pin tiles from Portal UI."
