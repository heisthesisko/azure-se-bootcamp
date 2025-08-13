<?php
// Simple PHP page to read patients from Azure PostgreSQL / on-prem PostgreSQL
// Use env vars for DB connection
$host = getenv('DB_HOST') ?: '127.0.0.1';
$port = getenv('DB_PORT') ?: '5432';
$db   = getenv('DB_NAME') ?: 'healthdb';
$user = getenv('DB_USER') ?: 'pgadmin';
$pass = getenv('DB_PASS') ?: 'P@ssword12345!';

try {
    $dsn = "pgsql:host=$host;port=$port;dbname=$db";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $stmt = $pdo->query('SELECT mrn, first_name, last_name, dob, condition_code FROM patients ORDER BY patient_id DESC LIMIT 20');
    echo "<h1>Healthcare Demo – Patients</h1><table border='1' cellpadding='6'><tr><th>MRN</th><th>Name</th><th>DOB</th><th>Condition</th></tr>";
    foreach ($stmt as $row) {
        $name = htmlspecialchars($row['first_name'].' '.$row['last_name']);
        $mrn = htmlspecialchars($row['mrn']);
        $dob = htmlspecialchars($row['dob']);
        $cc = htmlspecialchars($row['condition_code']);
        echo "<tr><td>$mrn</td><td>$name</td><td>$dob</td><td>$cc</td></tr>";
    }
    echo "</table>";
    echo "<p>HIPAA Notice: This page uses synthetic data only.</p>";
} catch (Exception $e) {
    http_response_code(500);
    echo "Error: " . htmlspecialchars($e->getMessage());
}
?>
