<?php
$envPath = __DIR__ . "/../../config/.env";
$cfg = [];
if (file_exists($envPath)) {
  foreach (file($envPath, FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES) as $line) {
    if (strpos($line,'=') !== false) { list($k,$v) = explode('=',$line,2); $cfg[$k]= $v; }
  }
}
?>
<!doctype html>
<html><head><meta charset="utf-8"><title>Healthcare ACS Workshop</title></head>
<body>
  <h1>Healthcare Azure Container Services Workshop</h1>
  <ul>
    <li>Subscription: <?= htmlspecialchars($cfg['SUBSCRIPTION_ID'] ?? 'not set') ?></li>
    <li>Resource Group: <?= htmlspecialchars($cfg['RESOURCE_GROUP'] ?? 'not set') ?></li>
    <li>Location: <?= htmlspecialchars($cfg['LOCATION'] ?? 'not set') ?></li>
    <li>AKS: <?= htmlspecialchars($cfg['AKS_NAME'] ?? 'not set') ?></li>
    <li>ACR: <?= htmlspecialchars($cfg['ACR_NAME'] ?? 'not set') ?></li>
  </ul>
</body></html>
