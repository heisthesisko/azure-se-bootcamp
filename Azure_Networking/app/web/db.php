<?php
// db.php - simple Postgres connector using env vars
$host = getenv('PGHOST') ?: 'localhost';
$port = getenv('PGPORT') ?: '5432';
$db   = getenv('PGDATABASE') ?: 'appdb';
$user = getenv('PGUSER') ?: 'pgadmin';
$pass = getenv('PGPASSWORD') ?: 'password';
function pg_connect_or_die($host,$port,$db,$user,$pass) {
  $conn_str = "host=$host port=$port dbname=$db user=$user password=$pass sslmode=require";
  $conn = pg_connect($conn_str);
  if (!$conn) { die("Connection failed: " . pg_last_error()); }
  return $conn;
}
