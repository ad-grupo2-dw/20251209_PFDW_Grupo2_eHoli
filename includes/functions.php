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
?>