#!/usr/bin/env bash
set -euo pipefail
if [ -f config/.env ]; then source config/.env; else echo "Create config/.env from env.sample"; exit 1; fi
az account set --subscription "$SUBSCRIPTION_ID"
az extension add --name monitor-control-service --only-show-errors || true
echo "Prereqs complete."
