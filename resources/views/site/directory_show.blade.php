@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $kindLabel = ['contracting' => $isAr ? 'مقاولات البناء' : 'Contracting', 'jobs' => $isAr ? 'الوظائف' : 'Jobs', 'companies' => $isAr ? 'الشركات العقارية' : 'Companies', 'engineering' => $isAr ? 'المكاتب الهندسية' : 'Engineering offices', 'hotels' => $isAr ? 'الفنادق' : 'Hotels'][$kind];
    $icon = ['contracting' => '🦺', 'jobs' => '💼', 'companies' => '🏢', 'engineering' => '📐', 'hotels' => '🏨'][$kind];
    $wa = $phone ? preg_replace('/\D/', '', $phone) : null;
@endphp
<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <section style="background:#0f4051;padding:26px 0 34px">
        <div class="af-wrap">
            <div style="color:rgba(255,255,255,.6);font-size:13px;margin-bottom:14px">
                <a href="{{ route('welcome') }}" style="color:inherit">{{ $isAr ? 'الرئيسية' : 'Home' }}</a> /
                <a href="{{ route('site.section', $kind) }}" style="color:inherit">{{ $kindLabel }}</a>
            </div>
            <div style="display:flex;align-items:center;gap:18px;flex-wrap:wrap">
                <div style="width:88px;height:88px;border-radius:22px;background:#fff {{ $logo ? "url('$logo') center/cover" : '' }};display:flex;align-items:center;justify-content:center;font-size:38px;border:3px solid #cba135;flex-shrink:0">@unless ($logo){{ $icon }}@endunless</div>
                <div style="flex:1;min-width:220px">
                    <h1 style="color:#fff;font-size:28px;font-weight:900;margin:0">{{ $title }}</h1>
                    <div style="color:#e6c76a;font-weight:700;margin-top:4px">{{ $kindLabel }} @if ($ref)· #{{ $ref }}@endif</div>
                </div>
                @if ($phone)
                    <div style="display:flex;gap:8px">
                        <a href="tel:{{ $phone }}" style="padding:12px 20px;border-radius:12px;background:#fff;color:#0f4051;font-weight:800">📞 {{ $isAr ? 'اتصال' : 'Call' }}</a>
                        <a href="https://wa.me/{{ $wa }}" target="_blank" style="padding:12px 20px;border-radius:12px;background:#25a35a;color:#fff;font-weight:800">{{ $isAr ? 'واتساب' : 'WhatsApp' }}</a>
                    </div>
                @endif
            </div>
        </div>
    </section>

    <div class="af-wrap" style="padding-top:26px;display:grid;grid-template-columns:minmax(0,1fr) 340px;gap:24px;align-items:start" id="afShowGrid">
        <div style="display:flex;flex-direction:column;gap:18px">
            @if (count($gallery) > 1)
                <div class="af-grid-3">
                    @foreach (array_slice($gallery, 0, 6) as $g)
                        <a href="{{ $g }}" target="_blank" style="height:170px;border-radius:16px;background:#dfe7e9 url('{{ $g }}') center/cover;display:block"></a>
                    @endforeach
                </div>
            @endif
            <div class="af-card" style="padding:22px">
                <div style="font-weight:900;font-size:18px;margin-bottom:10px">{{ $kind === 'jobs' ? ($isAr ? 'وصف الوظيفة' : 'Job description') : ($isAr ? 'نبذة' : 'About') }}</div>
                @if ($about)
                    <div style="font-size:15px;line-height:1.9;color:#334a51;white-space:pre-line">{{ $about }}</div>
                @else
                    <div style="font-size:14px;color:#98a2a6;font-style:italic">{{ $isAr ? 'لا يوجد وصف لهذا الإعلان' : 'No description provided' }}</div>
                @endif
            </div>

            @if ($ads->isNotEmpty())
                <div>
                    <div style="font-weight:900;font-size:20px;margin-bottom:14px">{{ $isAr ? 'إعلانات الشركة' : 'Company listings' }}</div>
                    <div class="af-grid-3">@foreach ($ads as $ad) @include('site.partials.property_card', ['ad' => $ad]) @endforeach</div>
                </div>
            @endif
        </div>

        <div class="af-card" style="padding:20px;position:sticky;top:90px">
            <div style="font-weight:900;font-size:17px;margin-bottom:12px">{{ $isAr ? 'التفاصيل' : 'Details' }}</div>
            @forelse ($fields as [$k, $v])
                <div style="display:flex;justify-content:space-between;gap:12px;padding:11px 0;border-bottom:1px solid #eef2f3;font-size:14px">
                    <span style="color:#7a8a90">{{ $k }}</span>
                    @if (is_string($v) && str_starts_with($v, 'map:'))
                        <a href="https://www.google.com/maps?q={{ substr($v, 4) }}" target="_blank" style="font-weight:800">🗺 {{ $isAr ? 'عرض على الخريطة' : 'View on map' }}</a>
                    @else
                        <span style="font-weight:800;text-align:{{ $isAr ? 'left' : 'right' }}">{{ $v }}</span>
                    @endif
                </div>
            @empty
                <div style="color:#98a2a6;font-size:14px">—</div>
            @endforelse
        </div>
    </div>
</div>
<style>@media (max-width:991px){#afShowGrid{grid-template-columns:1fr !important}#afShowGrid>.af-card{position:static !important}}</style>
@endsection
