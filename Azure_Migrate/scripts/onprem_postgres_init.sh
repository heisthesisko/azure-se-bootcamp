#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE USER pgadmin WITH PASSWORD 'P@ssword12345!';"
sudo -u postgres psql -c "CREATE DATABASE healthdb OWNER pgadmin;"
sudo -u postgres psql -d healthdb -f /vagrant/db/schema.sql 2>/dev/null || true
# Seed synthetic data
sudo -u postgres psql -d healthdb -c "INSERT INTO patients (mrn, first_name, last_name, dob, condition_code) VALUES ('MRN001','Test','Patient','1980-01-01','I10');"
echo "PostgreSQL initialized with synthetic data."
