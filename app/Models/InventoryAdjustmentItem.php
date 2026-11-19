<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InventoryAdjustmentItem extends Model
{
    use HasFactory;

    protected $fillable = ['inventory_adjustment_id', 'product_id', 'quantity_before', 'quantity_after', 'difference'];
}
