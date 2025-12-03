<?php
/**
 * Escapa el HTML de una cadena para prevenir ataques XSS.
 * @param string $data La cadena de texto a limpiar.
 * @return string La cadena con el HTML escapado.
 */
function safe_output($data) {
    // 1. Convertir a string si no lo es (manejo de otros tipos de datos)
    $data = (string) $data;

    // 2. Usar htmlspecialchars para convertir caracteres peligrosos
    // ENT_QUOTES: convierte comillas simples y dobles
    // 'UTF-8': asegurar la codificación correcta
    return htmlspecialchars($data, ENT_QUOTES, 'UTF-8');
}

/**
 * Obtiene la cadena de texto traducida.
 * @param string $key La clave del array de idioma (ej: 'nav_home').
 * @return string El texto traducido o la clave si no se encuentra (para depuración).
 */
function __(string $key): string {
    global $lang;
    return $lang[$key] ?? $key;
}

?>