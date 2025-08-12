<?php
// upload.php — receives image, calls AI microservice, stores results in PostgreSQL
// NOTE: placeholders <DB_PRIVATE_IP> and <AI_PRIVATE_IP> will be replaced by infra script

if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo "Upload failed.";
    exit;
}

$imagePath = $_FILES['image']['tmp_name'];
$imageData = file_get_contents($imagePath);

$conn = pg_connect("host=<DB_PRIVATE_IP> dbname=imagedb user=postgres password=YourPassword");
if (!$conn) {
    http_response_code(500);
    echo "DB connection failed.";
    exit;
}

// Call AI service
$ch = curl_init();
curl_setopt_array($ch, [
    CURLOPT_URL => "http://<AI_PRIVATE_IP>:5000/analyze",
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => ['image' => new CURLFILE($imagePath)],
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 20
]);
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($httpCode !== 200 || $response === false) {
    http_response_code(502);
    echo "AI service call failed.";
    exit;
}

$ai = json_decode($response, true);
$topLabel = $ai['top_label'] ?? null;
$topConfidence = $ai['predictions'][0]['confidence'] ?? null;
$predictionsJson = json_encode($ai);

// Store in DB
$sql = "INSERT INTO images (img_data, top_label, top_confidence, predictions)
        VALUES ($1, $2, $3, $4)";
$result = pg_query_params($conn, $sql, array($imageData, $topLabel, $topConfidence, $predictionsJson));

if ($result) {
    echo "Uploaded. Top label: " . htmlspecialchars($topLabel) .
         " (confidence: " . htmlspecialchars((string)$topConfidence) . ")";
} else {
    http_response_code(500);
    echo "Insert failed: " . pg_last_error($conn);
}
?>
