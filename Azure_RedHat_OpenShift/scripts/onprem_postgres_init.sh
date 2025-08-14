#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE USER clinic WITH PASSWORD 'clinicpass';"
sudo -u postgres psql -c "CREATE DATABASE patients OWNER clinic;"
sudo -u postgres psql -d patients -c "CREATE TABLE checkin(id SERIAL PRIMARY KEY, name TEXT);"
sudo -u postgres psql -d patients -c "INSERT INTO checkin(name) VALUES ('Alice'),('Bob');"
echo "PostgreSQL initialized with synthetic data."
