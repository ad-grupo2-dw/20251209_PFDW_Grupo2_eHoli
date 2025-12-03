-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-11-2025 a las 01:28:12
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `eholi`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `amenidades`
--

CREATE TABLE `amenidades` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `inclusivo` tinyint(1) DEFAULT 0,
  `icono` varchar(50) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `amenidades`
--

INSERT INTO `amenidades` (`id`, `nombre`, `descripcion`, `inclusivo`, `icono`, `creado_en`) VALUES
(1, 'WiFi', 'Internet inalámbrico', 0, 'wifi', '2025-11-27 14:47:12'),
(2, 'Rampas', 'Acceso para sillas de ruedas', 1, 'ramp', '2025-11-27 14:47:12'),
(3, 'Baño adaptado', 'Baño especial para discapacidad', 1, 'bath-adapt', '2025-11-27 14:47:12'),
(4, 'Ascensor', 'Elevador en edificio', 1, 'elevator', '2025-11-27 14:47:12'),
(5, 'Señalización Braille', 'Señales en sistema braille', 1, 'braille', '2025-11-27 14:47:12'),
(6, 'Cocina', 'Cocina equipada', 0, 'kitchen', '2025-11-27 14:47:12'),
(7, 'Piscina', 'Área de piscina', 0, 'pool', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `amenidades_propiedades`
--

CREATE TABLE `amenidades_propiedades` (
  `propiedad_id` int(11) NOT NULL,
  `amenidad_id` int(11) NOT NULL,
  `agregado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `amenidades_propiedades`
--

INSERT INTO `amenidades_propiedades` (`propiedad_id`, `amenidad_id`, `agregado_en`) VALUES
(1, 1, '2025-11-27 14:47:12'),
(1, 2, '2025-11-27 14:47:12'),
(1, 3, '2025-11-27 14:47:12'),
(1, 4, '2025-11-27 14:47:12'),
(2, 1, '2025-11-27 14:47:12'),
(2, 2, '2025-11-27 14:47:12'),
(2, 3, '2025-11-27 14:47:12'),
(2, 7, '2025-11-27 14:47:12'),
(3, 1, '2025-11-27 14:47:12'),
(3, 3, '2025-11-27 14:47:12'),
(3, 6, '2025-11-27 14:47:12'),
(4, 1, '2025-11-27 14:47:12'),
(4, 2, '2025-11-27 14:47:12'),
(4, 6, '2025-11-27 14:47:12'),
(5, 4, '2025-11-27 14:47:12'),
(5, 5, '2025-11-27 14:47:12'),
(5, 6, '2025-11-27 14:47:12'),
(6, 1, '2025-11-27 14:47:12'),
(6, 6, '2025-11-27 14:47:12'),
(6, 7, '2025-11-27 14:47:12'),
(7, 1, '2025-11-27 14:47:12'),
(7, 6, '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

CREATE TABLE `bitacora` (
  `id` bigint(20) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `evento` varchar(150) NOT NULL,
  `entidad` varchar(50) DEFAULT NULL,
  `entidad_id` varchar(50) DEFAULT NULL,
  `detalles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`detalles`)),
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `ip` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `bitacora`
--

