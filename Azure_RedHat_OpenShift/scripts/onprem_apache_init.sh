#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y apache2 libapache2-mod-php php php-pgsql
sudo a2enmod php* || true
sudo systemctl enable --now apache2
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/index.php
echo "Apache/PHP installed."
