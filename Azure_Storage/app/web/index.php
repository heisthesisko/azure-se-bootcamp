
<?php
$sas_file = __DIR__ . "/.sas_url.txt";
if (!file_exists($sas_file)) { die("Missing .sas_url.txt. Run scripts/05_sas.sh first."); }
$line = trim(array_slice(file($sas_file), -1)[0]);
$parts = explode(":", $line, 2);
$sas_url = trim($parts[1]);
$xml = @simplexml_load_string(file_get_contents($sas_url . "&restype=container&comp=list"));
?>
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>Blob Browser</title></head>
<body>
<h1>Blob Container Listing</h1>
<p>Container SAS: <?php echo htmlspecialchars($sas_url); ?></p>
<table border="1" cellpadding="6" cellspacing="0">
<tr><th>Name</th><th>URL</th><th>Last Modified</th><th>Size</th></tr>
<?php if ($xml && $xml->Blobs && $xml->Blobs->Blob): foreach ($xml->Blobs->Blob as $blob): ?>
<tr>
  <td><?php echo htmlspecialchars((string)$blob->Name); ?></td>
  <td><a href="<?php echo htmlspecialchars($sas_url . '/' . (string)$blob->Name); ?>" target="_blank">Open</a></td>
  <td><?php echo htmlspecialchars((string)$blob->Properties->{"Last-Modified"}); ?></td>
  <td><?php echo htmlspecialchars((string)$blob->Properties->{"Content-Length"}); ?></td>
</tr>
<?php endforeach; else: ?>
<tr><td colspan="4">No blobs or failed to list.</td></tr>
<?php endif; ?>
</table>
</body></html>
