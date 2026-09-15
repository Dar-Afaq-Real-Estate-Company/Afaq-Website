@extends('layouts.app')

@section('content')

<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
:root {
    --bg-main: #f8fafc;
    --navy-deep: #0f172a;
    --gold-premium: #cba135;
    --glass-effect: rgba(255, 255, 255, 0.98);
}

body {
    background-color: var(--bg-main);
    font-family: 'Tajawal', sans-serif;
    direction: rtl;
    color: var(--navy-deep);
    overflow-x: hidden;
}

/* ===== 1. Hero Section ===== */
.hero-premium {
    position: relative; padding: 120px 0 160px;
    background: linear-gradient(135deg, rgba(15, 23, 42, 0.95), rgba(15, 23, 42, 0.75)),
                url('https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg') center/cover fixed;
    border-radius: 0 0 80px 80px; text-align: center; color: white;
}

/* ===== 2. شريط البحث ===== */
.floating-search {
    max-width: 1100px; margin: -65px auto 0; background: var(--glass-effect);
    backdrop-filter: blur(20px); padding: 12px; border-radius: 60px;
    box-shadow: 0 30px 60px rgba(0,0,0,0.15); display: flex; gap: 12px; position: relative; z-index: 10; border: 1px solid rgba(255,255,255,1);
}

.search-field-wrapper {
    flex: 1; background: #f1f5f9; border-radius: 50px; padding: 4px 20px;
    display: flex; align-items: center; transition: 0.4s;
    border: 2px solid transparent; position: relative;
}

.search-select {
    border: none; background: transparent; font-weight: 700; color: var(--navy-deep);
    cursor: pointer; padding: 12px 5px; outline: none; width: 100%; font-size: 0.95rem;
    appearance: none; z-index: 2;
}

.dropdown-icon { position: absolute; left: 20px; color: var(--gold-premium); pointer-events: none; font-size: 0.8rem; }

.btn-search-main {
    background: var(--navy-deep); color: white; padding: 0 45px; border-radius: 50px;
    font-weight: 800; height: 60px; border: none; transition: 0.3s;
    display: flex; align-items: center; gap: 10px;
}

@media (max-width: 991px) {
    .floating-search { width: 98%; margin-top: -45px; padding: 5px; gap: 4px; border-radius: 50px; }
    .search-field-wrapper { padding: 0 6px; height: 42px; border-radius: 30px; }
    .search-field-wrapper i:not(.dropdown-icon) { display: none; }
    .search-select { font-size: 0.62rem; padding: 0 2px; font-weight: 800; }
    .dropdown-icon { left: 4px; font-size: 0.5rem; }
    .btn-search-main { width: 42px; min-width: 42px; height: 42px; padding: 0; justify-content: center; }
    .btn-search-main span { display: none; }
}

