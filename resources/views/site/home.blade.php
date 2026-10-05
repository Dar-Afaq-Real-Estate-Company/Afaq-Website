@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $kwd = $isAr ? 'د.ك' : 'KWD';
    $services = [
        ['🏠', $isAr ? 'اطلب عقارك' : 'Request a property', $isAr ? 'مجاني' : 'Free', true],
        ['🗂', $isAr ? 'إدارة الأملاك' : 'Property management', $isAr ? 'من 100 د.ك' : 'From 100 KWD', false],
        ['💬', $isAr ? 'الاستشارة العقارية' : 'Real estate consultation', '40 ' . $kwd, false],
        ['📋', $isAr ? 'التقييم العقاري المعتمد' : 'Certified valuation', $isAr ? 'من 100 د.ك' : 'From 100 KWD', false],
        ['🧮', $isAr ? 'حسبة الإيجار' : 'Rent calculator', $isAr ? 'مجاني' : 'Free', true],
        ['🏗', $isAr ? 'تكلفة البناء' : 'Construction cost', $isAr ? 'مجاني' : 'Free', true],
    ];
    $sections = [
        ['🏘', $isAr ? 'العقارات' : 'Properties', $counts['ads'], route('site.properties')],
        ['🦺', $isAr ? 'مقاولات البناء' : 'Contracting', $counts['contracting'], route('site.section', 'contracting')],
        ['💼', $isAr ? 'الوظائف' : 'Jobs', $counts['jobs'], route('site.section', 'jobs')],
        ['🏢', $isAr ? 'الشركات العقارية' : 'Companies', $counts['companies'], route('site.section', 'companies')],
        ['📐', $isAr ? 'المكاتب الهندسية' : 'Engineering offices', null, route('site.section', 'engineering')],
        ['🏨', $isAr ? 'الفنادق' : 'Hotels', $counts['hotels'], route('site.section', 'hotels')],
    ];
    $companyTypeLabel = fn ($t) => match ($t) {
        'real_estate' => $isAr ? 'عقارية' : 'Real estate',
        'engineering_office', 'engineering' => $isAr ? 'هندسية' : 'Engineering',
        'hotel' => $isAr ? 'فندقية' : 'Hotel',
        default => $isAr ? 'شركة' : 'Company',
    };
@endphp

