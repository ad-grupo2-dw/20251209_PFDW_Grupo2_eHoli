<?php
// ... con la comprobación de estado:
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// ... El resto del código de seguridad (funciones CSRF, etc.)
// Verifica si el usuario inició sesión
function verificar_login() {
    if (!isset($_SESSION['usuario_id'])) {
        header('Location: /login.php');
        exit();
    }
}

// Verifica acceso según rol requerido
function verificar_rol($rol_requerido) {
    verificar_login();
    if ($_SESSION['rol'] !== $rol_requerido) {
        header('Location: /index.php?error=acceso');
        exit();
    }
}

// Para permitir varios roles en una página:
function verificar_multiples_roles($roles_permitidos = []) {
    verificar_login();
    if (!in_array($_SESSION['rol'], $roles_permitidos)) {
        header('Location: /index.php?error=acceso');
        exit();
    }
}
?>
