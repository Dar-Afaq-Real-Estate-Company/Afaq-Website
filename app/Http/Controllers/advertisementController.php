<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\advertisement;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use App\Models\Propertytype; // الموديل الجديد
use App\Models\Areas;        // الموديل الجديد
use \Models\News;
class advertisementController extends Controller
{
    //
    public function search(Request $request)
{
    $query = advertisement::query();

    // فلترة حسب المنطقة
    if ($request->filled('region')) {
        $query->where('region', $request->region);
    }

    // فلترة حسب النوع
    if ($request->filled('type')) {
        $query->where('type', $request->type);
    }

    // فلترة حسب الحالة (للبيع، للايجار...)
    if ($request->filled('transaction_type') && $request->transaction_type != 'الكل') {
        $query->where('transaction_type', $request->transaction_type);
    }

    // إذا كان هناك بحث فعلي (أي مستخدم اختار منطقة أو نوع)
    // والنتيجة لم تجد شيئاً، سيعود المتغير فارغاً ولن تظهر البطاقات.
    $details = $query->get();

    return view('page.search', compact('details'));
}

public function filterAds($section, $type)
    {
        $now = Carbon::now();

        // فك الترميز للغة العربية
        $sectionName = urldecode($section);
        $typeName    = urldecode($type);

        // جلب البيانات بناءً على القسم والنوع
        $details = advertisement::where('transaction_type', $sectionName)
                                ->where('type', $typeName)
                                ->where('auction_date', '>', $now)
                                ->orderBy('auction_date', 'asc')
                                ->get();

        return view('page.show', [
            'details' => $details,
            'section' => $sectionName,
            'type'    => $typeName
        ]);
    }
public function show($section = 'all', $type = 'all', $region = 'all')
{
    $now = Carbon::now();

    // فك ترميز القيم للتعامل مع النصوص العربية
    $section = urldecode($section);
    $type    = urldecode($type);
    $region  = urldecode($region);

    // نبدأ الاستعلام مع شرط الوقت الأساسي (يُطبق دائماً)
    $query = advertisement::where('auction_date', '>', $now);

    // إضافة شرط "نوع المعاملة" فقط إذا لم يكن 'all'
    if ($section !== 'all') {
        $query->where('transaction_type', $section);
    }

    // إضافة شرط "النوع" فقط إذا لم يكن 'all'
    if ($type !== 'all') {
        $query->where('type', $type);
    }

    // إضافة شرط "المنطقة" فقط إذا لم يكن 'all'
    if ($region !== 'all') {
        $query->where('region', $region);
    }

    // تنفيذ الاستعلام وجلب النتائج
    $details = $query->latest()->get();

    return view('page.show', compact('details'));
}

  public function store(Request $request)
{
    try {
        $validated = $request->validate([
            'selected_plan_price' => 'required',
            'selected_plan_name'  => 'required',
            'transaction_type'    => 'required',

            'description'         => 'required',
            'type'                => 'required',
            'region'              => 'required',
            'price'               => 'required|numeric|min:1',
        ]);

        $auctionDate = $request->auction_date;

        if ($request->hasFile('images')) {
            $image = $request->file('images');
            $newphoto = time() . '_' . $image->getClientOriginalName();
            $image->move(public_path('uploade/image'), $newphoto);
            $imagePath = 'https://darafaqkw.com/uploade/image/' . $newphoto;
        } else {
            $imagePath = null;
        }

        $advertisement = advertisement::create([
            'plan_price'       => $validated['selected_plan_price'],
            'plan_name'        => $validated['selected_plan_name'],
            'transaction_type' => $validated['transaction_type'],
            'phone'            => auth()->user()->phone,
            'user_id'          => auth()->user()->id,
            'description'      => $validated['description'],
            'description'      => $validated['description'],
            'type'             => $validated['type'],
            'region'           => $validated['region'],
            'auction_date'     => $auctionDate,
            'price'            => $validated['price'],
            'images'           => $imagePath,
        ]);

        $advertisement->save();

        return redirect()->route('details')->with('success', __('main.data_saved_successfully'));

    } catch (\Exception $e) {
        // إرسال رسالة الخطأ الحقيقية نفسها للفورم
        return back()
            ->withInput()
            ->withErrors(['error' => $e->getMessage()]);
    }
}


public function update(Request $request)
{
    try {
        // 1. التحقق من البيانات (نفس قواعد الـ store)
        $validated = $request->validate([
            'ad_id'       => 'required|exists:advertisements,id', // التأكد من وجود الإعلان
            'type'        => 'required',
            'region'      => 'required',
            'price'       => 'required|numeric|min:1',
            'description' => 'required',
            // الهاتف اختياري هنا لأنه غالباً يتم تحديثه إذا لزم الأمر
            'phone'       => 'nullable',
        ]);

        // 2. البحث عن الإعلان المطلوب تحديثه
        $advertisement = advertisement::findOrFail($request->ad_id);

        // 3. منطق تحديث الصورة
        $imagePath = $advertisement->images; // الاحتفاظ بالصورة القديمة كافتراضي

        if ($request->hasFile('images')) {
            // ملاحظة: إذا كنت ترفع مصفوفة صور [images] في التعديل
            // هنا نأخذ أول صورة كما في منطق الـ store الخاص بك
            $files = $request->file('images');
            $image = is_array($files) ? $files[0] : $files;

            $newphoto = time() . '_' . $image->getClientOriginalName();
            $image->move(public_path('uploade/image'), $newphoto);
            $imagePath = 'https://darafaqkw.com/uploade/image/' . $newphoto;

            // (اختياري) يمكنك إضافة كود هنا لحذف الصورة القديمة من السيرفر لتوفير المساحة
        }

        // 4. تحديث البيانات في قاعدة البيانات
        $advertisement->update([
            'type'        => $validated['type'],
            'region'      => $validated['region'],
            'price'       => $validated['price'],
            'description' => $validated['description'],
            'phone'       => $request->phone ?? $advertisement->phone, // تحديث الهاتف إذا أُرسل
            'images'      => $imagePath,
        ]);

        return redirect()->route('details')->with('success', __('main.data_updated_successfully'));

    } catch (\Exception $e) {
        return back()
            ->withInput()
            ->withErrors(['error' => $e->getMessage()]);
    }
}


}