<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <section style="background:linear-gradient(160deg,#0b3442 0%,#0f4051 55%,#16606e 100%);padding:64px 0 110px;position:relative;overflow:hidden">
        <div style="position:absolute;inset:0;opacity:.07;background-image:radial-gradient(#fff 1px,transparent 1px);background-size:22px 22px"></div>
        <div class="af-wrap" style="position:relative;text-align:center">
            <div style="display:inline-block;padding:6px 16px;border-radius:30px;background:rgba(203,161,53,.16);color:#e6c76a;font-weight:700;font-size:13.5px;margin-bottom:18px">{{ $isAr ? 'المنصة العقارية الأولى في الكويت' : "Kuwait's leading real estate platform" }}</div>
            <h1 style="color:#fff;font-weight:900;font-size:clamp(32px,5vw,52px);line-height:1.2;margin-bottom:12px">{{ $isAr ? 'ابحث عن عقارك بثقة' : 'Find your property with confidence' }}</h1>
            <p style="color:rgba(255,255,255,.75);font-size:18px;max-width:640px;margin:0 auto">{{ $isAr ? 'عقارات، مقاولات البناء، وظائف، شركات عقارية ومكاتب هندسية في مكان واحد' : 'Properties, contracting, jobs, companies and engineering offices in one place' }}</p>
        </div>
    </section>

    <div class="af-wrap" style="max-width:1100px;margin-top:-62px;position:relative;z-index:5">
        <form method="GET" action="{{ route('site.properties') }}" style="background:#fff;border-radius:22px;box-shadow:0 24px 60px rgba(11,52,66,.18);padding:14px">
            <div style="display:flex;gap:6px;margin-bottom:12px" id="txTabs">
                @foreach (['بيع' => $isAr ? 'بيع' : 'Sale', 'إيجار' => $isAr ? 'إيجار' : 'Rent', 'بدل' => $isAr ? 'بدل' : 'Exchange'] as $v => $l)
                    <label style="cursor:pointer">
                        <input type="radio" name="tx" value="{{ $v }}" {{ $v === 'بيع' ? 'checked' : '' }} style="display:none" onchange="document.querySelectorAll('#txTabs span').forEach(s=>{s.style.background='#fff';s.style.color='#0f2a33'});this.nextElementSibling.style.background='#0f4051';this.nextElementSibling.style.color='#fff'">
                        <span style="display:inline-block;padding:8px 20px;border-radius:10px;font-weight:800;font-size:14px;background:{{ $v === 'بيع' ? '#0f4051' : '#fff' }};color:{{ $v === 'بيع' ? '#fff' : '#0f2a33' }}">{{ $l }}</span>
                    </label>
                @endforeach
            </div>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:10px">
                <select name="section" class="form-select" style="background-color:#f3f6f7;border:0;border-radius:14px;padding:14px;font-weight:800">
                    <option value="">{{ $isAr ? 'التصنيف' : 'Category' }}</option>
                    @foreach (['سكني' => $isAr ? 'سكني' : 'Residential', 'تجاري' => $isAr ? 'تجاري' : 'Commercial', 'استثماري' => $isAr ? 'استثماري' : 'Investment', 'صناعي' => $isAr ? 'صناعي' : 'Industrial'] as $v => $l)
                        <option value="{{ $v }}">{{ $l }}</option>
                    @endforeach
                </select>
                <select name="type" class="form-select" style="background-color:#f3f6f7;border:0;border-radius:14px;padding:14px;font-weight:800">
                    <option value="">{{ $isAr ? 'نوع العقار' : 'Property type' }}</option>
                    @foreach ($types as $t)<option value="{{ $t->name }}">{{ $t->name }}</option>@endforeach
                </select>
                <select name="region" class="form-select" style="background-color:#f3f6f7;border:0;border-radius:14px;padding:14px;font-weight:800">
                    <option value="">{{ $isAr ? 'المنطقة' : 'Area' }}</option>
                    @foreach ($areas as $a)<option value="{{ $a->name }}">{{ $a->name }}</option>@endforeach
                </select>
                <button type="submit" style="background:#0f4051;color:#fff;border:0;border-radius:14px;padding:14px 30px;font-weight:800;font-size:16px">{{ $isAr ? 'بحث' : 'Search' }}</button>
            </div>
        </form>
    </div>

    <section class="af-wrap" style="padding-top:56px">
        <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'خدماتنا' : 'Our services' }}</h2></div>
        <div class="af-grid-6">
            @foreach ($services as [$icon, $label, $tag, $free])
                <a href="{{ route('site.services') }}" style="background:#fff;border:1px solid #e8eef0;border-radius:18px;padding:20px 14px;text-align:center;color:inherit;display:block">
                    <div style="width:48px;height:48px;border-radius:14px;background:#fbf5e6;display:flex;align-items:center;justify-content:center;margin:0 auto 10px;font-size:22px">{{ $icon }}</div>
                    <div style="font-weight:800;font-size:14.5px">{{ $label }}</div>
                    <div style="font-size:12px;font-weight:700;margin-top:4px;color:{{ $free ? '#1b7a4a' : '#9a7a20' }}">{{ $tag }}</div>
                </a>
            @endforeach
        </div>
    </section>

    <section class="af-wrap af-section">
        <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'الأقسام' : 'Sections' }}</h2></div>
        <div class="af-grid-6">
            @foreach ($sections as [$icon, $label, $count, $url])
                <a href="{{ $url }}" style="border-radius:18px;padding:22px 16px;background:linear-gradient(150deg,#0f4051,#16606e);color:#fff;display:block">
                    <div style="font-size:28px;margin-bottom:12px">{{ $icon }}</div>
                    <div style="font-weight:900;font-size:16px">{{ $label }}</div>
                    @if (!is_null($count))<div style="font-size:12.5px;opacity:.75;margin-top:3px">{{ number_format($count) }}</div>@endif
                </a>
            @endforeach
        </div>
    </section>

    <section class="af-wrap af-section">
        <div class="af-head-row">
            <h2 class="af-h2">{{ $isAr ? 'أحدث العقارات' : 'Latest properties' }}</h2>
            <a class="af-more" href="{{ route('site.properties') }}">{{ $isAr ? 'الكل ←' : 'All →' }}</a>
        </div>
        @if ($latest->isEmpty())
            <div class="af-card" style="padding:30px;text-align:center;color:#7a8a90">{{ $isAr ? 'لا توجد عقارات حاليًا' : 'No properties yet' }}</div>
        @else
            <div class="af-grid-4">@foreach ($latest as $ad) @include('site.partials.property_card', ['ad' => $ad]) @endforeach</div>
        @endif
    </section>

    <section class="af-wrap af-section">
        <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'الشركات الأكثر ثقة' : 'Most trusted companies' }}</h2></div>
        @if ($companies->isEmpty())
            <div class="af-card" style="padding:30px;text-align:center;color:#7a8a90">{{ $isAr ? 'لا توجد شركات أكثر ثقة حاليًا' : 'No trusted companies yet' }}</div>
        @else
            <div class="af-grid-5">
                @foreach ($companies as $c)
                    @php $cn = $c->company_name ?: $c->name; @endphp
                    <div style="background:#fff;border:1px solid #e8eef0;border-radius:18px;padding:20px 14px;text-align:center">
                        <div style="width:62px;height:62px;border-radius:50%;margin:0 auto 10px;background:#0f4051;color:#cba135;display:flex;align-items:center;justify-content:center;font-weight:900;font-size:22px;border:3px solid #f1e3bb">{{ mb_substr($cn, 0, 1) }}</div>
                        <div style="font-weight:800;font-size:14.5px;line-height:1.35">{{ $cn }}</div>
                        <div style="font-size:12px;color:#7a8a90;margin-top:4px">{{ $companyTypeLabel($c->company_type) }} · {{ $c->ads_count }} {{ $isAr ? 'إعلان' : 'ads' }}</div>
                    </div>
                @endforeach
            </div>
        @endif
    </section>

    @if ($contracting->isNotEmpty() || $jobs->isNotEmpty())
    <section class="af-wrap af-section">
        <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'أحدث الإعلانات' : 'Latest ads' }}</h2></div>
        <div class="af-grid-4">
            @foreach ($contracting as $c)
                <div style="background:#fff;border:1px solid #e8eef0;border-radius:18px;padding:16px;display:flex;gap:12px;align-items:center">
                    <div style="width:52px;height:52px;border-radius:14px;background:#fff3e2;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0">🦺</div>
                    <div style="min-width:0">
                        <div style="font-size:11.5px;font-weight:800;color:#b8650f">{{ $isAr ? 'مقاولات البناء' : 'Contracting' }}</div>
                        <div style="font-weight:800;font-size:14.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ $c->name ?? $c->title ?? '' }}</div>
                        <div style="font-size:12px;color:#7a8a90">📍 {{ $c->region ?? '' }} @if(!empty($c->reference_no))· #{{ $c->reference_no }}@endif</div>
                    </div>
                </div>
            @endforeach
            @foreach ($jobs as $j)
                <div style="background:#fff;border:1px solid #e8eef0;border-radius:18px;padding:16px;display:flex;gap:12px;align-items:center">
                    <div style="width:52px;height:52px;border-radius:14px;background:#eaf0fb;display:flex;align-items:center;justify-content:center;font-size:22px;flex-shrink:0">💼</div>
                    <div style="min-width:0">
                        <div style="font-size:11.5px;font-weight:800;color:#2d5aa8">{{ $isAr ? 'الوظائف' : 'Jobs' }}</div>
                        <div style="font-weight:800;font-size:14.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ $j->title ?? '' }}</div>
                        <div style="font-size:12px;color:#7a8a90">📍 {{ $j->region ?? '' }} @if(!empty($j->reference_no))· #{{ $j->reference_no }}@endif</div>
                    </div>
                </div>
            @endforeach
        </div>
    </section>
    @endif

    <section class="af-wrap af-section">
        <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'المسوقين الأكثر ثقة' : 'Most trusted agents' }}</h2></div>
        @if ($agents->isEmpty())
            <div class="af-card" style="padding:30px;text-align:center;color:#7a8a90">{{ $isAr ? 'لا يوجد مسوقين أكثر ثقة حاليًا' : 'No trusted agents yet' }}</div>
        @else
            <div class="af-grid-5">
                @foreach ($agents as $g)
                    <div style="background:#fff;border:1px solid #e8eef0;border-radius:18px;padding:18px 14px;text-align:center">
                        <div style="width:58px;height:58px;border-radius:50%;margin:0 auto 10px;background:#f1e3bb;color:#0f4051;display:flex;align-items:center;justify-content:center;font-weight:900;font-size:20px">{{ mb_substr($g->name, 0, 1) }}</div>
                        <div style="font-weight:800;font-size:14.5px">{{ $g->name }}</div>
                        <div style="font-size:12px;color:#7a8a90;margin-top:3px">{{ $isAr ? 'مسوق عقاري' : 'Agent' }} · {{ $g->ads_count }} {{ $isAr ? 'إعلان' : 'ads' }}</div>
                        @if ($g->phone)
                        <div style="display:flex;gap:6px;justify-content:center;margin-top:10px">
                            <a href="tel:{{ $g->phone }}" style="padding:6px 12px;border-radius:9px;background:#eef4f6;color:#0f4051;font-size:12px;font-weight:800">{{ $isAr ? 'اتصال' : 'Call' }}</a>
                            <a href="https://wa.me/{{ preg_replace('/\D/', '', $g->phone) }}" target="_blank" style="padding:6px 12px;border-radius:9px;background:#e7f7ee;color:#1b7a4a;font-size:12px;font-weight:800">{{ $isAr ? 'واتساب' : 'WhatsApp' }}</a>
                        </div>
                        @endif
                    </div>
                @endforeach
            </div>
        @endif
    </section>

    @if ($featured->isNotEmpty())
    <section class="af-wrap af-section">
        <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'المشاريع المميزة' : 'Featured projects' }}</h2></div>
        <div class="af-grid-3">
            @foreach ($featured as $p)
                <a href="{{ route('details.show', $p->id) }}" style="border-radius:22px;overflow:hidden;position:relative;height:240px;display:block;background:#dfe7e9 url('{{ $p->images ?: asset('image/afaq.jpeg') }}') center/cover">
                    <span style="position:absolute;top:14px;{{ $isAr ? 'right' : 'left' }}:14px;background:#cba135;color:#0b3442;padding:5px 12px;border-radius:9px;font-weight:900;font-size:12.5px">VIP</span>
                    <div style="position:absolute;inset:auto 0 0 0;padding:18px;background:linear-gradient(transparent,rgba(11,52,66,.92));color:#fff">
                        <div style="font-weight:900;font-size:18px">{{ $p->title ?: $p->type }}</div>
                        <div style="display:flex;justify-content:space-between;margin-top:6px;font-size:14px"><span style="opacity:.85">📍 {{ $p->region }}</span><span style="font-weight:900;color:#e6c76a">{{ number_format((float) $p->price) }} {{ $kwd }}</span></div>
                    </div>
                </a>
            @endforeach
        </div>
    </section>
    @endif

    <section class="af-wrap" style="padding-top:56px">
        <div style="background:#0b3442;border-radius:26px;padding:36px">
            <div style="color:#fff;font-size:26px;font-weight:900">{{ $isAr ? 'باقاتنا' : 'Our plans' }}</div>
            <a href="{{ route('site.plans') }}" style="float:{{ $isAr ? 'left' : 'right' }};padding:11px 20px;border-radius:12px;background:#cba135;color:#0b3442;font-weight:800">{{ $isAr ? 'العروض والاشتراكات' : 'Plans & subscriptions' }}</a>
            <div style="color:rgba(255,255,255,.7);font-size:14.5px;margin:4px 0 22px">{{ $isAr ? 'اختر الباقة المناسبة لنوع حسابك' : 'Choose the plan that fits your account' }}</div>
            <div class="af-grid-3">
                @foreach ([
                    ['👤', $isAr ? 'فرد' : 'Individual', $isAr ? 'إعلانات أساسية مجانية، مع إعلانات مميزة ونشر على وسائل التواصل في الباقات المدفوعة.' : 'Free basic listings, plus featured listings and social media promotion on paid plans.'],
                    ['🤝', $isAr ? 'مسوق عقاري' : 'Real estate agent', $isAr ? 'صفحة خاصة باسمك، وظهور في المسوقين الأكثر ثقة، وإنشاء عقود قانونية.' : 'Your own page, a spot among trusted agents, and legal contracts.'],
                    ['🏢', $isAr ? 'شركة' : 'Company', $isAr ? 'صفحة خاصة للشركة، وظهور في الشركات الأكثر ثقة، ودعم فوري وبانر في الرئيسية.' : 'A company page, a spot among trusted companies, instant support and a home banner.'],
                ] as [$icon, $label, $desc])
                    <div style="background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.12);border-radius:18px;padding:22px">
                        <div style="font-size:28px">{{ $icon }}</div>
                        <div style="color:#e6c76a;font-weight:900;font-size:18px;margin-top:8px">{{ $label }}</div>
                        <div style="color:rgba(255,255,255,.78);font-size:13.5px;line-height:1.7;margin-top:6px">{{ $desc }}</div>
                    </div>
                @endforeach
            </div>
        </div>
    </section>
</div>
@endsection
