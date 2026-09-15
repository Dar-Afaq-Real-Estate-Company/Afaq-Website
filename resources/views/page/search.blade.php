@extends('layouts.app')

@section('content')
{{-- الخطوط والأيقونات --}}
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">

@php
    $sections = [
        ['title' => __('main.Property for sale'), 'icon' => 'fa-house-chimney', 'color' => '#27ae60'],
        ['title' => __('main.Property for rent'), 'icon' => 'fa-key', 'color' => '#f39c12'],
        ['title' => __('main.Property for exchange'), 'icon' => 'fa-right-left', 'color' => '#e74c3c'],
        ['title' => __('main.International Real Estate'), 'icon' => 'fa-earth-americas', 'color' => '#3498db'],
        ['title' => __('main.Real Estate Office'), 'icon' => 'fa-building-user', 'color' => '#8e44ad'],
        ['title' => __('main.Contractors'), 'icon' => 'fa-trowel-bricks', 'color' => '#d35400'],
        ['title' => __('main.Engineering Offices'), 'icon' => 'fa-compass-drafting', 'color' => '#16a085'],
    ];
@endphp

<style>
    :root {
        --brand-color: #265362;
        --accent-gold: #c5a059;
        --bg-soft: #f8fafc;
        --white: #ffffff;
        --text-dark: #1e293b;
        --text-muted: #64748b;
    }

    body {
        font-family: 'Tajawal', sans-serif;
        background-color: var(--bg-soft);
        direction: rtl;
        margin: 0;
        color: var(--text-dark);
    }

    /* Hero Section */
    .hero-section {
        background: linear-gradient(135deg, #265362 0%, #1a3a45 100%);
        padding: 100px 0 140px;
        text-align: center;
        position: relative;
    }

    .hero-content h1 {
        color: white;
        font-weight: 900;
        font-size: 3rem;
        margin-bottom: 15px;
    }

    .hero-content p {
        color: rgba(255,255,255,0.8);
        font-size: 1.2rem;
        margin-bottom: 40px;
    }

    /* Search Bar */
    .search-wrapper {
        max-width: 1100px;
        margin: -70px auto 50px;
        padding: 0 20px;
        position: relative;
        z-index: 10;
    }

    .main-search-bar {
        background: var(--white);
        padding: 12px;
        border-radius: 20px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .field-group {
        flex: 1;
        display: flex;
        align-items: center;
        border-left: 1px solid #f1f5f9;
        padding: 0 15px;
    }

    .field-group:last-of-type { border-left: none; }

    .field-group i { color: var(--accent-gold); font-size: 18px; }

    .search-input {
        width: 100%;
        border: none;
        padding: 12px 10px;
        font-weight: 600;
        color: var(--brand-color);
        outline: none;
        background: transparent;
        font-size: 15px;
    }

    .btn-search {
        background: var(--brand-color);
        color: white;
        border: none;
        padding: 0 35px;
        height: 55px;
        border-radius: 15px;
        font-weight: 700;
        font-size: 16px;
        cursor: pointer;
        transition: 0.3s ease;
    }

    .btn-search:hover { background: var(--accent-gold); transform: translateY(-2px); }

    /* Ads Grid */
    .ads-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 20px;
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 25px;
    }

    /* Card Style */
    .ad-card {
        background: var(--white);
        border-radius: 24px;
        overflow: hidden;
        position: relative;
        border: 1px solid rgba(0,0,0,0.03);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex;
        flex-direction: column;
    }

    .ad-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.08);
    }

    .ad-image-wrapper {
        position: relative;
        height: 220px;
        overflow: hidden;
    }

    .ad-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.6s ease;
    }

    .ad-card:hover .ad-img {
        transform: scale(1.1);
    }

    .ad-badge {
        position: absolute;
        top: 15px;
        right: 15px;
        background: rgba(255, 255, 255, 0.95);
        padding: 6px 14px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 700;
        color: var(--brand-color);
        z-index: 2;
        box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    }

    .ad-info {
        padding: 20px;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }

    .ad-location {
        font-size: 13px;
        color: var(--text-muted);
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 8px;
    }

    .ad-title {
        font-size: 18px;
        font-weight: 800;
        color: var(--text-dark);
        margin-bottom: 10px;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .ad-description {
        font-size: 14px;
        color: var(--text-muted);
        line-height: 1.6;
        margin-bottom: 15px;
        height: 45px; /* يحدد طول الوصف */
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .ad-meta {
        display: flex;
        gap: 15px;
        margin-bottom: 20px;
        padding-top: 15px;
        border-top: 1px solid #f1f5f9;
    }

    .meta-item {
        display: flex;
        align-items: center;
        gap: 5px;
        font-size: 13px;
        color: var(--text-muted);
    }

    .meta-item i { color: var(--accent-gold); }

    .ad-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: auto;
    }

    .ad-price {
        font-size: 20px;
        font-weight: 900;
        color: var(--brand-color);
    }

    .ad-price small {
        font-size: 12px;
        font-weight: 500;
        color: var(--text-muted);
    }

    .btn-details {
        background: #f1f5f9;
        color: var(--brand-color);
        padding: 10px 18px;
        border-radius: 12px;
        font-weight: 700;
        font-size: 14px;
        text-decoration: none;
        transition: 0.3s;
    }

    .btn-details:hover {
        background: var(--brand-color);
        color: white;
    }

    @media (max-width: 768px) {
        .main-search-bar { flex-direction: column; border-radius: 25px; padding: 15px; }
        .field-group { width: 100%; border-left: none; border-bottom: 1px solid #f1f5f9; padding: 10px 0; }
        .btn-search { width: 100%; margin-top: 10px; }
        .hero-content h1 { font-size: 2.2rem; }
    }
</style>

<div class="hero-section">
    <div class="container hero-content">
        <h1>ابحث عن عقارك المثالي</h1>
        <p>آلاف العقارات الموثوقة بانتظارك في كافة مناطق الكويت</p>
    </div>
</div>

<div class="search-wrapper">
    <div class="main-search-bar">
        <div class="field-group">
            <i class="fa-solid fa-layer-group"></i>
            <select id="main-section" class="search-input">
                <option value="all">القسم</option>
                @foreach($sections as $sec)
                    <option value="{{ $sec['title'] }}" {{ isset($section) && $section == $sec['title'] ? 'selected' : '' }}>{{ $sec['title'] }}</option>
                @endforeach
            </select>
        </div>

        <div class="field-group">
            <i class="fa-solid fa-house"></i>
            <select id="main-type" class="search-input">
                <option value="all">نوع العقار</option>
                @foreach($propertyTypes as $type)
                    <option value="{{ $type->name }}" {{ isset($type_val) && $type_val == $type->name ? 'selected' : '' }}>{{ $type->name }}</option>
                @endforeach
            </select>
        </div>

        <div class="field-group">
            <i class="fa-solid fa-location-dot"></i>
            <select id="main-region" class="search-input">
                <option value="all">المنطقة</option>
                @foreach($areas as $area)
                    <option value="{{ $area->name }}" {{ isset($region) && $region == $area->name ? 'selected' : '' }}>{{ $area->name }}</option>
                @endforeach
            </select>
        </div>

        <button class="btn-search" onclick="startSearch()">
            <i class="fa-solid fa-magnifying-glass me-2"></i> بحث
        </button>
    </div>
</div>

<div class="ads-container">
    @forelse($details as $detail)
        <div class="ad-card">
            <div class="ad-image-wrapper">
                <div class="ad-badge">{{ $detail->transaction_type ?? 'عقار' }}</div>
                <img src="{{ $detail->images ?? 'https://via.placeholder.com/400x300' }}" class="ad-img" alt="{{ $detail->title }}">
            </div>

            <div class="ad-info">
                <div class="ad-location">
                    <i class="fa-solid fa-location-dot"></i>
                    {{ $detail->region }}
                </div>
                
                <h4 class="ad-title">{{ Str::limit($detail->title, 55) }}</h4>

                {{-- إضافة وصف العقار هنا --}}
                <div class="ad-description">
                    {{ Str::limit(strip_tags($detail->description), 120) }}
                </div>

                <div class="ad-meta">
                    <div class="meta-item">
                        <i class="fa-solid fa-bed"></i>
                        <span>{{ $detail->rooms ?? '0' }}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fa-solid fa-bath"></i>
                        <span>{{ $detail->bathrooms ?? '0' }}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fa-solid fa-ruler-combined"></i>
                        <span>{{ $detail->area_size ?? '0' }} م²</span>
                    </div>
                </div>

                <div class="ad-footer">
                    <div class="ad-price">
                        {{ number_format($detail->price) }} 
                        <small>د.ك</small>
                    </div>
                    <a href="{{ route('details.show', $detail->id) }}" class="btn-details">
                        التفاصيل
                    </a>
                </div>
            </div>
        </div>
    @empty
        <div style="grid-column: 1 / -1; text-align: center; padding: 100px 0;">
            <i class="fa-solid fa-folder-open" style="font-size: 50px; color: #cbd5e1; margin-bottom: 20px;"></i>
            <p style="color: var(--text-muted); font-size: 18px;">لا توجد إعلانات متاحة حالياً</p>
        </div>
    @endforelse
</div>

<script>
    function startSearch() {
        const sectionVal = document.getElementById('main-section').value;
        const typeVal    = document.getElementById('main-type').value;
        const regionVal  = document.getElementById('main-region').value;

        const section = (sectionVal === "" || sectionVal === "all") ? 'all' : sectionVal;
        const type    = (typeVal === "" || typeVal === "all") ? 'all' : typeVal;
        const region  = (regionVal === "" || regionVal === "all") ? 'all' : regionVal;

        const baseUrl = "{{ url('/show') }}";
        const url = `${baseUrl}/${encodeURIComponent(section)}/${encodeURIComponent(type)}/${encodeURIComponent(region)}`;

        window.location.href = url;
    }
</script>

@endsection