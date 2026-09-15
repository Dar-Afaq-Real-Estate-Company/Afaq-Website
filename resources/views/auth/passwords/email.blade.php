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
   الزر (نفس تصميم اللوجن)
========================= */
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

/* تنبيه النجاح */
.alert-success {
    background-color: #d1e7dd;
    border-color: #badbcc;
    color: #0f5132;
    font-weight: 700;
    border-radius: 12px;
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
                        <h3>{{ __('auth.Reset Password') }}</h3>
                        <div class="gold-line"></div>
                        <p class="text-muted fw-bold small">{{ __('auth.Enter your email to receive a password reset link.') }}</p>
                    </div>

                    @if (session('status'))
                        <div class="alert alert-success mb-4" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    <form method="POST" action="{{ route('password.email') }}" class="text-start">
                        @csrf

                        <div class="form-group-custom">
                            <label class="custom-label">{{ __('auth.Email') }}</label>
                            <input id="email" type="email" class="custom-input @error('email') is-invalid @enderror" 
                                   name="email" value="{{ old('email') }}" required autocomplete="email" autofocus
                                   placeholder="example@email.com">
                            @error('email')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <button type="submit" class="login-btn-fakhim shadow-sm">
                            {{ __('auth.Send Reset Link') }}
                        </button>

                        <div class="footer-links text-center mt-4">
                            <a href="{{ route('login') }}">
                                <i class="fa-solid fa-arrow-left-long me-1"></i> {{ __('auth.Back to Login') }}
                            </a>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>
@endsection