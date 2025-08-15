<?php
// Training portal landing page for Azure Networking for Healthcare
// This page shows environment info (no PHI) and links to simple checks
header('Content-Type: text/html; charset=utf-8');
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Healthcare Networking Lab - PHP</title>
</head>
<body>
  <h1>Healthcare Networking Lab (PHP)</h1>
  <ul>
    <li><a href="phpinfo.php">PHP Info</a></li>
    <li><a href="fhir_probe.php">FHIR Probe (mock)</a></li>
    <li><a href="pg_probe.php">PostgreSQL Connectivity Check</a></li>
  </ul>
  <p><strong>Note:</strong> Training only. Do not upload real PHI. Use mock data.</p>
</body>
</html>
