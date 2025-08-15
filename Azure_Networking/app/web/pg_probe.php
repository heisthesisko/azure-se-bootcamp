<?php
require_once("db.php");
$host = getenv('PGHOST') ?: 'localhost';
$port = getenv('PGPORT') ?: '5432';
$db   = getenv('PGDATABASE') ?: 'appdb';
$user = getenv('PGUSER') ?: 'pgadmin';
$pass = getenv('PGPASSWORD') ?: 'password';
try {
  $conn = pg_connect_or_die($host,$port,$db,$user,$pass);
  $res = pg_query($conn, "SELECT NOW() as ts");
  $row = pg_fetch_assoc($res);
  echo "PostgreSQL connectivity OK at: " . $row['ts'];
  pg_close($conn);
} catch (Exception $e) {
  echo "Error: " . $e->getMessage();
}
