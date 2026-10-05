<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/// صفحات الموقع الجديدة (الرئيسية + قائمة العقارات) بنفس منطق التطبيق.
/// تقرأ مباشرة من نفس قاعدة بيانات التطبيق.
class SiteController extends Controller
{
    /// الإعلانات المنشورة فقط (معتمدة، غير محذوفة من صاحبها، غير منتهية)
    private function liveAds()
    {
        $q = DB::table('advertisements')->where('status', 1);
        if (Schema::hasColumn('advertisements', 'deleted_by_user_at')) {
            $q->whereNull('deleted_by_user_at');
        }
        if (Schema::hasColumn('advertisements', 'closed_status')) {
            $q->whereNull('closed_status');
        }
        $q->where(function ($w) {
            $w->whereNull('auction_date')->orWhere('auction_date', '>', now());
        });
        return $q;
    }

    private function safeTable(string $table, callable $build, $default)
    {
        try {
            return Schema::hasTable($table) ? $build(DB::table($table)) : $default;
        } catch (\Throwable $e) {
            return $default;
        }
    }

    public function home()
    {
        $latest = $this->liveAds()->where('is_featured', 0)->orderByDesc('id')->take(8)->get();
        $featured = $this->liveAds()->where('is_featured', 1)->orderByDesc('id')->take(6)->get();

        // الأكثر ثقة: أكثر 5 نشرًا (تلقائي، نفس منطق التطبيق)
        $topPublishers = function (string $accountType) {
            return DB::table('users')
                ->join('advertisements', 'advertisements.user_id', '=', 'users.id')
                ->where('users.account_type', $accountType)
                ->where('advertisements.status', 1)
                ->select('users.id', 'users.name', 'users.phone',
                    DB::raw(Schema::hasColumn('users', 'company_name') ? 'users.company_name' : 'NULL as company_name'),
                    DB::raw(Schema::hasColumn('users', 'company_type') ? 'users.company_type' : 'NULL as company_type'),
                    DB::raw('COUNT(advertisements.id) as ads_count'))
                ->groupBy('users.id', 'users.name', 'users.phone', 'company_name', 'company_type')
                ->orderByDesc('ads_count')
                ->take(5)
                ->get();
        };
        $companies = rescue(fn () => $topPublishers('company'), collect(), false);
        $agents = rescue(fn () => $topPublishers('broker'), collect(), false);

        $contracting = $this->safeTable('contracting_listings', fn ($t) => $t->where('status', 1)->orderByDesc('id')->take(2)->get(), collect());
        $jobs = $this->safeTable('job_listings', fn ($t) => $t->where('status', 1)->orderByDesc('id')->take(2)->get(), collect());

        $counts = [
            'ads' => $this->liveAds()->count(),
            'contracting' => $this->safeTable('contracting_listings', fn ($t) => $t->where('status', 1)->count(), 0),
            'jobs' => $this->safeTable('job_listings', fn ($t) => $t->where('status', 1)->count(), 0),
            'companies' => DB::table('users')->where('account_type', 'company')->count(),
            'hotels' => $this->safeTable('hotels', fn ($t) => $t->count(), 0),
        ];

        $areas = $this->safeTable('areas', fn ($t) => $t->orderBy('name')->get(), collect());
        $types = $this->safeTable('propertytypes', fn ($t) => $t->get(), collect());

        return view('site.home', compact('latest', 'featured', 'companies', 'agents', 'contracting', 'jobs', 'counts', 'areas', 'types'));
    }

