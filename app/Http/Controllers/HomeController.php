<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\verify;
use Illuminate\Support\Facades\Mail;
use App\Mail\Signup;
use App\Models\User;
use Carbon\Carbon;
use App\Models\advertisement;

use App\Models\Propertytype; // الموديل الجديد
use App\Models\areas;        // الموديل الجديد
use App\Models\News;         // الموديل الجديد

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    // public function __construct()
    // {
    //     $this->middleware('auth');
    // }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */


public function welcome()
{
    $now = Carbon::now();

    // 1. إعلانات VIP النشطة فقط
    $details = Advertisement::where('plan_name', 'VIP')
        ->where('status', 1)
        ->where(function ($q) use ($now) {
            $q->whereNull('auction_date')
              ->orWhere('auction_date', '>', $now);
        })
        ->latest()
        ->get();

    // 2. المزادات القادمة النشطة فقط
    $Upcomings = Advertisement::where('transaction_type', 'مزاد')
        ->where('status', 1)
        ->whereDate('auction_date', '>=', Carbon::today())
        ->where(function ($q) use ($now) {
            $q->whereNull('auction_date')
              ->orWhere('auction_date', '>', $now);
        })
        ->orderBy('auction_date')
        ->get();

    // --- إضافة الموديلات الجديدة ---

    // 3. جلب أنواع العقارات (لاستخدامها في محرك البحث أو التصنيفات)
    $propertyTypes = Propertytype::all();

    // 4. جلب المناطق (لاستخدامها في فلتر البحث)
    $areas = Areas::all();

    // 5. جلب أحدث 3 أخبار أو مقالات لنشرها في قسم الأخبار
    $latestNews = News::latest()->take(3)->get();

    return view('welcome', compact(
        'details', 
        'Upcomings', 
        'propertyTypes', 
        'areas', 
        'latestNews'
    ));
}
    




public function index()
{
    $now = Carbon::now();

    // 1. إعلانات VIP النشطة فقط
    $details = Advertisement::where('plan_name', 'VIP')
        ->where('status', 1) 
        ->where(function ($q) use ($now) {
            $q->whereNull('auction_date')
              ->orWhere('auction_date', '>', $now);
        })
        ->latest()
        ->get();

    // 2. المزادات القادمة النشطة فقط
    $Upcomings = Advertisement::where('transaction_type', 'مزاد')
        ->where('status', 1) 
        ->whereDate('auction_date', '>=', Carbon::today())
        ->where(function ($q) use ($now) {
            $q->whereNull('auction_date')
              ->orWhere('auction_date', '>', $now);
        })
        ->orderBy('auction_date')
        ->get();

    // --- إضافة الموديلات الجديدة لجعل الصفحة أكثر حيوية ---

    // 3. جلب كافة أنواع العقارات (لأغراض الفلترة أو الإحصائيات)
    $propertyTypes = Propertytype::all();

    // 4. جلب جميع المناطق المسجلة
    $areas = Areas::all();

    // 5. جلب أحدث 4 أخبار لعرضها في قسم المقالات/الأخبار
    $latestNews = News::latest()->take(4)->get();

    // إرسال كافة البيانات إلى ملف الـ view
    return view('home', compact(
        'details', 
        'Upcomings', 
        'propertyTypes', 
        'areas', 
        'latestNews'
    ));
}


 public function Verifyphone()
{
    $user = auth()->user();

    // جلب أو إنشاء كود التحقق لمرة واحدة سواء للإيميل أو الهاتف
    $verification = verify::firstOrCreate(
        ['user_Verif' => $user->email],
        ['Verif' => random_int(100000, 999999)]
    );

    // تحديث الكود كل مرة لضمان كود جديد
    $verification->Verif = random_int(100000, 999999);
    $verification->save();

    // نص الرسالة
    $msg = "رمز التحقق الخاص بك هو: " . $verification->Verif . 
           "\nلحفاظ على أمانك، لا تشارك الكود مع أي شخص.";

    // إرسال البريد الإلكتروني
   // Mail::to($user->email)->send(new Signup($verification->Verif));

    // إرسال WhatsApp بدون مفتاح الدولة
if (!empty($user->phone)) {
    $response = $this->sendWhatsAppMessage($user->phone, $msg);

    dd($response);
}

return view('page.Verifyphone');
}

/**
 * دالة إرسال WhatsApp عبر UltraMsg
 */
private function sendWhatsAppMessage($phone, $message)
{
    $instanceId = env('ULTRAMSG_INSTANCE_ID');
    $token      = env('ULTRAMSG_TOKEN');

    $url = "https://api.ultramsg.com/$instanceId/messages/chat";

    $data = [
        "token"   => $token,
        "to"      => $phone,   // رقم المستقبل
        "body"    => $message, // النص المرسل
    ];

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));

    $response = curl_exec($ch);
    curl_close($ch);

    return $response;
}


     public function Aboutus()
    {
        return view('page.Aboutus');
    }
     public function send()
    {
        $msg=verify::where('user_Verif',auth()->user()->email)->select()->value('Verif');
      
       return view('page.Verifyphone');
    }
    
    public function Mailsend()
    {
       return view('page.Mailsend');
    }
    public function advertisement()
    {
       return view('page.advertisement');
    }
}
