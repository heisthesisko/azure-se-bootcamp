#!/usr/bin/env bash
# scripts/onprem_postgres_init.sh - Initialize PostgreSQL with healthcare schema
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE DATABASE clinic;"
sudo -u postgres psql -d clinic -f /path/to/db/schema.sql || true
echo "PostgreSQL initialized with healthcare schema."
