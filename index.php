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
    p.num_habitaciones AS num_habitaciones, 
    u.nombre AS anfitrion_nombre,
    
    -- 🔑 AÑADIR ESTA SUB-CONSULTA/JOIN
    COALESCE(AVG(r.calificacion), 0) AS calificacion_promedio 

FROM propiedades p

INNER JOIN usuarios u ON p.anfitrion_id = u.id
LEFT JOIN categorias c ON p.categoria_id = c.id

-- 🔑 UNIÓN para calcular el promedio de las calificaciones (r)
LEFT JOIN resenas r ON p.id = r.propiedad_id 

WHERE p.estado = 'disponible'

-- 🔑 AGRUPAR por la propiedad para que AVG() funcione
GROUP BY p.id 

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
            
            <div class="property-card"> 
                
                <a href="/huesped/propiedad.php?id=<?php echo $propiedad['id']; ?>">
                    <div class="property-images">
                        <?php
                        // Obtener imágenes de la propiedad (El código PHP está limpio)
                        $img_query = "SELECT ruta_imagen FROM imagenes_propiedad 
                                        WHERE propiedad_id = :prop_id 
                                        ORDER BY orden LIMIT 1"; // SOLO NECESITAS LA PRIMERA IMAGEN PARA EL LISTADO
                        $img_stmt = $conn->prepare($img_query);
                        $img_stmt->bindParam(':prop_id', $propiedad['id']);
                        $img_stmt->execute();
                        $imagen_principal = $img_stmt->fetchColumn() ?: '/assets/images/default.jpg';
                        ?>
                        
                        <img src="<?php echo safe_output($imagen_principal); ?>" 
                             alt="<?php echo safe_output($propiedad['titulo']); ?>">
                        
                        <button class="favorite-btn" onclick="event.preventDefault(); toggleFavorito(<?php echo $propiedad['id']; ?>)">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M8 14s6-4 6-8a3 3 0 0 0-6-0 3 3 0 0 0-6 0c0 4 6 8 6 8z"/>
                            </svg>
                        </button> 
                        
                        <?php /*
                        <button class="image-nav prev" onclick="event.preventDefault()">‹</button>
                        <button class="image-nav next" onclick="event.preventDefault()">›</button> 
                        <div class="image-dots">...</div>
                        */ ?>
                    </div>
                </a>
                <div class="property-content">
                    
                    <a href="/huesped/propiedad.php?id=<?php echo $propiedad['id']; ?>" class="property-title">
                        <?php echo safe_output($propiedad['titulo']); ?>
                    </a>
                    
                    <p class="property-location">
                        <?php echo safe_output($propiedad['ciudad']); ?>, <?php echo safe_output($propiedad['pais']); ?>
                    </p>
                    
                    <div class="property-details">
                        <span class="property-rating">⭐ <?php echo safe_output(number_format($propiedad['calificacion_promedio'], 1)); ?></span>
                        · <?php echo safe_output($propiedad['tipo']); ?>
                        · <?php echo safe_output($propiedad['capacidad_huespedes']); ?> huéspedes
                        · <?php echo safe_output($propiedad['num_habitaciones']); ?> habitaciones
                    </div>

                    <div class="property-price">
                        **$<?php echo safe_output(number_format($propiedad['precio_noche'], 2)); ?>** por noche
                    </div>
                </div>

            </div> <?php endforeach; ?>
    </div> <nav class="pagination-nav">
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