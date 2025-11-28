<?php
$password_clara = "hsAD123"; // 🔑 ¡Tu contraseña real de administrador!
$hash_nuevo = password_hash($password_clara, PASSWORD_DEFAULT);
echo "<h1>NUEVO HASH</h1>";
echo "<p>Contraseña: " . $password_clara . "</p>";
echo "<p>Hash Generado: <strong>" . $hash_nuevo . "</strong></p>";
?>