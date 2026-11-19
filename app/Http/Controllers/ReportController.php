<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Inventory;
use App\Models\InventoryMovement;
use App\Models\Product;
use App\Models\Sale;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\View\View;

class ReportController extends Controller
{
    public function __invoke(Request $request): View
    {
        $filters = $request->validate([
            'from' => ['nullable', 'date'],
            'to' => ['nullable', 'date', 'after_or_equal:from'],
            'type' => ['nullable', 'in:sales,products,inventory,movements'],
            'category' => ['nullable', 'integer', 'exists:categories,id'],
            'product' => ['nullable', 'integer', 'exists:products,id'],
        ]);
        $from = $filters['from'] ?? now()->startOfMonth()->toDateString();
        $to = $filters['to'] ?? now()->toDateString();
        $type = $filters['type'] ?? 'sales';
        $categoryId = $filters['category'] ?? null;
        $productId = $filters['product'] ?? null;

        $salesQuery = Sale::with('user')->whereBetween('sold_at', ["{$from} 00:00:00", "{$to} 23:59:59"]);
        if ($categoryId || $productId) {
            $salesQuery->whereHas('items.product', fn ($query) => $query
                ->when($categoryId, fn ($products) => $products->where('category_id', $categoryId))
                ->when($productId, fn ($products) => $products->where('products.id', $productId)));
        }
        $productSalesQuery = DB::table('sale_items')
            ->join('sales', 'sales.id', '=', 'sale_items.sale_id')
            ->join('products', 'products.id', '=', 'sale_items.product_id')
            ->join('units', 'units.id', '=', 'products.unit_id')
            ->whereBetween('sales.sold_at', ["{$from} 00:00:00", "{$to} 23:59:59"])
            ->when($categoryId, fn ($query) => $query->where('products.category_id', $categoryId))
            ->when($productId, fn ($query) => $query->where('products.id', $productId));
        $inventoryQuery = Inventory::with(['product.category', 'product.unit'])
            ->whereHas('product', fn ($products) => $products->where('is_active', true))
            ->when($categoryId, fn ($query) => $query->whereHas('product', fn ($products) => $products->where('category_id', $categoryId)))
            ->when($productId, fn ($query) => $query->where('product_id', $productId));
        $movementQuery = InventoryMovement::with(['product.unit', 'user'])
            ->whereBetween('created_at', ["{$from} 00:00:00", "{$to} 23:59:59"])
            ->when($categoryId, fn ($query) => $query->whereHas('product', fn ($products) => $products->where('category_id', $categoryId)))
            ->when($productId, fn ($query) => $query->where('product_id', $productId));

        $sales = (clone $salesQuery)->latest('sold_at')->get();
        $summaryTotal = $sales->sum('total');
        $topProducts = (clone $productSalesQuery)
            ->select('products.name', 'units.abbreviation', 'units.allows_decimal', DB::raw('SUM(sale_items.quantity) as quantity'), DB::raw('SUM(sale_items.subtotal) as amount'))
            ->groupBy('products.id', 'products.name', 'units.abbreviation', 'units.allows_decimal')
            ->orderByDesc($type === 'products' ? 'quantity' : 'amount')
            ->limit(30)
            ->get();
        $inventory = (clone $inventoryQuery)->orderBy('quantity')->paginate(30)->withQueryString();
        $movements = (clone $movementQuery)->latest()->paginate(30)->withQueryString();

        return view('reports.index', [
            'type' => $type,
            'from' => $from,
            'to' => $to,
            'categoryId' => $categoryId,
            'productId' => $productId,
            'categories' => Category::where('is_active', true)->orderBy('name')->get(),
            'products' => Product::where('is_active', true)->orderBy('name')->get(),
            'sales' => $sales,
            'summaryTotal' => $summaryTotal,
            'salesCount' => $sales->count(),
            'averageTicket' => $sales->avg('total') ?? 0,
            'topProducts' => $topProducts,
            'inventory' => $inventory,
            'movements' => $movements,
        ]);
    }
}
