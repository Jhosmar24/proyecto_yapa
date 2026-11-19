<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Unit extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'abbreviation', 'allows_decimal'];

    protected function casts(): array
    {
        return ['allows_decimal' => 'boolean'];
    }

    public function products(): HasMany
    {
        return $this->hasMany(Product::class);
    }

    public function formatQuantity(float|string $quantity): string
    {
        $value = (float) $quantity;

        if (! $this->allows_decimal) {
            return number_format($value, 0, ',', '.');
        }

        return rtrim(rtrim(number_format($value, 3, ',', '.'), '0'), ',');
    }
}
