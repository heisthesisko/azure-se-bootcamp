#!/usr/bin/env bash
# Run on the PG VMs after SSH (sudo)
# Usage:
#   primary: sudo bash ~/db-setup.sh primary
#   replica: sudo bash ~/db-setup.sh replica <PRIMARY_PRIVATE_IP>
set -euo pipefail

ROLE=${1:-}
PRIMARY_IP=${2:-}

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-contrib

if [[ "$ROLE" == "primary" ]]; then
  PGCONF="/etc/postgresql/14/main/postgresql.conf"
  PHBA="/etc/postgresql/14/main/pg_hba.conf"
  sed -i "s/^#\?listen_addresses.*/listen_addresses = '*'/" "$PGCONF"
  echo "host all all 0.0.0.0/0 md5" >> "$PHBA"
  systemctl restart postgresql

  # Schema
  sudo -u postgres psql -c "CREATE ROLE replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'replicatorpass';" || true
  sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='imagedb'" | grep -q 1 || sudo -u postgres createdb imagedb
  sudo -u postgres psql -d imagedb -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
  if [[ -f ~/schema.sql ]]; then
    sudo -u postgres psql -f ~/schema.sql
  fi
  echo "Primary configured."

elif [[ "$ROLE" == "replica" ]]; then
  if [[ -z "$PRIMARY_IP" ]]; then
    echo "Usage: replica <PRIMARY_PRIVATE_IP>"
    exit 1
  fi
  systemctl stop postgresql
  rm -rf /var/lib/postgresql/14/main/*
  sudo -u postgres pg_basebackup -h "$PRIMARY_IP" -D /var/lib/postgresql/14/main -U replicator -P -v --wal-method=stream
  chown -R postgres:postgres /var/lib/postgresql/14/main
  cat >/var/lib/postgresql/14/main/recovery.conf <<EOR
standby_mode = 'on'
primary_conninfo = 'host=$PRIMARY_IP port=5432 user=replicator password=replicatorpass'
trigger_file = '/tmp/promote_to_primary'
EOR
  chmod 600 /var/lib/postgresql/14/main/recovery.conf
  systemctl start postgresql
  echo "Replica configured."

else
  echo "Specify role: primary | replica"
  exit 1
fi
