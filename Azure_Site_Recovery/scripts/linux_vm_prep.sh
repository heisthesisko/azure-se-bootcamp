#!/usr/bin/env bash
set -euo pipefail
if [ -f /etc/debian_version ]; then
  sudo apt-get update -y
  sudo apt-get install -y apache2 php php-pgsql php-cli unzip
  sudo systemctl enable --now apache2
elif [ -f /etc/redhat-release ]; then
  sudo dnf install -y httpd php php-pgsql php-cli unzip
  sudo systemctl enable --now httpd
else
  echo "Unsupported distro"
  exit 1
fi
echo "Apache + PHP ready."
