#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y apache2 libapache2-mod-php php php-pgsql
sudo a2enmod php* rewrite
sudo cp -r /vagrant/app/web/* /var/www/html/
sudo cp /vagrant/system/apache-vhost.conf /etc/apache2/sites-available/000-default.conf
sudo systemctl restart apache2
