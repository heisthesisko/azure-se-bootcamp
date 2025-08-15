<?php
$config = include __DIR__.'/config.php'; $db=$config['db'];
$conn=new PDO("pgsql:host={$db['host']};port={$db['port']};dbname={$db['dbname']}",$db['user'],$db['password']);
$rows=$conn->query("SELECT product_id, product_name FROM products ORDER BY product_id")->fetchAll(PDO::FETCH_ASSOC);
?><h2>Products (PostgreSQL A2A)</h2><ul><?php foreach($rows as $r){echo "<li>{$r['product_id']}: ".htmlspecialchars($r['product_name'])."</li>";} ?></ul>
