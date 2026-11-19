<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Inventory;
use App\Models\Product;
use App\Models\Unit;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class ProductController extends Controller
{
    public function index(Request $request): View
    {
        $products = Product::with(['category', 'unit', 'inventory'])->when($request->search, fn ($q, $s) => $q->where(fn ($n) => $n->where('name', 'like', "%{$s}%")->orWhere('code', 'like', "%{$s}%")))->orderBy('name')->paginate(15)->withQueryString();

        return view('products.index', compact('products'));
    }

    public function create(): View
    {
        return view('products.form', ['product' => new Product, 'categories' => Category::where('is_active', true)->orderBy('name')->get(), 'units' => Unit::orderBy('name')->get()]);
    }

    public function store(Request $request): RedirectResponse
    {
        $product = Product::create($this->validated($request));
        Inventory::create(['product_id' => $product->id]);

        return redirect()->route('products.index')->with('success', 'Producto registrado.');
    }

    public function edit(Product $product): View
    {
        return view('products.form', ['product' => $product, 'categories' => Category::where('is_active', true)->orderBy('name')->get(), 'units' => Unit::orderBy('name')->get()]);
    }

    public function update(Request $request, Product $product): RedirectResponse
    {
        $data = $this->validated($request, $product);
        $unit = Unit::findOrFail($data['unit_id']);
        $currentQuantity = (float) $product->inventory()->value('quantity');
        if (! $unit->allows_decimal && floor($currentQuantity) !== $currentQuantity) {
            return back()->withInput()->withErrors(['unit_id' => 'No puede asignar una unidad entera a un producto que tiene existencias fraccionadas. Ajuste primero el inventario a una cantidad entera.']);
        }
        $product->update($data);

        return redirect()->route('products.index')->with('success', 'Producto actualizado.');
    }

    private function validated(Request $request, ?Product $product = null): array
    {
        return $request->validate(['code' => ['required', 'string', 'max:50', 'unique:products,code,'.($product?->id ?? '')], 'name' => ['required', 'string', 'max:150'], 'category_id' => ['required', 'exists:categories,id'], 'unit_id' => ['required', 'exists:units,id'], 'price' => ['required', 'numeric', 'min:0'], 'image_url' => ['nullable', 'url', 'max:500'], 'is_active' => ['required', 'boolean']]);
    }
}
