
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ -f "$ROOT_DIR/config/env.sh" ]]; then
  source "$ROOT_DIR/config/env.sh"
else
  echo "Missing config/env.sh. Copy config/env.sample to config/env.sh and edit values." >&2
  exit 1
fi

az account set --subscription "${SUBSCRIPTION_ID}"
echo "Using subscription: $(az account show --query name -o tsv)"

ACCOUNT_KEY=$(az storage account keys list -g "$RG" -n "$SA_NAME" --query "[0].value" -o tsv)
EXPIRY=$(date -u -d "+2 hours" '+%Y-%m-%dT%H:%MZ' 2>/dev/null || python3 - <<'PY'
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc)+timedelta(hours=2)).strftime('%Y-%m-%dT%H:%MZ'))
PY
)
SAS=$(az storage container generate-sas -n "$CONTAINER" --permissions rl --expiry "$EXPIRY" --https-only --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o tsv)
echo "SAS URL: https://${SA_NAME}.blob.core.windows.net/${CONTAINER}?$SAS" > "$ROOT_DIR/app/web/.sas_url.txt"

QSAS=$(az storage queue generate-sas -n "$QUEUE_NAME" --permissions ap --expiry "$EXPIRY" --https-only --account-name "$SA_NAME" --account-key "$ACCOUNT_KEY" -o tsv)
echo "Queue SAS: $QSAS" > "$ROOT_DIR/app/ai/.queue_sas.txt"
