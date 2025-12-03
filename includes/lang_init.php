<?php
// includes/lang_init.php

// 1. Iniciar Sesión si no está iniciada
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// 2. Definir el idioma por defecto (fallback)
$default_lang = 'es';

// 3. Obtener el idioma de la sesión o establecer el por defecto
if (isset($_SESSION['lang']) && in_array($_SESSION['lang'], ['es', 'en'])) {
    $current_lang = $_SESSION['lang'];
} else {
    $current_lang = $default_lang;
    $_SESSION['lang'] = $default_lang; // Establecer el idioma por defecto en la sesión
}

// 4. Cargar el archivo de idioma
$lang_file = __DIR__ . '/../lan/' . $current_lang . '.php';

if (file_exists($lang_file)) {
    // Esto carga el array $lang definido en el archivo de idioma.
    require_once $lang_file; 
} else {
    // Fallback: Si el archivo de idioma seleccionado no existe, cargar el por defecto.
    require_once __DIR__ . '/../lan/' . $default_lang . '.php'; 
}
?>