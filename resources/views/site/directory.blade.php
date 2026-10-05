@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $titles = [
        'contracting' => [$isAr ? 'مقاولات البناء' : 'Contracting', '🦺'],
        'jobs'        => [$isAr ? 'الوظائف الشاغرة' : 'Job vacancies', '💼'],
        'companies'   => [$isAr ? 'الشركات العقارية' : 'Real estate companies', '🏢'],
        'engineering' => [$isAr ? 'المكاتب الهندسية' : 'Engineering offices', '📐'],
        'hotels'      => [$isAr ? 'الفنادق' : 'Hotels', '🏨'],
    ];
    [$title, $icon] = $titles[$kind];
    $hasRegion = in_array($kind, ['contracting', 'jobs', 'hotels']);
    $with = fn (array $p) => route('site.section', array_merge(['kind' => $kind], array_filter(array_merge(request()->query(), $p, ['page' => null]), fn ($v) => $v !== null && $v !== '')));
@endphp

<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <section style="background:#0f4051;padding:26px 0 30px">
        <div class="af-wrap">
            <div style="color:rgba(255,255,255,.6);font-size:13px;margin-bottom:8px"><a href="{{ route('welcome') }}" style="color:inherit">{{ $isAr ? 'الرئيسية' : 'Home' }}</a> / {{ $title }}</div>
            <div style="display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap">
                <h1 style="color:#fff;font-size:30px;font-weight:900;margin:0">{{ $icon }} {{ $title }}</h1>
                <form method="GET" action="{{ route('site.section', $kind) }}" style="display:flex;gap:8px;flex-wrap:wrap">
                    @if ($categories->isNotEmpty())
                        <select name="cat" class="form-select" style="border:0;border-radius:12px;min-width:170px;font-weight:700">
                            <option value="">{{ $catLabel }}: {{ $isAr ? 'الكل' : 'All' }}</option>
                            @foreach ($categories as $c)<option value="{{ $c }}" @selected(request('cat') === $c)>{{ $c }}</option>@endforeach
                        </select>
                    @endif
                    @if ($hasRegion)
                        <select name="region" class="form-select" style="border:0;border-radius:12px;min-width:150px;font-weight:700">
                            <option value="">{{ $isAr ? 'كل المناطق' : 'All areas' }}</option>
                            @foreach ($areas->pluck('governorate')->filter()->unique() as $g)<option value="{{ $g }}" @selected(request('region') === $g)>{{ $g }}</option>@endforeach
                        </select>
                    @endif
                    <input name="q" value="{{ request('q') }}" placeholder="{{ $isAr ? 'ابحث بالاسم أو الرقم المرجعي…' : 'Search by name or reference…' }}" style="border:0;border-radius:12px;padding:10px 14px;width:260px;max-width:70vw">
                    <button style="border:0;padding:10px 18px;border-radius:12px;background:#cba135;color:#0b3442;font-weight:800">{{ $isAr ? 'بحث' : 'Search' }}</button>
                </form>
            </div>
            @if (request()->hasAny(['q', 'cat', 'region']))
                <a href="{{ route('site.section', $kind) }}" style="display:inline-block;margin-top:12px;color:#e6c76a;font-weight:800;font-size:13px">{{ $isAr ? 'مسح الفلترة ✕' : 'Clear filters ✕' }}</a>
            @endif
        </div>
    </section>

    <div class="af-wrap" style="padding-top:26px">
        <div style="font-weight:800;color:#4b5d63;margin-bottom:14px">{{ number_format($items->total()) }} {{ $isAr ? 'نتيجة' : 'results' }}</div>

        @if ($items->isEmpty())
            <div class="af-card" style="padding:40px;text-align:center;color:#7a8a90">{{ $isAr ? 'لا توجد نتائج حاليًا في هذا القسم' : 'No results in this section yet' }}</div>
        @else
            <div class="af-grid-3">
                @foreach ($items as $it)
                    <div class="af-card" style="display:flex;gap:14px;padding:16px;align-items:flex-start">
                        <div style="width:76px;height:76px;border-radius:16px;flex-shrink:0;background:#eef4f6 {{ $it['img'] ? "url('" . $it['img'] . "') center/cover" : '' }};display:flex;align-items:center;justify-content:center;font-size:30px">@unless ($it['img']){{ $it['icon'] }}@endunless</div>
                        <div style="min-width:0;flex:1">
                            <a href="{{ route('site.section.show', [$kind, $it['id']]) }}" style="font-weight:900;font-size:16px;line-height:1.35;color:#0f2a33;display:block">{{ $it['title'] }}</a>
                            @if ($it['sub'])<div style="font-size:13px;color:#9a7a20;font-weight:700;margin-top:3px">{{ $it['sub'] }}</div>@endif
                            <div style="font-size:12.5px;color:#7a8a90;margin-top:4px">
                                @if ($it['region'])📍 {{ $it['region'] }}@endif
                                @if ($it['ref']) · #{{ $it['ref'] }}@endif
                                @if (!is_null($it['views'])) · 👁 {{ $it['views'] }}@endif
                            </div>
                            @if ($it['extra'])<div style="font-size:13px;color:#0f4051;font-weight:800;margin-top:6px">{{ \Illuminate\Support\Str::limit($it['extra'], 90) }}</div>@endif
                            @if ($it['phone'])
                                <div style="display:flex;gap:6px;margin-top:10px">
                                    <a href="tel:{{ $it['phone'] }}" style="padding:7px 12px;border-radius:9px;background:#eef4f6;color:#0f4051;font-size:12.5px;font-weight:800">📞 {{ $isAr ? 'اتصال' : 'Call' }}</a>
                                    <a href="https://wa.me/{{ preg_replace('/\D/', '', $it['phone']) }}" target="_blank" style="padding:7px 12px;border-radius:9px;background:#25a35a;color:#fff;font-size:12.5px;font-weight:800">{{ $isAr ? 'واتساب' : 'WhatsApp' }}</a>
                                </div>
                            @endif
                        </div>
                    </div>
                @endforeach
            </div>
            <div style="margin-top:18px">{{ $items->links('pagination::bootstrap-5') }}</div>
        @endif
    </div>
</div>
@endsection
