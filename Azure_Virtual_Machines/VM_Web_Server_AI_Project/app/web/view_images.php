<?php
// view_images.php — lists images + prediction summary
$conn = pg_connect("host=<DB_PRIVATE_IP> dbname=imagedb user=postgres password=YourPassword");
if (!$conn) { http_response_code(500); echo "DB connection failed."; exit; }

$res = pg_query($conn, "SELECT uploaded_at, img_data, top_label, top_confidence FROM images ORDER BY uploaded_at DESC");

echo "<h2>Uploaded Images</h2>";
while ($row = pg_fetch_assoc($res)) {
    $img = base64_encode(pg_unescape_bytea($row['img_data']));
    $label = htmlspecialchars($row['top_label'] ?? 'n/a');
    $conf  = isset($row['top_confidence']) ? number_format((float)$row['top_confidence'], 3) : 'n/a';

    echo "<div style='margin-bottom:20px'>";
    echo "<div><strong>{$label}</strong> (conf: {$conf}) — " . htmlspecialchars($row['uploaded_at']) . "</div>";
    echo "<img style='max-width:400px' src='data:image/jpeg;base64,{$img}' />";
    echo "</div>";
}
?>
