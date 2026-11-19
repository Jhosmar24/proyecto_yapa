<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CatalogController extends Controller
{
    public function __invoke(Request $request): View
    {
        $products = Product::query()->with(['category', 'unit', 'inventory'])->where('is_active', true)->when($request->search, fn ($query, $search) => $query->where(fn ($nested) => $nested->where('name', 'like', "%{$search}%")->orWhere('code', 'like', "%{$search}%")))->when($request->category, fn ($query, $category) => $query->where('category_id', $category))->orderBy('name')->paginate(12)->withQueryString();

        return view('catalog', ['products' => $products, 'categories' => Category::where('is_active', true)->orderBy('name')->get()]);
    }
}