    public function properties(Request $r)
    {
        $q = $this->liveAds();

        if ($r->filled('tx'))      $q->where('transaction_type', 'like', '%' . $r->tx . '%');
        if ($r->filled('section')) $q->where('property_section', $r->section);
        if ($r->filled('type'))    $q->where('type', 'like', '%' . $r->type . '%');
        if ($r->filled('region'))  $q->where('region', $r->region);
        if ($r->filled('min'))     $q->where('price', '>=', (float) $r->min);
        if ($r->filled('max'))     $q->where('price', '<=', (float) $r->max);
        if ($r->filled('rooms'))   $r->rooms === '5' ? $q->where('rooms', '>=', 5) : $q->where('rooms', (int) $r->rooms);
        if ($r->boolean('commission')) $q->where('has_commission', 1);
        if ($r->period === 'weekly' && Schema::hasColumn('advertisements', 'weekly_price')) $q->whereNotNull('weekly_price')->where('weekly_price', '>', 0);
        if ($r->period === 'daily' && Schema::hasColumn('advertisements', 'daily_price'))   $q->whereNotNull('daily_price')->where('daily_price', '>', 0);
        if ($r->filled('q')) {
            $s = '%' . $r->q . '%';
            $q->where(fn ($w) => $w->where('title', 'like', $s)->orWhere('description', 'like', $s)->orWhere('region', 'like', $s)->orWhere('reference_no', 'like', $s));
        }

        // المميز (VIP) مثبّت فوق دائمًا، ثم الترتيب المختار
        $q->orderByDesc('is_featured');
        match ($r->sort) {
            'price' => $q->orderBy('price'),
            'views' => $q->orderByDesc('views_count'),
            default => $q->orderByDesc('id'),
        };

        $ads = $q->paginate(12)->withQueryString();
        $areas = $this->safeTable('areas', fn ($t) => $t->orderBy('name')->get(), collect());

        return view('site.properties', compact('ads', 'areas'));
    }

