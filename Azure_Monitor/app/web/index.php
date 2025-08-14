<?php
  // Simple PHP sample, suitable for Azure App Service
  date_default_timezone_set('UTC');
  $ts = date('c');
  $client = $_SERVER['REMOTE_ADDR'];
  error_log("[WEB] hit at $ts from $client");
?>
<html>
<head><title>Azure Monitor Healthcare Workshop</title></head>
<body>
  <h1>Patient Portal (Demo)</h1>
  <p>Time: <?php echo htmlspecialchars($ts); ?></p>
  <p>Status: OK</p>
</body>
</html>
