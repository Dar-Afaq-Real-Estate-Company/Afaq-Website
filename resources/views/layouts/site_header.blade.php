@php
    $isAr = app()->getLocale() === 'ar';
    $otherLocale = $isAr ? 'en' : 'ar';
    $switchUrl = \LaravelLocalization::getLocalizedURL($otherLocale, null, [], true);
    $navItems = [
        ['label' => $isAr ? 'الرئيسية' : 'Home', 'url' => route('welcome'), 'active' => request()->routeIs('welcome')],
        ['label' => $isAr ? 'العقارات' : 'Properties', 'url' => route('site.properties'), 'active' => request()->routeIs('site.properties')],
        ['label' => $isAr ? 'مقاولات البناء' : 'Contracting', 'url' => route('site.section', 'contracting'), 'active' => request()->is('*section/contracting')],
        ['label' => $isAr ? 'الوظائف' : 'Jobs', 'url' => route('site.section', 'jobs'), 'active' => request()->is('*section/jobs')],
        ['label' => $isAr ? 'الشركات العقارية' : 'Companies', 'url' => route('site.section', 'companies'), 'active' => request()->is('*section/companies')],
        ['label' => $isAr ? 'المكاتب الهندسية' : 'Engineering', 'url' => route('site.section', 'engineering'), 'active' => request()->is('*section/engineering')],
        ['label' => $isAr ? 'الخدمات' : 'Services', 'url' => route('site.services'), 'active' => request()->routeIs('site.services')],
        ['label' => $isAr ? 'الباقات' : 'Plans', 'url' => route('site.plans'), 'active' => request()->routeIs('site.plans')],
        ['label' => $isAr ? 'الفنادق' : 'Hotels', 'url' => route('site.section', 'hotels'), 'active' => request()->is('*section/hotels')],
    ];
@endphp
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--teal:#0f4051;--teal-d:#0b3442;--gold:#cba135;--gold-l:#e6c76a;--bg:#f5f7f8;--line:#e8eef0;--muted:#7a8a90}
body{font-family:'Tajawal',sans-serif !important;background:var(--bg) !important;color:#0f2a33}
a{color:var(--teal);text-decoration:none}a:hover{color:var(--gold)}
.af-wrap{max-width:1280px;margin:0 auto;padding:0 28px}
.af-header{position:sticky;top:0;z-index:1030;background:var(--teal-d);box-shadow:0 6px 24px rgba(0,0,0,.18)}
.af-header .af-wrap{display:flex;align-items:center;gap:22px;padding-top:12px;padding-bottom:12px}
.af-brand{display:flex;align-items:center;gap:10px;color:#fff !important;font-weight:900;font-size:20px}
.af-brand img{width:46px;height:46px;border-radius:12px;background:#fff;object-fit:contain;padding:3px}
.af-nav{display:flex;gap:4px;flex:1;flex-wrap:wrap}
.af-nav a{padding:8px 12px;border-radius:10px;color:#fff;font-weight:700;font-size:14.5px;white-space:nowrap}
.af-nav a.active,.af-nav a:hover{background:rgba(203,161,53,.16);color:var(--gold-l)}
.af-tools{display:flex;align-items:center;gap:10px}
.af-lang{width:40px;height:40px;border-radius:11px;border:1px solid var(--gold);color:var(--gold) !important;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:13px}
.af-btn-ghost{padding:10px 16px;border-radius:11px;border:1px solid rgba(255,255,255,.25);color:#fff !important;font-weight:700;font-size:14px}
.af-btn-gold{padding:10px 18px;border-radius:11px;background:var(--gold);color:var(--teal-d) !important;font-weight:800;font-size:14px}
.af-menu-btn{display:none;background:none;border:0;color:#fff;font-size:26px}
.af-section{padding-top:48px}
.af-h2{font-size:26px;font-weight:900;margin:0}
.af-head-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:18px}
.af-more{font-weight:800}
.af-card{background:#fff;border:1px solid var(--line);border-radius:20px;overflow:hidden}
.af-chip{display:inline-block;padding:3px 10px;border-radius:7px;font-size:12px;font-weight:800}
.af-chip-teal{background:#eef4f6;color:var(--teal)}
.af-chip-gold{background:#fbf5e6;color:#9a7a20}
.af-chip-green{background:#e9f6ef;color:#1b7a4a;min-width:86px;text-align:center}
.af-grid-4{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:18px}
.af-grid-5{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:14px}
.af-grid-6{display:grid;grid-template-columns:repeat(6,minmax(0,1fr));gap:14px}
.af-grid-3{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px}
@media (max-width:1100px){.af-grid-6{grid-template-columns:repeat(3,minmax(0,1fr))}.af-grid-5,.af-grid-4{grid-template-columns:repeat(2,minmax(0,1fr))}.af-grid-3{grid-template-columns:1fr}}
@media (max-width:991px){.af-nav{display:none}.af-nav.open{display:flex;flex-direction:column;position:absolute;top:100%;right:0;left:0;background:var(--teal-d);padding:12px 28px}.af-menu-btn{display:block}.af-btn-ghost{display:none}}
@media (max-width:575px){.af-wrap{padding:0 14px}.af-grid-6{grid-template-columns:repeat(2,minmax(0,1fr))}.af-grid-5,.af-grid-4{grid-template-columns:1fr}}
</style>
<header class="af-header" dir="{{ $isAr ? 'rtl' : 'ltr' }}">
    <div class="af-wrap" style="position:relative">
        <a class="af-brand" href="{{ route('welcome') }}"><img src="{{ asset('image/afaq.jpeg') }}" alt="AFAQ">{{ $isAr ? 'آفاق' : 'AFAQ' }}</a>
        <nav class="af-nav" id="afNav">
            @foreach ($navItems as $n)
                <a href="{{ $n['url'] }}" class="{{ $n['active'] ? 'active' : '' }}">{{ $n['label'] }}</a>
            @endforeach
        </nav>
        <div class="af-tools">
            <a class="af-lang" href="{{ $switchUrl }}">{{ $isAr ? 'EN' : 'ع' }}</a>
            @guest
                <a class="af-btn-ghost" href="{{ route('login') }}">{{ $isAr ? 'تسجيل الدخول' : 'Login' }}</a>
            @else
                <a class="af-btn-ghost" href="{{ route('details') }}">{{ $isAr ? 'إعلاناتي' : 'My Ads' }}</a>
                <a class="af-btn-ghost" href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('af-logout').submit();">{{ $isAr ? 'خروج' : 'Logout' }}</a>
                <form id="af-logout" action="{{ route('logout') }}" method="POST" class="d-none">@csrf</form>
            @endguest
            <a class="af-btn-gold" href="{{ route('advertisement') }}">+ {{ $isAr ? 'أضف إعلان' : 'Add Ad' }}</a>
            <button class="af-menu-btn" type="button" onclick="document.getElementById('afNav').classList.toggle('open')">☰</button>
        </div>
    </div>
</header>
