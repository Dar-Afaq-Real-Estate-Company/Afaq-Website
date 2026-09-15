<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\advertisement;
use Carbon\Carbon;
use App\Models\Propertytype; // الموديل الجديد للأنواع
use App\Models\areas;        // الموديل الجديد للمناطق
// use App\Models\News;      // تأكد من مسار موديل News إذا كنت تستخدمه

class detailsController extends Controller
{
    // عرض إعلانات المستخدم الحالي
    public function index()
    { 
        $details = advertisement::where('user_id', auth()->id())->get();
        return view('page.details', compact('details'));
    }
    
    // عرض تفاصيل إعلان محدد
    public function show($id)
    {
        $detail = advertisement::where('id', $id)->first();
        return view('page.detailsshow', compact('detail'));
    }

    public function Aboutus()
    {
        return view('page.Aboutus');
    }

    public function Quick()
    {
        return view('page.Quickreview');
    }

    // دالة البحث المحدثة (تمرير البيانات الديناميكية)
    public function search()
    { 
        $now = Carbon::now();

        // 1. جلب البيانات لقوائم البحث المنسدلة (لتجنب خطأ Undefined variable)
        $propertyTypes = Propertytype::all(); 
        $areas = Areas::all(); 

        // 2. جلب الإعلانات النشطة
        // تم تعديل الشرط ليشمل الإعلانات التي ليس لها تاريخ مزاد أو تاريخ مزادها مستقبلي
        $details = advertisement::where('status', 1)
            ->where(function($query) use ($now) {
                $query->whereNull('auction_date')
                      ->orWhere('auction_date', '>', $now);
            })
            ->latest()
            ->get();

        // 3. تمرير الإعلانات + الأنواع + المناطق للـ Blade
        return view('page.search', compact('details', 'propertyTypes', 'areas'));
    }

    // حذف إعلان
    public function destroy($id)
    {
        // جلب الإعلان الذي يخص المستخدم الحالي
        $advertisement = advertisement::where('user_id', auth()->id())
                                      ->where('id', $id)
                                      ->first();

        if (!$advertisement) {
            return back()->withErrors([
                'message_ar' => 'الإعلان غير موجود أو ليس لديك صلاحية حذفه.',
                'message_en' => 'Advertisement not found or you are not authorized to delete it.'
            ]);
        }

        try {
            $advertisement->delete();
            return redirect()->route('Awards')->with([
                'status_ar' => 'تم حذف الإعلان بنجاح.',
                'status_en' => 'Advertisement deleted successfully.'
            ]);
        } catch (\Exception $e) {
            return back()->withErrors([
                'message_ar' => 'تعذر حذف الإعلان. حاول مرة أخرى.',
                'message_en' => 'Failed to delete the advertisement. Please try again.'
            ]);
        }
    }
}