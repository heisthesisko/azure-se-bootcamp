<?php
// Minimal PHP patient/study listing for workshop verification.
// For demo only; do not deploy to production without hardening.
$dbhost = getenv('PGHOST') ?: '127.0.0.1';
$dbport = getenv('PGPORT') ?: '5432';
$dbname = getenv('PGDATABASE') ?: 'workshopdb';
$dbuser = getenv('PGUSER') ?: 'workshop';
$dbpass = getenv('PGPASSWORD') ?: 'workshop';

try {
    $dsn = "pgsql:host={$dbhost};port={$dbport};dbname={$dbname};";
    $pdo = new PDO($dsn, $dbuser, $dbpass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo "<h1>Database connection failed</h1>";
    echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>";
    exit;
}

$patients = $pdo->query("SELECT patient_id, mrn, given_name, family_name, dob FROM patients ORDER BY patient_id DESC LIMIT 50")->fetchAll(PDO::FETCH_ASSOC);
?>
<!doctype html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Healthcare Backup Workshop – Patient Index</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 2rem; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background: #f3f3f3; }
        code { background: #f7f7f7; padding: 2px 4px; }
    </style>
</head>
<body>
    <h1>Healthcare Backup Workshop – Patient Index</h1>
    <p>This simple PHP page retrieves patients from PostgreSQL to create application data you can back up with Azure Backup.</p>
    <h2>Patients</h2>
    <table>
        <thead><tr><th>ID</th><th>MRN</th><th>Name</th><th>DOB</th></tr></thead>
        <tbody>
        <?php foreach ($patients as $p): ?>
            <tr>
                <td><?= htmlspecialchars($p['patient_id']) ?></td>
                <td><?= htmlspecialchars($p['mrn']) ?></td>
                <td><?= htmlspecialchars($p['given_name'] . ' ' . $p['family_name']) ?></td>
                <td><?= htmlspecialchars($p['dob']) ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
    <p><small>Tip: Use <code>scripts/onprem_apache_init.sh</code> to set this up on your on‑prem Linux VM.</small></p>
</body>
</html>
