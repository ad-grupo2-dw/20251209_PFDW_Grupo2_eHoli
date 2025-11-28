<?php

class Database {
    // 1. Propiedades para la conexión
    private $host = "localhost";
    private $db_name = "eholi";
    private $username = "root";
    private $password = "";
    private $conn; // Aquí se guardará el objeto PDO de conexión

    // 2. Método Constructor (__construct)
    // Se ejecuta automáticamente al hacer 'new Database()'
    public function __construct() {
        // Inicializa la variable de conexión
        $this->conn = null;

        // Tenta establecer la conexión (usando PDO)
        try {
            $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset=utf8mb4";
            
            // Crea el objeto PDO real, que es la conexión
            $this->conn = new PDO($dsn, $this->username, $this->password);
            
            // Configuración adicional: asegurar que los errores de PDO se reporten como excepciones
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        } catch(PDOException $exception) {
            // Manejo de error si la conexión falla
            echo "Error de conexión: " . $exception->getMessage();
            // Aquí se podría registrar el error y salir del script
        }
    }

    // 3. Método GetConnection (el que llamamos en tu código)
    public function getConnection() {
        // Simplemente devuelve la conexión PDO establecida en el constructor
        return $this->conn;
    }
}
?>