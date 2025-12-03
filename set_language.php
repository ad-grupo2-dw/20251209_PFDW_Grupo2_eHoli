<?php
// set_language.php
session_start();

$idioma_valido = ['es', 'en'];

$new_lang = $_GET['lang'] ?? '';

if (in_array($new_lang, $idioma_valido)) {
    $_SESSION['lang'] = $new_lang;
}

// Redirigir al usuario de vuelta a la página donde estaba
$referrer = $_SERVER['HTTP_REFERER'] ?? '/index.php';
header("Location: " . $referrer);
exit;
?>