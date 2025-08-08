#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../config/env.sh"

if [[ -z "${REPO_ZIP_URL:-}" ]]; then
  echo "REPO_ZIP_URL is not set in config/env.sh"
  echo "Example: https://codeload.github.com/<ORG>/<REPO>/zip/refs/heads/main"
  exit 1
fi

# Pull web files from repo ZIP into /var/www/html on all VMSS instances
az vmss run-command invoke -g "$RG" -n "$VMSS_NAME" --command-id RunShellScript --scripts "
set -e
TMP=/tmp/webzip
sudo rm -rf \$TMP && mkdir -p \$TMP
curl -L \"$REPO_ZIP_URL\" -o \$TMP/src.zip
cd \$TMP && unzip -q src.zip
TOPDIR=\$(ls -1 | head -n1)
sudo rsync -aH --delete \"\$TOPDIR/app/web/\" /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html -type f -name '*.php' -exec sed -i 's/\r$//' {} +
sudo systemctl restart apache2
"
