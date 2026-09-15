<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Notifications;
class NotificationsController extends Controller
{
    //
      public function index()
    {
        $notifications = Notifications::get();
        return view('page.notifications', compact('notifications'));
    }
    public function  policy()
    {
       
        return view('page.privacypolicy');
    }
}
