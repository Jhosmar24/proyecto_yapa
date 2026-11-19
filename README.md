# Minimarket YAPA

Sistema web Laravel para gestión de inventario y control de ventas, implementado según el perfil del proyecto.

## Requisitos incluidos

- Autenticación, usuarios activos/inactivos, roles y permisos.
- Categorías, unidades de medida y productos.
- Existencias, ajustes controlados e historial de movimientos.
- Ventas con detalle, cálculo de total y descuento atómico de stock.
- Reporte de ventas por fecha, reporte de existencias y catálogo público.

No incluye compras, proveedores, almacenes múltiples, transferencias, lotes, vencimientos, devoluciones, descuentos, pagos fraccionados, sucursales ni caja avanzada porque no forman parte de los requisitos funcionales del perfil.

## Modelo relacional

`roles`, `permissions`, `role_user` y `permission_role` separan la seguridad en 3FN. `categories` y `units` evitan duplicar sus nombres en `products`. Cada `product` tiene una única fila `inventories`, mientras `inventory_movements` conserva un historial inmutable de entradas o salidas. `sales` es la cabecera y `sale_items` almacena las líneas vendidas y el precio histórico aplicado. Los ajustes se conservan en `inventory_adjustments` y `inventory_adjustment_items`.

Todas las tablas usan claves primarias, claves foráneas, campos atómicos, índices de búsqueda y restricciones de unicidad para códigos, nombres de catálogo y relaciones de detalle. La venta bloquea las filas de inventario, valida que el stock sea suficiente y crea venta, detalle y movimiento dentro de una transacción: ante un error se revierte todo.

## Regla de unidades de venta

El sistema distingue entre la unidad de contenido y la unidad con la que se vende el producto. Una botella de 2 L, una bolsa de arroz de 1 kg o un paquete de agua se registran como `Unidad`, por lo que solo admiten cantidades enteras: 1, 2, 3. Las fracciones se reservan para productos a granel, como manzana por kilogramo o aceite por litro. Esta regla se valida en la interfaz, en el servidor y al realizar ajustes de inventario.

## Ejecutar en Windows con XAMPP

1. Inicie Apache y MySQL desde el panel de XAMPP.
2. Abra PowerShell en `D:\YAPA`.
3. Instale dependencias si es una copia nueva: `composer install`.
4. Revise `.env`: usa MySQL local, base `yapa`, usuario `root` y contraseña vacía. Si su MySQL tiene contraseña, cambie `DB_PASSWORD`.
5. Cree/cargue la base y demostración con `php artisan migrate:fresh --seed`.
6. Inicie el sistema con `php artisan serve`.
7. Abra `http://127.0.0.1:8000` para el catálogo público.

Para la demostración interna ingrese en `http://127.0.0.1:8000/login`:

- Administrador: `admin` / `Yapa2026!` — usuarios, catálogo, inventario, ventas y reportes.
- Cajera: `cajero` / `Yapa2026!` — punto de venta y consulta de existencias.
- Inventario: `inventario` / `Yapa2026!` — productos, categorías, existencias y ajustes.

## Verificación realizada

- Migraciones y datos de prueba ejecutados correctamente contra MySQL en la base `yapa`.
- Tres pruebas automatizadas aprobadas: catálogo, venta con actualización de stock y rechazo de venta sin existencias suficientes.
- Formato de código aplicado mediante Laravel Pint.
