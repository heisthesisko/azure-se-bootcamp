#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y apache2 php libapache2-mod-php php-pgsql
sudo mkdir -p /var/www/html/app
sudo cp -r ./app/web/* /var/www/html/app/
echo "export DB_HOST=127.0.0.1" | sudo tee /etc/apache2/envvars.dbenv >/dev/null
sudo systemctl restart apache2
echo "Apache/PHP deployed sample app."
