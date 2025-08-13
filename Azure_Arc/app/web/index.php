<?php
$host = getenv('DB_HOST') ?: '127.0.0.1';
$db   = getenv('DB_NAME') ?: 'healthcare';
$user = getenv('DB_USER') ?: 'arc_user';
$pass = getenv('DB_PASS') ?: 'ArcDemoPass!';
$conn = pg_connect("host=$host dbname=$db user=$user password=$pass");
if (!$conn) { echo "DB connection failed"; exit; }
$res = pg_query($conn, "SELECT mrn, name, dob, riskscore FROM patients ORDER BY patientid LIMIT 10");
echo "<h1>Patient Portal (Synthetic Data)</h1>";
echo "<table border='1'><tr><th>MRN</th><th>Name</th><th>DOB</th><th>RiskScore</th></tr>";
while ($row = pg_fetch_assoc($res)) {
  echo "<tr><td>{$row['mrn']}</td><td>{$row['name']}</td><td>{$row['dob']}</td><td>{$row['riskscore']}</td></tr>";
}
echo "</table>";
?>
