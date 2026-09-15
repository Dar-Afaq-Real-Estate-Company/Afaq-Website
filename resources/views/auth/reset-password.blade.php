@extends('layouts.app')

@section('content')

<main class="section-pad">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="card shadow-lg border-0 rounded-4 p-4 fancy-card">
                <div class="text-center mb-4">
                    <h3 class="fw-bold text-white">🔑 {{ __('auth.Reset Password') }}</h3>
                    <p class="text-white-50">{{ __('auth.Please enter your email and new password to update your account.') }}</p>
                </div>

                <div class="card-body">
                    <form method="POST" action="{{ route('password.update') }}">
                        @csrf
                        <input type="hidden" name="token" value="{{ $token }}">

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold text-white">{{ __('auth.Email') }}</label>
                            <input id="email" type="email"
                                class="form-control rounded-3 p-3 shadow-sm @error('email') is-invalid @enderror"
                                name="email" value="{{ $email ?? old('email') }}" required autocomplete="email" autofocus
                                placeholder="example@email.com">
                            @error('email')
                                <span class="invalid-feedback d-block mt-1 text-black" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <!-- New Password -->
                        <div class="mb-3 position-relative">
                            <label for="password" class="form-label fw-semibold text-white">{{ __('auth.New Password') }}</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-dark"><i class="fa-solid fa-lock"></i></span>
                                <input id="password" type="password"
                                    class="form-control border-start-0 rounded-end-3 shadow-sm @error('password') is-invalid @enderror"
                                    name="password" required autocomplete="new-password" placeholder="••••••••">
                                <span class="input-group-text bg-light border-start-0 border-end-0 show-pass" style="cursor:pointer;">
                                    <i class="fa-solid fa-eye" id="togglePassword"></i>
                                </span>
                            </div>
                            @error('password')
                                <span class="invalid-feedback d-block mt-1 text-black" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <!-- Confirm Password -->
                        <div class="mb-4 position-relative">
                            <label for="password-confirm" class="form-label fw-semibold text-white">{{ __('auth.Confirm Password') }}</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-dark"><i class="fa-solid fa-lock"></i></span>
                                <input id="password-confirm" type="password"
                                    class="form-control border-start-0 rounded-end-3 shadow-sm"
                                    name="password_confirmation" required autocomplete="new-password"
                                    placeholder="••••••••">
                                <span class="input-group-text bg-light border-start-0 border-end-0 show-pass" style="cursor:pointer;">
                                    <i class="fa-solid fa-eye" id="toggleConfirmPassword"></i>
                                </span>
                            </div>
                        </div>

                        <div class="text-center">
                            <button type="submit" class="btn fw-bold text-white px-5 py-2 rounded-3 shadow fancy-submit">
                                {{ __('auth.Reset Password') }}
                            </button>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>
</main>

<style>
/* Card */
.fancy-card {
    background: linear-gradient(145deg, #0f4051, #ffffff);
    box-shadow: 0 25px 60px rgba(15,64,81,0.4);
    border-radius: 20px;
    transition: transform 0.4s, box-shadow 0.4s;
    color: #ffffff;
}
.fancy-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 35px 70px rgba(15,64,81,0.6);
}

/* Input fields */
.form-control {
    background-color: #ffffff;
    color: #0f4051;
    border: 1px solid #0f4051;
    border-radius: 10px;
    padding: 10px 12px;
    transition: all 0.3s ease;
}
.form-control:focus {
    border-color: #0f4051;
    box-shadow: 0 0 5px rgba(15,64,81,0.3);
}

/* Buttons */
.fancy-submit {
    background: linear-gradient(135deg, #0f4051, #2c6b85);
    color: #ffffff;
    font-size: 16px;
    font-weight: 700;
    padding: 10px 0;
    border-radius: 12px;
    transition: all 0.4s ease;
    box-shadow: 0 8px 20px rgba(15,64,81,0.6);
}
.fancy-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(15,64,81,0.8);
}

/* Input group icon */
.input-group-text {
    color: #0f4051;
    background-color: #ffffff;
}

/* Links */
a { color: #ffffff !important; }

/* Responsive */
@media(max-width:576px){
    .row > .col-md-8 {flex:0 0 100%; max-width:100%;}
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const togglePassword = document.querySelector('#togglePassword');
    const passwordInput = document.querySelector('#password');

    const toggleConfirmPassword = document.querySelector('#toggleConfirmPassword');
    const confirmInput = document.querySelector('#password-confirm');

    togglePassword.addEventListener('click', function () {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        this.classList.toggle('fa-eye-slash');
    });

    toggleConfirmPassword.addEventListener('click', function () {
        const type = confirmInput.getAttribute('type') === 'password' ? 'text' : 'password';
        confirmInput.setAttribute('type', type);
        this.classList.toggle('fa-eye-slash');
    });
});
</script>

@endsection