    /// صفحة موحّدة لأقسام: مقاولات البناء، الوظائف، الشركات العقارية، المكاتب الهندسية، الفنادق
    public function directory(Request $r, string $kind)
    {
        $isAr = app()->getLocale() === 'ar';
        $img = fn ($p) => $p ? (str_starts_with($p, 'http') ? $p : 'https://api.afaq.group/storage/' . ltrim($p, '/')) : null;
        $items = collect();
        $categories = collect();
        $catLabel = null;

        if ($kind === 'contracting') {
            $q = DB::table('contracting_listings')->where('status', 1);
            if (Schema::hasColumn('contracting_listings', 'deleted_by_user_at')) $q->whereNull('deleted_by_user_at');
            $categories = DB::table('contracting_listings')->where('status', 1)->whereNotNull('category')->distinct()->orderBy('category')->pluck('category');
            $catLabel = $isAr ? 'التخصص' : 'Specialty';
            if ($r->filled('cat')) $q->where('category', $r->cat);
            if ($r->filled('region')) $q->where('region', 'like', '%' . $r->region . '%');
            if ($r->filled('q')) $q->where(fn ($w) => $w->where('name', 'like', "%{$r->q}%")->orWhere('category', 'like', "%{$r->q}%")->orWhere('reference_no', 'like', "%{$r->q}%"));
            $page = $q->orderByDesc('id')->paginate(12)->withQueryString();
            $items = $page->getCollection()->map(fn ($x) => ['id' => $x->id, 'title' => $x->name, 'sub' => $x->category, 'region' => $x->region, 'ref' => $x->reference_no, 'img' => $img($x->logo_path ?? null), 'phone' => $x->whatsapp ?: $x->phone, 'views' => $x->views_count ?? 0, 'extra' => $x->bio ?? null, 'icon' => '🦺']);
        } elseif ($kind === 'jobs') {
            $q = DB::table('job_listings')->where('status', 1)->where(fn ($w) => $w->whereNull('listing_type')->orWhere('listing_type', 'vacancy'));
            if (Schema::hasColumn('job_listings', 'expires_at')) $q->where(fn ($w) => $w->whereNull('expires_at')->orWhere('expires_at', '>', now()));
            $categories = collect(['دوام كامل', 'دوام جزئي', 'عن بعد']);
            $catLabel = $isAr ? 'نوع الدوام' : 'Employment type';
            if ($r->filled('cat')) $q->where('employment_type', 'like', '%' . $r->cat . '%');
            if ($r->filled('region')) $q->where('region', 'like', '%' . $r->region . '%');
            if ($r->filled('q')) $q->where(fn ($w) => $w->where('title', 'like', "%{$r->q}%")->orWhere('profession', 'like', "%{$r->q}%")->orWhere('reference_no', 'like', "%{$r->q}%"));
            $page = $q->orderByDesc('id')->paginate(12)->withQueryString();
            $items = $page->getCollection()->map(function ($x) use ($isAr) {
                $salary = ($x->salary && $x->salary !== '0') ? $x->salary . ($isAr ? ' د.ك' : ' KWD') : ($isAr ? 'الراتب عند المقابلة' : 'Salary at interview');
                return ['id' => $x->id, 'title' => $x->title, 'sub' => trim(($x->profession ?? '') . ' · ' . ($x->employment_type ?? ''), ' ·'), 'region' => $x->region, 'ref' => $x->reference_no, 'img' => null, 'phone' => $x->phone, 'views' => $x->views_count ?? 0, 'extra' => $salary, 'icon' => '💼'];
            });
        } elseif ($kind === 'hotels') {
            $q = DB::table('hotels');
            if (Schema::hasColumn('hotels', 'is_active')) $q->where('is_active', 1);
            if ($r->filled('region')) $q->where('region', 'like', '%' . $r->region . '%');
            if ($r->filled('q')) $q->where('name', 'like', "%{$r->q}%");
            $page = $q->orderByDesc('id')->paginate(12)->withQueryString();
            $firstImg = DB::table('hotel_images')->whereIn('hotel_id', $page->getCollection()->pluck('id'))->orderBy('id')->get()->groupBy('hotel_id');
            $items = $page->getCollection()->map(fn ($x) => ['id' => $x->id, 'title' => $x->name, 'sub' => $x->price_per_night ? (number_format((float) $x->price_per_night) . ($isAr ? ' د.ك / الليلة' : ' KWD / night')) : null, 'region' => $x->region, 'ref' => $x->reference_no ?? null, 'img' => $img(optional($firstImg->get($x->id))->first()->path ?? null), 'phone' => $x->whatsapp ?: $x->phone, 'views' => $x->views_count ?? 0, 'extra' => null, 'icon' => '🏨']);
        } else {
            // الشركات العقارية والمكاتب الهندسية: حسابات المستخدمين من نوع شركة
            $types = $kind === 'engineering' ? ['engineering_office', 'engineering', 'office'] : ['real_estate'];
            $q = DB::table('users')->where(function ($w) use ($types, $kind) {
                $w->where('account_type', 'company')->whereIn('company_type', $types);
                if ($kind === 'engineering') $w->orWhere('account_type', 'office');
            });
            if ($r->filled('q')) $q->where(fn ($w) => $w->where('name', 'like', "%{$r->q}%")->orWhere('company_name', 'like', "%{$r->q}%"));
            $page = $q->select('users.*', DB::raw('(SELECT COUNT(*) FROM advertisements a WHERE a.user_id = users.id AND a.status = 1) as ads_count'))
                ->orderByDesc('ads_count')->paginate(12)->withQueryString();
            $items = $page->getCollection()->map(fn ($x) => ['id' => $x->id, 'title' => ($x->company_name ?? null) ?: $x->name, 'sub' => ($isAr ? 'عدد الإعلانات: ' : 'Listings: ') . $x->ads_count, 'region' => $x->region ?? null, 'ref' => null, 'img' => $img(($x->company_logo ?? null) ?: ($x->logo ?? null)), 'phone' => $x->phone, 'views' => null, 'extra' => null, 'icon' => $kind === 'engineering' ? '📐' : '🏢']);
        }

        $page->setCollection($items);
        $areas = $this->safeTable('areas', fn ($t) => $t->orderBy('name')->get(), collect());
        return view('site.directory', ['kind' => $kind, 'items' => $page, 'categories' => $categories, 'catLabel' => $catLabel, 'areas' => $areas]);
    }

