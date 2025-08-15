#!/usr/bin/env bash
set -euo pipefail
if [ -f "config/.env" ]; then set -a; source config/.env; set +a; else echo "Missing config/.env"; exit 1; fi
az account show >/dev/null 2>&1 || az login --use-device-code
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set -s "$SUBSCRIPTION_ID"
log(){ echo -e "\n[ASR-HC] $*\n"; }
ok(){ echo -e "[OK] $*"; }

echo "#!/usr/bin/env bash" > scripts/pre-freeze.sh; echo "echo pre-freeze $(date)" >> scripts/pre-freeze.sh; chmod +x scripts/pre-freeze.sh
echo "#!/usr/bin/env bash" > scripts/post-thaw.sh; echo "echo post-thaw $(date)" >> scripts/post-thaw.sh; chmod +x scripts/post-thaw.sh
ok "Sample freeze/thaw hooks created (attach per workload guidance)"
