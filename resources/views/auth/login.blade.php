@extends('layouts.app')

@section('content')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">

<style>
:root {
    --brand-teal: #0f4051;
    --brand-gold: #cba135;
    --brand-gold-hover: #b38d2d;
    --pure-white: #ffffff;
    --border-color: #e2e8f0;
}

body {
    font-family: "Tajawal", sans-serif;
    background-color: #f8fafc !important; 
    margin: 0;
}

.login-section {
    padding-top: 100px; /* تقليل المسافة في الموبايل */
    padding-bottom: 60px;
    min-height: 90vh;
    display: flex;
    align-items: center;
}

/* =========================
   الكارد المطور (متجاوب)
========================= */
.login-card {
    background: var(--pure-white);
    border: 2px solid var(--brand-teal);
    border-radius: 25px;
    padding: 40px 30px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05);
    transition: 0.3s ease-in-out;
    width: 100%;
}

.login-header h3 {
    color: var(--brand-teal);
    font-weight: 900;
    font-size: 1.8rem; /* تصغير الخط قليلاً للموبايل */
    margin-bottom: 5px;
}

.gold-line {
    width: 50px;
    height: 4px;
    background: var(--brand-gold);
    margin: 12px auto;
    border-radius: 10px;
}

/* =========================
   المدخلات
========================= */
.form-group-custom { margin-bottom: 20px; }

.custom-label {
    color: var(--brand-teal);
    font-weight: 800;
    font-size: 1rem;
    margin-bottom: 8px;
    display: block;
}

.custom-input {
    width: 100%;
    padding: 14px 18px;
    border: 2px solid var(--border-color);
    border-radius: 15px;
    font-weight: 700;
    font-size: 1rem;
    color: var(--brand-teal);
    transition: 0.3s;
    background-color: #f1f5f9;
}

.custom-input:focus {
    border-color: var(--brand-gold);
    background-color: #fff;
    box-shadow: 0 0 0 4px rgba(203, 161, 53, 0.1);
    outline: none;
}

.pass-wrapper { position: relative; }
.eye-icon {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    font-size: 1.1rem;
    color: var(--brand-teal);
    padding: 10px;
    z-index: 10;
}

[dir="rtl"] .eye-icon { left: 10px; }
[dir="ltr"] .eye-icon { right: 10px; }

.login-btn-fakhim {
    background-color: var(--brand-teal);
    color: #fff !important;
    width: 100%;
    padding: 15px;
    border-radius: 15px;
    font-weight: 800;
    font-size: 1.1rem;
    border: none;
    transition: 0.3s;
    margin-top: 10px;
    box-shadow: 0 4px 12px rgba(15, 64, 81, 0.2);
}

.login-btn-fakhim:active { transform: scale(0.98); }

/* =========================
   تحسينات الروابط للموبايل
========================= */
.footer-links {
    flex-direction: row; /* الحفاظ على سطر واحد */
    gap: 10px;
}

.footer-links a {
    color: var(--brand-teal);
    font-weight: 700;
    text-decoration: none;
    font-size: 0.85rem;
}

/* =========================
   شاشات الموبايل الصغيرة (Media Queries)
========================= */
@media (max-width: 576px) {
    .login-section { padding-top: 80px; }
    .login-card {
        padding: 30px 20px; /* تقليل الحواف الداخلية */
        border-radius: 20px;
    }
    .login-header h3 { font-size: 1.5rem; }
    .custom-input { padding: 12px 15px; font-size: 0.95rem; }
    .footer-links {
        flex-direction: column; /* جعل الروابط تحت بعضها في الشاشات الصغيرة جداً */
        align-items: center;
        gap: 15px;
    }
}
</style>

<main class="login-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-4 px-3">

                <div class="login-card text-center">
                    <div class="login-header mb-4">
                        <h3>{{ trans('auth.Login') }}</h3>
                        <div class="gold-line"></div>
                    </div>

                    <form method="POST" action="{{ route('login') }}" class="text-start">
                        @csrf

                        <div class="form-group-custom">
                            <label class="custom-label">{{ trans('auth.Email') }}</label>
                            <input id="email" type="email" class="custom-input @error('email') is-invalid @enderror" 
                                   name="email" value="{{ old('email') }}" required autofocus placeholder="example@mail.com">
                            @error('email')
                                <span class="invalid-feedback" role="alert" style="display:block; font-size:0.8rem; font-weight:bold; margin-top:5px;">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <div class="form-group-custom">
                            <label class="custom-label">{{ trans('auth.password') }}</label>
                            <div class="pass-wrapper">
                                <input type="password" id="password" name="password" 
                                       class="custom-input @error('password') is-invalid @enderror" required placeholder="••••••••">
                                <span class="eye-icon" data-target="password">
                                    <i class="fa-solid fa-eye"></i>
                                </span>
                            </div>
                            @error('password')
                                <span class="invalid-feedback" role="alert" style="display:block; font-size:0.8rem; font-weight:bold; margin-top:5px;">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <button type="submit" class="login-btn-fakhim">
                            {{ trans('auth.Login') }}
                        </button>

                        <div class="footer-links d-flex justify-content-between mt-4">
                            @if (Route::has('password.request'))
                                <a href="{{ route('password.request') }}">
                                    {{ trans('auth.Forgot Your Password?') }}
                                </a>
                            @endif
                            <a href="{{ route('register') }}" style="color: var(--brand-gold);">
                                {{ trans('auth.Register') }}
                            </a>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>

<script>
document.querySelectorAll('.eye-icon').forEach(btn => {
    btn.addEventListener('click', function () {
        const input = document.getElementById(this.dataset.target);
        const icon = this.querySelector('i');
        if(input.type === "password") {
            input.type = "text";
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            input.type = "password";
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    });
});
</script>
@endsection