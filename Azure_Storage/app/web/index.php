<?php
$container = getenv('BLOB_CONTAINER') ?: 'phi';
$account = getenv('BLOB_ACCOUNT') ?: '';
$sas = getenv('WEB_SAS') ?: '';
$maxMb = getenv('PHP_UPLOAD_MAX_MB') ?: 10;
?>
<!doctype html><html><head><meta charset="utf-8"><title>Healthcare Uploader (Training)</title><meta name="viewport" content="width=device-width, initial-scale=1"></head>
<body>
<h1>Healthcare Training Uploader</h1>
<p>Uploads go to container <strong><?php echo htmlspecialchars($container); ?></strong> on account <strong><?php echo htmlspecialchars($account); ?></strong>.</p>
<?php if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])): ?>
<?php
$file = $_FILES['file']['tmp_name'];
$name = basename($_FILES['file']['name']);
if ($_FILES['file']['size'] > $maxMb * 1024 * 1024) {
  echo "<p>File too large. Max {$maxMb}MB.</p>";
} elseif (!$account || !$sas) {
  echo "<p>Missing BLOB_ACCOUNT or WEB_SAS env vars.</p>";
} else {
  $url = "https://{$account}.blob.core.windows.net/{$container}/" . rawurlencode($name) . "?{$sas}";
  $fp = fopen($file, 'r');
  $ch = curl_init($url);
  curl_setopt($ch, CURLOPT_PUT, true);
  curl_setopt($ch, CURLOPT_INFILE, $fp);
  curl_setopt($ch, CURLOPT_INFILESIZE, filesize($file));
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['x-ms-blob-type: BlockBlob']);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $resp = curl_exec($ch);
  $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  curl_close($ch); fclose($fp);
  if ($code >= 200 && $code < 300) { echo "<p>Upload OK: {$name}</p>"; }
  else { echo "<p>Upload failed ({$code}): " . htmlspecialchars($resp) . "</p>"; }
}
?>
<?php endif; ?>
<form method="post" enctype="multipart/form-data"><input type="file" name="file" required><button type="submit">Upload</button></form>
<blockquote><strong>Training note:</strong> Use SAS with minimal permissions and short expiry.</blockquote>
</body></html>
