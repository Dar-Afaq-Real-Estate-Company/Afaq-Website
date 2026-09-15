<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
class ProfileControllerController extends Controller
{
        public function update(Request $request)
    {
        
        $userData =[
                
            'name' => $request->name,
            'email' => $request->email,
            'last_name' => $request->last_name,
            'phone' => $request->phone,
         
          
        ];
        $user_id=$request->user_id;
        User::where('id' ,(auth()->user()->id ))->update($userData);
       


        return back()->withStatus(__('Profile successfully updated.'));
    }
}
