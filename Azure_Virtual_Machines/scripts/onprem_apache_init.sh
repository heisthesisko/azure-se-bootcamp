#!/usr/bin/env bash
# scripts/onprem_apache_init.sh - Install Apache + PHP for local web app
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y apache2 libapache2-mod-php php-pgsql
sudo a2enmod php* || true
sudo systemctl enable --now apache2
echo "Apache with PHP installed. Deploy your app/web files to /var/www/html"
