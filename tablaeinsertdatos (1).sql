-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 02-05-2022 a las 15:19:31
-- Versión del servidor: 8.0.17
-- Versión de PHP: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tablaeinsertdatos`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `contarProductosPorEstado` (IN `nombre_estado` VARCHAR(25), OUT `numero` INT)  BEGIN
    SELECT count(id) 
    INTO numero
    FROM productos
    WHERE estado = nombre_estado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nombreproducto` (IN `nombre_cliente` VARCHAR(55))  BEGIN
   select nombre from producto where id in 
(select id from detalle_fac where id_enc = ( select id from factura where id_person =
(select id from personas where nombre = nombre_cliente ))) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nombreproductos` (IN `nombre_cliente` VARCHAR(55))  BEGIN
   select nombre from productos where id in 
(select id from detalle_fac where id_enc = ( select id from factura where id_person =
(select id from personas where nombre = nombre_cliente )));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerProductosPorEstado` (IN `nombre_estado` VARCHAR(255))  BEGIN
    SELECT * 
    FROM productos
    WHERE estado = nombre_estado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `venderProducto` (INOUT `beneficio` INT(255), IN `id_producto` INT)  BEGIN
    SELECT @incremento_precio = precio 
    FROM productos
    WHERE id=id_producto;
    SET beneficio=beneficio + @incremento_precio;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_fac`
--

CREATE TABLE `detalle_fac` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `id_enc` int(11) DEFAULT NULL,
  `id_pro` int(11) DEFAULT NULL,
  `cant` int(11) DEFAULT NULL,
  `total` bigint(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `detalle_fac`
--

INSERT INTO `detalle_fac` (`id`, `nombre`, `id_enc`, `id_pro`, `cant`, `total`) VALUES
(1, 'orlay', 1, 1, 5, 40),
(2, 'samuel', 2, 2, 3, 45);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `id` int(11) NOT NULL,
  `id_person` int(11) DEFAULT NULL,
  `nom_emp` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`id`, `id_person`, `nom_emp`) VALUES
(1, 123, 'emp_ciclojunior'),
(2, 456, 'emp_flynn');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id`, `nombre`) VALUES
(123, 'orlay'),
(456, 'samuel');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'disponible',
  `precio` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `estado`, `precio`) VALUES
(1, 'Producto A', 'disponible', 8),
(2, 'Producto B', 'disponible', 1.5),
(3, 'Producto C', 'agotado', 80);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detalle_fac`
--
ALTER TABLE `detalle_fac`
  ADD PRIMARY KEY (`id`),
  ADD KEY `relacion` (`id_pro`),
  ADD KEY `relacion2` (`id_enc`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`id`),
  ADD KEY `relacion3` (`id_person`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_fac`
--
ALTER TABLE `detalle_fac`
  ADD CONSTRAINT `relacion` FOREIGN KEY (`id_pro`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `relacion2` FOREIGN KEY (`id_enc`) REFERENCES `factura` (`id`);

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `relacion3` FOREIGN KEY (`id_person`) REFERENCES `personas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
