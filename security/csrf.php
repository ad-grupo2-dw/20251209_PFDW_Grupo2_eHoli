<?php
//if (session_status() == PHP_SESSION_NONE) session_start();

function generar_csrf() {
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function validar_csrf($token) {
    return hash_equals($_SESSION['csrf_token'], $token);
}
?>
