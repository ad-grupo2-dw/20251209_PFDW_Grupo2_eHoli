<?php
// ==========================================================
// auth.php - Lógica de Autenticación y Control de Roles (Revisado)
// ==========================================================

// Iniciar sesión si aún no está iniciada
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
// Asegúrate de que 'db.php' provee una variable $pdo (objeto PDO)
require_once __DIR__ . '/config.php';

// Función para verificar inicio de sesión
function usuario_logueado() {
    // Se estandariza el nombre de la variable de sesión
    return isset($_SESSION['user_id']); 
}

// ----------------------------------------------------------
// 🔑 LOGIN Y ASIGNACIÓN DE ROL
// ----------------------------------------------------------

// Login
function login($email, $password) {
    // 💡 CAMBIO 1: Crea la conexión usando la clase Database
    $database = new Database();
    $conn = $database->getConnection(); // $conn ahora es tu objeto PDO

    // Si la conexión falló en el constructor (aunque solo mostraría un echo)
    if ($conn === null) {
        return false; 
    }

    // 💡 CAMBIO 2: Reemplazamos $pdo por $conn
    $sql = "SELECT id, password, rol FROM usuarios WHERE email = ? AND estado = 'activo'";
    $stmt = $conn->prepare($sql); 
    $stmt->execute([$email]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

    // ... (el resto de la lógica de login, ya es correcta)
    if ($usuario && password_verify($password, $usuario['password'])) {
        
        $_SESSION['user_id'] = $usuario['id'];
        $_SESSION['user_role'] = $usuario['rol']; 

        session_regenerate_id(true);
        
        return true; 
    }

    return false;
}

// ----------------------------------------------------------
// 🛡️ VERIFICACIÓN DE ROLES ESPECÍFICOS
// ----------------------------------------------------------

function get_current_user_role() {
    // Devuelve el rol guardado en la sesión o 'invitado' si no hay sesión
    return $_SESSION['user_role'] ?? 'invitado';
}

function es_admin() {
    return get_current_user_role() === 'admin';
}

function es_anfitrion() {
    return get_current_user_role() === 'anfitrion';
}

function es_huesped() {
    return get_current_user_role() === 'huesped';
}

// ----------------------------------------------------------
// 🚨 FUNCIÓN DE 'GUARDIÁN' CENTRALIZADA
// ----------------------------------------------------------

/**
 * Función que restringe el acceso a la página a una lista de roles permitidos.
 * Si el usuario no tiene el rol, es redirigido.
 *
 * @param array $allowed_roles Roles que tienen permiso de acceso (ej. ['admin', 'soporte']).
 * @param string $redirect_url URL de destino si el acceso es denegado (ej. /login.php).
 */
function enforce_role_access(array $allowed_roles, string $redirect_url = '/login.php') {
    $current_role = get_current_user_role();
    
    // Si el usuario no está logueado, redirigir al login
    if ($current_role === 'invitado') {
        header("Location: " . $redirect_url);
        exit;
    }

    // Si el rol actual no está en la lista de roles permitidos
    if (!in_array($current_role, $allowed_roles)) {
        // Redireccionar al dashboard correspondiente o a una página de error
        switch ($current_role) {
            case 'anfitrion':
                header("Location: ../anfitrion/dashboard.php");
                break;
            case 'huesped':
                header("Location: ../huesped/dashboard.php");
                break;
            default:
                header("Location: /acceso_denegado.php");
                break;
        }
        exit;
    }
}

// --- Otras funciones (Registro, Flash, Logout) ---

// Tu función anterior de Redirección (solo_admin) puede ser eliminada
// y reemplazada por enforce_role_access(['admin']).

// Registro seguro
function registrar_usuario($nombre, $email, $password, $rol = 'huesped') {
    global $pdo;
    $hash = password_hash($password, PASSWORD_DEFAULT);
    
    // Usamos 'huesped' como rol por defecto
    $sql = "INSERT INTO usuarios (rol, nombre, email, password, estado) VALUES (?, ?, ?, ?, 'activo')";
    $stmt = $pdo->prepare($sql);
    
    // Se añade el rol en el registro
    return $stmt->execute([$rol, $nombre, $email, $hash]);
}

// Guardar mensaje flash
function set_flash($msg, $tipo='info') {
    $_SESSION['flash'] = ['msg' => $msg, 'tipo' => $tipo];
}

// Mostrar y limpiar mensaje flash
function mostrar_flash() {
    if (isset($_SESSION['flash'])) {
        $tipo = $_SESSION['flash']['tipo'];
        // Se asegura el escape para prevenir XSS
        $msg = htmlspecialchars($_SESSION['flash']['msg'], ENT_QUOTES, 'UTF-8'); 
        echo "<div class='flash {$tipo}'>$msg</div>";
        unset($_SESSION['flash']);
    }
}

// Cierre de sesión
function logout() {
    session_unset();
    session_destroy();
}
?>