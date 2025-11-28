<?php
require_once '../config/auth.php';
// Solo permite a 'huesped'. Si no lo es, lo redirige a su dashboard.
enforce_role_access(['huesped']); 
require_once __DIR__ . '/../includes/navbar-principal.php';
require_once __DIR__ . '/../config/auth.php';
?>
<main class="container">
    <h2>Bienvenido</h2>
    <!-- Aquí el dashboard con métricas, enlaces o cards admin, usando las clases CSS -->
</main>
<?php require_once __DIR__.'/../includes/footer.php'; ?>

<?php
