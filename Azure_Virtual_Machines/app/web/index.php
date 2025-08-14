<?php
// app/web/index.php - Simple PHP page reading synthetic patient data from PostgreSQL
// Use environment variables for DB connection (never hard-code secrets).
$host = getenv('DB_HOST') ?: '127.0.0.1';
$port = getenv('DB_PORT') ?: '5432';
$db   = getenv('DB_NAME') ?: 'postgres';
$user = getenv('DB_USER') ?: 'postgres';
$pass = getenv('DB_PASS') ?: '';

$conn_str = "host=$host port=$port dbname=$db user=$user password=$pass";
$conn = pg_connect($conn_str);
if (!$conn) {
    echo "<h2>Database connection failed</h2>";
    die();
}

$result = pg_query($conn, "SELECT patient_id, mrn, first_name, last_name, date_of_birth FROM healthcare.patients ORDER BY patient_id DESC LIMIT 20");
echo "<h1>Healthcare Patient Listing (Synthetic Data)</h1>";
echo "<table border='1' cellpadding='6'><tr><th>ID</th><th>MRN</th><th>Name</th><th>DOB</th></tr>";
while ($row = pg_fetch_assoc($result)) {
    $name = htmlspecialchars($row['first_name'] . ' ' . $row['last_name']);
    echo "<tr><td>{$row['patient_id']}</td><td>{$row['mrn']}</td><td>{$name}</td><td>{$row['date_of_birth']}</td></tr>";
}
echo "</table>";
pg_close($conn);
?>
