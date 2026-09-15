<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Database\QueryException;
use Illuminate\Auth\Events\Registered;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
             'name' => ['required', 'string', 'max:255'],
             'last_name' => ['required', 'string', 'max:255'],
             'phone' => ['required', 'integer', ],
             'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
             'password' => ['required', 'string', 'min:8', 'confirmed'],
           
        ]);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\Models\User
     */
   


protected function create(array $data)
{
    return User::create([
        'name' => $data['name'],
        'last_name' => $data['last_name'],
        'phone' => ltrim($data['country_code'], '+') . $data['phone'],
        'email' => $data['email'],
        'password' => Hash::make($data['password']),

    ]);
}

public function register(Request $request)
{
    $data = $request->all();

    try {

        $user = $this->create($data);
                       
        // تسجيل دخول المستخدم مباشرة
       // auth()->login($user);
                        
        // فحص هل المستخدم يدعم التحقق بالبريد
        event(new Registered($user));

         return redirect()->route('verification.notice');} 
                         
                         
                         
    catch (QueryException $qe) {

        $errorCode = $qe->errorInfo[1] ?? null;

        if ($errorCode == 1062) {
            return redirect()->back()
                ->withInput()
                ->with('error', 'البريد الإلكتروني أو الهاتف موجود مسبقاً.');
        }

        return redirect()->back()
            ->withInput()
            ->with('error', 'خطأ في قاعدة البيانات: '.$qe->getMessage());

    } catch (\Exception $e) {

        return redirect()->back()
            ->withInput()
            ->with('error', 'حدث خطأ: '.$e->getMessage());
    }
}

}
