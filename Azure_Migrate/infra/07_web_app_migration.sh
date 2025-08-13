#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"

az appservice plan create -g "$RG_NAME" -n "$APP_SERVICE_PLAN" --is-linux --sku P1v3
az webapp create -g "$RG_NAME" -p "$APP_SERVICE_PLAN" -n "$APP_SERVICE_NAME" --runtime "PHP|8.2"

# Zip deploy sample PHP app
zip -r app.zip app/web > /dev/null
az webapp deploy --resource-group "$RG_NAME" --name "$APP_SERVICE_NAME" --src-path app.zip --type zip

# Enforce HTTPS only
az webapp update -g "$RG_NAME" -n "$APP_SERVICE_NAME" --https-only true

echo "App Service deployed with sample PHP app."
