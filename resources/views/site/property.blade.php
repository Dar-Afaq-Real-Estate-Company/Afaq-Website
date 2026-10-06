@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $kwd = $isAr ? 'د.ك' : 'KWD';
    $tx = $ad->transaction_type ?? '';
    $isRent = str_contains($tx, 'يجار');
    $txLabel = $isRent ? ($isAr ? 'للإيجار' : 'For rent') : (str_contains($tx, 'بدل') ? ($isAr ? 'للبدل' : 'For exchange') : ($isAr ? 'للبيع' : 'For sale'));
    $commission = is_null($ad->has_commission ?? null) ? null : ((int) $ad->has_commission === 1 ? ($isAr ? 'بعمولة' : 'Commission') : ($isAr ? 'بدون عمولة' : 'No commission'));
    $img = $ad->images ?: asset('image/afaq.jpeg');
    $phone = $ad->phone ?: ($publisher->phone ?? null);
    $wa = $phone ? preg_replace('/\D/', '', $phone) : null;
    $pubName = $publisher ? (($publisher->company_name ?? null) ?: $publisher->name) : null;
    $pubType = match ($publisher->account_type ?? null) {
        'company' => match ($publisher->company_type ?? null) {
            'real_estate' => $isAr ? 'شركة عقارية' : 'Real estate company',
            'engineering_office', 'engineering' => $isAr ? 'مكتب هندسي' : 'Engineering office',
            'hotel' => $isAr ? 'شركة فندقية' : 'Hotel company',
            default => $isAr ? 'شركة' : 'Company',
        },
        'broker' => $isAr ? 'مسوق عقاري' : 'Real estate agent',
        default => $isAr ? 'فرد' : 'Individual',
    };
    $specs = array_filter([
        [$isAr ? 'نوع العقار' : 'Type', $ad->type],
        [$isAr ? 'التصنيف' : 'Category', $ad->property_section ?? null],
        [$isAr ? 'المنطقة' : 'Area', $ad->region],
        [$isAr ? 'الغرف' : 'Rooms', $ad->rooms],
        [$isAr ? 'الحمامات' : 'Bathrooms', $ad->bathrooms],
        [$isAr ? 'المساحة' : 'Size', $ad->area ? $ad->area . ($isAr ? ' م²' : ' m²') : null],
        [$isAr ? 'عدد الأدوار' : 'Floors', $ad->floors_count ?? null],
        [$isAr ? 'عمر البناء' : 'Building age', $ad->building_age ?? null],
        [$isAr ? 'التأثيث' : 'Furnishing', $ad->furnishing ?? null],
    ], fn ($s) => !empty($s[1]));
