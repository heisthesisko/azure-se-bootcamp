<?php
$config = include __DIR__.'/config.php'; $db=$config['db'];
$info=["Database"=>$db['dbname'],"UID"=>$db['user'],"PWD"=>$db['password']];
$conn=sqlsrv_connect($db['server'],$info); if(!$conn){die(print_r(sqlsrv_errors(),true));}
$stmt=sqlsrv_query($conn,"SELECT product_id, product_name FROM products ORDER BY product_id");
echo "<h2>Products (SQL Server)</h2><ul>";
while($row=sqlsrv_fetch_array($stmt,SQLSRV_FETCH_ASSOC)){echo "<li>{$row['product_id']}: ".htmlspecialchars($row['product_name'])."</li>";}
echo "</ul>"; sqlsrv_free_stmt($stmt); sqlsrv_close($conn);
