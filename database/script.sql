-- =========================================
-- Configuración inicial y Tablas base
-- =========================================
DROP DATABASE IF EXISTS eholi;
CREATE DATABASE eholi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eholi;

-- Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    edad INT NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    rol ENUM('admin', 'anfitrion', 'huesped', 'soporte', 'postulante') DEFAULT 'huesped' NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    preferencias VARCHAR(255),
    foto_perfil VARCHAR(255),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Categorías
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion VARCHAR(255),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Amenidades
CREATE TABLE amenidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    inclusivo BOOLEAN DEFAULT 0,
    icono VARCHAR(50),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Propiedades
CREATE TABLE propiedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    anfitrion_id INT NOT NULL,
    categoria_id INT,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    anfitrion_vive TINYINT(1) DEFAULT 0,
    capacidad INT NOT NULL CHECK (capacidad >= 1),
    admite_por_horas TINYINT(1) DEFAULT 0,
    precio_noche DECIMAL(12,2) NOT NULL CHECK (precio_noche >= 0),
    precio_hora DECIMAL(12,2) NOT NULL CHECK (precio_hora >= 0),
    moneda VARCHAR(5) DEFAULT 'USD',
    amenidades TEXT,
    estado ENUM('borrador','publicada','pausada','eliminada','disponible','ocupado','mantenimiento') DEFAULT 'borrador',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (anfitrion_id) REFERENCES usuarios(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Relación propiedad-amenidad
CREATE TABLE amenidades_propiedades (
    propiedad_id INT NOT NULL,
    amenidad_id INT NOT NULL,
    agregado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (propiedad_id, amenidad_id),
    FOREIGN KEY (propiedad_id) REFERENCES propiedades(id) ON DELETE CASCADE,
    FOREIGN KEY (amenidad_id) REFERENCES amenidades(id)
);

-- Experiencias
CREATE TABLE experiencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    anfitrion_id INT NOT NULL,
    categoria_id INT,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    inclusiva BOOLEAN DEFAULT 0,
    ubicacion VARCHAR(255),
    precio DECIMAL(12,2) NOT NULL CHECK (precio >= 0),
    moneda VARCHAR(5) DEFAULT 'USD',
    estado ENUM('borrador','publicada','pausada','eliminada','disponible','ocupado','mantenimiento') DEFAULT 'borrador',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    imagen VARCHAR(255),
    FOREIGN KEY (anfitrion_id) REFERENCES usuarios(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Reservas
CREATE TABLE reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propiedad_id INT NOT NULL,
    huesped_id INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    num_huespedes INT,
    tipo_uso ENUM('completa','por_horas') DEFAULT 'completa',
    estado ENUM('pendiente','confirmada','cancelada','finalizada') DEFAULT 'pendiente',
    precio_total DECIMAL(12,2) NOT NULL CHECK (precio_total >= 0),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (propiedad_id) REFERENCES propiedades(id),
    FOREIGN KEY (huesped_id) REFERENCES usuarios(id)
);

-- Pagos
CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    monto DECIMAL(12,2) NOT NULL CHECK (monto >= 0),
    moneda VARCHAR(10) DEFAULT 'USD',
    metodo ENUM('tarjeta','transferencia','efectivo') NOT NULL,
    estado ENUM('pendiente','aprobado','fallido') NOT NULL,
    referencia VARCHAR(100),
    procesado_en TIMESTAMP NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE
);

-- Reseñas
CREATE TABLE resenas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    usuario_id INT NOT NULL,
    propiedad_id INT NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (reserva_id, usuario_id),
    FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (propiedad_id) REFERENCES propiedades(id)
);

-- Favoritos
CREATE TABLE favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    propiedad_id INT NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (usuario_id, propiedad_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (propiedad_id) REFERENCES propiedades(id) ON DELETE CASCADE
);

-- Notificaciones
CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo ENUM('reserva','pago','experiencia','sistema'),
    titulo VARCHAR(150) NOT NULL,
    mensaje TEXT NOT NULL,
    leida BOOLEAN DEFAULT FALSE,
    enviado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Log de Eventos
