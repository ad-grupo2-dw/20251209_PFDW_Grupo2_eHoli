<?php
require_once __DIR__.'/config/auth.php';

session_start();
$_SESSION = [];
session_unset();
session_destroy();
// Regenerar ID al logout por seguridad
session_start();
session_regenerate_id(true);
header('Location: login.php?logout=1');
exit();
?>