    /// صفحة تفاصيل موحّدة لأقسام: مقاول، وظيفة، شركة/مكتب هندسي، فندق
    public function directoryShow(string $kind, int $id)
    {
        $isAr = app()->getLocale() === 'ar';
        $img = fn ($p) => $p ? (str_starts_with($p, 'http') ? $p : 'https://api.afaq.group/storage/' . ltrim($p, '/')) : null;
        $kwd = $isAr ? ' د.ك' : ' KWD';
        $fields = [];
        $gallery = [];
        $ads = collect();

        if ($kind === 'contracting') {
            $x = DB::table('contracting_listings')->where('id', $id)->where('status', 1)->first() ?? abort(404);
            $title = $x->name; $logo = $img($x->logo_path ?? null); $phone = $x->whatsapp ?: $x->phone; $about = $x->bio ?? null; $ref = $x->reference_no;
            $fields = [[$isAr ? 'التخصص' : 'Specialty', $x->category], [$isAr ? 'المحافظة' : 'Governorate', $x->region], [$isAr ? 'المشاهدات' : 'Views', $x->views_count ?? 0]];
            DB::table('contracting_listings')->where('id', $id)->increment('views_count');
        } elseif ($kind === 'jobs') {
            $x = DB::table('job_listings')->where('id', $id)->where('status', 1)->first() ?? abort(404);
            $title = $x->title; $logo = null; $phone = $x->phone; $about = $x->description; $ref = $x->reference_no;
            $days = $x->expires_at ? now()->diffInDays(\Carbon\Carbon::parse($x->expires_at), false) : null;
            $fields = [
                [$isAr ? 'المهنة' : 'Profession', $x->profession],
                [$isAr ? 'نوع الدوام' : 'Employment type', $x->employment_type],
                [$isAr ? 'المؤهل' : 'Qualification', $x->qualification],
                [$isAr ? 'الخبرة' : 'Experience', $x->experience],
                [$isAr ? 'المحافظة' : 'Governorate', $x->region],
                [$isAr ? 'الراتب' : 'Salary', ($x->salary && $x->salary !== '0') ? $x->salary . $kwd : ($isAr ? 'الراتب عند المقابلة' : 'Salary at interview')],
                [$isAr ? 'المتبقي على التقديم' : 'Days left to apply', is_null($days) ? null : max(0, (int) ceil($days)) . ($isAr ? ' يوم' : ' days')],
                [$isAr ? 'البريد' : 'Email', $x->email ?? null],
            ];
        } elseif ($kind === 'hotels') {
            $x = DB::table('hotels')->where('id', $id)->first() ?? abort(404);
            $title = $x->name; $phone = $x->whatsapp ?: $x->phone; $about = $x->description; $ref = $x->reference_no ?? null;
            $gallery = DB::table('hotel_images')->where('hotel_id', $id)->pluck('path')->map($img)->all();
            $logo = $gallery[0] ?? null;
            $fields = [[$isAr ? 'المنطقة' : 'Area', $x->region], [$isAr ? 'سعر الليلة' : 'Per night', $x->price_per_night ? number_format((float) $x->price_per_night) . $kwd : null]];
            foreach (DB::table('hotel_rooms')->where('hotel_id', $id)->get() as $room) {
                $fields[] = [$room->room_type, number_format((float) $room->price_per_night) . $kwd . ' · ' . ($isAr ? 'سعة ' : 'capacity ') . $room->capacity];
            }
            if (!empty($x->latitude) && !empty($x->longitude)) $fields[] = [$isAr ? 'الموقع' : 'Location', 'map:' . $x->latitude . ',' . $x->longitude];
        } else {
            $x = DB::table('users')->where('id', $id)->where('account_type', '!=', 'individual')->first() ?? abort(404);
            $title = ($x->company_name ?? null) ?: $x->name; $logo = $img(($x->company_logo ?? null) ?: ($x->logo ?? null)); $phone = $x->phone; $ref = null;
            $about = Schema::hasTable('company_profiles') ? DB::table('company_profiles')->where('user_id', $id)->value('description') : null;
            $fields = [[$isAr ? 'تاريخ التأسيس' : 'Founded', $x->founded_at ?? null], [$isAr ? 'البريد' : 'Email', $x->email]];
            $ads = $this->liveAds()->where('user_id', $id)->orderByDesc('is_featured')->orderByDesc('id')->take(12)->get();
        }

        $fields = array_values(array_filter($fields, fn ($f) => !is_null($f[1]) && $f[1] !== ''));
        return view('site.directory_show', compact('kind', 'title', 'logo', 'phone', 'about', 'ref', 'fields', 'gallery', 'ads'));
    }

    /// صفحة الخدمات بأسعارها المعتمدة
    public function services()
    {
        return view('site.services');
    }

    /// صفحة العروض والاشتراكات (من جدول الباقات نفسه اللي يستخدمه التطبيق)
    public function plans(Request $r)
    {
        $audience = in_array($r->audience, ['individual', 'broker', 'company']) ? $r->audience : 'individual';
        $cycle = $r->cycle === 'yearly' ? 'yearly' : 'monthly';
        $plans = $this->safeTable('subscription_plans', fn ($t) => $t->where('is_active', 1)->where('audience', $audience)->where('billing_cycle', $cycle)->orderBy('sort_order')->get(), collect());
        return view('site.plans', compact('plans', 'audience', 'cycle'));
    }
}