CREATE TABLE bitacora (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    evento VARCHAR(150) NOT NULL,
    entidad VARCHAR(50),
    entidad_id VARCHAR(50),
    detalles JSON,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip VARCHAR(20),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Políticas de Privacidad
CREATE TABLE politicas_privacidad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    anfitrion_id INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,
    vigente BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    certificado BOOLEAN DEFAULT 0,
    FOREIGN KEY (anfitrion_id) REFERENCES usuarios(id)
);

-- Comisiones
CREATE TABLE comisiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('registro_anfitrion','reserva','propiedad','alojamiento_horas') NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL CHECK (porcentaje >= 0 AND porcentaje <= 100),
    fijo DECIMAL(12,2) DEFAULT 0 CHECK (fijo >= 0),
    vigente BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reclamos
CREATE TABLE reclamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    reserva_id INT,
    motivo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    estado ENUM('nuevo','en_proceso','resuelto','rechazado','cerrado') DEFAULT 'nuevo',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (reserva_id) REFERENCES reservas(id)
);

-- Postulaciones
CREATE TABLE postulaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    edad INT,
    perfil TEXT,
    cv_url VARCHAR(255),
    mensaje TEXT,
    estado ENUM('recibida','en_revision','entrevista','aceptada','rechazada') DEFAULT 'recibida',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tutoriales de Asistencia
CREATE TABLE tutoriales_asistencia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    anfitrion_id INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    url_video VARCHAR(255),
    contenido TEXT NOT NULL,
    publicado BOOLEAN DEFAULT FALSE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visualizado BOOLEAN DEFAULT 0,
    FOREIGN KEY (anfitrion_id) REFERENCES usuarios(id)
);

-- Imágenes de Propiedad
CREATE TABLE imagenes_propiedad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propiedad_id INT NOT NULL,
    ruta_imagen VARCHAR(255) NOT NULL,
    orden INT DEFAULT 1,
    principal BOOLEAN DEFAULT FALSE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (propiedad_id, orden),
    FOREIGN KEY (propiedad_id) REFERENCES propiedades(id) ON DELETE CASCADE
);

