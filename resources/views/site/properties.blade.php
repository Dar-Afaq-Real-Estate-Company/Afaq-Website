@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $kwd = $isAr ? 'د.ك' : 'KWD';
    $tx = request('tx', '');
    $chip = fn ($on) => $on ? 'background:#0f4051;color:#fff' : 'background:#fff;color:#0f2a33';
    $with = fn (array $p) => route('site.properties', array_filter(array_merge(request()->query(), $p, ['page' => null]), fn ($v) => $v !== null && $v !== ''));
    $txList = ['بيع' => $isAr ? 'بيع' : 'Sale', 'إيجار' => $isAr ? 'إيجار' : 'Rent', 'بدل' => $isAr ? 'بدل' : 'Exchange'];
    $sectionList = ['سكني' => $isAr ? 'سكني' : 'Residential', 'تجاري' => $isAr ? 'تجاري' : 'Commercial', 'استثماري' => $isAr ? 'استثماري' : 'Investment', 'صناعي' => $isAr ? 'صناعي' : 'Industrial'];
    $typeList = ['شقة', 'بيت', 'دور', 'فيلا', 'عمارة', 'أرض', 'شاليه', 'محل', 'مكتب'];
    $title = trim(($typeList && request('type') ? request('type') . ' ' : '') . ($tx ? ($isAr ? 'لل' . $tx : $txList[$tx] ?? '') : ($isAr ? 'العقارات' : 'Properties')) . (request('section') ? ' · ' . ($sectionList[request('section')] ?? request('section')) : ''));
@endphp

