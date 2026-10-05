@extends('layouts.site')

@section('content')
@php
    $isAr = app()->getLocale() === 'ar';
    $kwd = $isAr ? 'د.ك' : 'KWD';
    $tab = fn ($on) => $on ? 'background:#cba135;color:#0b3442' : 'background:rgba(255,255,255,.1);color:#fff';
    $audiences = ['individual' => $isAr ? 'فرد' : 'Individual', 'broker' => $isAr ? 'مسوق عقاري' : 'Agent', 'company' => $isAr ? 'شركة' : 'Company'];
@endphp
<div dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <section style="background:#0b3442;padding:40px 0 46px;text-align:center">
        <div class="af-wrap">
            <h1 style="color:#fff;font-size:32px;font-weight:900;margin:0">{{ $isAr ? 'العروض والاشتراكات' : 'Plans & subscriptions' }}</h1>
            <div style="color:rgba(255,255,255,.7);margin:8px 0 22px">{{ $isAr ? 'الإعلانات الأساسية مجانية دائمًا. اختر نوع حسابك:' : 'Basic listings are always free. Choose your account type:' }}</div>
            <div style="display:inline-flex;gap:6px;margin-bottom:12px">
                @foreach ($audiences as $k => $l)
                    <a href="{{ route('site.plans', ['audience' => $k, 'cycle' => $cycle]) }}" style="padding:10px 22px;border-radius:12px;font-weight:800;{{ $tab($audience === $k) }}">{{ $l }}</a>
                @endforeach
            </div>
            <div>
                <div style="display:inline-flex;gap:4px;background:rgba(255,255,255,.08);padding:4px;border-radius:12px">
                    <a href="{{ route('site.plans', ['audience' => $audience, 'cycle' => 'monthly']) }}" style="padding:8px 18px;border-radius:9px;font-weight:800;{{ $cycle === 'monthly' ? 'background:#fff;color:#0b3442' : 'color:#fff' }}">{{ $isAr ? 'شهري' : 'Monthly' }}</a>
                    <a href="{{ route('site.plans', ['audience' => $audience, 'cycle' => 'yearly']) }}" style="padding:8px 18px;border-radius:9px;font-weight:800;{{ $cycle === 'yearly' ? 'background:#fff;color:#0b3442' : 'color:#fff' }}">{{ $isAr ? 'سنوي' : 'Yearly' }}</a>
                </div>
            </div>
        </div>
    </section>

    <div class="af-wrap" style="padding-top:30px">
        @if ($plans->isEmpty())
            <div class="af-card" style="padding:40px;text-align:center;color:#7a8a90">{{ $isAr ? 'لا توجد باقات متاحة حاليًا' : 'No plans available yet' }}</div>
        @else
            <div class="af-grid-3">
                @foreach ($plans as $p)
                    @php
                        $features = json_decode($isAr ? $p->features : ($p->features_en ?? $p->features), true) ?: [];
                        $pro = $p->tier === 'professional';
                    @endphp
                    <div class="af-card" style="padding:26px;display:flex;flex-direction:column;{{ $pro ? 'border:2px solid #cba135;box-shadow:0 18px 40px rgba(203,161,53,.18)' : '' }}">
                        @if ($pro)<div style="align-self:flex-start;background:#cba135;color:#0b3442;padding:4px 12px;border-radius:8px;font-weight:900;font-size:12px;margin-bottom:10px">{{ $isAr ? 'الأكثر طلبًا' : 'Most popular' }}</div>@endif
                        <div style="font-weight:900;font-size:20px">{{ $isAr ? $p->name : ($p->name_en ?? $p->name) }}</div>
                        <div style="margin:10px 0 4px">
                            @if ((float) $p->price == 0)
                                <span style="font-size:34px;font-weight:900;color:#1b7a4a">{{ $isAr ? 'مجانية' : 'Free' }}</span>
                            @else
                                <span style="font-size:34px;font-weight:900;color:#0f4051">{{ rtrim(rtrim(number_format((float) $p->price, 3), '0'), '.') }}</span>
                                <span style="color:#7a8a90;font-weight:700"> {{ $kwd }} / {{ $cycle === 'yearly' ? ($isAr ? 'سنة' : 'year') : ($isAr ? 'شهر' : 'month') }}</span>
                            @endif
                        </div>
                        @if ($p->original_price)<div style="color:#98a2a6;text-decoration:line-through;font-size:14px">{{ $p->original_price }} {{ $kwd }}</div>@endif
                        <div style="margin:16px 0;flex:1;display:flex;flex-direction:column;gap:9px">
                            @foreach ($features as $f)
                                <div style="display:flex;gap:8px;font-size:14px;line-height:1.6"><span style="color:#cba135;font-weight:900">✓</span><span>{{ $f }}</span></div>
                            @endforeach
                        </div>
                        <div style="text-align:center;padding:12px;border-radius:12px;background:{{ $pro ? '#0f4051' : '#eef4f6' }};color:{{ $pro ? '#fff' : '#0f4051' }};font-weight:800">{{ $isAr ? 'الاشتراك متاح من تطبيق آفاق' : 'Subscribe in the AFAQ app' }}</div>
                    </div>
                @endforeach
            </div>
        @endif
    </div>
</div>
@endsection
