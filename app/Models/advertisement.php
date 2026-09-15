<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class advertisement extends Model
{
    //
     protected $fillable = [
        'plan_price',
        'plan_name',
        'transaction_type',
        'phone',
        'title',
        'description',
        'type',
        'region',
        'rooms',
        'bathrooms',
        'halls',
        'area',
        'price',
        'address',
        'images',
        'video',
        'user_id',
        'auction_date',
       
    ];
}
