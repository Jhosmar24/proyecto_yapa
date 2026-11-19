<?php

namespace Tests\Feature;

use App\Models\Inventory;
use App\Models\Product;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class InventoryAndSalesTest extends TestCase
{
    use RefreshDatabase;

    public function test_sale_reduces_stock_and_creates_movement(): void
    {
        $this->seed();
        $user = User::where('username', 'admin')->firstOrFail();
        $product = Product::where('code', 'BEB-001')->firstOrFail();
        $response = $this->actingAs($user)->post(route('sales.store'), ['items' => [['product_id' => $product->id, 'quantity' => 2]]]);
        $response->assertRedirect();
        $this->assertDatabaseHas('sales', ['user_id' => $user->id, 'total' => 25]);
        $this->assertDatabaseHas('inventory_movements', ['product_id' => $product->id, 'type' => 'sale', 'quantity_after' => 18]);
        $this->assertSame('18.000', Inventory::where('product_id', $product->id)->value('quantity'));
    }

    public function test_sale_with_insufficient_stock_is_rejected_without_changes(): void
    {
        $this->seed();
        $user = User::where('username', 'admin')->firstOrFail();
        $product = Product::where('code', 'BEB-001')->firstOrFail();
        $this->actingAs($user)->from(route('sales.create'))->post(route('sales.store'), ['items' => [['product_id' => $product->id, 'quantity' => 21]]])->assertRedirect(route('sales.create'));
        $this->assertDatabaseCount('sales', 0);
        $this->assertSame('20.000', Inventory::where('product_id', $product->id)->value('quantity'));
    }

    public function test_sale_rejects_fractional_quantity_for_packaged_products(): void
    {
        $this->seed();
        $user = User::where('username', 'admin')->firstOrFail();
        $product = Product::where('code', 'BEB-002')->firstOrFail();

        $this->actingAs($user)->from(route('sales.create'))->post(route('sales.store'), [
            'items' => [['product_id' => $product->id, 'quantity' => 1.067]],
        ])->assertRedirect(route('sales.create'))->assertSessionHasErrors('items');

        $this->assertDatabaseCount('sales', 0);
        $this->assertSame('18.000', Inventory::where('product_id', $product->id)->value('quantity'));
    }

    public function test_sale_allows_fractional_quantity_for_products_sold_by_weight(): void
    {
        $this->seed();
        $user = User::where('username', 'admin')->firstOrFail();
        $product = Product::where('code', 'FRU-001')->firstOrFail();

        $this->actingAs($user)->post(route('sales.store'), [
            'items' => [['product_id' => $product->id, 'quantity' => 1.5]],
        ])->assertRedirect();

        $this->assertSame('23.000', Inventory::where('product_id', $product->id)->value('quantity'));
    }
}