/* ===== 3. بطاقة العروض ===== */
.prop-card-modern { background: white; border-radius: 40px; padding: 15px; transition: 0.5s; border: 1px solid rgba(0,0,0,0.04); height: 100%; }
.img-stack { position: relative; height: 200px; border-radius: 30px; overflow: hidden; }
.price-pill { position: absolute; bottom: 15px; right: 15px; background: white; color: var(--navy-deep); padding: 5px 15px; border-radius: 100px; font-weight: 900; box-shadow: 0 5px 15px rgba(0,0,0,0.1); font-size: 0.9rem; }
.prop-description { font-size: 0.85rem; color: #64748b; margin: 12px 0; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.6; }
.btn-details { background: #f1f5f9; color: var(--navy-deep); border-radius: 100px; padding: 12px; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 10px; width: 100%; margin-bottom: 12px; text-decoration: none; transition: 0.3s; }

/* ===== 4. خدماتنا وحراج ===== */
.services-grid-new { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.service-tool-small { background: white; padding: 12px 5px; border-radius: 18px; border: 1px solid rgba(0,0,0,0.04); display: flex; flex-direction: column; align-items: center; gap: 6px; text-decoration: none; color: var(--navy-deep); transition: 0.3s; }
.service-tool-small i { font-size: 1.1rem; color: var(--gold-premium); }
.service-tool-small span { font-size: 0.7rem; font-weight: 700; }

.haraj-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 50px; }
.haraj-item { background: white; border-radius: 15px; padding: 15px 5px; display: flex; flex-direction: column; align-items: center; gap: 8px; border: 1px solid rgba(0,0,0,0.05); transition: 0.3s; cursor: pointer; }
.haraj-icon-box { width: 45px; height: 45px; background: #f1f5f9; border-radius: 12px; display: flex; align-items: center; justify-content: center; }
.haraj-icon-box i { font-size: 1.2rem; color: var(--gold-premium); }
.haraj-label { font-size: 0.75rem; font-weight: 700; color: var(--navy-deep); }

@media (min-width: 992px) {
    .services-grid-new { grid-template-columns: repeat(5, 1fr); gap: 20px; }
    .haraj-grid { grid-template-columns: repeat(7, 1fr); gap: 20px; }
}

/* ===== 5. أخبار ومقالات ===== */
.news-list { display:flex; flex-direction:column; gap:12px; background: white; border-radius: 25px; padding: 15px; border: 1px solid rgba(0,0,0,0.05); }
.news-item { padding:15px 10px; border-bottom:1px solid #f1f5f9; cursor:pointer; transition: 0.3s; }
.news-item:last-child { border-bottom: none; }
.news-item:hover { background: #f8fafc; }

.news-title {
    margin:0; font-size:0.95rem; color:#0f4051; font-weight:bold; line-height: 1.5;
    display: block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}

@media (min-width: 992px) { .news-title { white-space: normal; } }

.section-title { font-weight: 900; font-size: 1.8rem; margin-bottom: 25px; position: relative; display: inline-block; }
.section-title::after { content: ''; position: absolute; bottom: -8px; right: 0; width: 40px; height: 4px; background: var(--gold-premium); border-radius: 10px; }

.mobile-dock { position: fixed; bottom: 25px; left: 50%; transform: translateX(-50%); background: rgba(15, 23, 42, 0.95); backdrop-filter: blur(20px); display: flex; gap: 40px; padding: 15px 40px; border-radius: 100px; z-index: 1000; box-shadow: 0 20px 50px rgba(0,0,0,0.3); }
.dock-link { color: white; text-decoration: none; font-size: 20px; }

/* Modal sub-type item */
.sub-type-item { display: flex; align-items: center; gap: 15px; padding: 15px; background: #f8fafc; border-radius: 15px; text-decoration: none; color: var(--navy-deep); font-weight: 700; transition: 0.3s; margin-bottom: 10px; }
.sub-type-item:hover { background: #f1f5f9; transform: translateX(-5px); }
.rounded-luxury { border-radius: 25px !important; overflow: hidden; }
    .text-navy { color: #0a2d39; }
    .text-gold { color: #cba135; }

    .bg-light-hover {
        background-color: #f8fafd;
        transition: all 0.3s ease;
    }

    .bg-light-hover:hover {
        background-color: #0a2d39 !important;
        color: #fff !important;
        transform: scale(1.02);
    }

    .bg-light-hover:hover i { color: #cba135 !important; }

    .haraj-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
        gap: 20px;
    }

    .haraj-item {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 20px;
        padding: 20px;
        text-align: center;
        cursor: pointer;
        transition: 0.3s;
    }

    .haraj-item:hover { box-shadow: 0 10px 30px rgba(0,0,0,0.08); transform: translateY(-5px); }
.pure-text-news {
    padding: 30px 0;
    margin-bottom: 80px;
}

/* حاوية القائمة - دائماً تحت بعض في كل الشاشات */
.news-list-container {
    display: flex;
    flex-direction: column;
    gap: 12px; /* المسافة بين الأخبار */
    padding: 0 5px;
}

/* سطر الخبر الواحد */
.news-text-row {
    display: flex;
    align-items: center;
    text-decoration: none !important;
    width: 100%; /* يأخذ عرض الشاشة كاملاً */
    overflow: hidden; /* إخفاء أي نص زائد */
}

/* النقطة الجانبية */
.news-bullet {
    color: #cba135;
    font-size: 1.5rem;
    margin-left: 12px;
    flex-shrink: 0; /* منع النقطة من الانضغاط */
}

/* النص البرمجي - الأهم هنا */
.news-title-text {
    color: #0f172a !important; /* لون كحلي غامق واضح */
    font-weight: 700;
    font-size: 1.05rem;
    margin: 0;

    /* إجبار النص على البقاء في خط واحد وظهور النقاط */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;

    flex-grow: 1; /* السماح للنص بأخذ المساحة المتبقية */
}

/* تأثير عند المرور بالماوس */
.news-text-row:hover .news-title-text {
    color: #cba135 !important;
    text-decoration: underline;
}

/* الموبايل - التأكيد على بقاء العناصر تحت بعض */
@media (max-width: 768px) {
    .news-list-container {
        flex-direction: column !important; /* إجبار الترتيب الرأسي في الموبايل */
    }

    .news-title-text {
        font-size: 0.95rem; /* تصغير الخط قليلاً ليناسب الشاشات الصغيرة */
    }
}
/* تنسيق بطاقات الرؤية المصغرة */
.mini-about-card {
    background: #ffffff;
    padding: 10px 5px;
    border-radius: 12px;
    text-align: center;
    height: 100%;
    border: 1px solid #f1f5f9;
    box-shadow: 0 2px 5px rgba(0,0,0,0.02);
}

.mini-title {
    font-size: 0.75rem; /* خط صغير ليناسب 3 أعمدة */
    font-weight: 800;
    color: #cba135;
    margin-bottom: 5px;
    white-space: nowrap;
}

.mini-content {
    font-size: 0.65rem; /* خط أصغر للمحتوى */
    color: #64748b;
    line-height: 1.2;
    display: -webkit-box;
    -webkit-line-clamp: 2; /* إظهار سطرين فقط */
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* تنسيق الأخبار (كما طلبته سابقاً) */
.pure-text-news-up {
    padding: 10px 0;
}
.news-list-container { display: flex; flex-direction: column; gap: 10px; }
.news-text-row { display: flex; align-items: center; text-decoration: none !important; overflow: hidden; }
.news-bullet { color: #cba135; margin-left: 8px; flex-shrink: 0; }
.news-title-text {
    color: #0f172a !important;
    font-weight: 700;
    font-size: 0.95rem;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* تعديلات خاصة للموبايل */
@media (max-width: 768px) {
    .container { padding-left: 10px; padding-right: 10px; }
    .row.g-2 { margin-left: -4px; margin-right: -4px; }
    .col-4 { padding-left: 4px; padding-right: 4px; }
}

/* الحاوية الأساسية */
.info-section-wrapper {
    margin-top: 20px;
    padding-bottom: 30px;
}

/* نظام الشبكة - 3 أعمدة دائماً */
.info-grid-container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px; /* مسافة مريحة بين البطاقات */
}

/* تصميم البطاقة */
.info-card-modern {
    background: #ffffff;
    border: 1px solid #f1f5f9;
    border-radius: 16px;
    padding: 20px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: 0 4px 15px rgba(0,0,0,0.02);
    transition: 0.3s ease;
}

/* الأيقونة داخل دائرة */
.info-icon-circle {
    width: 45px;
    height: 45px;
    background: #fff9eb; /* لون ذهبي خفيف جداً */
    color: #cba135;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    margin-bottom: 12px;
}

/* العناوين */
.info-content-box h5 {
    font-size: 1rem;
    font-weight: 800;
    color: #0f172a;
    margin-bottom: 8px;
}

/* النصوص */
.info-content-box p {
    font-size: 0.85rem;
    color: #64748b;
    line-height: 1.5;
    margin: 0;
}

/* ===== التعديلات الخاصة بشاشة الهاتف (تلقائي) ===== */
@media (max-width: 768px) {
    .info-grid-container {
        gap: 8px; /* تقليل المسافات في الموبايل */
    }

    .info-card-modern {
        padding: 12px 5px; /* ضغط الحواف لزيادة مساحة الكلام */
        border-radius: 10px;
    }

    .info-icon-circle {
        width: 32px;
        height: 32px;
        font-size: 0.9rem;
        margin-bottom: 6px;
    }

    .info-content-box h5 {
        font-size: 0.65rem; /* تصغير العنوان ليناسب عرض الشاشة */
        margin-bottom: 4px;
    }

    .info-content-box p {
        font-size: 0.55rem; /* نص صغير جداً لمنع تداخل الكلام */
        line-height: 1.2;
        /* إظهار 3 أسطر فقط في الموبايل لضمان الترتيب */
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
}

/* للشاشات الكبيرة جداً */
@media (min-width: 1200px) {
    .info-card-modern {
        padding: 30px 25px;
    }
    .info-icon-circle {
        width: 55px;
        height: 55px;
        font-size: 1.4rem;
    }
    .info-content-box h5 {
        font-size: 1.15rem;
    }
}
</style>



@php
    $sections = [
        [
            'title' => __('main.Property for sale'),
            'icon' => 'fa-home',
            'color' => '#7CC580',
            // هنا التغيير: بدلاً من المصفوفة الثابتة، نضع بيانات الموديل
            'types' => $propertyTypes
        ],
        [
            'title' => __('main.Property for rent'),
            'icon' => 'fa-key',
            'color' => '#FFA500',
            'types' => $propertyTypes
        ],
        [
            'title' => __('main.Property for exchange'),
            'icon' => 'fa-exchange-alt',
            'color' => '#FF6B6B',
            'types' => $propertyTypes
        ],
        [
            'title' => __('main.International Real Estate'),
            'icon' => 'fa-globe',
            'color' => '#1E90FF',
            'types' => $propertyTypes
        ],
        [
            'title' => __('main.Real Estate Office'),
            'icon' => 'fa-building-user',
            'color' => '#6A5ACD',
            'types' => $propertyTypes
        ],
        [
            'title' => __('main.Contracting'),
            'icon' => 'fa-helmet-safety',
            'color' => '#FF8C00',
            'types' => $propertyTypes
        ],
        [
            'title' => __('main.Engineering Offices'),
            'icon' => 'fa-drafting-compass',
            'color' => '#2E8B57',
            'types' => $propertyTypes
        ],
    ];
@endphp

<section class="hero-premium">
    <div class="container" data-aos="fade-down">
        <h1 class="fw-black" style="font-size: clamp(2.5rem, 6vw, 4.5rem);">دار آفاق العقارية</h1>
        <p class="opacity-75 fs-5">خيارك الأول في السوق العقاري الكويتي</p>
    </div>
</section>

<div class="container">
    <div class="floating-search">
        {{-- 1. حقل الأقسام (يبقى كما هو) --}}
        <div class="search-field-wrapper">
            <select id="search-section" class="search-select">
                <option value="">{{ __('main.Department') }}</option>
                @foreach($sections as $sec)
                    <option value="{{ $sec['title'] }}">{{ $sec['title'] }}</option>
                @endforeach
            </select>
            <i class="fa fa-chevron-down dropdown-icon"></i>
        </div>

        {{-- 2. حقل النوع (تم تعديله ليسحب من قاعدة البيانات) --}}
        <div class="search-field-wrapper">
            <select id="search-type" class="search-select">
                <option value="">{{ __('main.Choose_Type') }}</option>
                @foreach($propertyTypes as $type)
                    {{-- نستخدم name أو title حسب المسمى في جدول propertytypes --}}
                    <option value="{{ $type->name }}">{{ $type->name }}</option>
                @endforeach
            </select>
            <i class="fa fa-home dropdown-icon"></i>
        </div>

        {{-- 3. حقل المنطقة (تم تعديله ليسحب من قاعدة البيانات بدلاً من القائمة اليدوية الطويلة) --}}
        <div class="search-field-wrapper">
            <select id="search-region" class="search-select">
                <option value="">{{ __('main.Choose_Region') }}</option>
                @foreach($areas as $area)
                    {{-- نستخدم id للقيمة و name للعرض --}}
                    <option value="{{ $area->name }}">{{ $area->name }}</option>
                @endforeach
            </select>
            <i class="fa fa-map-marker-alt dropdown-icon"></i>
        </div>

        {{-- زر البحث --}}
        <button onclick="executeSearch()" class="btn-search-main">
            <i class="fa fa-magnifying-glass"></i>
            <span>{{ __('main.search') }}</span>
        </button>
    </div>
</div>

<section class="container mt-5 pt-4">
    <h3 class="section-title mb-4">{{ __('main.Our services') }}</h3>

    <div class="services-grid-new">
        <a href="{{ route('advertisement') }}" class="service-tool-small">
            <i class="fa fa-circle-plus"></i>
            <span>{{ __('main.add_ad') }}</span>
        </a>

        <a href="{{ route('Quicks') }}" class="service-tool-small">
            <i class="fa fa-building-circle-check"></i>
            <span>{{ __('main.Property management for others') }}</span>
        </a>

        <a href="{{ route('Quicks') }}" class="service-tool-small">
            <i class="fa fa-calculator"></i>
            <span>{{ __('main.rent_calculation') }}</span>
        </a>

        <a href="{{ route('Quicks') }}" class="service-tool-small">
            <i class="fa fa-hammer"></i>
            <span>{{ __('main.construction_cost') }}</span>
        </a>

        <a href="{{ route('Quicks') }}" class="service-tool-small">
            <i class="fa fa-gem"></i>
            <span>{{ __('main.real_estate_evaluation') }}</span>
        </a>
    </div>
</section>

<section class="container mt-5 pt-4">
    <h3 class="section-title mb-4">  {{ __('main.Real Estate Sections') }}</h3>
    <div class="haraj-grid">
        @foreach($sections as $key => $sec)
            <div class="haraj-item-wrapper" style="position: relative;">
                <div class="haraj-item" data-bs-toggle="modal" data-bs-target="#modal-{{ $key }}">
                    <div class="haraj-icon-box"><i class="fa {{ $sec['icon'] }}"></i></div>
                    <span class="haraj-label">{{ $sec['title'] }}</span>
                </div>
            </div>

            {{-- المودال الخاص بكل قسم --}}
            <div class="modal fade" id="modal-{{ $key }}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content rounded-luxury">
                        <div class="modal-header border-0">
                            <h5 class="modal-title fw-bold text-navy">{{ $sec['title'] }}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="list-group list-group-flush">
                                {{-- التغيير الجوهري هنا: القراءة من الموديل ديناميكياً --}}
                                @foreach($sec['types'] as $type)
                                    <a href="{{ route('browse.ads', ['section' => $sec['title'], 'type' => $type->name]) }}"
                                       class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 border-0 rounded-3 mb-2 bg-light-hover">

                                        {{-- ملاحظة: إذا كان جدول الأنواع يحتوي على عمود للأيقونة نستخدمه، وإلا نضع أيقونة افتراضية شيك --}}
                                        <i class="fa {{ $type->icon ?? 'fa-tag' }} text-gold"></i>

                                        <span class="fw-bold">{{ $type->name }}</span>

                                        <i class="fa fa-chevron-left ms-auto text-muted small"></i>
                                    </a>
                                @endforeach
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
</section>

<section class="container mt-5">
    <h2 class="section-title">{{ trans('main.The strongest offers') }}</h2>
    <div class="row g-4">
        @foreach ($details as $detail)
        <div class="col-lg-4 col-md-6">
            <div class="prop-card-modern shadow-sm">
                <div class="img-stack"><img src="{{ $detail->images }}" class="w-100 h-100 object-fit-cover"><div class="price-pill">{{ number_format($detail->price) }} د.ك</div></div>
                <div class="mt-4 px-2">
                    <h5 class="fw-black mb-2 text-truncate">{{ $detail->title }}</h5>
                    <p class="prop-description">{{ $detail->description }}</p>
                    <p class="text-muted small mb-3"><i class="fa fa-location-dot me-1 text-warning"></i> {{ $detail->region }}</p>
                    <a href="{{ route('details.show', $detail->id) }}" class="btn-details"> {{ __('main.view_details') }} <i class="fa fa-arrow-left"></i></a>
                </div>
            </div>
        </div>
        @endforeach
    </div>
</section>



@foreach($sections as $key => $sec)
<div class="modal fade" id="modal-{{ $key }}" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0" style="border-radius:30px;">
            <div class="modal-header bg-dark text-white border-0" style="border-radius:30px 30px 0 0;">
                <h5 class="fw-bold m-0">{{ $sec['title'] }}</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-2">
                    @foreach($sec['types'] as $type)
                    <div class="col-12">
                        {{-- الرابط المطلوب استخدامه --}}
                        <a href="{{ route('sections.show', [
                            'section' => urlencode($sec['title']),
                            'type' => urlencode($type['name'])
                        ]) }}" class="sub-type-item">
                            <i class="fas {{ $type['icon'] }} text-warning"></i>
                            <span>{{ $type['name'] }}</span>
                        </a>
                    </div>
                    @endforeach
                </div>
            </div>
        </div>
    </div>
</div>
@endforeach


<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>
function executeSearch() {
    // جلب القيم المختارة، وإذا كانت فارغة نضع 'all'
    const section = document.getElementById('search-section').value || 'all';
    const type = document.getElementById('search-type').value || 'all';
    const region = document.getElementById('search-region').value || 'all';

    // بناء الرابط بناءً على القيم (الممتلئة أو 'all')
    const url = `/show/${encodeURIComponent(section)}/${encodeURIComponent(type)}/${encodeURIComponent(region)}`;

    // التوجيه للرابط
    window.location.href = url;
}
</script>

@endsection
