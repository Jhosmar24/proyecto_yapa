-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-11-2026 a las 04:04:23
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
-- Base de datos: `yapa`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Bebidas', NULL, 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(2, 'Abarrotes', NULL, 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(3, 'Frutas y Verduras', NULL, 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(4, 'Limpieza', NULL, 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` varchar(255) NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventories`
--

CREATE TABLE `inventories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` decimal(12,3) NOT NULL DEFAULT 0.000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `inventories`
--

INSERT INTO `inventories` (`id`, `product_id`, `quantity`, `created_at`, `updated_at`) VALUES
(1, 1, 20.000, '2026-11-09 17:40:38', '2026-11-19 02:58:29'),
(2, 2, 1.000, '2026-11-09 17:40:38', '2026-11-09 19:00:11'),
(3, 3, 10.000, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(4, 4, 26.000, '2026-11-09 17:40:38', '2026-11-18 07:00:39'),
(5, 5, 28.000, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(6, 6, 0.000, '2026-11-09 17:40:38', '2026-11-18 07:00:39'),
(7, 7, 8.000, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(8, 8, 24.500, '2026-11-09 17:40:38', '2026-11-19 02:57:48'),
(9, 9, 14.250, '2026-11-09 17:40:38', '2026-11-11 16:28:39'),
(10, 10, 0.000, '2026-11-10 22:33:51', '2026-11-10 22:33:51'),
(11, 11, 23.000, '2026-11-11 05:54:35', '2026-11-16 00:18:23'),
(12, 12, 0.000, '2026-11-16 00:17:48', '2026-11-16 00:17:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventory_adjustments`
--

CREATE TABLE `inventory_adjustments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `inventory_adjustments`
--

INSERT INTO `inventory_adjustments` (`id`, `user_id`, `reason`, `created_at`, `updated_at`) VALUES
(1, 3, 'inventario', '2026-11-16 00:18:23', '2026-11-16 00:18:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventory_adjustment_items`
--

CREATE TABLE `inventory_adjustment_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `inventory_adjustment_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity_before` decimal(12,3) NOT NULL,
  `quantity_after` decimal(12,3) NOT NULL,
  `difference` decimal(12,3) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `inventory_adjustment_items`
--

INSERT INTO `inventory_adjustment_items` (`id`, `inventory_adjustment_id`, `product_id`, `quantity_before`, `quantity_after`, `difference`, `created_at`, `updated_at`) VALUES
(1, 1, 11, 0.000, 23.000, 23.000, '2026-11-16 00:18:23', '2026-11-16 00:18:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventory_movements`
--

CREATE TABLE `inventory_movements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `quantity_before` decimal(12,3) NOT NULL,
  `quantity_after` decimal(12,3) NOT NULL,
  `reference_type` varchar(40) DEFAULT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `inventory_movements`
--

INSERT INTO `inventory_movements` (`id`, `product_id`, `user_id`, `type`, `quantity`, `quantity_before`, `quantity_after`, `reference_type`, `reference_id`, `reason`, `created_at`, `updated_at`) VALUES
(1, 2, 2, 'sale', 17.000, 18.000, 1.000, 'sale', 1, 'Venta V-20261109150011-0001', '2026-11-09 19:00:11', '2026-11-09 19:00:11'),
(2, 9, 2, 'sale', 1.500, 15.750, 14.250, 'sale', 2, 'Venta V-20261111122839-0002', '2026-11-11 16:28:39', '2026-11-11 16:28:39'),
(3, 11, 3, 'adjustment', 23.000, 0.000, 23.000, 'adjustment', 1, 'inventario', '2026-11-16 00:18:23', '2026-11-16 00:18:23'),
(119, 4, 1, 'sale', 3.000, 35.000, 32.000, 'sale', 31, 'Venta V-20261118025940-0022', '2026-11-18 06:59:40', '2026-11-18 06:59:40'),
(120, 6, 1, 'sale', 4.000, 12.000, 8.000, 'sale', 31, 'Venta V-20261118025940-0022', '2026-11-18 06:59:40', '2026-11-18 06:59:40'),
(121, 4, 1, 'sale', 3.000, 32.000, 29.000, 'sale', 32, 'Venta V-20261118030021-0020', '2026-11-18 07:00:21', '2026-11-18 07:00:21'),
(122, 6, 1, 'sale', 4.000, 8.000, 4.000, 'sale', 32, 'Venta V-20261118030021-0020', '2026-11-18 07:00:21', '2026-11-18 07:00:21'),
(123, 4, 1, 'sale', 3.000, 29.000, 26.000, 'sale', 33, 'Venta V-20261118030039-0021', '2026-11-18 07:00:39', '2026-11-18 07:00:39'),
(124, 6, 1, 'sale', 4.000, 4.000, 0.000, 'sale', 33, 'Venta V-20261118030039-0021', '2026-11-18 07:00:39', '2026-11-18 07:00:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_11_09_124530_create_roles_table', 1),
(5, '2026_11_09_124531_create_permissions_table', 1),
(6, '2026_11_09_124532_create_categories_table', 1),
(7, '2026_11_09_124533_create_units_table', 1),
(8, '2026_11_09_124534_create_products_table', 1),
(9, '2026_11_09_124535_create_inventories_table', 1),
(10, '2026_11_09_124536_create_inventory_movements_table', 1),
(11, '2026_11_09_124537_create_inventory_adjustments_table', 1),
(12, '2026_11_09_124538_create_inventory_adjustment_items_table', 1),
(13, '2026_11_09_124539_create_sales_table', 1),
(14, '2026_11_09_124540_create_sale_items_table', 1),
(15, '2026_11_09_124552_create_permission_role_and_role_user_tables', 1),
(16, '2026_11_09_131030_add_image_url_to_products_table', 1),
(17, '2026_11_09_133237_add_allows_decimal_to_units_table', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'manage-users', 'manage-users', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(2, 'manage-catalog', 'manage-catalog', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(3, 'view-inventory', 'view-inventory', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(4, 'adjust-inventory', 'adjust-inventory', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(5, 'register-sales', 'register-sales', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(6, 'view-reports', 'view-reports', '2026-11-09 17:40:37', '2026-11-09 17:40:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permission_role`
--

CREATE TABLE `permission_role` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permission_role`
--

INSERT INTO `permission_role` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 3),
(5, 1),
(5, 2),
(6, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`id`, `code`, `name`, `category_id`, `unit_id`, `price`, `image_url`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'BEB-001', 'Gaseosa Cola botella 2 L', 1, 1, 12.50, 'https://images.unsplash.com/photo-1629203849820-fdd70d49c38e?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(2, 'BEB-002', 'Agua mineral botella 2 L', 1, 1, 6.50, 'https://images.unsplash.com/photo-1560023907-5f339617ea30?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(3, 'BEB-003', 'Agua mineral paquete 6 botellas', 1, 1, 30.00, 'https://images.unsplash.com/photo-1560023907-5f339617ea30?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(4, 'ABR-001', 'Arroz bolsa 1 kg', 2, 1, 9.80, 'https://images.unsplash.com/photo-1586208958839-06c17cacdf08?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(5, 'ABR-002', 'Fideo surtido 400 g', 2, 1, 6.00, 'https://images.unsplash.com/photo-1556761223-4c4282c73f77?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(6, 'LIM-001', 'Detergente 500 g', 4, 1, 11.00, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(7, 'LIM-002', 'Papel higiénico 4 un.', 4, 1, 14.50, 'https://images.unsplash.com/photo-1584556811426-7d7c2a0df4c8?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(8, 'FRU-001', 'Manzana roja a granel', 3, 2, 18.00, 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(9, 'ABR-003', 'Aceite vegetal a granel', 2, 3, 17.00, 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=800&q=80', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(10, 'BHC', 'Sal', 2, 1, 5.00, NULL, 1, '2026-11-10 22:33:51', '2026-11-10 22:33:51'),
(11, 'ABR-004', 'Aceite Fino botella 2 L', 2, 1, 23.00, NULL, 1, '2026-11-11 05:54:35', '2026-11-11 05:54:35'),
(12, 'e2qe', 't', 2, 1, 43.00, NULL, 1, '2026-11-16 00:17:48', '2026-11-16 00:17:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Administrador', 'Control total del sistema', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(2, 'Cajero', 'Registro de ventas y consulta de existencias', '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(3, 'Encargado de Inventario', 'Control de productos, existencias y ajustes', '2026-11-09 17:40:37', '2026-11-09 17:40:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_user`
--

CREATE TABLE `role_user` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role_user`
--

INSERT INTO `role_user` (`role_id`, `user_id`) VALUES
(1, 1),
(2, 2),
(2, 4),
(3, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `number` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `sold_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `total` decimal(12,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'completed',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sales`
--

INSERT INTO `sales` (`id`, `number`, `user_id`, `sold_at`, `total`, `status`, `created_at`, `updated_at`) VALUES
(1, 'V-20261109150011-0001', 2, '2026-11-09 15:00:11', 110.50, 'completed', '2026-11-09 19:00:11', '2026-11-09 19:00:11'),
(2, 'V-20261111122839-0002', 2, '2026-11-11 12:28:39', 25.50, 'completed', '2026-11-11 16:28:39', '2026-11-11 16:28:39'),
(31, 'V-20261118025940-0022', 1, '2026-11-18 02:59:40', 73.40, 'completed', '2026-11-18 06:59:40', '2026-11-18 06:59:40'),
(32, 'V-20261118030021-0020', 1, '2026-11-18 03:00:21', 73.40, 'completed', '2026-11-18 07:00:21', '2026-11-18 07:00:21'),
(33, 'V-20261118030039-0021', 1, '2026-11-18 03:00:39', 73.40, 'completed', '2026-11-18 07:00:39', '2026-11-18 07:00:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sale_items`
--

CREATE TABLE `sale_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sale_items`
--

INSERT INTO `sale_items` (`id`, `sale_id`, `product_id`, `quantity`, `unit_price`, `subtotal`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 17.000, 6.50, 110.50, '2026-11-09 19:00:11', '2026-11-09 19:00:11'),
(2, 2, 9, 1.500, 17.00, 25.50, '2026-11-11 16:28:39', '2026-11-11 16:28:39'),
(112, 31, 4, 3.000, 9.80, 29.40, '2026-11-18 06:59:40', '2026-11-18 06:59:40'),
(113, 31, 6, 4.000, 11.00, 44.00, '2026-11-18 06:59:40', '2026-11-18 06:59:40'),
(114, 32, 4, 3.000, 9.80, 29.40, '2026-11-18 07:00:21', '2026-11-18 07:00:21'),
(115, 32, 6, 4.000, 11.00, 44.00, '2026-11-18 07:00:21', '2026-11-18 07:00:21'),
(116, 33, 4, 3.000, 9.80, 29.40, '2026-11-18 07:00:39', '2026-11-18 07:00:39'),
(117, 33, 6, 4.000, 11.00, 44.00, '2026-11-18 07:00:39', '2026-11-18 07:00:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('6aSOV9N4zzg13SilcyLONVzCW39WiDEjgexCK0ru', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJRSXpIS0R0TmxaaGhjdWFQSFY3U1Rxb0RFMjJIZ3lDVW1KbkVFbFZqIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJfcHJldmlvdXMiOnsidXJsIjoiaHR0cDpcL1wvMTI3LjAuMC4xOjgwMDAiLCJyb3V0ZSI6ImNhdGFsb2cifX0=', 1794970971);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `units`
--

CREATE TABLE `units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `abbreviation` varchar(12) NOT NULL,
  `allows_decimal` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `units`
--

INSERT INTO `units` (`id`, `name`, `abbreviation`, `allows_decimal`, `created_at`, `updated_at`) VALUES
(1, 'Unidad', 'unid', 0, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(2, 'Kilogramo', 'kg', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(3, 'Litro', 'l', 1, '2026-11-09 17:40:38', '2026-11-09 17:40:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `is_active`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Administrador YAPA', 'admin', 'admin@yapa.test', 1, NULL, '$2y$12$cc.mBx/86Xb0SK/RCPOF0en5k0pByGSMynz5qhA24kKYLAxS8oOl2', NULL, '2026-11-09 17:40:37', '2026-11-09 17:40:37'),
(2, 'Cajero YAPA', 'cajero', 'cajero@yapa.test', 1, NULL, '$2y$12$Dkms0GtNdaNXMzkyqeu87uDCRrgkbH.zi1kuVVGeeU01Cl9keG9ke', NULL, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(3, 'Encargado de Inventario', 'inventario', 'inventario@yapa.test', 1, NULL, '$2y$12$je.wyZ0qoIYnSu6GWWLneuO2ofrGsrVaQjNJxkb93siiTuCfE.ob6', NULL, '2026-11-09 17:40:38', '2026-11-09 17:40:38'),
(4, 'jhos', 'cajero1', 'cuentalolsec234@gmail.com', 0, NULL, '$2y$12$BS8tI17Hw3UI4qsEqFkN8Oqyy9xDTAkZ0Mzoph8AQsmH6RqBgPP0O', NULL, '2026-11-16 00:20:03', '2026-11-16 00:20:11');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_name_unique` (`name`),
  ADD KEY `categories_is_active_index` (`is_active`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indices de la tabla `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inventories_product_id_unique` (`product_id`);

--
-- Indices de la tabla `inventory_adjustments`
--
ALTER TABLE `inventory_adjustments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_adjustments_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `inventory_adjustment_items`
--
ALTER TABLE `inventory_adjustment_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `adjustment_product_unique` (`inventory_adjustment_id`,`product_id`),
  ADD KEY `inventory_adjustment_items_product_id_foreign` (`product_id`);

--
-- Indices de la tabla `inventory_movements`
--
ALTER TABLE `inventory_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_movements_product_id_foreign` (`product_id`),
  ADD KEY `inventory_movements_user_id_foreign` (`user_id`),
  ADD KEY `inventory_movements_reference_type_reference_id_index` (`reference_type`,`reference_id`),
  ADD KEY `inventory_movements_type_index` (`type`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Indices de la tabla `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_code_unique` (`code`),
  ADD KEY `products_category_id_foreign` (`category_id`),
  ADD KEY `products_unit_id_foreign` (`unit_id`),
  ADD KEY `products_name_index` (`name`),
  ADD KEY `products_is_active_index` (`is_active`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Indices de la tabla `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`role_id`,`user_id`),
  ADD KEY `role_user_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sales_number_unique` (`number`),
  ADD KEY `sales_user_id_foreign` (`user_id`),
  ADD KEY `sales_sold_at_index` (`sold_at`),
  ADD KEY `sales_status_index` (`status`);

--
-- Indices de la tabla `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sale_items_sale_id_product_id_unique` (`sale_id`,`product_id`),
  ADD KEY `sale_items_product_id_foreign` (`product_id`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `units_name_unique` (`name`),
  ADD UNIQUE KEY `units_abbreviation_unique` (`abbreviation`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_is_active_index` (`is_active`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventories`
--
ALTER TABLE `inventories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1019;

--
-- AUTO_INCREMENT de la tabla `inventory_adjustments`
--
ALTER TABLE `inventory_adjustments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `inventory_adjustment_items`
--
ALTER TABLE `inventory_adjustment_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `inventory_movements`
--
ALTER TABLE `inventory_movements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1019;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT de la tabla `units`
--
ALTER TABLE `units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `inventories`
--
ALTER TABLE `inventories`
  ADD CONSTRAINT `inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `inventory_adjustments`
--
ALTER TABLE `inventory_adjustments`
  ADD CONSTRAINT `inventory_adjustments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `inventory_adjustment_items`
--
ALTER TABLE `inventory_adjustment_items`
  ADD CONSTRAINT `inventory_adjustment_items_inventory_adjustment_id_foreign` FOREIGN KEY (`inventory_adjustment_id`) REFERENCES `inventory_adjustments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_adjustment_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Filtros para la tabla `inventory_movements`
--
ALTER TABLE `inventory_movements`
  ADD CONSTRAINT `inventory_movements_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `inventory_movements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `products_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`);

--
-- Filtros para la tabla `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `sale_items`
--
ALTER TABLE `sale_items`
  ADD CONSTRAINT `sale_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `sale_items_sale_id_foreign` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
