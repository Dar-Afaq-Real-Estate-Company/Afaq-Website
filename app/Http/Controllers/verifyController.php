<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\verify;
use Illuminate\Support\Facades\Hash;
class verifyController extends Controller
{
     public function update(Request $request)
    {
    
        $verify0= ("$request->verify1$request->verify2$request->verify3$request->verify4$request->verify5$request->verify6");
     
        if( verify::where('Verif',$verify0)->exists())
        {

           
            $userData =[
                 
            
                'phone_type' => 1,
                
              
            ];
            User::where('id' ,auth()->user()->id)->update($userData);
           
            $product=verify::where('Verif', $verify0);
       
            $product ->delete();
    
            return redirect()->route('home');
        }
        else{

            return back();
        }
        }
}
