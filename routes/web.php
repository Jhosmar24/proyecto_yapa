<?php

use App\Http\Controllers\AuthenticatedSessionController;
use App\Http\Controllers\CatalogController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\InventoryController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\SaleController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\EnsureActiveUser;
use Illuminate\Support\Facades\Route;

Route::get('/', CatalogController::class)->name('catalog');
Route::middleware('guest')->group(function (): void {
    Route::get('/login', [AuthenticatedSessionController::class, 'create'])->name('login');
    Route::post('/login', [AuthenticatedSessionController::class, 'store'])->name('login.store');
});
Route::middleware(['auth', EnsureActiveUser::class])->group(function (): void {
    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->name('logout');
    Route::get('/panel', DashboardController::class)->name('dashboard');
    Route::middleware('permission:manage-users')->group(function (): void {
        Route::get('/usuarios', [UserController::class, 'index'])->name('users.index');
        Route::post('/usuarios', [UserController::class, 'store'])->name('users.store');
        Route::put('/usuarios/{user}', [UserController::class, 'update'])->name('users.update');
    });
    Route::middleware('permission:manage-catalog')->group(function (): void {
        Route::get('/categorias', [CategoryController::class, 'index'])->name('categories.index');
        Route::post('/categorias', [CategoryController::class, 'store'])->name('categories.store');
        Route::put('/categorias/{category}', [CategoryController::class, 'update'])->name('categories.update');
        Route::resource('products', ProductController::class)->except('show', 'destroy');
    });
    Route::middleware('permission:view-inventory')->get('/inventario', [InventoryController::class, 'index'])->name('inventory.index');
    Route::middleware('permission:adjust-inventory')->group(function (): void {
        Route::get('/inventario/ajuste', [InventoryController::class, 'adjustForm'])->name('inventory.adjust.form');
        Route::post('/inventario/ajuste', [InventoryController::class, 'adjust'])->name('inventory.adjust');
    });
    Route::middleware('permission:register-sales')->group(function (): void {
        Route::get('/ventas', [SaleController::class, 'index'])->name('sales.index');
        Route::get('/ventas/nueva', [SaleController::class, 'create'])->name('sales.create');
        Route::post('/ventas', [SaleController::class, 'store'])->name('sales.store');
        Route::get('/ventas/{sale}', [SaleController::class, 'show'])->name('sales.show');
    });
    Route::middleware('permission:view-reports')->get('/reportes', ReportController::class)->name('reports.index');
});
