#!/usr/bin/env bash
# Derive a codeload ZIP URL from the current repo's origin remote.
# Works only for **public** repos (no auth on VMSS). For private repos, see README for alternatives.
set -euo pipefail
source "$(dirname "$0")/../config/env.sh"

ORIGIN=$(git remote get-url origin 2>/dev/null || true)
if [[ -z "$ORIGIN" ]]; then
  echo "No git remote origin found. Set REPO_ZIP_URL in config/env.sh and run infra/25-web-update.sh"
  exit 1
fi

# Normalize to https://github.com/ORG/REPO
if [[ "$ORIGIN" =~ ^git@github.com:(.*)\.git$ ]]; then
  PATHPART="${ORIGIN#git@github.com:}"
  PATHPART="${PATHPART%.git}"
  HTTPS="https://github.com/${PATHPART}"
elif [[ "$ORIGIN" =~ ^https://github.com/ ]]; then
  HTTPS="$ORIGIN"
  HTTPS="${HTTPS%.git}"
else
  echo "Unsupported origin URL: $ORIGIN"
  exit 1
fi

ZIP_URL="${HTTPS/https:\/\/github.com/https:\/\/codeload.github.com}/zip/refs/heads/main"
export REPO_ZIP_URL="$ZIP_URL"
echo "Computed REPO_ZIP_URL=$REPO_ZIP_URL"
bash "$(dirname "$0")/25-web-update.sh"