@endphp
<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <div class="af-wrap" style="padding-top:22px">
        <div style="color:#7a8a90;font-size:13px;margin-bottom:12px">
            <a href="{{ route('welcome') }}">{{ $isAr ? 'الرئيسية' : 'Home' }}</a> /
            <a href="{{ route('site.properties') }}">{{ $isAr ? 'العقارات' : 'Properties' }}</a> / #{{ $ad->reference_no }}
        </div>

        <div style="display:grid;grid-template-columns:minmax(0,1fr) 360px;gap:24px;align-items:start" id="afPropGrid">
            <div style="display:flex;flex-direction:column;gap:18px">
                <div style="position:relative;border-radius:22px;overflow:hidden;height:440px;background:#dfe7e9 url('{{ $img }}') center/cover;cursor:zoom-in" onclick="window.open('{{ $img }}','_blank')">
                    <div style="position:absolute;top:16px;{{ $isAr ? 'right' : 'left' }}:16px;display:flex;gap:6px">
                        <span class="af-chip" style="background:#fff;color:#0f4051;font-size:13px">{{ $txLabel }}</span>
                        @if (!empty($ad->is_featured))<span class="af-chip" style="background:#cba135;color:#0b3442;font-size:13px">VIP</span>@endif
                    </div>
                    <div style="position:absolute;bottom:14px;{{ $isAr ? 'left' : 'right' }}:16px;background:rgba(11,52,66,.78);color:#fff;padding:5px 12px;border-radius:9px;font-size:13px">👁 {{ ($ad->views_count ?? 0) + 1 }}</div>
                </div>

                <div class="af-card" style="padding:22px">
                    <div style="display:flex;gap:6px;flex-wrap:wrap;margin-bottom:10px">
                        <span class="af-chip af-chip-teal">{{ $txLabel }}</span>
                        @if (!empty($ad->property_section))<span class="af-chip af-chip-gold">{{ $ad->property_section }}</span>@endif
                        @if ($commission)<span class="af-chip af-chip-green">{{ $commission }}</span>@endif
                    </div>
                    <h1 style="font-size:26px;font-weight:900;margin:0">{{ $ad->title ?: ($ad->type . ' ' . $txLabel) }}</h1>
                    <div style="color:#7a8a90;margin-top:6px">📍 {{ $ad->region }} · #{{ $ad->reference_no }}</div>
                    <div style="margin-top:16px;padding-top:16px;border-top:1px solid #eef2f3">
                        <div style="font-size:30px;font-weight:900;color:#0f4051">{{ number_format((float) $ad->price) }} {{ $kwd }}@if ($isRent)<span style="font-size:15px;color:#7a8a90"> / {{ $isAr ? 'شهري' : 'month' }}</span>@endif</div>
                        @if ($isRent && !empty($ad->weekly_price))<div style="font-size:17px;font-weight:800;color:#0f4051;margin-top:4px">{{ number_format((float) $ad->weekly_price) }} {{ $kwd }} <span style="color:#7a8a90;font-size:14px">/ {{ $isAr ? 'أسبوعي' : 'week' }}</span></div>@endif
                        @if ($isRent && !empty($ad->daily_price))<div style="font-size:17px;font-weight:800;color:#0f4051;margin-top:4px">{{ number_format((float) $ad->daily_price) }} {{ $kwd }} <span style="color:#7a8a90;font-size:14px">/ {{ $isAr ? 'يومي' : 'day' }}</span></div>@endif
                    </div>
                </div>

                <div class="af-card" style="padding:22px">
                    <div style="font-weight:900;font-size:18px;margin-bottom:12px">{{ $isAr ? 'المواصفات' : 'Specifications' }}</div>
                    <div class="af-grid-3" style="gap:10px">
                        @foreach ($specs as [$k, $v])
                            <div style="background:#f5f7f8;border-radius:12px;padding:12px 14px"><div style="font-size:12px;color:#7a8a90;font-weight:700">{{ $k }}</div><div style="font-weight:900;margin-top:2px">{{ $v }}</div></div>
                        @endforeach
                    </div>
                    @if ($amenities->isNotEmpty())
                        <div style="font-weight:900;font-size:16px;margin:18px 0 10px">{{ $isAr ? 'المميزات' : 'Amenities' }}</div>
                        <div style="display:flex;flex-wrap:wrap;gap:8px">@foreach ($amenities as $a)<span style="padding:7px 14px;border-radius:20px;background:#eef4f6;color:#0f4051;font-weight:700;font-size:13px">✓ {{ $a }}</span>@endforeach</div>
                    @endif
                </div>

                <div class="af-card" style="padding:22px">
                    <div style="font-weight:900;font-size:18px;margin-bottom:10px">{{ $isAr ? 'الوصف' : 'Description' }}</div>
                    @if (!empty($ad->description))
                        <div style="font-size:15px;line-height:1.9;color:#334a51;white-space:pre-line">{{ $ad->description }}</div>
                    @else
                        <div style="font-size:14px;color:#98a2a6;font-style:italic">{{ $isAr ? 'لا يوجد وصف لهذا الإعلان' : 'No description provided' }}</div>
                    @endif
                </div>

                @if (!empty($ad->latitude) && !empty($ad->longitude))
                    <div class="af-card" style="overflow:hidden">
                        <iframe src="https://maps.google.com/maps?q={{ $ad->latitude }},{{ $ad->longitude }}&z=15&output=embed" style="width:100%;height:320px;border:0" loading="lazy"></iframe>
                    </div>
                @endif
            </div>

            <div style="display:flex;flex-direction:column;gap:16px;position:sticky;top:90px" id="afPropSide">
                @if ($publisher)
                    <div class="af-card" style="padding:20px">
                        <div style="font-size:13px;color:#7a8a90;font-weight:700;margin-bottom:10px">{{ $isAr ? 'الناشر' : 'Publisher' }}</div>
                        <div style="display:flex;align-items:center;gap:12px">
                            <div style="width:56px;height:56px;border-radius:50%;background:#0f4051;color:#cba135;display:flex;align-items:center;justify-content:center;font-weight:900;font-size:20px;flex-shrink:0">{{ mb_substr($pubName, 0, 1) }}</div>
                            <div>
                                <div style="font-weight:900">{{ $pubName }}</div>
                                <div style="font-size:13px;color:#9a7a20;font-weight:700">{{ $pubType }}</div>
                            </div>
                        </div>
                        @if (($publisher->account_type ?? null) === 'company')
                            <a href="{{ route('site.section.show', [in_array($publisher->company_type ?? '', ['engineering_office', 'engineering']) ? 'engineering' : 'companies', $publisher->id]) }}" style="display:block;margin-top:12px;font-weight:800;font-size:13.5px">{{ $isAr ? 'صفحة الناشر ←' : 'Publisher page →' }}</a>
                        @endif
                    </div>
                @endif
                @if ($phone)
                    <div class="af-card" style="padding:20px;display:flex;flex-direction:column;gap:10px">
                        <a href="tel:{{ $phone }}" style="text-align:center;padding:13px;border-radius:12px;background:#0f4051;color:#fff;font-weight:800">📞 {{ $isAr ? 'اتصال' : 'Call' }}</a>
                        <a href="https://wa.me/{{ $wa }}?text={{ urlencode(($isAr ? 'استفسار عن الإعلان #' : 'Inquiry about listing #') . $ad->reference_no) }}" target="_blank" style="text-align:center;padding:13px;border-radius:12px;background:#25a35a;color:#fff;font-weight:800">{{ $isAr ? 'واتساب' : 'WhatsApp' }}</a>
                        <div style="font-size:12.5px;color:#7a8a90;text-align:center">{{ $isAr ? 'طلب المعاينة وإنشاء العقد متاحان من تطبيق آفاق' : 'Viewing requests and contracts are available in the AFAQ app' }}</div>
                    </div>
                @endif
                <div class="af-card" style="padding:16px;display:flex;gap:8px">
                    <button onclick="navigator.share ? navigator.share({title: document.title, url: location.href}) : navigator.clipboard.writeText(location.href).then(() => alert('{{ $isAr ? 'تم نسخ الرابط' : 'Link copied' }}'))" style="flex:1;border:1px solid #e3eaec;background:#fff;border-radius:10px;padding:10px;font-weight:800;color:#0f4051">↗ {{ $isAr ? 'مشاركة' : 'Share' }}</button>
                </div>
            </div>
        </div>

        @if ($similar->isNotEmpty())
            <div class="af-section">
                <div class="af-head-row"><h2 class="af-h2">{{ $isAr ? 'عقارات مشابهة' : 'Similar properties' }}</h2></div>
                <div class="af-grid-4">@foreach ($similar as $s) @include('site.partials.property_card', ['ad' => $s]) @endforeach</div>
            </div>
        @endif
    </div>
</div>
<style>@media (max-width:991px){#afPropGrid{grid-template-columns:1fr !important}#afPropSide{position:static !important}#afPropGrid>div:first-child>div:first-child{height:280px !important}}</style>
@endsection
