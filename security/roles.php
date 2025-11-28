<?php
// =========================================
// roles.php - Control de Roles Básico
// =========================================

/**
 * Función de utilidad para obtener el rol del usuario actual.
 * @return string|null El rol del usuario ('admin', 'anfitrion', 'huesped') o null si no hay sesión.
 */
function get_current_user_role() {
    // 1. Verificar si la sesión se ha iniciado
    if (session_status() == PHP_SESSION_NONE) {
        // En un entorno de producción, podrías iniciar la sesión aquí si fuera necesario
        // session_start(); 
        return null; 
    }

    // 2. Comprobar si la variable de sesión 'user_role' existe
    if (isset($_SESSION['user_role'])) {
        return $_SESSION['user_role'];
    }

    return null;
}

// ----------------------------------------------------------------------
// FUNCIONES DE VERIFICACIÓN DE ACCESO
// ----------------------------------------------------------------------

/**
 * Verifica si el usuario actual es un Administrador.
 * @return bool True si el rol es 'admin', False en caso contrario.
 */
function is_admin() {
    return get_current_user_role() === 'admin';
}

/**
 * Verifica si el usuario actual es un Anfitrión.
 * @return bool True si el rol es 'anfitrion', False en caso contrario.
 */
function is_anfitrion() {
    return get_current_user_role() === 'anfitrion';
}

/**
 * Verifica si el usuario actual es un Huésped.
 * @return bool True si el rol es 'huesped', False en caso contrario.
 */
function is_huesped() {
    return get_current_user_role() === 'huesped';
}

// ----------------------------------------------------------------------
// FUNCIÓN DE REDIRECCIÓN (GUARDIÁN)
// ----------------------------------------------------------------------

/**
 * Función de 'guardián' que asegura que solo ciertos roles accedan a la página.
 * Si el rol no está autorizado, redirige al usuario.
 *
 * @param array $allowed_roles Arreglo de roles permitidos (e.g., ['admin', 'soporte']).
 * @param string $redirect_url URL a la que se redirige si el acceso es denegado.
 */
function enforce_role_access(array $allowed_roles, string $redirect_url = '/denied.php') {
    $current_role = get_current_user_role();
    
    // Si no hay rol (usuario no logueado) o el rol no está en la lista de permitidos
    if (!$current_role || !in_array($current_role, $allowed_roles)) {
        header("Location: " . $redirect_url);
        exit(); // Es crucial usar exit() después de la redirección
    }
}