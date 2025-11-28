<?php
require_once __DIR__ . '/config/auth.php';
require_once __DIR__ . '/security/csrf.php';
require_once __DIR__ . '/includes/header.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!validar_csrf($_POST['csrf_token'])) {
        set_flash('Token CSRF inválido', 'error');
    } else {
        if (login($_POST['email'], $_POST['password'])) {
            set_flash('¡Bienvenido!', 'success');
            header("Location: ../20251209_PFDW_Grupo2_eHoli/admin/dashboard.php");
            exit;
        } else {
            set_flash('Creadenciales incorrectas', 'error');
        }
    }
}
require_once __DIR__ . '../includes/header.php';
require_once __DIR__ . '../includes/navbar-principal.php';
mostrar_flash();
?>
<form method="POST">
    <input type="email" name="email" value="<?php echo isset($_POST['email']) ? htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8') : ''; ?>" required placeholder="Correo">
    <input type="password" name="password" required placeholder="Contraseña">
    <input type="hidden" name="csrf_token" value="<?php echo generar_csrf(); ?>">

    <button type="submit">Iniciar sesión</button>
</form>
<?php require_once __DIR__ . '../includes/footer.php'; ?>
