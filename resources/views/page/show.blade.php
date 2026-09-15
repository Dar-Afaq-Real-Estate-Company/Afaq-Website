@extends('layouts.app')
@section('content')
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DarAfaq - العقارات</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
:root {
    --primary-navy: #0f172a;
    --accent-gold: #cba135;
    --text-muted: #64748b;
    --card-bg: #ffffff;
}

body {
    font-family: 'Tajawal', sans-serif;
    background-color: #f8fafc;
    color: var(--primary-navy);
    margin: 0;
}

/* ======= الهيرو ======= */
.modern-header {
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
    padding: 110px 0 150px;
    text-align: center;
    color: white;
    clip-path: ellipse(150% 100% at 50% 0%);
}

.modern-header h1 {
    font-size: clamp(2rem, 5vw, 2.8rem);
    font-weight: 900;
}

/* ======= الشبكة والبطاقات ======= */
.ads-grid {
    max-width: 1240px;
    margin: -70px auto 80px;
    padding: 0 20px;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 35px;
}

.modern-card {
    background: var(--card-bg);
    border-radius: 35px;
    border: 1px solid rgba(0,0,0,0.02);
    box-shadow: 0 15px 35px rgba(0,0,0,0.05);
    transition: all 0.4s ease;
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

.modern-card:hover {
    transform: translateY(-12px);
    box-shadow: 0 25px 50px rgba(15, 23, 42, 0.12);
}

.image-container {
    height: 230px;
    overflow: hidden;
    position: relative;
}

.image-container img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.8s ease;
}

.modern-card:hover .image-container img {
    transform: scale(1.12);
}

.content-area {
    padding: 25px;
    flex-grow: 1;
}

.property-title {
    font-size: 1.3rem;
    font-weight: 800;
    margin-bottom: 10px;
    color: var(--primary-navy);
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* ======= تنسيق الوصف الجديد ======= */
.property-desc {
    font-size: 0.9rem;
    color: var(--text-muted);
    line-height: 1.6;
    margin-bottom: 20px;
    height: 45px; /* يضمن توازن شكل البطاقات */
    display: -webkit-box;
    -webkit-line-clamp: 2; /* يظهر سطرين فقط */
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.property-meta {
    display: flex;
    gap: 15px;
    font-size: 0.85rem;
    color: var(--text-muted);
    margin-bottom: 20px;
    font-weight: 600;
}

.property-meta i { color: var(--accent-gold); }

.price-box {
    margin-bottom: 25px;
    display: flex;
    align-items: baseline;
    gap: 5px;
}

.price-box .val {
    font-size: 1.6rem;
    font-weight: 900;
    color: var(--primary-navy);
}

.price-box .unit {
    font-size: 0.85rem;
    font-weight: 700;
    color: var(--accent-gold);
}

.btn-view {
    background: #f1f5f9;
    color: var(--primary-navy);
    text-align: center;
    padding: 15px;
    border-radius: 20px;
    font-weight: 800;
    text-decoration: none;
    transition: 0.3s;
    display: block;
    font-size: 0.95rem;
}

.btn-view:hover {
    background: var(--primary-navy);
    color: white;
}

.trust-footer {
    padding: 15px 25px;
    background: #fafafa;
    border-top: 1px solid #f3f4f6;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 0.8rem;
    font-weight: 600;
}

@media (max-width: 768px) {
    .ads-grid { gap: 20px; margin-top: -50px; }
    .modern-card { border-radius: 25px; }
}
</style>
</head>

<body>

<header class="modern-header">
    <div class="container">
        <h1>{{ trans('main.Offers') }}</h1>
        <p class="opacity-75">عقارات مختارة تليق بتطلعاتكم</p>
    </div>
</header>

<div class="ads-grid" id="adsContainer">
    @if($details->isEmpty())
        <div class="text-center w-100 py-5">
            <p class="fs-4 text-muted">{{ trans('main.no_offers') }}</p>
        </div>
    @else
        @foreach ($details as $detail)
        <div class="modern-card">
            <div class="image-container">
                <img src="{{ $detail->images ?? 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80' }}" alt="Property">
            </div>

            <div class="content-area">
                <h3 class="property-title">{{ $detail->title }}</h3>
                
                <p class="property-desc">
                    {{ $detail->description }}
                </p>
                
                <div class="property-meta">
                    <span><i class="fa-solid fa-location-dot me-1"></i> {{ $detail->region }}</span>
                    <span><i class="fa-solid fa-tag me-1"></i> {{  $detail->transaction_type }}</span>
                </div>

                <div class="price-box">
                    <span class="val">{{ $detail->price ?? 0 }}</span>
                    <span class="unit">ألف د.ك</span>
                </div>

                <a href="{{ route('details.show', $detail->id) }}" class="btn-view">
                    التفاصيل الكاملة <i class="fa-solid fa-chevron-left ms-2" style="font-size: 0.7rem;"></i>
                </a>
            </div>

            <div class="trust-footer">
                <span class="text-success"><i class="fa-solid fa-shield-check me-1"></i> {{ __('main.real_estate_company') }}</span>
                <span class="text-muted">ID: #{{ $detail->id }}</span>
            </div>
        </div>
        @endforeach
    @endif
</div>

</body>
</html>
@endsection