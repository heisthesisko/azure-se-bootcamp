#!/usr/bin/env bash
set -euo pipefail
if [ -f /etc/debian_version ]; then
  sudo apt-get update -y
  sudo apt-get install -y postgresql
  sudo systemctl enable --now postgresql
elif [ -f /etc/redhat-release ]; then
  sudo dnf install -y postgresql-server postgresql
  sudo /usr/bin/postgresql-setup --initdb || true
  sudo systemctl enable --now postgresql
else
  echo "Unsupported distro"
  exit 1
fi
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='trek_northwind';" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE trek_northwind;"
echo "PostgreSQL ready."
