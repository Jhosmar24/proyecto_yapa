<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Inventory;
use App\Models\Permission;
use App\Models\Product;
use App\Models\Role;
use App\Models\Unit;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $permissionNames = ['manage-users', 'manage-catalog', 'view-inventory', 'adjust-inventory', 'register-sales', 'view-reports'];
        $permissions = collect($permissionNames)->mapWithKeys(fn ($name) => [$name => Permission::firstOrCreate(['name' => $name], ['description' => $name])]);
        $administrator = Role::firstOrCreate(['name' => 'Administrador'], ['description' => 'Control total del sistema']);
        $administrator->permissions()->sync($permissions->pluck('id'));
        $cashier = Role::firstOrCreate(['name' => 'Cajero'], ['description' => 'Registro de ventas y consulta de existencias']);
        $cashier->permissions()->sync($permissions->only(['view-inventory', 'register-sales'])->pluck('id'));
        $inventoryManager = Role::firstOrCreate(['name' => 'Encargado de Inventario'], ['description' => 'Control de productos, existencias y ajustes']);
        $inventoryManager->permissions()->sync($permissions->only(['manage-catalog', 'view-inventory', 'adjust-inventory'])->pluck('id'));
        $admin = User::firstOrCreate(['username' => 'admin'], ['name' => 'Administrador YAPA', 'email' => 'admin@yapa.test', 'password' => Hash::make('Yapa2026!'), 'is_active' => true]);
        $admin->roles()->sync([$administrator->id]);
        $cashierUser = User::firstOrCreate(['username' => 'cajero'], ['name' => 'Cajero YAPA', 'email' => 'cajero@yapa.test', 'password' => Hash::make('Yapa2026!'), 'is_active' => true]);
        $cashierUser->roles()->sync([$cashier->id]);
        $inventoryUser = User::firstOrCreate(['username' => 'inventario'], ['name' => 'Encargado de Inventario', 'email' => 'inventario@yapa.test', 'password' => Hash::make('Yapa2026!'), 'is_active' => true]);
        $inventoryUser->roles()->sync([$inventoryManager->id]);
        $units = collect([['Unidad', 'unid', false], ['Kilogramo', 'kg', true], ['Litro', 'l', true]])->mapWithKeys(fn ($item) => [$item[1] => Unit::firstOrCreate(['abbreviation' => $item[1]], ['name' => $item[0], 'allows_decimal' => $item[2]])]);
        $categories = collect(['Bebidas', 'Abarrotes', 'Frutas y Verduras', 'Limpieza'])->mapWithKeys(fn ($name) => [$name => Category::firstOrCreate(['name' => $name], ['is_active' => true])]);
        foreach ([
            ['BEB-001', 'Gaseosa Cola botella 2 L', 'Bebidas', 'unid', 12.50, 20, 'https://images.unsplash.com/photo-1629203849820-fdd70d49c38e?auto=format&fit=crop&w=800&q=80'],
            ['BEB-002', 'Agua mineral botella 2 L', 'Bebidas', 'unid', 6.50, 18, 'https://images.unsplash.com/photo-1560023907-5f339617ea30?auto=format&fit=crop&w=800&q=80'],
            ['BEB-003', 'Agua mineral paquete 6 botellas', 'Bebidas', 'unid', 30.00, 10, 'https://images.unsplash.com/photo-1560023907-5f339617ea30?auto=format&fit=crop&w=800&q=80'],
            ['ABR-001', 'Arroz bolsa 1 kg', 'Abarrotes', 'unid', 9.80, 35, 'https://images.unsplash.com/photo-1586208958839-06c17cacdf08?auto=format&fit=crop&w=800&q=80'],
            ['ABR-002', 'Fideo surtido 400 g', 'Abarrotes', 'unid', 6.00, 28, 'https://images.unsplash.com/photo-1556761223-4c4282c73f77?auto=format&fit=crop&w=800&q=80'],
            ['ABR-004', 'Aceite Fino botella 2 L', 'Abarrotes', 'unid', 23.00, 0, 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=800&q=80'],
            ['LIM-001', 'Detergente 500 g', 'Limpieza', 'unid', 11.00, 12, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?auto=format&fit=crop&w=800&q=80'],
            ['LIM-002', 'Papel higiénico 4 un.', 'Limpieza', 'unid', 14.50, 8, 'https://images.unsplash.com/photo-1584556811426-7d7c2a0df4c8?auto=format&fit=crop&w=800&q=80'],
            ['FRU-001', 'Manzana roja a granel', 'Frutas y Verduras', 'kg', 18.00, 24.500, 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?auto=format&fit=crop&w=800&q=80'],
            ['ABR-003', 'Aceite vegetal a granel', 'Abarrotes', 'l', 17.00, 15.750, 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=800&q=80'],
        ] as [$code, $name, $category, $unit, $price, $stock, $imageUrl]) {
            $product = Product::firstOrCreate(['code' => $code], ['name' => $name, 'category_id' => $categories[$category]->id, 'unit_id' => $units[$unit]->id, 'price' => $price, 'image_url' => $imageUrl, 'is_active' => true]);
            Inventory::firstOrCreate(['product_id' => $product->id], ['quantity' => $stock]);
        }
    }
}
