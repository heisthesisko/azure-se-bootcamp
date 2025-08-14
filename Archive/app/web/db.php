<?php
$host = getenv("DB_HOST") ?: "127.0.0.1";
$port = getenv("DB_PORT") ?: "5432";
$db   = getenv("DB_NAME") ?: "healthdb";
$user = getenv("DB_USER") ?: "workshop";
$pass = getenv("DB_PASSWORD") ?: "ChangeMeStrong!";
$dsn = "pgsql:host=$host;port=$port;dbname=$db;";
try {
  $options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
  ];
  $pdo = new PDO($dsn, $user, $pass, $options);
} catch (Exception $e) {
  http_response_code(500);
  echo "Database connection error.";
  error_log("DB error: " . $e->getMessage());
  exit;
}
?>
