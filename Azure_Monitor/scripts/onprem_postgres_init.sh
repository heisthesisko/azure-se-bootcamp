#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y postgresql
sudo -u postgres psql -c "CREATE DATABASE ehr;"
sudo -u postgres psql -d ehr -c "CREATE TABLE patients(id serial PRIMARY KEY, mrn varchar(32), name text, dob date);"
sudo -u postgres psql -d ehr -c "INSERT INTO patients(mrn,name,dob) VALUES ('MRN001','Test Patient','1970-01-01');"
echo "log_line_prefix='%m %u %d [%p] '">> /etc/postgresql/*/main/postgresql.conf
echo "logging_collector=on" >> /etc/postgresql/*/main/postgresql.conf
sudo systemctl restart postgresql
echo "PostgreSQL initialized with sample schema and logging."
