<?php

namespace App\Http\Controllers;

use App\Models\Inventory;
use App\Models\Product;
use App\Models\Sale;
use Illuminate\View\View;

class DashboardController extends Controller
{
    public function __invoke(): View
    {
        return view('dashboard', ['productCount' => Product::where('is_active', true)->count(), 'lowStock' => Inventory::whereHas('product', fn ($products) => $products->where('is_active', true))->where('quantity', '<=', 5)->count(), 'todayTotal' => Sale::whereDate('sold_at', today())->sum('total'), 'recentSales' => Sale::with('user')->latest('sold_at')->take(5)->get()]);
    }
}