INSERT INTO `bitacora` (`id`, `usuario_id`, `evento`, `entidad`, `entidad_id`, `detalles`, `creado_en`, `ip`) VALUES
(1, 3, 'Reserva realizada', 'reservas', '1', NULL, '2025-11-27 14:47:12', '192.168.1.10'),
(2, 3, 'Inició sesión', 'usuarios', '3', NULL, '2025-11-27 14:47:12', '192.168.1.10'),
(3, 3, 'Nuevo reclamo', 'reclamos', '1', NULL, '2025-11-27 14:47:12', '192.168.1.10'),
(4, 8, 'Pago realizado', 'pagos', '2', NULL, '2025-11-27 14:47:12', '192.168.1.11'),
(5, 9, 'Propiedad marcada como favorita', 'favoritos', '8', NULL, '2025-11-27 14:47:12', '192.168.1.12'),
(6, 10, 'Acceso de administrador', 'usuarios', '10', NULL, '2025-11-27 14:47:12', '10.0.0.1'),
(7, 3, 'Nuevo reclamo: Baño no adaptado', 'reclamos', '1', NULL, '2025-11-27 14:47:12', 'N/A'),
(8, 8, 'Nuevo reclamo: Rampas ocupadas', 'reclamos', '2', NULL, '2025-11-27 14:47:12', 'N/A'),
(9, 9, 'Nuevo reclamo: Falta info de accesibilidad', 'reclamos', '3', NULL, '2025-11-27 14:47:12', 'N/A'),
(10, 3, 'Nuevo reclamo: Ruido excesivo', 'reclamos', '4', NULL, '2025-11-27 14:47:12', 'N/A'),
(11, 8, 'Nuevo reclamo: Problema con WiFi', 'reclamos', '5', NULL, '2025-11-27 14:47:12', 'N/A'),
(12, 9, 'Nuevo reclamo: Anfitrion no responde', 'reclamos', '6', NULL, '2025-11-27 14:47:12', 'N/A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cambios_estado`
--

CREATE TABLE `cambios_estado` (
  `id` bigint(20) NOT NULL,
  `entidad` varchar(50) NOT NULL,
  `entidad_id` varchar(50) NOT NULL,
  `anterior` varchar(50) DEFAULT NULL,
  `nuevo` varchar(50) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `comentario` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cambios_estado`
--

INSERT INTO `cambios_estado` (`id`, `entidad`, `entidad_id`, `anterior`, `nuevo`, `usuario_id`, `fecha`, `comentario`) VALUES
(1, 'reserva', '1', 'pendiente', 'confirmada', 3, '2025-11-27 14:47:12', 'Pago aprobado con tarjeta'),
(2, 'reserva', '2', 'pendiente', 'confirmada', 8, '2025-11-27 14:47:12', 'Confirmación por huesped'),
(3, 'propiedad', '1', 'borrador', 'disponible', 2, '2025-11-27 14:47:12', 'Propiedad aprobada por admin');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `creado_en`) VALUES
(1, 'Playa', 'Alojamientos cerca de la playa', '2025-11-27 14:47:12'),
(2, 'Accesible', 'Adaptado para personas con discapacidad', '2025-11-27 14:47:12'),
(3, 'Senior-Friendly', 'Enfocados en adultos mayores', '2025-11-27 14:47:12'),
(4, 'Urbano', 'Zona céntrica de la ciudad', '2025-11-27 14:47:12'),
(5, 'Naturaleza', 'Áreas naturales y reservas ecológicas', '2025-11-27 14:47:12'),
(6, 'Romántico', 'Alojamientos ideales para parejas', '2025-11-27 14:47:12'),
(7, 'Negocios', 'Propiedades con espacio de trabajo', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comisiones`
--

CREATE TABLE `comisiones` (
  `id` int(11) NOT NULL,
  `tipo` enum('registro_anfitrion','reserva','propiedad','alojamiento_horas','experiencia') NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL CHECK (`porcentaje` >= 0 and `porcentaje` <= 100),
  `fijo` decimal(12,2) DEFAULT 0.00 CHECK (`fijo` >= 0),
  `vigente` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `comisiones`
--

INSERT INTO `comisiones` (`id`, `tipo`, `porcentaje`, `fijo`, `vigente`, `creado_en`) VALUES
(1, 'reserva', 13.50, 0.00, 1, '2025-11-27 14:47:12'),
(2, 'alojamiento_horas', 16.00, 0.00, 1, '2025-11-27 14:47:12'),
(3, 'registro_anfitrion', 5.00, 25.00, 1, '2025-11-27 14:47:12'),
(4, 'propiedad', 7.00, 10.00, 1, '2025-11-27 14:47:12'),
(5, 'experiencia', 10.00, 0.00, 1, '2025-11-27 14:47:12'),
(6, '', 5.00, 5.00, 1, '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `experiencias`
--

CREATE TABLE `experiencias` (
  `id` int(11) NOT NULL,
  `anfitrion_id` int(11) NOT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `titulo` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `inclusiva` tinyint(1) DEFAULT 0,
  `ubicacion` varchar(255) DEFAULT NULL,
  `precio` decimal(12,2) NOT NULL CHECK (`precio` >= 0),
  `moneda` varchar(5) DEFAULT 'USD',
  `estado` enum('borrador','publicada','pausada','eliminada','disponible','ocupado','mantenimiento') DEFAULT 'borrador',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `imagen` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `experiencias`
--

INSERT INTO `experiencias` (`id`, `anfitrion_id`, `categoria_id`, `titulo`, `descripcion`, `inclusiva`, `ubicacion`, `precio`, `moneda`, `estado`, `creado_en`, `actualizado_en`, `imagen`) VALUES
(1, 2, 2, 'Tour inclusivo Centro', 'Tour adaptado en el centro', 1, 'Centro Ciudad', 30.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL),
(2, 2, 1, 'Taller de Playa', 'Taller creativo frente al mar', 0, 'Playa Blanca', 40.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL),
(3, 6, 3, 'Yoga Senior', 'Yoga suave para adultos mayores', 1, 'Villa Senior', 25.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL),
(4, 7, 4, 'Caminata Urbana', 'Con guía y asistencia', 1, 'Centro Urbano', 10.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL),
(5, 7, 5, 'Senderismo Ecológico', 'Ruta accesible y adaptada', 1, 'Eco Refugio', 35.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL),
(6, 6, 6, 'Cata de Vinos', 'Experiencia romántica', 0, 'Cabaña Romántica', 50.00, 'USD', 'publicada', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL),
(7, 2, 7, 'Taller de Productividad', 'Enfoque y herramientas', 0, 'Apartamento Ejecutivo', 20.00, 'USD', 'publicada', '2025-11-27 14:47:12', '2025-11-27 14:47:12', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favoritos`
--

CREATE TABLE `favoritos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `propiedad_id` int(11) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `favoritos`
--

INSERT INTO `favoritos` (`id`, `usuario_id`, `propiedad_id`, `creado_en`) VALUES
(1, 3, 1, '2025-11-27 14:47:12'),
(2, 3, 3, '2025-11-27 14:47:12'),
(3, 3, 5, '2025-11-27 14:47:12'),
(4, 3, 4, '2025-11-27 14:47:12'),
(5, 3, 2, '2025-11-27 14:47:12'),
(6, 8, 7, '2025-11-27 14:47:12'),
(7, 8, 6, '2025-11-27 14:47:12'),
(8, 9, 3, '2025-11-27 14:47:12'),
(9, 9, 5, '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagenes_propiedad`
--

CREATE TABLE `imagenes_propiedad` (
  `id` int(11) NOT NULL,
  `propiedad_id` int(11) NOT NULL,
  `ruta_imagen` varchar(255) NOT NULL,
  `orden` int(11) DEFAULT 1,
  `principal` tinyint(1) DEFAULT 0,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `imagenes_propiedad`
--

INSERT INTO `imagenes_propiedad` (`id`, `propiedad_id`, `ruta_imagen`, `orden`, `principal`, `creado_en`) VALUES
(1, 1, 'adaptado1.jpg', 1, 1, '2025-11-27 14:47:12'),
(2, 2, 'playa1.jpg', 1, 1, '2025-11-27 14:47:12'),
(3, 3, 'senior1.jpg', 1, 1, '2025-11-27 14:47:12'),
(4, 4, 'urbano1.jpg', 1, 1, '2025-11-27 14:47:12'),
(5, 5, 'eco1.jpg', 1, 1, '2025-11-27 14:47:12'),
(6, 6, 'romantica1.jpg', 1, 1, '2025-11-27 14:47:12'),
(7, 7, 'ejecutivo1.jpg', 1, 1, '2025-11-27 14:47:12'),
(8, 1, 'adaptado2.jpg', 2, 0, '2025-11-27 14:47:12'),
(9, 2, 'playa2.jpg', 2, 0, '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `tipo` enum('reserva','pago','experiencia','sistema') DEFAULT NULL,
  `titulo` varchar(150) NOT NULL,
  `mensaje` text NOT NULL,
  `leida` tinyint(1) DEFAULT 0,
  `enviado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id`, `usuario_id`, `tipo`, `titulo`, `mensaje`, `leida`, `enviado_en`) VALUES
(1, 3, 'reserva', 'Reserva Confirmada', 'Tu reserva por horas fue confirmada', 0, '2025-11-27 14:47:12'),
(2, 3, 'sistema', 'Nueva experiencia disponible', 'Yoga para adultos mayores', 0, '2025-11-27 14:47:12'),
(3, 8, 'pago', 'Pago recibido', 'Reserva Casa de Playa', 1, '2025-11-27 14:47:12'),
(4, 9, 'reserva', 'Reserva Pendiente', 'Recuerda completar tu pago', 0, '2025-11-27 14:47:12'),
(5, 8, 'reserva', 'Reserva Aprobada', 'Casa de Playa Accesible aprobada', 1, '2025-11-27 14:47:12'),
(6, 3, 'reserva', 'Cambio de Estado', 'Tu reserva pasó a finalizada', 1, '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `reserva_id` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL CHECK (`monto` >= 0),
  `moneda` varchar(10) DEFAULT 'USD',
  `metodo` enum('tarjeta','transferencia','efectivo') NOT NULL,
  `estado` enum('pendiente','aprobado','fallido') NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `procesado_en` timestamp NULL DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `reserva_id`, `monto`, `moneda`, `metodo`, `estado`, `referencia`, `procesado_en`, `creado_en`) VALUES
(1, 1, 45.00, 'USD', 'tarjeta', 'aprobado', NULL, '2025-10-15 15:00:00', '2025-11-27 14:47:12'),
(2, 2, 360.00, 'USD', 'tarjeta', 'aprobado', NULL, '2025-10-25 20:30:00', '2025-11-27 14:47:12'),
(3, 3, 360.00, 'USD', 'efectivo', 'aprobado', NULL, '2025-11-10 14:00:00', '2025-11-27 14:47:12'),
(4, 4, 20.00, 'USD', 'transferencia', 'pendiente', NULL, NULL, '2025-11-27 14:47:12'),
(5, 5, 360.00, 'USD', 'tarjeta', 'pendiente', NULL, NULL, '2025-11-27 14:47:12'),
(6, 7, 80.00, 'USD', 'transferencia', 'aprobado', NULL, '2025-11-02 16:45:00', '2025-11-27 14:47:12'),
(7, 8, 45.00, 'USD', 'tarjeta', 'aprobado', NULL, '2025-11-20 19:00:00', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `politicas_privacidad`
--

CREATE TABLE `politicas_privacidad` (
  `id` int(11) NOT NULL,
  `anfitrion_id` int(11) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `contenido` text NOT NULL,
  `vigente` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `certificado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `politicas_privacidad`
--

INSERT INTO `politicas_privacidad` (`id`, `anfitrion_id`, `titulo`, `contenido`, `vigente`, `creado_en`, `actualizado_en`, `certificado`) VALUES
(1, 2, 'Privacidad Cliente', 'Se garantiza la privacidad y protección de datos', 1, '2025-11-27 14:47:12', '2025-11-27 14:47:12', 1),
(2, 6, 'Manipulación de Datos', 'Datos manejados con ética y transparencia', 1, '2025-11-27 14:47:12', '2025-11-27 14:47:12', 1),
(3, 7, 'Consentimiento Requerido', 'Siempre se pide consentimiento del cliente', 1, '2025-11-27 14:47:12', '2025-11-27 14:47:12', 1),
(4, 2, 'Certificación Vigente', 'Cumplimos con normas internacionales', 1, '2025-11-27 14:47:12', '2025-11-27 14:47:12', 1),
(5, 6, 'Protección de Menores', 'Resguardamos la info de menores', 1, '2025-11-27 14:47:12', '2025-11-27 14:47:12', 1),
(6, 7, 'Política de Cancelación', 'Reglas claras de cancelación', 1, '2025-11-27 14:47:12', '2025-11-27 14:47:12', 0);

--
-- Disparadores `politicas_privacidad`
--
DELIMITER $$
CREATE TRIGGER `renovar_politica_privacidad` BEFORE UPDATE ON `politicas_privacidad` FOR EACH ROW BEGIN
    IF NEW.vigente = 1 AND OLD.vigente = 0 THEN
        SET NEW.creado_en = NOW();
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `postulaciones`
--

CREATE TABLE `postulaciones` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `perfil` text DEFAULT NULL,
  `cv_url` varchar(255) DEFAULT NULL,
  `mensaje` text DEFAULT NULL,
  `estado` enum('recibida','en_revision','entrevista','aceptada','rechazada') DEFAULT 'recibida',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `postulaciones`
--

INSERT INTO `postulaciones` (`id`, `nombre`, `apellido`, `email`, `telefono`, `edad`, `perfil`, `cv_url`, `mensaje`, `estado`, `creado_en`) VALUES
(1, 'Carlos', 'Ramos', 'carlos@colab.com', '33321', 29, 'Desarrollador Backend', 'http://cv.com/carlos', 'Listo para trabajar', 'recibida', '2025-11-27 14:47:12'),
(2, 'Julia', 'Pérez', 'julia@colab.com', '33222', 31, 'Soporte al usuario', 'http://cv.com/julia', 'Apoyo a usuarios', 'en_revision', '2025-11-27 14:47:12'),
(3, 'Luis', 'Martínez', 'luis@colab.com', '33444', 40, 'Front-end', 'http://cv.com/luis', 'Diseño y UX', 'entrevista', '2025-11-27 14:47:12'),
(4, 'Sandra', 'Gómez', 'sandra@colab.com', '33555', 28, 'Diseño Accesible', 'http://cv.com/sandra', 'Diseño inclusivo', 'aceptada', '2025-11-27 14:47:12'),
(5, 'Teresa', 'López', 'teresa@colab.com', '33666', 33, 'Gestión de experiencia', 'http://cv.com/teresa', 'Líder de experiencias', 'rechazada', '2025-11-27 14:47:12'),
(6, 'Roberto', 'Gil', 'roberto@colab.com', '33777', 35, 'Desarrollador Backend', 'http://cv.com/roberto', 'Buscando nuevo reto', 'recibida', '2025-11-27 14:47:12'),
(7, 'Elena', 'Soto', 'elena@colab.com', '33888', 25, 'Soporte al usuario', 'http://cv.com/elena', 'Experiencia en call center', 'en_revision', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `propiedades`
--

CREATE TABLE `propiedades` (
  `id` int(11) NOT NULL,
  `anfitrion_id` int(11) NOT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `titulo` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `direccion` varchar(255) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `pais` varchar(100) NOT NULL,
  `anfitrion_vive` tinyint(1) DEFAULT 0,
  `capacidad` int(11) NOT NULL CHECK (`capacidad` >= 1),
  `admite_por_horas` tinyint(1) DEFAULT 0,
  `precio_noche` decimal(12,2) NOT NULL CHECK (`precio_noche` >= 0),
  `precio_hora` decimal(12,2) NOT NULL CHECK (`precio_hora` >= 0),
  `moneda` varchar(5) DEFAULT 'USD',
  `estado` enum('borrador','publicada','pausada','eliminada','disponible','ocupado','mantenimiento') DEFAULT 'borrador',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `propiedades`
--

INSERT INTO `propiedades` (`id`, `anfitrion_id`, `categoria_id`, `titulo`, `descripcion`, `direccion`, `ciudad`, `pais`, `anfitrion_vive`, `capacidad`, `admite_por_horas`, `precio_noche`, `precio_hora`, `moneda`, `estado`, `creado_en`, `actualizado_en`) VALUES
(1, 2, 2, 'Apartamento Adaptado Centro', 'Totalmente adaptado con baño especial', 'Av. Central 123', 'Panamá', 'Panamá', 0, 4, 1, 75.00, 15.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(2, 2, 1, 'Casa de Playa Accesible', 'Frente al mar y acceso para sillas de ruedas', 'Calle Sol 45', 'Playa Blanca', 'Panamá', 0, 6, 1, 120.00, 20.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(3, 6, 3, 'Villa Senior Vistas', 'Ideal para mayores, todo en una planta', 'Ruta Verde 108', 'Montaña', 'Panamá', 0, 5, 0, 90.00, 0.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(4, 7, 4, 'Loft Urbano', 'Cerca de hospitales y transporte accesible', 'Calle Centro 11', 'Ciudad', 'Panamá', 0, 3, 1, 60.00, 10.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(5, 7, 5, 'Eco Refugio', 'Naturaleza, senderos adaptados', 'Ruta Bosque 91', 'Reserva', 'Panamá', 0, 8, 0, 180.00, 0.00, 'USD', 'disponible', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(6, 6, 6, 'Cabaña Romántica', 'Con chimenea y jacuzzi', 'Sendero del Amor 5', 'Valle', 'Panamá', 0, 2, 0, 150.00, 0.00, 'USD', 'publicada', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(7, 2, 7, 'Apartamento Ejecutivo', 'Conexión rápida y escritorio amplio', 'Av. Negocios 101', 'Ciudad', 'Panamá', 0, 2, 1, 80.00, 12.00, 'USD', 'publicada', '2025-11-27 14:47:12', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reclamos`
--

CREATE TABLE `reclamos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `reserva_id` int(11) DEFAULT NULL,
  `motivo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` enum('nuevo','en_proceso','resuelto','rechazado','cerrado') DEFAULT 'nuevo',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `reclamos`
--

INSERT INTO `reclamos` (`id`, `usuario_id`, `reserva_id`, `motivo`, `descripcion`, `estado`, `creado_en`, `actualizado_en`) VALUES
(1, 3, 1, 'Baño no adaptado', 'El baño no era accesible como se anunciaba', 'nuevo', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(2, 8, 2, 'Rampas ocupadas', 'Rampas ocupadas por objetos', 'nuevo', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(3, 9, 3, 'Falta info de accesibilidad', 'Poca info útil en el perfil', 'en_proceso', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(4, 3, 4, 'Ruido excesivo', 'Mucho ruido en el entorno a cualquier hora', 'cerrado', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(5, 8, 7, 'Problema con WiFi', 'El internet falló durante la estadía de negocios', 'resuelto', '2025-11-27 14:47:12', '2025-11-27 14:47:12'),
(6, 9, 6, 'Anfitrion no responde', 'La reserva fue cancelada pero el anfitrión no da respuesta', 'nuevo', '2025-11-27 14:47:12', '2025-11-27 14:47:12');

--
-- Disparadores `reclamos`
--
DELIMITER $$
CREATE TRIGGER `log_nuevo_reclamo` AFTER INSERT ON `reclamos` FOR EACH ROW BEGIN
    -- Se inserta en 'bitacora' con valores para 'entidad' y 'entidad_id'
    INSERT INTO bitacora(usuario_id, evento, entidad, entidad_id, creado_en, ip)
    VALUES (NEW.usuario_id, CONCAT('Nuevo reclamo: ', NEW.motivo), 'reclamos', NEW.id, NOW(), 'N/A');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resenas`
--

CREATE TABLE `resenas` (
  `id` int(11) NOT NULL,
  `reserva_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `propiedad_id` int(11) NOT NULL,
  `calificacion` int(11) NOT NULL CHECK (`calificacion` between 1 and 5),
  `comentario` text DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `resenas`
--

INSERT INTO `resenas` (`id`, `reserva_id`, `usuario_id`, `propiedad_id`, `calificacion`, `comentario`, `creado_en`) VALUES
(1, 1, 3, 1, 5, 'Excelente para personas con movilidad reducida', '2025-11-27 14:47:12'),
(2, 2, 8, 2, 4, 'La vista increíble, falta más señalización', '2025-11-27 14:47:12'),
(3, 3, 9, 3, 5, 'Muy recomendado para mayores, atención de 10', '2025-11-27 14:47:12'),
(4, 7, 8, 7, 4, 'Buena opción para estadía de negocios', '2025-11-27 14:47:12'),
(5, 8, 3, 1, 5, 'Apartamento impecable, todo funcionaba perfecto.', '2025-11-27 14:47:12'),
(6, 5, 3, 5, 4, 'Naturaleza adaptada, recomendable', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `id` int(11) NOT NULL,
  `propiedad_id` int(11) NOT NULL,
  `huesped_id` int(11) NOT NULL,
  `fecha_entrada` date NOT NULL,
  `fecha_salida` date NOT NULL,
  `num_huespedes` int(11) DEFAULT NULL,
  `tipo_uso` enum('completa','por_horas') DEFAULT 'completa',
  `estado` enum('pendiente','confirmada','cancelada','finalizada') DEFAULT 'pendiente',
  `precio_total` decimal(12,2) NOT NULL CHECK (`precio_total` >= 0),
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`id`, `propiedad_id`, `huesped_id`, `fecha_entrada`, `fecha_salida`, `num_huespedes`, `tipo_uso`, `estado`, `precio_total`, `creado_en`, `actualizado_en`) VALUES
(1, 1, 3, '2025-10-20', '2025-10-20', 2, 'por_horas', 'finalizada', 45.00, '2025-10-15 05:00:00', '2025-11-27 14:47:12'),
(2, 2, 8, '2025-11-05', '2025-11-08', 3, 'completa', 'confirmada', 360.00, '2025-10-25 05:00:00', '2025-11-27 14:47:12'),
(3, 3, 9, '2025-12-01', '2025-12-05', 1, 'completa', 'confirmada', 360.00, '2025-11-10 05:00:00', '2025-11-27 14:47:12'),
(4, 4, 8, '2025-12-10', '2025-12-10', 1, 'por_horas', 'pendiente', 20.00, '2025-12-05 05:00:00', '2025-11-27 14:47:12'),
(5, 5, 3, '2026-01-01', '2026-01-03', 2, 'completa', 'pendiente', 360.00, '2025-12-15 05:00:00', '2025-11-27 14:47:12'),
(6, 6, 9, '2026-01-15', '2026-01-17', 2, 'completa', 'cancelada', 300.00, '2025-12-20 05:00:00', '2025-11-27 14:47:12'),
(7, 7, 8, '2025-11-15', '2025-11-16', 1, 'completa', 'finalizada', 80.00, '2025-11-01 05:00:00', '2025-11-27 14:47:12'),
(8, 1, 3, '2025-11-25', '2025-11-25', 2, 'por_horas', 'confirmada', 45.00, '2025-11-20 05:00:00', '2025-11-27 14:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutoriales_asistencia`
--

CREATE TABLE `tutoriales_asistencia` (
  `id` int(11) NOT NULL,
  `anfitrion_id` int(11) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `url_video` varchar(255) DEFAULT NULL,
  `contenido` text NOT NULL,
  `publicado` tinyint(1) DEFAULT 0,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `visualizado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tutoriales_asistencia`
--

INSERT INTO `tutoriales_asistencia` (`id`, `anfitrion_id`, `titulo`, `url_video`, `contenido`, `publicado`, `creado_en`, `visualizado`) VALUES
(1, 2, '¿Cómo publicar propiedades en eHoli?', 'https://youtube.com/demo', 'Tutorial paso a paso', 1, '2025-11-27 14:47:12', 0),
(2, 6, 'Certificación de Privacidad', 'https://youtube.com/cert', 'Renovar y certificar tu política', 1, '2025-11-27 14:47:12', 0),
(3, 7, 'Responde a tus huéspedes', 'https://youtube.com/resp', 'Cómo usar la mensajería interna', 1, '2025-11-27 14:47:12', 0),
(4, 2, 'Carga imágenes accesibles', 'https://youtube.com/img', 'Optimiza imágenes para lectores de pantalla', 1, '2025-11-27 14:47:12', 1),
(5, 6, 'Gestión de experiencias', 'https://youtube.com/exp', 'Publica y administra experiencias', 1, '2025-11-27 14:47:12', 1),
(6, 7, 'Comisiones y Pagos', 'https://youtube.com/pago', 'Entiende el desglose de tus pagos', 1, '2025-11-27 14:47:12', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `edad` int(11) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `rol` enum('admin','anfitrion','huesped','soporte','postulante') NOT NULL DEFAULT 'huesped',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `preferencias` varchar(255) DEFAULT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `apellido`, `edad`, `email`, `password`, `telefono`, `rol`, `estado`, `preferencias`, `foto_perfil`, `creado_en`, `actualizado_en`) VALUES
(1, 'Nicole', 'Staff', 23, 'ns@eholi.com', '$2y$10$Q5rCycOHbalweJ83JYmzOekm3T/5x8//G.B8iuc6.f5KRF5KOGcba', NULL, 'admin', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 23:21:26'),
(2, 'Harold', 'Sánchez', 20, 'hs@eholi.com', '$2y$10$agN0/gV08HQlq9ljpzmjSuRoufgBuyazRWTY4K.5KWBaTFcoT43Ca', NULL, 'anfitrion', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 23:48:43'),
(3, 'Moisés', 'Sanchez', 21, 'ms@eholi.com', '$2y$10$Q0CfEgqUAlP8bSopTUvJgOxJ6g9Rl6BrvYiGuYh59hHs5Eyh9rJs2', NULL, 'huesped', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(4, 'Yahna', 'Chee', 29, 'yc@eholi.com', '$2y$10$uBi3BpVjGlyXIqDcWuQHeOq9qegArDj/gRtrUPVHYNLqSar8.LswO', NULL, 'postulante', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(5, 'Carlos', 'Ramos', 30, 'cr@eholi.com', '$2y$10$7B4uSdjvHBV7nmRVWdd.3eP4KD1wHIC1A.u5tHPgljKA6Uu1QJCAu', NULL, 'soporte', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(6, 'María', 'Gómez', 65, 'mg@eholi.com', '$2y$10$fN8X7gDk5bUo0hLpQr2ZeuVq3Yc7sWnL9tMp1vF0xW9jE4mO0oT3', NULL, 'anfitrion', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(7, 'Juan', 'Díaz', 72, 'jd@eholi.com', '$2y$10$1WvT8aVqC2rYpS3oLm4GgXzE0yIu6jJ7hK5cM2dU2gP6aQ1qR8sW', NULL, 'anfitrion', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(8, 'Ana', 'Pérez', 45, 'ap@eholi.com', '$2y$10$2lGvXwZcT4fYrUoM5pQ8sYd0xJpC9lV7mH8kE3nT6oI1fR0sX2wV', NULL, 'huesped', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(9, 'Pedro', 'López', 50, 'pl@eholi.com', '$2y$10$3nOaZwXfU6gHjQyK7rI9tAe1xM0pL2sD5vJ4wE6uH7vC8bZ9yF0t', NULL, 'huesped', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(10, 'Lucía', 'Vera', 35, 'lv@eholi.com', '$2y$10$4oQwXyZaV8hImRjS9tU2pB3eC4fG5iH6jK7lM8nO9pQ0rS1tU2vW', NULL, 'admin', 'activo', NULL, NULL, '2025-11-27 14:47:11', '2025-11-27 14:47:11'),
(11, 'Diego', 'Salazar', 0, 'ds@eholi.com', '$2y$10$wgIDMDi7pizffP7Fc3FC7.ZIBdoBVZndVibrtnnt/HOvc8XzW3XAO', '62685533', 'huesped', 'activo', NULL, NULL, '2025-11-28 00:08:12', '2025-11-28 00:08:12');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_pagos_comisiones_mes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_pagos_comisiones_mes` (
`mes` varchar(7)
,`total_pago` decimal(34,2)
,`total_comision` decimal(43,8)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_props_inclusivas_ciudad`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_props_inclusivas_ciudad` (
`ciudad` varchar(100)
,`categoria` varchar(100)
,`total` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_reclamos_motivo_estado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_reclamos_motivo_estado` (
`motivo` varchar(200)
,`estado` enum('nuevo','en_proceso','resuelto','rechazado','cerrado')
,`total` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_reclamos_pendientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_reclamos_pendientes` (
`id` int(11)
,`nombre` varchar(100)
,`apellido` varchar(100)
,`motivo` varchar(200)
,`descripcion` text
,`estado` enum('nuevo','en_proceso','resuelto','rechazado','cerrado')
,`creado_en` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_reservas_por_estado_mes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_reservas_por_estado_mes` (
`mes` varchar(7)
,`estado` enum('pendiente','confirmada','cancelada','finalizada')
,`total` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `v_pagos_comisiones_mes`
--
DROP TABLE IF EXISTS `v_pagos_comisiones_mes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_pagos_comisiones_mes`  AS SELECT date_format(`p`.`procesado_en`,'%Y-%m') AS `mes`, sum(`p`.`monto`) AS `total_pago`, sum(`p`.`monto` * case `r`.`tipo_uso` when 'completa' then (select `comisiones`.`porcentaje` / 100 from `comisiones` where `comisiones`.`tipo` = 'reserva' and `comisiones`.`vigente` = 1 limit 1) when 'por_horas' then (select `comisiones`.`porcentaje` / 100 from `comisiones` where `comisiones`.`tipo` = 'alojamiento_horas' and `comisiones`.`vigente` = 1 limit 1) else 0 end) AS `total_comision` FROM (`pagos` `p` join `reservas` `r` on(`p`.`reserva_id` = `r`.`id`)) WHERE `p`.`estado` = 'aprobado' AND `p`.`procesado_en` is not null GROUP BY date_format(`p`.`procesado_en`,'%Y-%m') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_props_inclusivas_ciudad`
--
DROP TABLE IF EXISTS `v_props_inclusivas_ciudad`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_props_inclusivas_ciudad`  AS SELECT `p`.`ciudad` AS `ciudad`, `c`.`nombre` AS `categoria`, count(0) AS `total` FROM (`propiedades` `p` join `categorias` `c` on(`p`.`categoria_id` = `c`.`id`)) WHERE `c`.`nombre` in ('Accesible','Senior-Friendly') GROUP BY `p`.`ciudad`, `c`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_reclamos_motivo_estado`
--
DROP TABLE IF EXISTS `v_reclamos_motivo_estado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_reclamos_motivo_estado`  AS SELECT `reclamos`.`motivo` AS `motivo`, `reclamos`.`estado` AS `estado`, count(0) AS `total` FROM `reclamos` GROUP BY `reclamos`.`motivo`, `reclamos`.`estado` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_reclamos_pendientes`
--
DROP TABLE IF EXISTS `v_reclamos_pendientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_reclamos_pendientes`  AS SELECT `r`.`id` AS `id`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido`, `r`.`motivo` AS `motivo`, `r`.`descripcion` AS `descripcion`, `r`.`estado` AS `estado`, `r`.`creado_en` AS `creado_en` FROM (`reclamos` `r` join `usuarios` `u` on(`r`.`usuario_id` = `u`.`id`)) WHERE `r`.`estado` in ('nuevo','en_proceso') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_reservas_por_estado_mes`
--
DROP TABLE IF EXISTS `v_reservas_por_estado_mes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_reservas_por_estado_mes`  AS SELECT date_format(`reservas`.`creado_en`,'%Y-%m') AS `mes`, `reservas`.`estado` AS `estado`, count(0) AS `total` FROM `reservas` GROUP BY date_format(`reservas`.`creado_en`,'%Y-%m'), `reservas`.`estado` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `amenidades`
--
ALTER TABLE `amenidades`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `amenidades_propiedades`
--
ALTER TABLE `amenidades_propiedades`
  ADD PRIMARY KEY (`propiedad_id`,`amenidad_id`),
  ADD KEY `amenidad_id` (`amenidad_id`);

--
-- Indices de la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_bitacora_evento` (`evento`);

--
-- Indices de la tabla `cambios_estado`
--
ALTER TABLE `cambios_estado`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `comisiones`
--
ALTER TABLE `comisiones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `experiencias`
--
ALTER TABLE `experiencias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `anfitrion_id` (`anfitrion_id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Indices de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario_id` (`usuario_id`,`propiedad_id`),
  ADD KEY `propiedad_id` (`propiedad_id`),
  ADD KEY `idx_favoritos_usuario_prop` (`usuario_id`,`propiedad_id`);

--
-- Indices de la tabla `imagenes_propiedad`
--
ALTER TABLE `imagenes_propiedad`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `propiedad_id` (`propiedad_id`,`orden`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pagos_estado` (`estado`),
  ADD KEY `idx_pago_reserva` (`reserva_id`);

--
-- Indices de la tabla `politicas_privacidad`
--
ALTER TABLE `politicas_privacidad`
  ADD PRIMARY KEY (`id`),
  ADD KEY `anfitrion_id` (`anfitrion_id`);

--
-- Indices de la tabla `postulaciones`
--
ALTER TABLE `postulaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `propiedades`
--
ALTER TABLE `propiedades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`),
  ADD KEY `idx_propiedad_estado_categoria` (`estado`,`categoria_id`),
  ADD KEY `idx_propiedad_ciudad_pais` (`ciudad`,`pais`),
  ADD KEY `idx_propiedad_anfitrion` (`anfitrion_id`);

--
-- Indices de la tabla `reclamos`
--
ALTER TABLE `reclamos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `reserva_id` (`reserva_id`),
  ADD KEY `idx_reclamos_estado` (`estado`);

--
-- Indices de la tabla `resenas`
--
ALTER TABLE `resenas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reserva_id` (`reserva_id`,`usuario_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_resena_propiedad` (`propiedad_id`,`calificacion`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `propiedad_id` (`propiedad_id`),
  ADD KEY `idx_reservas_estado_fecha` (`estado`,`fecha_entrada`,`fecha_salida`),
  ADD KEY `idx_reserva_huesped` (`huesped_id`);

--
-- Indices de la tabla `tutoriales_asistencia`
--
ALTER TABLE `tutoriales_asistencia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `anfitrion_id` (`anfitrion_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_usuario_rol_estado` (`rol`,`estado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `amenidades`
--
ALTER TABLE `amenidades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `bitacora`
--
ALTER TABLE `bitacora`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `cambios_estado`
--
ALTER TABLE `cambios_estado`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `comisiones`
--
ALTER TABLE `comisiones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `experiencias`
--
ALTER TABLE `experiencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `imagenes_propiedad`
--
ALTER TABLE `imagenes_propiedad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `politicas_privacidad`
--
ALTER TABLE `politicas_privacidad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `postulaciones`
--
ALTER TABLE `postulaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `propiedades`
--
ALTER TABLE `propiedades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `reclamos`
--
ALTER TABLE `reclamos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `resenas`
--
ALTER TABLE `resenas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tutoriales_asistencia`
--
ALTER TABLE `tutoriales_asistencia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `amenidades_propiedades`
--
ALTER TABLE `amenidades_propiedades`
  ADD CONSTRAINT `amenidades_propiedades_ibfk_1` FOREIGN KEY (`propiedad_id`) REFERENCES `propiedades` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `amenidades_propiedades_ibfk_2` FOREIGN KEY (`amenidad_id`) REFERENCES `amenidades` (`id`);

--
-- Filtros para la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD CONSTRAINT `bitacora_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `cambios_estado`
--
ALTER TABLE `cambios_estado`
  ADD CONSTRAINT `cambios_estado_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `experiencias`
--
ALTER TABLE `experiencias`
  ADD CONSTRAINT `experiencias_ibfk_1` FOREIGN KEY (`anfitrion_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `experiencias_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `favoritos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favoritos_ibfk_2` FOREIGN KEY (`propiedad_id`) REFERENCES `propiedades` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `imagenes_propiedad`
--
ALTER TABLE `imagenes_propiedad`
  ADD CONSTRAINT `imagenes_propiedad_ibfk_1` FOREIGN KEY (`propiedad_id`) REFERENCES `propiedades` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `politicas_privacidad`
--
ALTER TABLE `politicas_privacidad`
  ADD CONSTRAINT `politicas_privacidad_ibfk_1` FOREIGN KEY (`anfitrion_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `propiedades`
--
ALTER TABLE `propiedades`
  ADD CONSTRAINT `propiedades_ibfk_1` FOREIGN KEY (`anfitrion_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `propiedades_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `reclamos`
--
ALTER TABLE `reclamos`
  ADD CONSTRAINT `reclamos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `reclamos_ibfk_2` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `resenas`
--
ALTER TABLE `resenas`
  ADD CONSTRAINT `resenas_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `resenas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `resenas_ibfk_3` FOREIGN KEY (`propiedad_id`) REFERENCES `propiedades` (`id`);

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`propiedad_id`) REFERENCES `propiedades` (`id`),
  ADD CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`huesped_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `tutoriales_asistencia`
--
ALTER TABLE `tutoriales_asistencia`
  ADD CONSTRAINT `tutoriales_asistencia_ibfk_1` FOREIGN KEY (`anfitrion_id`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
