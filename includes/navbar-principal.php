<?php
require_once __DIR__ . '/../security/security.php';
// Nota: La verificación de sesión se debería centralizar en una función (usuario_logueado() en auth.php)
?>
<nav class="header">
    <div class="header-container">
        <a href="/index.php" class="logo" style="color: var(--airbnb-rausch)">
            eHoli
        </a>
        <ul class="header-right" style="list-style:none; display:flex; gap:24px;">
            <li><a href="/index.php" class="btn-host">Inicio</a></li>
            <li><a href="/huesped/buscar.php">Buscar alojamiento</a></li>

            <?php 
            // 🔑 CAMBIO CLAVE AQUÍ: Usar 'user_id'
            if (isset($_SESSION['user_id'])): 
            ?>
                <?php 
                // 🔑 CAMBIO CLAVE AQUÍ: Usar 'user_role'
                if ($_SESSION['user_role'] === 'admin'): 
                ?>
                    <li><a href="/20251209_PFDW_Grupo2_eHoli/admin/dashboard.php">Admin</a></li>
                <?php 
                // 🔑 CAMBIO CLAVE AQUÍ: Usar 'user_role'
                elseif ($_SESSION['user_role'] === 'anfitrion'): 
                ?>
                    <li><a href="/anfitrion/dashboard.php">Anfitrión</a></li>
                <?php endif; ?> 
                
                <?php 
                // 🔑 CAMBIO CLAVE AQUÍ: Usar 'user_role'
                if ($_SESSION['user_role'] === 'huesped'): 
                ?>
                    <li><a href="/huesped/mis-reservas.php">Mis Reservas</a></li>
                <?php endif; ?>
                
                <li><a href="/20251209_PFDW_Grupo2_eHoli/logout.php" class="btn btn-secondary">Logout</a></li>
                
            <?php else: ?>
                <li><a href="/20251209_PFDW_Grupo2_eHoli/login.php" class="btn btn-secondary">Login</a></li>
            <?php endif; ?>
        </ul>
    </div>
</nav>