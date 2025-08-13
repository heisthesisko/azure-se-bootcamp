#!/usr/bin/env bash
set -euo pipefail
# Create a custom role for migration operators (limited actions)
cat > /tmp/migrate-operator-role.json <<'JSON'
{{
  "Name": "Migration Operator (Limited)",
  "IsCustom": true,
  "Description": "Limited role to perform migration-related read/write without full Owner privileges",
  "Actions": [
    "Microsoft.Compute/*/read",
    "Microsoft.Network/*/read",
    "Microsoft.Storage/*/read",
    "Microsoft.Migrate/*",
    "Microsoft.DBforPostgreSQL/*/read",
    "Microsoft.Web/*/read"
  ],
  "NotActions": [],
  "AssignableScopes": ["/subscriptions/{sub}"]
}}
JSON
SUB=$(az account show --query id -o tsv)
sed -i "s|{sub}|$SUB|g" /tmp/migrate-operator-role.json
az role definition create --role-definition /tmp/migrate-operator-role.json
echo "Custom role created."
