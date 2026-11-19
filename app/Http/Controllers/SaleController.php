<?php

namespace App\Http\Controllers;

use App\Models\Inventory;
use App\Models\InventoryMovement;
use App\Models\Product;
use App\Models\Sale;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Illuminate\View\View;

class SaleController extends Controller
{
    public function index(Request $request): View
    {
        $filters = $request->validate([
            'from' => ['nullable', 'date'],
            'to' => ['nullable', 'date', 'after_or_equal:from'],
            'search' => ['nullable', 'string', 'max:80'],
        ]);
        $query = Sale::with('user')
            ->when($filters['from'] ?? null, fn ($query, $from) => $query->whereDate('sold_at', '>=', $from))
            ->when($filters['to'] ?? null, fn ($query, $to) => $query->whereDate('sold_at', '<=', $to))
            ->when($filters['search'] ?? null, fn ($query, $search) => $query->where(fn ($nested) => $nested->where('number', 'like', "%{$search}%")->orWhereHas('user', fn ($users) => $users->where('name', 'like', "%{$search}%"))));

        return view('sales.index', [
            'sales' => (clone $query)->latest('sold_at')->paginate(20)->withQueryString(),
            'periodTotal' => (clone $query)->sum('total'),
            'periodCount' => (clone $query)->count(),
            'from' => $filters['from'] ?? '',
            'to' => $filters['to'] ?? '',
            'search' => $filters['search'] ?? '',
        ]);
    }

    public function create(): View
    {
        return view('sales.create', ['products' => Product::with(['inventory', 'unit'])->where('is_active', true)->orderBy('name')->get()]);
    }

    public function store(Request $request): RedirectResponse
    {
        $request->merge(['items' => collect($request->input('items', []))->filter(fn (array $item) => (float) ($item['quantity'] ?? 0) > 0)->values()->all()]);
        $data = $request->validate(['items' => ['required', 'array', 'min:1'], 'items.*.product_id' => ['required', 'distinct', 'exists:products,id'], 'items.*.quantity' => ['required', 'numeric', 'gt:0']]);
        $sale = DB::transaction(function () use ($data, $request): Sale {
            $sale = Sale::create(['number' => 'V-'.now()->format('YmdHis').'-'.str_pad((string) Sale::count() + 1, 4, '0', STR_PAD_LEFT), 'user_id' => $request->user()->id, 'sold_at' => now(), 'total' => 0, 'status' => 'completed']);
            $total = 0;
            foreach ($data['items'] as $item) {
                $product = Product::with('unit')->lockForUpdate()->findOrFail($item['product_id']);
                $inventory = Inventory::where('product_id', $product->id)->lockForUpdate()->firstOrFail();
                $quantity = (float) $item['quantity'];
                $this->ensureQuantityMatchesUnit($product, $quantity);
                if ((float) $inventory->quantity < $quantity) {
                    throw ValidationException::withMessages(['items' => "Stock insuficiente para {$product->name}."]);
                }
                $subtotal = round($quantity * (float) $product->price, 2);
                $sale->items()->create(['product_id' => $product->id, 'quantity' => $quantity, 'unit_price' => $product->price, 'subtotal' => $subtotal]);
                $before = (float) $inventory->quantity;
                $inventory->update(['quantity' => $before - $quantity]);
                InventoryMovement::create(['product_id' => $product->id, 'user_id' => $request->user()->id, 'type' => 'sale', 'quantity' => $quantity, 'quantity_before' => $before, 'quantity_after' => $before - $quantity, 'reference_type' => 'sale', 'reference_id' => $sale->id, 'reason' => 'Venta '.$sale->number]);
                $total += $subtotal;
            }
            $sale->update(['total' => $total]);

            return $sale;
        });

        return redirect()->route('sales.show', $sale)->with('success', 'Venta registrada y stock actualizado.');
    }

    public function show(Sale $sale): View
    {
        return view('sales.show', ['sale' => $sale->load(['user', 'items.product.unit'])]);
    }

    private function ensureQuantityMatchesUnit(Product $product, float $quantity): void
    {
        if (! $product->unit->allows_decimal && floor($quantity) !== $quantity) {
            throw ValidationException::withMessages(['items' => "{$product->name} se vende por unidad: ingrese una cantidad entera, sin decimales."]);
        }
    }
}
