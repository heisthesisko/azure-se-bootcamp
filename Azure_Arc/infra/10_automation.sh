#!/usr/bin/env bash
set -euo pipefail


source config/.env
echo "Create Automation Account (if desired) and import Az.ConnectedMachine module. Configure a Hybrid Runbook Worker on an Arc server."
echo "Runbooks can use: Invoke-AzConnectedMachineCommand to remediate services."
