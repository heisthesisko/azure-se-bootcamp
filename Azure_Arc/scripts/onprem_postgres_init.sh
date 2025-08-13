#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib

sudo -u postgres psql -c "CREATE USER ${DB_USER:-arc_user} WITH PASSWORD '${DB_PASS:-ArcDemoPass!}';" || true
sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME:-healthcare} OWNER ${DB_USER:-arc_user};" || true

cat <<SQL | sudo -u postgres psql -d ${DB_NAME:-healthcare}
CREATE TABLE IF NOT EXISTS Patients (
  PatientId SERIAL PRIMARY KEY,
  MRN VARCHAR(32) NOT NULL,
  Name VARCHAR(100),
  DOB DATE,
  RiskScore NUMERIC
);
INSERT INTO Patients (MRN, Name, DOB, RiskScore) VALUES
('TST0001','Jane Doe','1985-02-12', 0.22),
('TST0002','John Smith','1978-11-03', 0.37)
ON CONFLICT DO NOTHING;
SQL

echo "listen_addresses='*'" | sudo tee -a /etc/postgresql/*/main/postgresql.conf
echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
sudo systemctl restart postgresql
echo "PostgreSQL ready."
