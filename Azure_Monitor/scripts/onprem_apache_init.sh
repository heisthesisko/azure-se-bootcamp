#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update && sudo apt-get install -y apache2 php libapache2-mod-php
sudo mkdir -p /var/www/html/portal
sudo tee /var/www/html/portal/index.php >/dev/null <<'PHP'
<?php
  date_default_timezone_set('UTC');
  $ip = $_SERVER['REMOTE_ADDR'];
  $ts = date('c');
  error_log("[ACCESS] $ts from $ip");
  echo "<h1>Healthcare Portal</h1><p>Time: $ts</p>";
?>
PHP
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php >/dev/null
sudo a2enmod status && sudo systemctl restart apache2
echo "Apache/PHP portal ready."
