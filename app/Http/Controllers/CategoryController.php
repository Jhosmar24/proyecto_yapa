<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CategoryController extends Controller
{
    public function index(): View
    {
        return view('categories.index', ['categories' => Category::withCount('products')->orderBy('name')->get()]);
    }

    public function store(Request $request): RedirectResponse
    {
        Category::create($this->validated($request));

        return back()->with('success', 'Categoría registrada.');
    }

    public function update(Request $request, Category $category): RedirectResponse
    {
        $category->update($this->validated($request, $category));

        return back()->with('success', 'Categoría actualizada.');
    }

    private function validated(Request $request, ?Category $category = null): array
    {
        return $request->validate(['name' => ['required', 'string', 'max:100', 'unique:categories,name,'.($category?->id ?? '')], 'description' => ['nullable', 'string', 'max:255'], 'is_active' => ['required', 'boolean']]);
    }
}
