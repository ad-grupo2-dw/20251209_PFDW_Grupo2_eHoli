<?php
require_once __DIR__ . '/../security/security.php';

// Determinar el idioma actual y los colores de los enlaces
$current_lang = $_SESSION['lang'] ?? 'es';
$color_es = ($current_lang === 'es') ? 'red' : 'inherit';
$color_en = ($current_lang === 'en') ? 'red' : 'inherit';
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eHoli - Encuentra tu hogar perfecto</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="/" class="logo">
                <svg width="30" height="32" viewBox="0 0 30 32" fill="currentColor">
                    <path d="M15 0.5c-4.416 0-8 3.584-8 8 0 5.5 8 15 8 15s8-9.5 8-15c0-4.416-3.584-8-8-8zm0 11c-1.657 0-3-1.343-3-3s1.343-3 3-3 3 1.343 3 3-1.343 3-3 3z"/>
                </svg>
                <span style="margin-left: 8px;">eHoli</span>
            </a>
            
            <div class="nav-search">
                <input type="text" placeholder="¿A dónde vas?" id="searchInput">
                <button class="search-btn">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                        <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                    </svg>
                </button>
            </div>
            
            <div class="header-right">
                <?php if (isset($_SESSION['usuario_id'])): ?>
                    <?php if ($_SESSION['rol'] === 'anfitrion'): ?>
                        <a href="/anfitrion/dashboard.php" class="btn-host">
                            Modo anfitrión
                        </a>
                    <?php endif; ?>
                    
                    <div class="user-menu" onclick="toggleUserMenu()">
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                            <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm5 2v2h6V4H5zm6 3H5v2h6V7zM5 10v2h6v-2H5z"/>
                        </svg>
                        <div class="user-avatar">
                            <?php echo strtoupper(substr($_SESSION['nombre'], 0, 1)); ?>
                        </div>
                    </div>
                <?php else: ?>
                    <a href="/20251209_PFDW_Grupo2_eHoli/login.php" class="btn btn-secondary">
                        Iniciar sesión
                    </a>
                    <a href="/20251209_PFDW_Grupo2_eHoli/registro.php" class="btn btn-primary">
                        Registrarse
                    </a>
                <?php endif; ?>
            </div>
        </div>
    </header>
    
    <nav class="categories">
        <div class="categories-container">
            <div class="category-item active">
                <span class="category-icon">🏠</span>
                <span class="category-name">Todo</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏖️</span>
                <span class="category-name">Playa</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏔️</span>
                <span class="category-name">Montaña</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏙️</span>
                <span class="category-name">Ciudad</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏡</span>
                <span class="category-name">Casas</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏨</span>
                <span class="category-name">Apartamentos</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏰</span>
                <span class="category-name">Villas</span>
            </div>
            <div class="category-item">
                <span class="category-icon">🏕️</span>
                <span class="category-name">Cabañas</span>
            </div>
        </div>
        <div class="language-switcher">
            <a href="/20251209_PFDW_Grupo2_eHoli/set_language.php?lang=es" style="color: <?php echo $color_es; ?>;">ES</a> |
            <a href="/20251209_PFDW_Grupo2_eHoli/set_language.php?lang=en" style="color: <?php echo $color_en; ?>;">EN</a>
        </div>
    </nav>
