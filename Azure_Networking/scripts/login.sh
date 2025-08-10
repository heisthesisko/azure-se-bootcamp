#!/usr/bin/env bash
set -euo pipefail
az account show >/dev/null 2>&1 || az login
echo "Logged in. Current subscription:"
az account show --query "{name:name, id:id, tenant:tenantId}" -o table
