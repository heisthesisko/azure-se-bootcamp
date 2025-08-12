<?php
// index.php — simple upload form
?>
<html><body>
<h2>Upload an image</h2>
<form action="upload.php" method="post" enctype="multipart/form-data">
  <input type="file" name="image" accept="image/*" required>
  <input type="submit" value="Upload">
</form>
<p><a href="view_images.php">View uploaded images</a></p>
</body></html>
