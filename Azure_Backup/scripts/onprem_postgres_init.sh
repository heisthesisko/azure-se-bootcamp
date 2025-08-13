#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE USER workshop WITH PASSWORD 'workshop';"
sudo -u postgres psql -c "CREATE DATABASE workshopdb OWNER workshop;"
sudo -u postgres psql -d workshopdb -f /vagrant/db/schema.sql || true
echo 'listen_addresses = *' | sudo tee -a /etc/postgresql/*/main/postgresql.conf
echo 'host all all 0.0.0.0/0 md5' | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
sudo systemctl restart postgresql
echo "export PGHOST=127.0.0.1 PGUSER=workshop PGPASSWORD=workshop PGDATABASE=workshopdb PGPORT=5432" | sudo tee /etc/profile.d/pg.sh
