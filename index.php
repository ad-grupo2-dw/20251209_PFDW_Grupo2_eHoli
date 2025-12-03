<?php
// =========================================
// INCLUSIONES (Aseguradas con __DIR__)
// =========================================
require_once __DIR__ . '/config/config.php'; 
// Asume que config.php define la clase Database

require_once __DIR__ . '/includes/functions.php'; // <-- CORRECCIÓN: Usar __DIR__
// Asume que functions.php define safe_output()

require_once __DIR__ . '/includes/header.php'; // Se incluye el encabezado

$database = new Database();
$conn = $database->getConnection();

// =========================================
// LÓGICA DE PAGINACIÓN
// =========================================
$pagina = isset($_GET['pagina']) ? (int)$_GET['pagina'] : 1;
// Asegura que la página sea al menos 1
$pagina = max(1, $pagina); 

$por_pagina = 12;
$offset = ($pagina - 1) * $por_pagina;

// 1. Consulta para OBTENER EL TOTAL DE REGISTROS (Para la paginación)
$count_query = "SELECT COUNT(id) FROM propiedades WHERE estado = 'disponible'";
$count_stmt = $conn->prepare($count_query);
$count_stmt->execute();
$total_propiedades = $count_stmt->fetchColumn();

// Calcular el total de páginas
$total_paginas = ceil($total_propiedades / $por_pagina);

// 2. Consulta para OBTENER LAS PROPIEDADES (con LIMIT y OFFSET)
$query = "SELECT 
            p.*, 
            c.nombre AS tipo,                      
            p.capacidad AS capacidad_huespedes,    
            p.num_habitaciones AS num_habitaciones, -- 🔑 Ahora esta columna existe y se mapea
            u.nombre AS anfitrion_nombre 
          FROM propiedades p
          INNER JOIN usuarios u ON p.anfitrion_id = u.id
          LEFT JOIN categorias c ON p.categoria_id = c.id
          WHERE p.estado = 'disponible'
          ORDER BY p.creado_en DESC
          LIMIT :limit OFFSET :offset";

$stmt = $conn->prepare($query);
$stmt->bindParam(':limit', $por_pagina, PDO::PARAM_INT);
$stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
$stmt->execute();
$propiedades = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<main class="container">
    <div class="properties-grid">
        <?php foreach ($propiedades as $propiedad): ?>
            <a href="/20251209_PFDW_Grupo2_eHoli/huesped/propiedad.php?id=<?php echo $propiedad['id']; ?>" class="property-card">
                <div class="property-images">
                    <?php
                    // Obtener imágenes de la propiedad (Código limpio, no necesita cambios)
                    $img_query = "SELECT ruta_imagen FROM imagenes_propiedad 
                                  WHERE propiedad_id = :prop_id 
                                  ORDER BY orden LIMIT 5";
                    $img_stmt = $conn->prepare($img_query);
                    $img_stmt->bindParam(':prop_id', $propiedad['id']);
                    $img_stmt->execute();
                    $imagenes = $img_stmt->fetchAll(PDO::FETCH_COLUMN);
                    
                    $imagen_principal = !empty($imagenes) ? $imagenes[0] : '/assets/images/default.jpg';
                    ?>
                    
                    <img src="<?php echo safe_output($imagen_principal); ?>" 
                         alt="<?php echo safe_output($propiedad['titulo']); ?>">
                    
                    <button class="favorite-btn" onclick="event.preventDefault(); toggleFavorito(<?php echo $propiedad['id']; ?>)">
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M8 14s6-4 6-8a3 3 0 0 0-6-0 3 3 0 0 0-6 0c0 4 6 8 6 8z"/>
                        </svg>
                    </button>
                    
                    <?php if (count($imagenes) > 1): ?>
                        <button class="image-nav prev" onclick="event.preventDefault()">‹</button>
                        <button class="image-nav next" onclick="event.preventDefault()">›</button>
                        
                        <div class="image-dots">
                            <?php foreach ($imagenes as $index => $img): ?>
                                <span class="dot <?php echo $index === 0 ? 'active' : ''; ?>"></span>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </div>
                
                <div class="property-info">
                    <div class="property-header">
                        <div class="property-location">
                            <?php echo safe_output($propiedad['ciudad'] . ', ' . $propiedad['pais']); ?>
                        </div>
                        <?php if ($propiedad['calificacion_promedio']): ?>
                            <div class="property-rating">
                                <span>⭐</span>
                                <span><?php echo number_format($propiedad['calificacion_promedio'], 1); ?></span>
                            </div>
                        <?php endif; ?>
                    </div>
                    
                                    <div class="property-details">
                    <?php echo safe_output($propiedad['tipo']); ?> · 
                    
                    <?php echo safe_output($propiedad['capacidad_huespedes']); ?> huéspedes · 
                    
                    <?php 
                    // Si no tienes la columna en la BD, omite esta línea temporalmente 
                    // o usa un valor por defecto.
                    // Si la añades a la BD, debes añadirla a la consulta SQL del Paso 1.
                    echo safe_output($propiedad['num_habitaciones'] ?? 'N/A');
                    ?> habitaciones
                </div>
                    
                    <div class="property-price">
                        <span class="price-amount">$<?php echo number_format($propiedad['precio_noche'], 2); ?></span> 
                        por noche
                    </div>
                </div>
            </a>
        <?php endforeach; ?>
    </div>

    <nav class="pagination-nav">
        <?php if ($pagina > 1): ?>
            <a href="?pagina=<?php echo $pagina - 1; ?>" class="page-link">« Anterior</a>
        <?php endif; ?>
        
        <?php for ($i = 1; $i <= $total_paginas; $i++): ?>
            <a href="?pagina=<?php echo $i; ?>" class="page-link <?php echo ($i === $pagina) ? 'active' : ''; ?>">
                <?php echo $i; ?>
            </a>
        <?php endfor; ?>

        <?php if ($pagina < $total_paginas): ?>
            <a href="?pagina=<?php echo $pagina + 1; ?>" class="page-link">Siguiente »</a>
        <?php endif; ?>
    </nav>
</main>

<?php require_once __DIR__ . '/includes/footer.php'; ?>