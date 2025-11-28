<?php
// ===========================================
// INCLUSIONES
// ===========================================
require_once __DIR__ . '/config/auth.php';
require_once __DIR__ . '/security/csrf.php';
// Asegúrate de que este archivo existe y contiene safe_output()
require_once __DIR__ . '/includes/functions.php'; 
require_once __DIR__ . '/includes/header.php';
// Asegúrate de que 'Database.php' esté disponible si no está en header.php

// ===========================================
// LÓGICA DE PROCESAMIENTO
// ===========================================

// 1. GENERAR TOKEN CSRF antes de mostrar el formulario
// Asume que generar_csrf() está en security/csrf.php
$csrf_token = generar_csrf(); 

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    // 2. CORREGIR VALIDACIÓN CSRF: Usar ?? para asegurar string
    $token_recibido = $_POST['csrf_token'] ?? '';
    if (!validar_csrf($token_recibido)) {
        $error = 'Error de validación. Intenta nuevamente.';
    } else {
        // Inicializar la conexión DENTRO de la acción POST
        $database = new Database();
        $conn = $database->getConnection();
        
        // Saneamiento y recolección de datos
        $nombre = trim($_POST['nombre']);
        $apellido = trim($_POST['apellido']);
        $email = trim($_POST['email']);
        $telefono = trim($_POST['telefono']);
        $password = $_POST['password'];
        $rol = 'huesped'; 

        // 3. Validar Contraseña (Patrón mejorado)
        // La contraseña debe tener al menos 8 caracteres y contener una letra Y un número.
        if (strlen($password) < 8 || !preg_match('/[A-Za-z]/', $password) || !preg_match('/[0-9]/', $password)) {
            $error = 'La contraseña debe tener al menos 8 caracteres, contener al menos una letra y un número.';
        } 
        
        // 4. Validar Email y Campos Vacíos Básicos
        elseif (empty($nombre) || empty($apellido) || empty($email) || empty($telefono) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $error = 'Por favor, completa todos los campos correctamente.';
        }
        
        else {
            $passwordHash = password_hash($password, PASSWORD_DEFAULT);
            
            // Usar marcadores de posición con nombre (PDO)
            $query = "INSERT INTO usuarios (nombre, apellido, email, password, telefono, rol) 
                      VALUES (:nombre, :apellido, :email, :password_hash, :telefono, :rol)";
            $stmt = $conn->prepare($query);
            
            try {
                $stmt->execute([
                    ':nombre' => $nombre,
                    ':apellido' => $apellido,
                    ':email' => $email,
                    ':password_hash' => $passwordHash, // Usar un nombre de marcador distinto del valor
                    ':telefono' => $telefono,
                    ':rol' => $rol
                ]);
                header('Location: login.php?registrado=1');
                exit();
            } catch (PDOException $ex) {
                // Capturar específicamente el error de duplicado (código 23000 es común para UNIQUE constraint)
                if ($ex->getCode() == 23000) {
                    $error = 'El correo electrónico ya está registrado.';
                } else {
                    $error = 'Error desconocido al registrar: ' . $ex->getMessage();
                }
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrarse - eHoli</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
<div class="login-container">
    <div class="login-box">
        <div class="login-header">
            <h1>Regístrate</h1>
            <p>Crea tu cuenta para reservar alojamientos únicos.</p>
        </div>
        <?php if ($error): ?>
        <div class="alert alert-error">
            <?php echo safe_output($error); ?> 
        </div>
        <?php endif; ?>
        <form method="POST" action="">
            <input type="hidden" name="csrf_token" value="<?php echo $csrf_token; ?>">
            
            <div class="form-group">
                <label for="nombre">Nombre</label>
                <input type="text" id="nombre" name="nombre" class="form-control" value="<?php echo safe_output($_POST['nombre'] ?? ''); ?>" required>
            </div>
            <div class="form-group">
                <label for="apellido">Apellido</label>
                <input type="text" id="apellido" name="apellido" class="form-control" value="<?php echo safe_output($_POST['apellido'] ?? ''); ?>" required>
            </div>
            <div class="form-group">
                <label for="email">Correo electrónico</label>
                <input type="email" id="email" name="email" class="form-control" value="<?php echo safe_output($_POST['email'] ?? ''); ?>" required>
            </div>
            <div class="form-group">
                <label for="telefono">Teléfono</label>
                <input type="tel" id="telefono" name="telefono" class="form-control" value="<?php echo safe_output($_POST['telefono'] ?? ''); ?>" required>
            </div>
            <div class="form-group">
                <label for="password">Contraseña</label>
                <input type="password" id="password" name="password" class="form-control" required minlength="8">
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 24px;">
                Registrarse
            </button>
        </form>
        <div style="text-align: center; margin-top: 24px; color: var(--text-gray);">
            ¿Ya tienes cuenta?
            <a href="/login.php" style="color: var(--airbnb-rausch); font-weight: 600;">
                Inicia sesión aquí
            </a>
        </div>
    </div>
</div>
</body>
</html>