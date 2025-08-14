<?php
// Simple PHP demo: reads patients from PostgreSQL if env vars provided.
$dsn = getenv('DB_DSN') ?: 'pgsql:host=localhost;port=5432;dbname=patients';
$user = getenv('DB_USER') ?: 'clinic';
$pass = getenv('DB_PASS') ?: 'clinicpass';
header('Content-Type: text/html; charset=utf-8');
echo "<h1>Healthcare Portal (Demo)</h1>";
echo "<p>FHIR-style patient list (synthetic data)</p>";
try {
  $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
  $rows = $pdo->query("SELECT patient_id, first_name, last_name, dob, member_id FROM patients LIMIT 25")->fetchAll(PDO::FETCH_ASSOC);
  echo "<table border='1' cellpadding='6'><tr><th>ID</th><th>First</th><th>Last</th><th>DOB</th><th>Member</th></tr>";
  foreach ($rows as $r) {
    printf("<tr><td>%d</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
      $r['patient_id'], htmlspecialchars($r['first_name']), htmlspecialchars($r['last_name']),
      htmlspecialchars($r['dob']), htmlspecialchars($r['member_id']));
  }
  echo "</table>";
} catch (Exception $e) {
  echo "<pre>DB not available yet. Set DB_DSN/DB_USER/DB_PASS envs. Error: " . htmlspecialchars($e->getMessage()) . "</pre>";
}
?>
