@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $wa = 'https://wa.me/96555525030?text=' . urlencode($isAr ? 'السلام عليكم، أرغب بطلب خدمة: ' : 'Hello, I would like to request: ');
    $services = [
        ['🏠', $isAr ? 'اطلب عقارك' : 'Request a property', $isAr ? 'أخبرنا بالعقار الذي تبحث عنه وسنتواصل معك.' : 'Tell us what you are looking for and we will contact you.', [[$isAr ? 'الخدمة' : 'Service', $isAr ? 'مجانية' : 'Free']]],
        ['🗂', $isAr ? 'إدارة الأملاك' : 'Property management', $isAr ? 'نظام متكامل لإدارة الوحدات والمستأجرين والعقود والصيانة والتقارير المالية.' : 'Manage units, tenants, contracts, maintenance and financial reports.', [
            [$isAr ? 'طلب معاينة للإدارة' : 'Management inspection request', $isAr ? 'مجاني' : 'Free'],
            [$isAr ? 'اشتراك مالك · 6 أشهر' : 'Owner · 6 months', '100 ' . ($isAr ? 'د.ك' : 'KWD')],
            [$isAr ? 'اشتراك مالك · سنة' : 'Owner · 1 year', '180 ' . ($isAr ? 'د.ك' : 'KWD')],
            [$isAr ? 'اشتراك شركة · 6 أشهر' : 'Company · 6 months', '80 ' . ($isAr ? 'د.ك' : 'KWD')],
            [$isAr ? 'اشتراك شركة · سنة' : 'Company · 1 year', '150 ' . ($isAr ? 'د.ك' : 'KWD')],
        ]],
        ['💬', $isAr ? 'الاستشارة العقارية' : 'Real estate consultation', $isAr ? 'جلسة استشارية مع مختص في السوق العقاري الكويتي.' : 'A session with a Kuwaiti real estate expert.', [[$isAr ? 'الجلسة' : 'Session', '40 ' . ($isAr ? 'د.ك' : 'KWD')]]],
        ['📋', $isAr ? 'التقييم العقاري · حسبة الإيجار · تكلفة البناء (معتمدة)' : 'Certified valuation · rent · construction cost', $isAr ? 'تقارير معتمدة. للمساحات 1000 م² فأكثر يُدفع المبلغ كعربون وتحدد الإدارة السعر النهائي.' : 'Certified reports. For 1000 m² and above the amount is a deposit and the final price is set by management.', [
            [$isAr ? 'سكني' : 'Residential', '100 ' . ($isAr ? 'د.ك' : 'KWD')],
            [$isAr ? 'استثماري / صناعي' : 'Investment / Industrial', '150 ' . ($isAr ? 'د.ك' : 'KWD')],
            [$isAr ? 'تجاري' : 'Commercial', '250 ' . ($isAr ? 'د.ك' : 'KWD')],
            [$isAr ? 'مزرعة / شاليه' : 'Farm / Chalet', '250 ' . ($isAr ? 'د.ك' : 'KWD')],
        ]],
        ['🧮', $isAr ? 'حسبة الإيجار وتكلفة البناء (تقديرية)' : 'Rent & construction estimate', $isAr ? 'حاسبة تقديرية سريعة داخل التطبيق.' : 'A quick estimate calculator in the app.', [[$isAr ? 'الخدمة' : 'Service', $isAr ? 'مجانية' : 'Free']]],
    ];
@endphp
<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <section style="background:#0f4051;padding:34px 0">
        <div class="af-wrap">
            <h1 style="color:#fff;font-size:30px;font-weight:900;margin:0">{{ $isAr ? 'خدماتنا' : 'Our services' }}</h1>
            <div style="color:rgba(255,255,255,.75);margin-top:6px">{{ $isAr ? 'الأسعار بالدينار الكويتي، وتُدفع إلكترونيًا عبر كي نت أو فيزا/ماستركارد من التطبيق.' : 'Prices in KWD, paid via KNET or Visa/Mastercard in the app.' }}</div>
        </div>
    </section>
    <div class="af-wrap" style="padding-top:26px">
        <div class="af-grid-3">
            @foreach ($services as [$icon, $name, $desc, $rows])
                <div class="af-card" style="padding:22px;display:flex;flex-direction:column">
                    <div style="font-size:30px">{{ $icon }}</div>
                    <div style="font-weight:900;font-size:17px;margin-top:8px">{{ $name }}</div>
                    <div style="font-size:13.5px;color:#7a8a90;line-height:1.7;margin-top:6px">{{ $desc }}</div>
                    <div style="margin-top:14px;flex:1">
                        @foreach ($rows as [$k, $v])
                            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px dashed #e3eaec;font-size:14px"><span>{{ $k }}</span><span style="font-weight:900;color:#0f4051">{{ $v }}</span></div>
                        @endforeach
                    </div>
                    <a href="{{ $wa . urlencode($name) }}" target="_blank" style="margin-top:16px;text-align:center;padding:11px;border-radius:12px;background:#0f4051;color:#fff;font-weight:800">{{ $isAr ? 'اطلب الخدمة' : 'Request service' }}</a>
                </div>
            @endforeach
        </div>
    </div>
</div>
@endsection
