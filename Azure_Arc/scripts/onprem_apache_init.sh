#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y apache2 php php-pgsql

sudo mkdir -p /var/www/html/arc
sudo cp -r app/web/* /var/www/html/arc/ || true
sudo chown -R www-data:www-data /var/www/html/arc
sudo a2enmod php* >/dev/null 2>&1 || true
sudo systemctl restart apache2
IP=$(hostname -I | awk '{print $1}')
echo "Apache/PHP deployed at http://$IP/arc/"
