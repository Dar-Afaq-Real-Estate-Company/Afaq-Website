@extends('layouts.app')

@section('content')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">

<style>
/* المتغيرات الأساسية (نفس تسجيل الدخول) */
:root {
    --brand-teal: #0f4051;
    --brand-gold: #cba135;
    --brand-gold-hover: #b38d2d;
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
.login-section {
    padding-top: 140px; /* مسافة للنافبار */
    padding-bottom: 100px; /* مسافة أمان للفوتر */
    min-height: 85vh; /* يضمن دفع الفوتر للأسفل */
    display: flex;
    align-items: center;
}

/* =========================
   الكارد الاحترافي (نفس تسجيل الدخول تماماً)
========================= */
.login-card {
    background: var(--pure-white);
    border: 2px solid var(--brand-teal); /* إطار بلون الهوية */
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
   المدخلات (أكبر وأوضح)
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

/* رسائل الخطأ */
.invalid-feedback strong {
    font-weight: 800;
    color: #d00000;
}
</style>

<main class="login-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-8 px-4">

                <div class="login-card text-center">
                    <div class="login-header mb-4">
                        <h3>{{ __('auth.Reset Password') }}</h3>
                        <div class="gold-line"></div>
                        <p class="text-muted fw-bold small">{{ __('auth.Enter your email and new password to update your account.') }}</p>
                    </div>

                    <form method="POST" action="{{ route('password.update') }}" class="text-start">
                        @csrf
                        <input type="hidden" name="token" value="{{ $token }}">

                        <div class="form-group-custom">
                            <label class="custom-label">{{ __('auth.Email') }}</label>
                            <input id="email" type="email" class="custom-input @error('email') is-invalid @enderror" 
                                   name="email" value="{{ $email ?? old('email') }}" required autofocus>
                            @error('email')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <div class="form-group-custom">
                            <label class="custom-label">{{ __('auth.New Password') }}</label>
                            <div class="pass-wrapper">
                                <input id="password" type="password" name="password" class="custom-input @error('password') is-invalid @enderror" required placeholder="••••••••">
                                <span class="eye-icon" data-target="password">
                                    <i class="fa-solid fa-eye"></i>
                                </span>
                            </div>
                            @error('password')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <div class="form-group-custom">
                            <label class="custom-label">{{ __('auth.Confirm Password') }}</label>
                            <div class="pass-wrapper">
                                <input id="password-confirm" type="password" name="password_confirmation" class="custom-input" required placeholder="••••••••">
                                <span class="eye-icon" data-target="password-confirm">
                                    <i class="fa-solid fa-eye"></i>
                                </span>
                            </div>
                        </div>

                        <button type="submit" class="login-btn-fakhim shadow-sm">
                            {{ __('auth.Reset Now') }}
                        </button>
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