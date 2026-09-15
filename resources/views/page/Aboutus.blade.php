@extends('layouts.app')

@section('content')
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@200;400;700;900&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<style>
    :root {
        --dark-navy: #0a2d39; 
        --gold-silk: #cba135; 
        --off-white: #f8fafd;
    }

    body { 
        font-family: 'Tajawal', sans-serif; 
        /* تحديد الاتجاه والتحاذي حسب اللغة */
        direction: {{ app()->getLocale() == 'ar' ? 'rtl' : 'ltr' }}; 
        background: #fff; 
        color: #333; 
        margin: 0; 
        overflow-x: hidden; 
        text-align: {{ app()->getLocale() == 'ar' ? 'right' : 'left' }};
    }

    /* --- Hero Section --- */
    .hero-luxury {
        position: relative; height: 100vh;
        background: url('https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
        display: flex; align-items: center; justify-content: center; overflow: hidden;
    }
    .hero-luxury::before {
        content: ''; position: absolute; inset: 0;
        background: radial-gradient(circle, rgba(10, 45, 57, 0.7) 0%, rgba(0, 0, 0, 0.9) 100%);
        z-index: 1;
    }
    .hero-content { position: relative; z-index: 5; text-align: center; color: #fff; max-width: 1000px; padding: 20px; }
    .hero-content h1 { 
        font-size: clamp(2.2rem, 5vw, 4.5rem); font-weight: 900; line-height: 1.2; margin-bottom: 20px;
        background: linear-gradient(to bottom, #fff 60%, var(--gold-silk)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    }

    /* --- Stats --- */
    .stats-container {
        display: flex; justify-content: space-around; max-width: 1100px; margin: -100px auto 0;
        background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
        padding: 40px; border-radius: 30px; box-shadow: 0 40px 100px rgba(0,0,0,0.08);
        position: relative; z-index: 10; border: 1px solid rgba(255,255,255,0.2);
    }
    .stat-card { text-align: center; flex: 1; border-{{ app()->getLocale() == 'ar' ? 'left' : 'right' }}: 1px solid #eee; }
    .stat-card:last-child { border: none; }
    .stat-card h3 { font-size: 2.8rem; font-weight: 900; color: var(--dark-navy); margin: 0; }
    .stat-card p { font-size: 1rem; color: #777; font-weight: 700; margin-top: 5px; }

    /* --- Section Styling --- */
    .section-spacing { padding: 120px 20px; }
    .about-luxury-grid {
        display: grid; grid-template-columns: 1fr 1fr; gap: 80px; max-width: 1200px; margin: 0 auto; align-items: center;
    }
    .about-info h2 { font-size: 2.8rem; font-weight: 900; color: var(--dark-navy); margin-bottom: 20px; }
    .about-info p { font-size: 1.2rem; color: #555; line-height: 2; text-align: justify; }

    /* --- Contact Box --- */
    .contact-box {
        max-width: 1200px; margin: 0 auto; background: var(--dark-navy); border-radius: 50px;
        display: grid; grid-template-columns: 1fr 1.5fr; overflow: hidden; box-shadow: 0 50px 100px rgba(10,45,57,0.2);
    }
    .contact-cta { padding: 80px; color: #fff; background: linear-gradient(135deg, #0a2d39 0%, #051920 100%); }
    .contact-form { padding: 80px; background: #fff; }

    /* رقم الهاتف - يظل LTR دائماً */
    .phone-wrapper {
        direction: ltr; text-align: {{ app()->getLocale() == 'ar' ? 'right' : 'left' }}; 
        display: flex; align-items: center; 
        justify-content: {{ app()->getLocale() == 'ar' ? 'flex-end' : 'flex-start' }}; gap: 15px; margin: 20px 0;
    }
    .phone-link { color: #fff; text-decoration: none; font-size: 2rem; font-weight: 900; }

    .email-capsule {
        display: inline-flex; align-items: center; gap: 12px; background: rgba(255,255,255,0.08);
        padding: 15px 25px; border-radius: 50px; border: 1px solid rgba(203,161,53,0.3);
        color: var(--gold-silk); text-decoration: none; font-weight: 700; font-size: 1.2rem;
    }

    .form-group-lux { position: relative; margin-bottom: 35px; }
    .form-group-lux input, .form-group-lux textarea {
        width: 100%; padding: 15px 0; border: none; border-bottom: 1px solid #ddd;
        background: none; font-size: 1.1rem; text-align: {{ app()->getLocale() == 'ar' ? 'right' : 'left' }};
    }
    .btn-lux {
        background: var(--dark-navy); color: #fff; padding: 20px 50px; border-radius: 50px;
        border: none; font-size: 1.2rem; font-weight: 800; cursor: pointer; width: 100%;
        display: flex; align-items: center; justify-content: center; gap: 15px;
    }

    .reveal { opacity: 0; transform: translateY(30px); transition: 1s ease; }
    .reveal.active { opacity: 1; transform: translateY(0); }

    @media (max-width: 992px) {
        .about-luxury-grid { grid-template-columns: 1fr; gap: 40px; text-align: center; }
        .contact-box { grid-template-columns: 1fr; }
        .phone-wrapper { justify-content: center; }
    }
</style>

<body>

<section class="hero-luxury">
    <div class="hero-content animate__animated animate__fadeIn">
        <span style="color:var(--gold-silk); font-weight:bold; letter-spacing: 2px;">{{ __('main.hero_subtitle') }}</span>
        <h1>{{ __('main.dar_afaq_real_estate') }} <br> {{ __('main.hero_title_2') }}</h1>
        <p>{{ __('main.hero_description') }}</p>
    </div>
</section>

<div class="stats-container reveal">
    <div class="stat-card">
        <h3>1+</h3>
        <p>{{ __('main.stat_experience') }}</p>
    </div>
    <div class="stat-card">
        <h3>1+</h3>
        <p>{{ __('main.stat_partners') }}</p>
    </div>
    <div class="stat-card">
        <h3>100%</h3>
        <p>{{ __('main.stat_reliability') }}</p>
    </div>
</div>

<section class="section-spacing">
    <div class="about-luxury-grid">
        <div class="about-info reveal">
            <h2>{{ __('main.About') }}</h2>
            <p>{{ __('main.About_text_1') }}</p>
            <p>{{ __('main.About_text_2') }}</p>
            <div style="display: flex; justify-content: center; margin-top: 20px;">
                <img src="https://upload.wikimedia.org/wikipedia/commons/e/e3/Kuwait_signature.png" alt="Signature" style="width:150px; opacity:0.6;">
            </div>
        </div>
        <div class="about-img-frame reveal">
            <img src="https://images.unsplash.com/photo-1582407947304-fd86f028f716?auto=format&fit=crop&w=800&q=80" style="width:100%; border-radius:40px; box-shadow: 0 50px 80px rgba(0,0,0,0.15);" alt="Real Estate">
        </div>
    </div>
</section>

<section class="section-spacing">
    <div class="contact-box reveal">
        <div class="contact-cta">
            <h2 style="font-size:2.5rem; margin-bottom:20px;">{{ __('main.contact_channels') }}</h2>
            <p style="opacity:0.8; line-height:1.8;">{{ __('main.contact_description') }}</p>
            
            <div style="margin-top:40px;">
                <span style="color:var(--gold-silk); font-weight:bold; font-size:0.9rem;">{{ __('main.hotline') }}:</span>
                <div class="phone-wrapper">
                    <a href="tel:+96555525030" class="phone-link">+965 5552 5030</a>
                    <i class="fa-solid fa-phone-volume" style="color:var(--gold-silk); font-size:1.8rem;"></i>
                </div>
            </div>

            <div style="margin-top:30px;">
                <span style="color:var(--gold-silk); font-weight:bold; font-size:0.9rem;">{{ __('main.official_email') }}:</span><br>
                <a href="mailto:afaqkw.app@gmail.com" class="email-capsule">
                   afaqkw.app@gmail.com
                    <i class="fa-solid fa-envelope-open-text" style="font-size:1.4rem;"></i>
                </a>
            </div>
        </div>

        <div class="contact-form">
            <h3 style="margin-bottom:40px; color:var(--dark-navy); font-weight:900;">{{ __('main.contact_us_title') }}</h3>
            <form id="whatsappForm">
                <div class="form-group-lux">
                    <input type="text" placeholder="{{ __('main.full_name_placeholder') }}" required>
                </div>
                <div class="form-group-lux">
                    <input type="email" placeholder="{{ __('main.email_placeholder') }}" required>
                </div>
                <div class="form-group-lux">
                    <textarea rows="4" placeholder="{{ __('main.message_placeholder') }}"></textarea>
                </div>
                <button type="submit" class="btn-lux">
                    <span>{{ __('main.send_request') }}</span>
                    <i class="fa-brands fa-whatsapp" style="font-size:1.6rem; color:#25d366;"></i>
                </button>
            </form>
        </div>
    </div>
</section>

<script>
    function reveal() {
        var reveals = document.querySelectorAll(".reveal");
        for (var i = 0; i < reveals.length; i++) {
            var windowHeight = window.innerHeight;
            var elementTop = reveals[i].getBoundingClientRect().top;
            if (elementTop < windowHeight - 100) {
                reveals[i].classList.add("active");
            }
        }
    }
    window.addEventListener("scroll", reveal);
    window.addEventListener("load", reveal);
</script>

</body>
@endsection