<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <section style="background:#0f4051;padding:26px 0 30px">
        <div class="af-wrap">
            <div style="color:rgba(255,255,255,.6);font-size:13px;margin-bottom:8px"><a href="{{ route('welcome') }}" style="color:inherit">{{ $isAr ? 'الرئيسية' : 'Home' }}</a> / {{ $isAr ? 'العقارات' : 'Properties' }}</div>
            <div style="display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap">
                <h1 style="color:#fff;font-size:30px;font-weight:900;margin:0">{{ $title }}</h1>
                <form method="GET" action="{{ route('site.properties') }}" style="display:flex;gap:8px">
                    @foreach (request()->except(['q', 'page']) as $k => $v)<input type="hidden" name="{{ $k }}" value="{{ $v }}">@endforeach
                    <input name="q" value="{{ request('q') }}" placeholder="{{ $isAr ? 'ابحث بالعنوان أو المنطقة أو الرقم المرجعي…' : 'Search by title, area or reference…' }}" style="border:0;border-radius:12px;padding:10px 14px;width:320px;max-width:60vw">
                    <button style="border:0;padding:10px 16px;border-radius:12px;background:#cba135;color:#0b3442;font-weight:800">{{ $isAr ? 'بحث' : 'Search' }}</button>
                </form>
            </div>
        </div>
    </section>

    <div class="af-wrap" style="padding-top:26px;display:grid;grid-template-columns:290px minmax(0,1fr);gap:24px;align-items:start" id="afListGrid">
        <form method="GET" action="{{ route('site.properties') }}" style="background:#fff;border:1px solid #e8eef0;border-radius:20px;padding:20px;position:sticky;top:90px">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
                <div style="font-weight:900;font-size:17px">{{ $isAr ? 'الفلترة' : 'Filters' }}</div>
                <a href="{{ route('site.properties') }}" style="color:#d14343;font-size:13px;font-weight:800">{{ $isAr ? 'مسح الكل' : 'Clear all' }}</a>
            </div>
            @if (request('q'))<input type="hidden" name="q" value="{{ request('q') }}">@endif

            <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'نوع المعاملة' : 'Transaction' }}</div>
            <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:6px;margin-bottom:18px">
                @foreach ($txList as $v => $l)
                    <a href="{{ $with(['tx' => $tx === $v ? null : $v, 'period' => null]) }}" style="text-align:center;padding:9px 0;border-radius:10px;font-weight:800;font-size:13px;border:1px solid #e3eaec;{{ $chip($tx === $v) }}">{{ $l }}</a>
                @endforeach
            </div>

            @if ($tx === 'إيجار')
                <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'مدة الإيجار' : 'Rent period' }}</div>
                <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:6px;margin-bottom:18px">
                    @foreach (['monthly' => $isAr ? 'شهري' : 'Monthly', 'weekly' => $isAr ? 'أسبوعي' : 'Weekly', 'daily' => $isAr ? 'يومي' : 'Daily'] as $v => $l)
                        <a href="{{ $with(['period' => $v === 'monthly' ? null : $v]) }}" style="text-align:center;padding:8px 0;border-radius:10px;font-weight:800;font-size:12.5px;border:1px solid #e3eaec;{{ $chip(request('period', 'monthly') === $v) }}">{{ $l }}</a>
                    @endforeach
                </div>
            @endif

            <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'التصنيف' : 'Category' }}</div>
            <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:6px;margin-bottom:18px">
                @foreach ($sectionList as $v => $l)
                    <a href="{{ $with(['section' => request('section') === $v ? null : $v]) }}" style="text-align:center;padding:8px 0;border-radius:10px;font-weight:800;font-size:13px;border:1px solid #e3eaec;{{ $chip(request('section') === $v) }}">{{ $l }}</a>
                @endforeach
            </div>

            <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'نوع العقار' : 'Property type' }}</div>
            <div style="display:flex;flex-wrap:wrap;gap:6px;margin-bottom:18px">
                @foreach ($typeList as $t)
                    <a href="{{ $with(['type' => request('type') === $t ? null : $t]) }}" style="padding:7px 12px;border-radius:9px;font-size:13px;font-weight:700;border:1px solid #e3eaec;{{ $chip(request('type') === $t) }}">{{ $t }}</a>
                @endforeach
            </div>

            @foreach (['tx', 'period', 'section', 'type'] as $keep)
                @if (request($keep))<input type="hidden" name="{{ $keep }}" value="{{ request($keep) }}">@endif
            @endforeach

            <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'المنطقة' : 'Area' }}</div>
            <select name="region" class="form-select" style="background-color:#f3f6f7;border:0;border-radius:12px;font-weight:700;margin-bottom:18px">
                <option value="">{{ $isAr ? 'كل المناطق' : 'All areas' }}</option>
                @foreach ($areas as $a)<option value="{{ $a->name }}" @selected(request('region') === $a->name)>{{ $a->name }}</option>@endforeach
            </select>

            <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'السعر' : 'Price' }} ({{ $kwd }})</div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:6px;margin-bottom:18px">
                <input name="min" type="number" value="{{ request('min') }}" placeholder="{{ $isAr ? 'من' : 'Min' }}" class="form-control" style="background:#f3f6f7;border:0;border-radius:10px">
                <input name="max" type="number" value="{{ request('max') }}" placeholder="{{ $isAr ? 'إلى' : 'Max' }}" class="form-control" style="background:#f3f6f7;border:0;border-radius:10px">
            </div>

            <div style="font-size:13px;font-weight:800;color:#4b5d63;margin-bottom:8px">{{ $isAr ? 'عدد الغرف' : 'Rooms' }}</div>
            <select name="rooms" class="form-select" style="background-color:#f3f6f7;border:0;border-radius:12px;font-weight:700;margin-bottom:18px">
                <option value="">{{ $isAr ? 'الكل' : 'Any' }}</option>
                @foreach (['1', '2', '3', '4', '5'] as $n)<option value="{{ $n }}" @selected(request('rooms') === $n)>{{ $n === '5' ? '+5' : $n }}</option>@endforeach
            </select>

            <label style="display:flex;align-items:center;gap:10px;cursor:pointer;margin-bottom:20px;font-weight:700;font-size:14px">
                <input type="checkbox" name="commission" value="1" @checked(request()->boolean('commission')) style="width:18px;height:18px;accent-color:#0f4051">
                {{ $isAr ? 'بعمولة فقط' : 'With commission only' }}
            </label>

            <button type="submit" style="width:100%;background:#0f4051;color:#fff;border:0;padding:12px;border-radius:12px;font-weight:800">{{ $isAr ? 'عرض النتائج' : 'Show results' }}</button>
        </form>

        <div>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;flex-wrap:wrap;gap:8px">
                <div style="font-weight:800;color:#4b5d63">{{ number_format($ads->total()) }} {{ $isAr ? 'عقار' : 'properties' }}</div>
                <div style="display:flex;gap:6px">
                    @foreach (['' => $isAr ? 'الأحدث' : 'Newest', 'price' => $isAr ? 'الأقل سعرًا' : 'Lowest price', 'views' => $isAr ? 'الأكثر مشاهدة' : 'Most viewed'] as $v => $l)
                        <a href="{{ $with(['sort' => $v ?: null]) }}" style="padding:7px 13px;border-radius:9px;font-size:13px;font-weight:800;border:1px solid #e3eaec;{{ $chip(request('sort', '') === $v) }}">{{ $l }}</a>
                    @endforeach
                </div>
            </div>

            @forelse ($ads as $ad)
                @php
                    $atx = $ad->transaction_type ?? '';
                    $isRent = str_contains($atx, 'يجار');
                    $txLabel = $isRent ? ($isAr ? 'للإيجار' : 'For rent') : (str_contains($atx, 'بدل') ? ($isAr ? 'للبدل' : 'For exchange') : ($isAr ? 'للبيع' : 'For sale'));
                    $commission = is_null($ad->has_commission ?? null) ? null : ((int) $ad->has_commission === 1 ? ($isAr ? 'بعمولة' : 'Commission') : ($isAr ? 'بدون عمولة' : 'No commission'));
                    $extras = [];
                    if ($isRent && !empty($ad->weekly_price)) $extras[] = ($isAr ? 'أسبوعي ' : 'Weekly ') . number_format((float) $ad->weekly_price) . ' ' . $kwd;
                    if ($isRent && !empty($ad->daily_price)) $extras[] = ($isAr ? 'يومي ' : 'Daily ') . number_format((float) $ad->daily_price) . ' ' . $kwd;
                @endphp
                <a href="{{ route('site.property', $ad->id) }}" class="af-card" style="display:grid;grid-template-columns:260px minmax(0,1fr);margin-bottom:14px;color:inherit;{{ !empty($ad->is_featured) ? 'border:2px solid #cba135' : '' }}">
                    <div style="background:#dfe7e9 url('{{ $ad->images ?: asset('image/afaq.jpeg') }}') center/cover;min-height:190px;position:relative">
                        @if (!empty($ad->is_featured))<span style="position:absolute;top:12px;{{ $isAr ? 'right' : 'left' }}:12px;background:#cba135;color:#0b3442;padding:4px 10px;border-radius:8px;font-weight:900;font-size:12px">VIP</span>@endif
                        <span style="position:absolute;bottom:10px;{{ $isAr ? 'left' : 'right' }}:12px;background:rgba(11,52,66,.75);color:#fff;padding:3px 9px;border-radius:7px;font-size:11.5px">👁 {{ $ad->views_count ?? 0 }}</span>
                    </div>
                    <div style="padding:18px 20px;display:flex;flex-direction:column">
                        <div style="display:flex;gap:6px;margin-bottom:8px;flex-wrap:wrap">
                            <span class="af-chip af-chip-teal">{{ $txLabel }}</span>
                            @if ($ad->property_section)<span class="af-chip af-chip-gold">{{ $ad->property_section }}</span>@endif
                            @if ($commission)<span class="af-chip af-chip-green">{{ $commission }}</span>@endif
                        </div>
                        <div style="font-weight:900;font-size:18px">{{ $ad->title ?: ($ad->type . ' ' . $txLabel) }}</div>
                        <div style="font-size:13.5px;color:#7a8a90;margin-top:4px">📍 {{ $ad->region }} @if($ad->reference_no)· #{{ $ad->reference_no }}@endif</div>
                        <div style="display:flex;gap:16px;font-size:13px;color:#4b5d63;margin-top:10px">
                            @if ($ad->rooms)<span>🛏 {{ $ad->rooms }} {{ $isAr ? 'غرف' : 'rooms' }}</span>@endif
                            @if ($ad->bathrooms)<span>🛁 {{ $ad->bathrooms }} {{ $isAr ? 'حمامات' : 'baths' }}</span>@endif
                            @if ($ad->area)<span>📐 {{ $ad->area }} {{ $isAr ? 'م²' : 'm²' }}</span>@endif
                        </div>
                        <div style="display:flex;align-items:end;justify-content:space-between;margin-top:auto;padding-top:14px;gap:10px;flex-wrap:wrap">
                            <div>
                                <div style="font-weight:900;font-size:21px;color:#0f4051">{{ number_format((float) $ad->price) }} {{ $kwd }}@if ($isRent)<span style="font-size:12px;color:#7a8a90"> / {{ $isAr ? 'شهري' : 'month' }}</span>@endif</div>
                                @if ($extras)<div style="font-size:12px;color:#7a8a90">{{ implode(' · ', $extras) }}</div>@endif
                            </div>
                            @if ($ad->phone)
                            <div style="display:flex;gap:6px">
                                <span onclick="event.preventDefault();location.href='tel:{{ $ad->phone }}'" style="padding:9px 14px;border-radius:10px;background:#eef4f6;color:#0f4051;font-weight:800;font-size:13px">📞 {{ $isAr ? 'اتصال' : 'Call' }}</span>
                                <span onclick="event.preventDefault();window.open('https://wa.me/{{ preg_replace('/\D/', '', $ad->phone) }}','_blank')" style="padding:9px 14px;border-radius:10px;background:#25a35a;color:#fff;font-weight:800;font-size:13px">{{ $isAr ? 'واتساب' : 'WhatsApp' }}</span>
                            </div>
                            @endif
                        </div>
                    </div>
                </a>
            @empty
                <div class="af-card" style="padding:40px;text-align:center;color:#7a8a90">{{ $isAr ? 'لا توجد عقارات مطابقة للفلترة' : 'No properties match your filters' }}</div>
            @endforelse

            <div style="margin-top:18px">{{ $ads->links('pagination::bootstrap-5') }}</div>
        </div>
    </div>
</div>
<style>@media (max-width:991px){#afListGrid{grid-template-columns:1fr !important}#afListGrid>form{position:static !important}#afListGrid .af-card{grid-template-columns:1fr !important}}</style>
@endsection
