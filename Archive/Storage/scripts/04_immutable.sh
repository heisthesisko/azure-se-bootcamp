
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

az storage container immutability-policy create --account-name "$SA_NAME" --container-name "$CONTAINER" --period 1 --allow-protected-append-writes true -o table || true
az storage container immutability-policy lock --account-name "$SA_NAME" --container-name "$CONTAINER" --if-match * -o table || true
az storage container legal-hold set --account-name "$SA_NAME" --container-name "$CONTAINER" --tags "training","demo" -o table || true
