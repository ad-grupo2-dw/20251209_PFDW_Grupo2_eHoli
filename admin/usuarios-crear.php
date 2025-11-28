<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../includes/functions.php';
require_once __DIR__ . '/../config/auth.php';
require_once __DIR__ . '/../security/csrf.php';

// 1. Proteger la página
if (!usuario_logueado() || $_SESSION['user_role'] !== 'admin') {
    header("Location: /login.php");
    exit;
}

$error = '';
$csrf_token = generar_csrf(); // Generar el token para el formulario

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token_recibido = $_POST['csrf_token'] ?? '';
    
    // 2. Validar CSRF
    if (!validar_csrf($token_recibido)) {
        $error = 'Error de validación CSRF. Intenta nuevamente.';
    } else {
        // 3. Recolección y saneamiento de datos
        $nombre = trim($_POST['nombre']);
        $apellido = trim($_POST['apellido']);
        $email = trim($_POST['email']);
        $password = $_POST['password'];
        $rol = $_POST['rol']; // Permitir al admin seleccionar el rol
        $estado = $_POST['estado'];
        
        // 4. Validación
        if (empty($nombre) || empty($email) || empty($password)) {
            $error = 'Todos los campos obligatorios deben ser completados.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $error = 'El formato del email es inválido.';
        } elseif (strlen($password) < 8) {
            $error = 'La contraseña debe tener al menos 8 caracteres.';
        } else {
            // 5. Procesamiento
            $database = new Database();
            $conn = $database->getConnection();
            $passwordHash = password_hash($password, PASSWORD_DEFAULT);
            
            $query = "INSERT INTO usuarios (nombre, apellido, email, password, rol, estado) 
                      VALUES (:nombre, :apellido, :email, :password_hash, :rol, :estado)";
            $stmt = $conn->prepare($query);
            
            try {
                $stmt->execute([
                    ':nombre' => $nombre,
                    ':apellido' => $apellido,
                    ':email' => $email,
                    ':password_hash' => $passwordHash,
                    ':rol' => $rol,
                    ':estado' => $estado
                ]);
                
                // Redirigir y mostrar éxito
                header('Location: usuarios-listar.php?success=created');
                exit();
                
            } catch (PDOException $ex) {
                if ($ex->getCode() == 23000) {
                    $error = 'El correo electrónico ya está registrado.';
                } else {
                    $error = 'Error al crear usuario.';
                }
            }
        }
    }
}

require_once __DIR__ . '/includes/header.php';
?>

<main class="container admin-container">
    <h2>Crear Nuevo Usuario</h2>
    <a href="usuarios-listar.php" class="btn btn-secondary mb-3">← Volver a la Lista</a>

    <?php if ($error): ?>
    <div class="alert alert-error"><?php echo safe_output($error); ?></div>
    <?php endif; ?>

    <form method="POST">
        <input type="hidden" name="csrf_token" value="<?php echo $csrf_token; ?>">

        <div class="form-group">
            <label for="nombre">Nombre</label>
            <input type="text" name="nombre" id="nombre" class="form-control" required value="<?php echo safe_output($_POST['nombre'] ?? ''); ?>">
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" class="form-control" required value="<?php echo safe_output($_POST['email'] ?? ''); ?>">
        </div>

        <div class="form-group">
            <label for="password">Contraseña (Mínimo 8 caracteres)</label>
            <input type="password" name="password" id="password" class="form-control" required minlength="8">
        </div>

        <div class="form-group">
            <label for="rol">Rol</label>
            <select name="rol" id="rol" class="form-control" required>
                <option value="huesped">Huésped</option>
                <option value="anfitrion">Anfitrión</option>
                <option value="admin">Admin</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="estado">Estado</label>
            <select name="estado" id="estado" class="form-control" required>
                <option value="activo">Activo</option>
                <option value="inactivo">Inactivo</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary mt-3">Guardar Usuario</button>
    </form>
</main>

<?php require_once __DIR__ . '/includes/footer.php'; ?>