-- Cambios de Estado y Autorización
CREATE TABLE cambios_estado (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entidad VARCHAR(50) NOT NULL,
    entidad_id VARCHAR(50) NOT NULL,
    anterior VARCHAR(50),
    nuevo VARCHAR(50) NOT NULL,
    usuario_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ==============================================
-- Indexación, Triggers, Vistas y Otros Cálculos
-- ==============================================

USE eHoli;

-- Indexación para búsquedas rápidas y reportes
CREATE INDEX idx_usuario_rol_estado ON usuarios(rol, estado);
CREATE INDEX idx_propiedad_estado_categoria ON propiedades(estado, categoria_id);
CREATE INDEX idx_reservas_estado_fecha ON reservas(estado, fecha_entrada, fecha_salida);
CREATE INDEX idx_reclamos_estado ON reclamos(estado);
CREATE INDEX idx_pagos_estado ON pagos(estado);
CREATE INDEX idx_favoritos_usuario_prop ON favoritos(usuario_id, propiedad_id);
CREATE INDEX idx_resena_propiedad ON resenas(propiedad_id, calificacion);

-- Trigger para actualización automática de fecha renovación en políticas privacidad
DELIMITER $$
CREATE TRIGGER renovar_politica_privacidad
BEFORE UPDATE ON politicas_privacidad
FOR EACH ROW
BEGIN
    IF NEW.aceptada = 1 AND OLD.aceptada = 0 THEN
        SET NEW.fecha_renovacion = NOW();
    END IF;
END $$
DELIMITER ;

-- Trigger: Log nuevo reclamo en bitácora
DELIMITER $$
CREATE TRIGGER log_nuevo_reclamo
AFTER INSERT ON reclamos
FOR EACH ROW
BEGIN
    INSERT INTO bitacora(usuario_id, evento, modulo, fecha, ip)
    VALUES (NEW.usuario_id, CONCAT('Nuevo reclamo: ', NEW.motivo), 'reclamos', NOW(), '');
END $$
DELIMITER ;

-- Vista: Reservas por estado por mes
CREATE OR REPLACE VIEW v_reservas_por_estado_mes AS
SELECT 
    DATE_FORMAT(fecha_reserva, '%Y-%m') AS mes,
    estado,
    COUNT(*) AS total
FROM reservas
GROUP BY mes, estado;

-- Vista: Reclamos por motivo y estado
CREATE OR REPLACE VIEW v_reclamos_motivo_estado AS
SELECT motivo, estado, COUNT(*) AS total
FROM reclamos
GROUP BY motivo, estado;

-- Vista: Propiedades inclusivas y senior-friendly por ciudad
CREATE OR REPLACE VIEW v_props_inclusivas_ciudad AS
SELECT p.ciudad, c.nombre as categoria, COUNT(*) AS total
FROM propiedades p
JOIN categorias c ON p.categoria_id = c.id
WHERE c.nombre IN ('Accesible', 'Senior-Friendly')
GROUP BY p.ciudad, c.nombre;

-- Vista: Pagos y comisiones generados por mes
CREATE OR REPLACE VIEW v_pagos_comisiones_mes AS
SELECT 
    DATE_FORMAT(p.fecha_pago, '%Y-%m') AS mes,
    SUM(p.monto) AS total_pago,
    SUM(p.monto * (CASE WHEN c.porcentaje IS NOT NULL THEN c.porcentaje/100 ELSE 0 END)) AS total_comision
FROM pagos p
JOIN reservas r ON p.reserva_id = r.id
JOIN comisiones c ON c.tipo = 'reserva' 
GROUP BY mes;

-- Vista: Reclamos pendientes o no resueltos
CREATE OR REPLACE VIEW v_reclamos_pendientes AS
SELECT r.id, u.nombre, u.apellido, r.motivo, r.descripcion, r.estado, r.fecha
FROM reclamos r
JOIN usuarios u ON r.usuario_id = u.id
WHERE r.estado IN ('nuevo','en_proceso');

-- Total de reservas inclusivas por mes
SELECT DATE_FORMAT(reserva.fecha_reserva, '%Y-%m') AS mes, COUNT(*) AS total
FROM reservas AS reserva
JOIN propiedades p ON reserva.propiedad_id = p.id
JOIN categorias c ON p.categoria_id = c.id
WHERE c.nombre='Accesible'
GROUP BY mes;

-- Motivo de reclamos más frecuentes
SELECT motivo, COUNT(*) as total
FROM reclamos
GROUP BY motivo
ORDER BY total DESC
LIMIT 5;

-- Propiedades administradas por anfitriones mayores de 60 años
SELECT p.*, u.nombre, u.apellido, u.edad
FROM propiedades p
JOIN usuarios u ON p.anfitrion_id = u.id
WHERE u.edad >= 60;

-- Ingreso en comisiones por mes (reservas)
SELECT DATE_FORMAT(p.fecha_pago, '%Y-%m') AS mes, SUM(p.monto * 0.12) AS comision_aproximada
FROM pagos p
WHERE p.estado='pagado'
GROUP BY mes;

-- Calificación promedio de cada propiedad inclusiva
SELECT p.id, p.titulo, AVG(r.calificacion) as promedio
FROM propiedades p
JOIN resenas r ON p.id = r.propiedad_id
JOIN categorias c ON p.categoria_id = c.id
WHERE c.nombre IN ('Accesible','Senior-Friendly')
GROUP BY p.id, p.titulo;

-- Total de postulaciones recibidas por perfil
SELECT perfil, COUNT(*) as total
FROM postulaciones
GROUP BY perfil
ORDER BY total DESC;

-- =========================================
-- Datos iniciales
-- =========================================

-- USUARIOS (contraseñas hasheadas con bcrypt)
-- nsAdmin123: $2y$10$oaXOeZVgDksyHyQyVuV9VeGLpHYRh4j3mvHTDo7304JHRVwEnodbK
-- hsAdmin123: $2y$10$8JDtpR2dLXB1TosewPOUNetKUM4gcf3VPuuTAl6sTpVxBA3BRpRGe
-- msAdmin123: $2y$10$Q0CfEgqUAlP8bSopTUvJgOxJ6g9Rl6BrvYiGuYh59hHs5Eyh9rJs2
-- ycAdmin123: $2y$10$uBi3BpVjGlyXIqDcWuQHeOq9qegArDj/gRtrUPVHYNLqSar8.LswO

INSERT INTO usuarios (nombre, apellido, edad, email, password, rol, estado) VALUES
('Nicole', 'Staff', 23, 'ns@eholi.com', '$2y$10$oaXOeZVgDksyHyQyVuV9VeGLpHYRh4j3mvHTDo7304JHRVwEnodbK', 'admin', 'activo'),
('Harold', 'Sánchez', 20, 'hs@eholi.com', '$2y$10$8JDtpR2dLXB1TosewPOUNetKUM4gcf3VPuuTAl6sTpVxBA3BRpRGe', 'anfitrion', 'activo'),
('Moisés', 'Sanchez', 21, 'ms@eholi.com', '$2y$10$Q0CfEgqUAlP8bSopTUvJgOxJ6g9Rl6BrvYiGuYh59hHs5Eyh9rJs2', 'huesped', 'activo'),
('Yahna', 'Chee', 29, 'yc@eholi.com', '$2y$10$uBi3BpVjGlyXIqDcWuQHeOq9qegArDj/gRtrUPVHYNLqSar8.LswO', 'postulante', 'activo'),
('Carlos', 'Ramos', 30, 'cr@eholi.com', '$2y$10$7B4uSdjvHBV7nmRVWdd.3eP4KD1wHIC1A.u5tHPgljKA6Uu1QJCAu', 'soporte', 'activo');

-- CATEGORÍAS
INSERT INTO categorias (nombre, descripcion) VALUES
('Playa', 'Alojamientos cerca de la playa'),
('Accesible', 'Adaptado para personas con discapacidad'),
('Senior-Friendly', 'Enfocados en adultos mayores'),
('Urbano', 'Zona céntrica de la ciudad'),
('Naturaleza', 'Áreas naturales y reservas ecológicas');

-- AMENIDADES
INSERT INTO amenidades (nombre, descripcion, inclusivo, icono) VALUES
('WiFi', 'Internet inalámbrico', 0, 'wifi'),
('Rampas', 'Acceso para sillas de ruedas', 1, 'ramp'),
('Baño adaptado', 'Baño especial para discapacidad', 1, 'bath-adapt'),
('Ascensor', 'Elevador en edificio', 1, 'elevator'),
('Señalización Braille', 'Señales en sistema braille', 1, 'braille');

-- PROPIEDADES
INSERT INTO propiedades (anfitrion_id, categoria_id, titulo, descripcion, direccion, ciudad, pais, capacidad, admite_por_horas, precio_noche, precio_hora, moneda, estado) VALUES
(2, 2, 'Apartamento Adaptado Centro', 'Totalmente adaptado con baño especial', 'Av. Central 123', 'Panamá', 'Panamá', 4, 1, 75.00, 15.00, 'USD', 'disponible'),
(2, 1, 'Casa de Playa Accesible', 'Frente al mar y acceso para sillas de ruedas', 'Calle Sol 45', 'Playa Blanca', 'Panamá', 6, 1, 120.00, 20.00, 'USD', 'disponible'),
(2, 3, 'Villa Senior Vistas', 'Ideal para mayores, todo en una planta', 'Ruta Verde 108', 'Montaña', 'Panamá', 5, 0, 90.00, 0.00, 'USD', 'disponible'),
(2, 4, 'Loft Urbano', 'Cerca de hospitales y transporte accesible', 'Calle Centro 11', 'Ciudad', 'Panamá', 3, 1, 60.00, 10.00, 'USD', 'disponible'),
(2, 5, 'Eco Refugio', 'Naturaleza, senderos adaptados', 'Ruta Bosque 91', 'Reserva', 'Panamá', 8, 0, 180.00, 0.00, 'USD', 'disponible');

-- AMENIDADES_PROPIEDADES
INSERT INTO amenidades_propiedades (propiedad_id, amenidad_id) VALUES
(1,2), (1,3), (1,4), (2,2), (2,3), (3,3), (4,1), (4,2), (5,4), (5,5);

-- EXPERIENCIAS
INSERT INTO experiencias (anfitrion_id, categoria_id, titulo, descripcion, inclusiva, ubicacion, precio, moneda, estado) VALUES
(2, 2, 'Tour inclusivo', 'Tour adaptado en el centro', 1, 'Centro Ciudad', 30.00, 'USD', 'disponible'),
(2, 1, 'Taller de Playa', 'Taller creativo frente al mar', 0, 'Playa Blanca', 40.00, 'USD', 'disponible'),
(2, 3, 'Yoga Senior', 'Yoga suave para adultos mayores', 1, 'Villa Senior', 25.00, 'USD', 'disponible'),
(2, 4, 'Caminata Urbana', 'Con guía y asistencia', 1, 'Centro Urbano', 10.00, 'USD', 'disponible'),
(2, 5, 'Senderismo Ecológico', 'Ruta accesible y adaptada', 1, 'Eco Refugio', 35.00, 'USD', 'disponible');

-- RESERVAS
INSERT INTO reservas (propiedad_id, huesped_id, fecha_entrada, fecha_salida, num_huespedes, tipo_uso, estado, precio_total) VALUES
(1,3,'2025-12-20','2025-12-22',2,'por_horas','confirmada',45.00),
(2,3,'2025-12-28','2025-12-29',3,'completa','pendiente',120.00),
(3,3,'2026-01-02','2026-01-05',1,'completa','confirmada',270.00),
(4,3,'2026-01-10','2026-01-10',1,'por_horas','pendiente',15.00),
(5,3,'2026-02-01','2026-02-02',2,'completa','pendiente',180.00);

-- PAGOS
INSERT INTO pagos (reserva_id, monto, moneda, metodo, estado) VALUES
(1,45.00,'USD','tarjeta','aprobado'),
(2,120.00,'USD','tarjeta','pendiente'),
(3,270.00,'USD','efectivo','aprobado'),
(4,15.00,'USD','transferencia','pendiente'),
(5,180.00,'USD','tarjeta','pendiente');

-- RESEÑAS
INSERT INTO resenas (reserva_id, usuario_id, propiedad_id, calificacion, comentario) VALUES
(1,3,1,5,'Excelente para personas con movilidad reducida'),
(2,3,2,4,'La vista increíble, falta más señalización'),
(3,3,3,5,'Muy recomendado para mayores'),
(4,3,4,4,'Buena opción para estadía breve'),
(5,3,5,4,'Naturaleza adaptada, recomendable');

-- FAVORITOS
INSERT INTO favoritos (usuario_id, propiedad_id) VALUES
(3,1),(3,3),(3,5),(3,4),(3,2);

-- NOTIFICACIONES
INSERT INTO notificaciones (usuario_id, tipo, titulo, mensaje, leida) VALUES
(3,'reserva','Reserva Confirmada','Tu reserva por horas fue confirmada',FALSE),
(3,'sistema','Nueva experiencia disponible','Yoga para adultos mayores',FALSE),
(3,'pago','Pago recibido','Reserva apartamento adaptado',TRUE),
(3,'reserva','Reserva Pendiente','Recuerda completar tu pago',FALSE),
(3,'reserva','Reserva Aprobada','Casa de Playa Accesible aprobada',TRUE);

-- BITACORA
INSERT INTO bitacora (usuario_id, evento, entidad, entidad_id, creado_en, ip) VALUES
(3,'Reserva realizada','reservas','1',NOW(),'192.168.1.10'),
(3,'Inició sesión','usuarios','3',NOW(),'192.168.1.10'),
(3,'Nuevo reclamo','reclamos','1',NOW(),'192.168.1.10'),
(3,'Actualizó perfil','usuarios','3',NOW(),'192.168.1.10'),
(3,'Pago realizado','pagos','1',NOW(),'192.168.1.10');

-- POLITICAS PRIVACIDAD
INSERT INTO politicas_privacidad (anfitrion_id, titulo, contenido, vigente, certificado) VALUES
(2,'Privacidad Cliente','Se garantiza la privacidad y protección de datos',TRUE,TRUE),
(2,'Manipulación de Datos','Datos manejados con ética y transparencia',TRUE,TRUE),
(2,'Consentimiento Requerido','Siempre se pide consentimiento del cliente',TRUE,TRUE),
(2,'Certificación Vigente','Cumplimos con normas internacionales',TRUE,TRUE),
(2,'Protección de Menores','Resguardamos la info de menores',TRUE,TRUE);

-- COMISIONES
INSERT INTO comisiones (tipo, porcentaje, fijo, vigente) VALUES
('reserva',13.50,0,TRUE),
('alojamiento_horas',16.00,0,TRUE),
('registro_anfitrion',5.00,25.00,TRUE),
('propiedad',7.00,10.00,TRUE),
('experiencia',10.00,0,TRUE);

-- RECLAMOS
INSERT INTO reclamos (usuario_id, reserva_id, motivo, descripcion, estado) VALUES
(3,1,'Baño no adaptado','El baño no era accesible como se anunciaba','nuevo'),
(3,2,'Rampas ocupadas','Rampas ocupadas por objetos','nuevo'),
(3,3,'Falta info de accesibilidad','Poca info útil en el perfil','en_proceso'),
(3,4,'Ruido excesivo','Mucho ruido en el entorno a cualquier hora','cerrado'),
(3,5,'No llegó confirmación','No recibí email ni mensaje de confirmación','resuelto');

-- POSTULACIONES
INSERT INTO postulaciones (nombre, apellido, email, telefono, edad, perfil, cv_url, mensaje, estado) VALUES
('Carlos','Ramos','carlos@colab.com','33321',29,'Desarrollador Backend','http://cv.com/carlos','Listo para trabajar','recibida'),
('Julia','Pérez','julia@colab.com','33222',31,'Soporte al usuario','http://cv.com/julia','Apoyo a usuarios','en_revision'),
('Luis','Martínez','luis@colab.com','33444',40,'Front-end','http://cv.com/luis','Diseño y UX','entrevista'),
('Sandra','Gómez','sandra@colab.com','33555',28,'Diseño Accesible','http://cv.com/sandra','Diseño inclusivo','aceptada'),
('Teresa','López','teresa@colab.com','33666',33,'Gestión de experiencia','http://cv.com/teresa','Líder de experiencias','rechazada');

-- TUTORIALES DE ASISTENCIA
INSERT INTO tutoriales_asistencia (anfitrion_id, titulo, url_video, contenido, publicado, visualizado) VALUES
(2,'¿Cómo publicar propiedades en eHoli?','https://youtube.com/demo','Tutorial paso a paso',TRUE,FALSE),
(2,'Certificación de Privacidad','https://youtube.com/cert','Renovar y certificar tu política',TRUE,FALSE),
(2,'Responde a tus huéspedes','https://youtube.com/resp','Cómo usar la mensajería interna',TRUE,FALSE),
(2,'Carga imágenes accesibles','https://youtube.com/img','Optimiza imágenes para lectores de pantalla',TRUE,TRUE),
(2,'Gestión de experiencias','https://youtube.com/exp','Publica y administra experiencias',TRUE,TRUE);

-- IMÁGENES DE PROPIEDAD
INSERT INTO imagenes_propiedad (propiedad_id, ruta_imagen, orden, principal) VALUES
(1,'adaptado1.jpg',1,TRUE),
(2,'playa1.jpg',1,TRUE),
(3,'senior1.jpg',1,TRUE),
(4,'urbano1.jpg',1,TRUE),
(5,'eco1.jpg',1,TRUE);
