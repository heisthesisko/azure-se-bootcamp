#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y apache2 php php-cli php-curl
sudo mkdir -p /var/www/html/app
sudo cp -r /vagrant/app/web/* /var/www/html/app/ || true
echo "SetEnv BLOB_ACCOUNT youraccount" | sudo tee -a /etc/apache2/conf-available/training.conf
echo "SetEnv WEB_SAS yourSAS" | sudo tee -a /etc/apache2/conf-available/training.conf
echo "SetEnv BLOB_CONTAINER phi" | sudo tee -a /etc/apache2/conf-available/training.conf
sudo a2enconf training || true
sudo systemctl reload apache2
