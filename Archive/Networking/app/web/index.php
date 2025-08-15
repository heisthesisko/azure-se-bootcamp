<?php $host=gethostname(); $ip=$_SERVER['SERVER_ADDR']??'unknown'; header('Content-Type: text/plain'); echo "Hello from PHP on $host ($ip)\n"; ?>
