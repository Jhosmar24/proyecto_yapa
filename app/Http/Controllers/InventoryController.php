<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Inventory;
use App\Models\InventoryAdjustment;
use App\Models\InventoryMovement;
use App\Models\Product;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Illuminate\View\View;

class InventoryController extends Controller
{
    public function index(Request $request): View
    {
        $filters = $request->validate([
            'search' => ['nullable', 'string', 'max:80'],
            'category' => ['nullable', 'integer', 'exists:categories,id'],
            'status' => ['nullable', 'in:all,available,low,out'],
        ]);
        $inventoryQuery = Inventory::with(['product.category', 'product.unit'])
            ->whereHas('product', fn ($query) => $query->where('is_active', true)
                ->when($filters['search'] ?? null, fn ($products, $search) => $products->where(fn ($nested) => $nested->where('name', 'like', "%{$search}%")->orWhere('code', 'like', "%{$search}%")))
                ->when($filters['category'] ?? null, fn ($products, $category) => $products->where('category_id', $category)))
            ->when(($filters['status'] ?? 'all') === 'out', fn ($query) => $query->where('quantity', '<=', 0))
            ->when(($filters['status'] ?? 'all') === 'low', fn ($query) => $query->where('quantity', '>', 0)->where('quantity', '<=', 5))
            ->when(($filters['status'] ?? 'all') === 'available', fn ($query) => $query->where('quantity', '>', 5));

        return view('inventory.index', [
            'inventories' => (clone $inventoryQuery)->orderBy('quantity')->paginate(20)->withQueryString(),
            'lowStock' => Inventory::whereHas('product', fn ($products) => $products->where('is_active', true))->where('quantity', '>', 0)->where('quantity', '<=', 5)->count(),
            'outOfStock' => Inventory::whereHas('product', fn ($products) => $products->where('is_active', true))->where('quantity', '<=', 0)->count(),
            'movements' => InventoryMovement::with(['product.unit'])->latest()->take(10)->get(),
            'categories' => Category::where('is_active', true)->orderBy('name')->get(),
            'filters' => $filters + ['status' => 'all'],
        ]);
    }

    public function adjustForm(): View
    {
        return view('inventory.adjust', ['products' => Product::with(['inventory', 'unit'])->where('is_active', true)->orderBy('name')->get()]);
    }

    public function adjust(Request $request): RedirectResponse
    {
        $data = $request->validate(['reason' => ['required', 'string', 'max:255'], 'items' => ['required', 'array', 'min:1'], 'items.*.product_id' => ['required', 'distinct', 'exists:products,id'], 'items.*.quantity_after' => ['required', 'numeric', 'min:0']]);
        DB::transaction(function () use ($data, $request): void {
            $adjustment = InventoryAdjustment::create(['user_id' => $request->user()->id, 'reason' => $data['reason']]);
            foreach ($data['items'] as $item) {
                $product = Product::with('unit')->findOrFail($item['product_id']);
                $inventory = Inventory::where('product_id', $item['product_id'])->lockForUpdate()->firstOrFail();
                $before = (float) $inventory->quantity;
                $after = (float) $item['quantity_after'];
                if (! $product->unit->allows_decimal && floor($after) !== $after) {
                    throw ValidationException::withMessages(['items' => "{$product->name} se controla por unidad: ingrese una cantidad entera, sin decimales."]);
                }
                if ($before === $after) {
                    continue;
                }
                $adjustment->items()->create(['product_id' => $item['product_id'], 'quantity_before' => $before, 'quantity_after' => $after, 'difference' => $after - $before]);
                $inventory->update(['quantity' => $after]);
                InventoryMovement::create(['product_id' => $item['product_id'], 'user_id' => $request->user()->id, 'type' => 'adjustment', 'quantity' => abs($after - $before), 'quantity_before' => $before, 'quantity_after' => $after, 'reference_type' => 'adjustment', 'reference_id' => $adjustment->id, 'reason' => $data['reason']]);
            }
            if (! $adjustment->items()->exists()) {
                throw ValidationException::withMessages(['items' => 'Indique al menos una cantidad diferente.']);
            }
        });

        return redirect()->route('inventory.index')->with('success', 'Ajuste de inventario registrado.');
    }
}
