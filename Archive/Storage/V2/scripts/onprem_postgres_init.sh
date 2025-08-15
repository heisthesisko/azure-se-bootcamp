#!/usr/bin/env bash
set -euo pipefail
sudo -n true || echo "This script assumes sudo privileges."
sudo apt-get update -y
sudo apt-get install -y postgresql
sudo -u postgres psql -c "CREATE DATABASE healthcare;"
sudo -u postgres psql -d healthcare -f /vagrant/db/schema.sql || true
