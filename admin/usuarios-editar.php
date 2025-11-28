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
$csrf_token = generar_csrf();
$database = new Database();
$conn = $database->getConnection();

// 2. Obtener el ID del usuario
$user_id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

// Redirigir si no hay ID válido
if (!$user_id) {
    header('Location: usuarios-listar.php');
    exit;
}

// 3. Cargar datos del usuario existente
$query = "SELECT id, nombre, apellido, email, telefono, rol, estado FROM usuarios WHERE id = :id";
$stmt = $conn->prepare($query);
$stmt->bindParam(':id', $user_id, PDO::PARAM_INT);
$stmt->execute();
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

// Si el usuario no existe, redirigir
if (!$usuario) {
    header('Location: usuarios-listar.php');
    exit;
}

// 4. Procesar formulario POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token_recibido = $_POST['csrf_token'] ?? '';
    
    if (!validar_csrf($token_recibido)) {
        $error = 'Error de validación CSRF. Intenta nuevamente.';
    } else {
        // Recolección y saneamiento de datos del POST
        $nombre = trim($_POST['nombre']);
        $apellido = trim($_POST['apellido']);
        $email = trim($_POST['email']);
        $rol = $_POST['rol'];
        $estado = $_POST['estado'];
        $password_nueva = $_POST['password_nueva'] ?? ''; // Opcional
        
        if (empty($nombre) || empty($email) || empty($rol)) {
            $error = 'Todos los campos obligatorios deben ser completados.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $error = 'El formato del email es inválido.';
        } elseif (!empty($password_nueva) && strlen($password_nueva) < 8) {
            $error = 'La nueva contraseña debe tener al menos 8 caracteres.';
        } else {
            // 5. Construir y ejecutar la consulta de actualización
            $fields = ['nombre' => $nombre, 'apellido' => $apellido, 'email' => $email, 'rol' => $rol, 'estado' => $estado];
            $set_clauses = "nombre = :nombre, apellido = :apellido, email = :email, rol = :rol, estado = :estado";
            
            // Si hay una nueva contraseña, la hasheamos y la añadimos a la consulta
            if (!empty($password_nueva)) {
                $fields['password_hash'] = password_hash($password_nueva, PASSWORD_DEFAULT);
                $set_clauses .= ", password = :password_hash";
            }
            
            $fields['id'] = $user_id;
            
            $query_update = "UPDATE usuarios SET $set_clauses WHERE id = :id";
            $stmt_update = $conn->prepare($query_update);
            
            try {
                $stmt_update->execute($fields);
                
                // Redirigir y mostrar éxito
                header('Location: usuarios-listar.php?success=updated');
                exit();
                
            } catch (PDOException $ex) {
                // Si el error es por email duplicado
                if ($ex->getCode() == 23000) {
                    $error = 'El correo electrónico ya está registrado por otro usuario.';
                } else {
                    $error = 'Error al actualizar el usuario.';
                }
            }
        }
    }
    // Si hay error, actualiza la variable $usuario con los datos POST para pre-rellenar
    $usuario = array_merge($usuario, $_POST);
}

require_once __DIR__ . '/includes/header.php';
?>

<main class="container admin-container">
    <h2>Editar Usuario: <?php echo safe_output($usuario['nombre'] . ' ' . $usuario['apellido']); ?></h2>
    <a href="usuarios-listar.php" class="btn btn-secondary mb-3">← Volver a la Lista</a>

    <?php if ($error): ?>
    <div class="alert alert-error"><?php echo safe_output($error); ?></div>
    <?php endif; ?>

    <form method="POST">
        <input type="hidden" name="csrf_token" value="<?php echo $csrf_token; ?>">
        
        <div class="form-group">
            <label for="nombre">Nombre</label>
            <input type="text" name="nombre" id="nombre" class="form-control" required value="<?php echo safe_output($usuario['nombre']); ?>">
        </div>
        
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" class="form-control" required value="<?php echo safe_output($usuario['email']); ?>">
        </div>

        <div class="form-group">
            <label for="password_nueva">Nueva Contraseña (Dejar vacío para no cambiar)</label>
            <input type="password" name="password_nueva" id="password_nueva" class="form-control" minlength="8">
        </div>

        <div class="form-group">
            <label for="rol">Rol</label>
            <select name="rol" id="rol" class="form-control" required>
                <option value="huesped" <?php if ($usuario['rol'] === 'huesped') echo 'selected'; ?>>Huésped</option>
                <option value="anfitrion" <?php if ($usuario['rol'] === 'anfitrion') echo 'selected'; ?>>Anfitrión</option>
                <option value="admin" <?php if ($usuario['rol'] === 'admin') echo 'selected'; ?>>Admin</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="estado">Estado</label>
            <select name="estado" id="estado" class="form-control" required>
                <option value="activo" <?php if ($usuario['estado'] === 'activo') echo 'selected'; ?>>Activo</option>
                <option value="inactivo" <?php if ($usuario['estado'] === 'inactivo') echo 'selected'; ?>>Inactivo</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary mt-3">Actualizar Usuario</button>
    </form>
</main>

<?php require_once __DIR__ . '/includes/footer.php'; ?>