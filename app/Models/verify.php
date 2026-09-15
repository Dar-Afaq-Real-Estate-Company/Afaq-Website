<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class verify extends Model
{
     protected $fillable = [
        'Verif',
        'user_Verif',
        'password',
        'last_name',
        'address',
        'Date_of_Birth',
        'phone',
        'Areaname',
        'street',
        'building_number',
        'floor',
        'apartment_number',
        'address_type',
       
    ];
}
