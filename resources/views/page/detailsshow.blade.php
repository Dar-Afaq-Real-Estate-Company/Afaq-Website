@extends('layouts.app')

@section('content')

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

<div class="smart-property-page animate__animated animate__fadeIn">
    
    <div class="top-smart-bar">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-3">
                <span class="badge-live"><span class="pulse"></span> {{ __('main.live_now') }}</span>
                <p class="m-0 small text-white-50 d-none d-md-block">{{ __('main.currently_viewing', ['count' => 12]) }}</p>
            </div>
            <div class="header-tools">
                <button class="tool-btn"><i class="fa-solid fa-share-nodes"></i></button>
                <button class="tool-btn"><i class="fa-regular fa-heart"></i></button>
            </div>
        </div>
    </div>

    <section class="visual-viewport">
        <div class="container-fluid p-0">
            <div class="hero-image-container">
                <img src="{{ $detail->images }}" id="mainImg" class="viewport-img">
                <div class="viewport-overlay">
                    <div class="container">
                        <h1 class="display-title">{{ $detail->title }}</h1>
                        <p class="display-location"><i class="fa-solid fa-location-dot"></i> {{ $detail->region }}</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="lower-content-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="detail-card main-info">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="fw-black m-0">{{ __('main.overview') }}</h4>
                            <div class="price-tag-big">{{ number_format($detail->price) }} <small>{{ __('main.kwd') }}</small></div>
                        </div>
                        
                        <div class="quick-specs-row">
                            <div class="spec-tile">
                                <i class="fa-solid fa-expand"></i>
                                <div><small>{{ __('main.area') }}</small><strong>{{ $detail->area }} {{ __('main.sqm') }}</strong></div>
                            </div>
                            <div class="spec-tile">
                                <i class="fa-solid fa-bed"></i>
                                <div><small>{{ __('main.rooms') }}</small><strong>{{ $detail->rooms }}</strong></div>
                            </div>
                            <div class="spec-tile">
                                <i class="fa-solid fa-bath"></i>
                                <div><small>{{ __('main.bathrooms') }}</small><strong>{{ $detail->bathrooms }}</strong></div>
                            </div>
                        </div>

                        <hr class="my-4">
                        <h5 class="fw-bold mb-3">{{ __('main.about_property') }}</h5>
                        <p class="description-text">{{ $detail->description }}</p>
                    </div>

                    <div class="detail-card mt-4">
                        <h5 class="fw-bold mb-3">{{ __('main.location') }}</h5>
                        <div id="map" class="map-view"></div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="sticky-column">
                        <div class="detail-card contact-card">
                            <div class="mb-4 text-center">
                                <label class="text-muted small d-block mb-1">{{ __('main.total_price') }}</label>
                                <h2 class="fw-black text-primary" style="font-size: 36px;">{{ number_format($detail->price) }} <small style="font-size: 16px;">{{ __('main.kwd') }}</small></h2>
                            </div>
                            
                            <h6 class="fw-bold mb-3 border-top pt-3">{{ __('main.contact_advertiser') }}</h6>
                            @auth
                                <a href="tel:{{ $detail->phone }}" class="btn-action call"><i class="fa-solid fa-phone"></i> {{ __('main.call_phone') }}</a>
                                <a href="https://wa.me/{{ $detail->phone }}" class="btn-action whatsapp"><i class="fa-brands fa-whatsapp"></i> {{ __('main.quick_whatsapp') }}</a>
                            @else
                                <div class="auth-lock-box" onclick="showLoginAlert()">
                                    <i class="fa-solid fa-lock"></i>
                                    <p class="m-0 mt-2 small">{{ __('main.login_to_view_data') }}</p>
                                </div>
                            @endauth
                        </div>

                        <div class="detail-card mt-4 bg-light border-0">
                            <div class="d-flex gap-3">
                                <i class="fa-solid fa-shield-halved text-success fs-3"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">{{ __('main.safety_tip') }}</h6>
                                    <p class="small text-muted m-0">{{ __('main.safety_tip_desc') }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
:root { 
    --navy: #0f172a; 
    --gold: #cba135; 
    --accent: #3b82f6;
}

body { background: #f8fafc; font-family: 'Tajawal', sans-serif; direction: rtl; }

/* Top Smart Bar */
.top-smart-bar { background: var(--navy); padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.1); }
.badge-live { background: rgba(239, 68, 68, 0.2); color: #f87171; padding: 4px 12px; border-radius: 100px; font-size: 12px; font-weight: bold; }
.pulse { width: 8px; height: 8px; background: #ef4444; border-radius: 50%; display: inline-block; margin-left: 5px; animation: blink 1s infinite; }
@keyframes blink { 50% { opacity: 0; } }
.tool-btn { background: rgba(255,255,255,0.05); border: none; color: white; width: 35px; height: 35px; border-radius: 10px; margin-right: 5px; }

/* Visual Viewport (Hero) */
.hero-image-container { position: relative; height: 60vh; overflow: hidden; }
.viewport-img { width: 100%; height: 100%; object-fit: cover; }
.viewport-overlay { 
    position: absolute; inset: 0; 
    background: linear-gradient(to top, #f8fafc 5%, transparent 60%); 
    display: flex; align-items: flex-end; padding-bottom: 50px;
}
.display-title { font-size: 42px; font-weight: 900; color: var(--navy); text-shadow: 0 4px 15px rgba(255,255,255,0.5); }
.display-location { color: #64748b; font-size: 18px; }

/* Lower Content */
.lower-content-section { margin-top: -30px; position: relative; z-index: 10; padding-bottom: 80px; }
.detail-card { background: white; border-radius: 25px; padding: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.02); }

/* Specs Tile */
.quick-specs-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; }
.spec-tile { background: #f1f5f9; padding: 15px; border-radius: 20px; display: flex; align-items: center; gap: 12px; }
.spec-tile i { font-size: 22px; color: var(--gold); }
.spec-tile small { display: block; font-size: 11px; color: #64748b; }
.spec-tile strong { font-size: 16px; color: var(--navy); }

/* Price Tag */
.price-tag-big { background: var(--navy); color: white; padding: 10px 25px; border-radius: 15px; font-size: 28px; font-weight: 900; }

/* Map View */
.map-view { height: 300px; border-radius: 20px; border: 1px solid #e2e8f0; }

/* Buttons */
.btn-action { display: block; text-align: center; padding: 18px; border-radius: 20px; text-decoration: none; font-weight: 800; margin-bottom: 12px; transition: 0.3s; }
.btn-action.call { background: var(--navy); color: white; }
.btn-action.whatsapp { background: #22c55e; color: white; }
.btn-action:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }

.auth-lock-box { background: #f8fafc; border: 2px dashed #cbd5e1; padding: 30px; border-radius: 20px; text-align: center; color: #64748b; cursor: pointer; }

@media (max-width: 991px) {
    .hero-image-container { height: 40vh; }
    .display-title { font-size: 28px; }
    .price-tag-big { font-size: 22px; padding: 8px 15px; }
    .quick-specs-row { grid-template-columns: 1fr; }
}
</style>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    // الخريطة
    var map = L.map('map').setView([29.3759, 47.9774], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
    L.marker([29.3759, 47.9774]).addTo(map);

    function showLoginAlert() { alert('يرجى تسجيل الدخول أولاً لعرض بيانات التواصل.'); }
</script>

@endsection