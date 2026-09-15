@extends('layouts.app')

@section('content')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">

<style>
/* المتغيرات الأساسية للموقع */
:root {
    --brand-teal: #0f4051;
    --brand-gold: #cba135;
    --pure-white: #ffffff;
    --border-color: #e2e8f0;
}

body {
    font-family: "Tajawal", sans-serif;
    background-color: var(--pure-white) !important; /* خلفية بيضاء صريحة */
    margin: 0;
}

/* =========================
   تنسيق القسم الرئيسي (حماية الفوتر)
========================= */
.auth-section {
    padding-top: 140px; 
    padding-bottom: 100px;
    min-height: 85vh; 
    display: flex;
    align-items: center;
}

/* =========================
   الكارد الاحترافي (نفس تصميم اللوجن)
========================= */
.login-card {
    background: var(--pure-white);
    border: 2px solid var(--brand-teal); 
    border-radius: 20px;
    padding: 45px 35px;
    box-shadow: 20px 20px 60px #d9d9d9, -20px -20px 60px #ffffff;
    transition: 0.3s ease-in-out;
}

.login-card:hover {
    border-color: var(--brand-gold);
}

.login-header h3 {
    color: var(--brand-teal);
    font-weight: 900;
    font-size: 2.2rem;
    margin-bottom: 5px;
}

.gold-line {
    width: 60px;
    height: 4px;
    background: var(--brand-gold);
    margin: 15px auto;
    border-radius: 10px;
}

/* =========================
   المدخلات (وضوح فائق)
========================= */
.form-group-custom {
    margin-bottom: 25px;
}

.custom-label {
    color: var(--brand-teal);
    font-weight: 800;
    font-size: 1.1rem;
    margin-bottom: 10px;
    display: block;
}

.custom-input {
    width: 100%;
    padding: 15px 20px;
    border: 2px solid var(--border-color);
    border-radius: 12px;
    font-weight: 700;
    font-size: 1.05rem;
    color: var(--brand-teal);
    transition: 0.3s;
}

.custom-input:focus {
    border-color: var(--brand-teal);
    box-shadow: 0 0 10px rgba(15, 64, 81, 0.1);
    outline: none;
}

/* =========================
   أيقونة العين والزر
========================= */
.pass-wrapper {
    position: relative;
}

.eye-icon {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    font-size: 1.2rem;
    color: var(--brand-teal);
    opacity: 0.7;
    z-index: 10;
}

[dir="rtl"] .eye-icon { left: 20px; }
[dir="ltr"] .eye-icon { right: 20px; }

.eye-icon:hover { opacity: 1; color: var(--brand-gold); }

.login-btn-fakhim {
    background-color: var(--brand-teal);
    color: #fff !important;
    width: 100%;
    padding: 16px;
    border-radius: 12px;
    font-weight: 900;
    font-size: 1.2rem;
    border: 2px solid var(--brand-teal);
    transition: 0.3s;
    margin-top: 10px;
}

.login-btn-fakhim:hover {
    background-color: var(--brand-gold);
    border-color: var(--brand-gold);
    transform: translateY(-3px);
}

.footer-links a {
    color: var(--brand-teal);
    font-weight: 800;
    text-decoration: none;
    font-size: 0.95rem;
    transition: 0.3s;
}

.footer-links a:hover {
    color: var(--brand-gold);
}

.invalid-feedback strong {
    font-weight: 800;
    color: #d00000;
}
</style>

<main class="auth-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-8 px-4">

                <div class="login-card text-center">
                    <div class="login-header mb-4">
                        <h3>{{ __('auth.Confirm Password') }}</h3>
                        <div class="gold-line"></div>
                        <p class="text-muted fw-bold small">{{ __('auth.Please confirm your password before continuing.') }}</p>
                    </div>

                    <form method="POST" action="{{ route('password.confirm') }}" class="text-start">
                        @csrf

                        <div class="form-group-custom">
                            <label class="custom-label">{{ __('auth.password') }}</label>
                            <div class="pass-wrapper">
                                <input id="password" type="password" name="password" 
                                       class="custom-input @error('password') is-invalid @enderror" 
                                       required autocomplete="current-password" placeholder="••••••••">
                                <span class="eye-icon" id="togglePassword">
                                    <i class="fa-solid fa-eye"></i>
                                </span>
                            </div>
                            @error('password')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <button type="submit" class="login-btn-fakhim shadow-sm">
                            {{ __('auth.Confirm') }}
                        </button>

                        @if (Route::has('password.request'))
                        <div class="footer-links text-center mt-4">
                            <a href="{{ route('password.request') }}">
                                {{ __('auth.Forgot Your Password?') }}
                            </a>
                        </div>
                        @endif
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const togglePassword = document.querySelector('#togglePassword');
    const passwordInput = document.querySelector('#password');

    togglePassword.addEventListener('click', function () {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        const icon = this.querySelector('i');
        if (type === 'text') {
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    });
});
</script>
@endsection