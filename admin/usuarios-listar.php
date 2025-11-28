<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../includes/functions.php';
require_once __DIR__ . '/../config/auth.php'; // Incluye funciones de rol

// 1. Proteger la página
if (!usuario_logueado() || $_SESSION['user_role'] !== 'admin') {
    header("Location: /login.php");
    exit;
}

// 2. Obtener conexión
$database = new Database();
$conn = $database->getConnection();

// 3. Consulta SQL para obtener todos los usuarios (excluyendo la contraseña)
$query = "SELECT id, nombre, apellido, email, telefono, rol, estado, creado_en FROM usuarios ORDER BY creado_en DESC";
$stmt = $conn->prepare($query);
$stmt->execute();
$usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Incluir la cabecera
require_once __DIR__ . '/includes/header.php'; 
?>

<main class="container admin-container">
    <h2>Gestión de Usuarios</h2>
    <p><a href="usuarios-crear.php" class="btn btn-primary">Crear Nuevo Usuario</a></p>

    <?php 
    // Muestra mensajes flash (si usas un sistema de mensajería)
    // echo get_flash(); 
    ?>

    <?php if (count($usuarios) > 0): ?>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre Completo</th>
                <th>Email</th>
                <th>Rol</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($usuarios as $usuario): ?>
            <tr>
                <td><?php echo safe_output($usuario['id']); ?></td>
                <td><?php echo safe_output($usuario['nombre'] . ' ' . $usuario['apellido']); ?></td>
                <td><?php echo safe_output($usuario['email']); ?></td>
                <td><?php echo safe_output($usuario['rol']); ?></td>
                <td><?php echo safe_output($usuario['estado']); ?></td>
                <td>
                    <a href="usuarios-editar.php?id=<?php echo $usuario['id']; ?>" class="btn btn-sm btn-secondary">Editar</a>
                    <form action="usuarios-eliminar.php" method="POST" style="display:inline-block;">
                        <input type="hidden" name="id" value="<?php echo $usuario['id']; ?>">
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('¿Estás seguro de que quieres eliminar a este usuario?');">Eliminar</button>
                    </form>
                </td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <?php else: ?>
    <p class="alert alert-info">No hay usuarios registrados.</p>
    <?php endif; ?>
</main>

<?php require_once __DIR__ . '/includes/footer.php'; ?>