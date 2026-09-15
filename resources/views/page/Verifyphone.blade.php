<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OTP Verification</title>
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        background: linear-gradient(135deg, #0f4051, #2c6b85);
        color: #fff;
    }
    .container {
        background: #ffffff;
        padding: 2rem 2.5rem;
        border-radius: 12px;
        box-shadow: 0 6px 15px rgba(15,64,81,0.3);
        text-align: center;
        width: 100%;
        max-width: 400px;
        color: #0f4051;
    }
    h1 {
        margin-bottom: 0.5rem;
        color: #0f4051;
    }
    p {
        margin-bottom: 1.5rem;
        color: #535b66;
    }
    .otp-input {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-bottom: 1.5rem;
    }
    .otp-input input {
        width: 45px;
        height: 50px;
        text-align: center;
        font-size: 1.2rem;
        border: 2px solid #0f4051;
        border-radius: 10px;
        background-color: #fff;
        color: #0f4051;
        transition: all 0.2s ease;
        -moz-appearance: textfield;
    }
    .otp-input input:focus {
        border-color: #2c6b85;
        box-shadow: 0 0 8px rgba(15,64,81,0.3);
        outline: none;
    }
    .otp-input input::-webkit-outer-spin-button,
    .otp-input input::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    button {
        background: linear-gradient(135deg, #0f4051, #2c6b85);
        color: #fff;
        border: none;
        padding: 12px 25px;
        font-size: 1rem;
        border-radius: 8px;
        cursor: pointer;
        margin: 5px 0;
        width: 100%;
        transition: all 0.3s ease;
    }
    button:hover {
        background: linear-gradient(135deg, #2c6b85, #0f4051);
    }
    button:disabled {
        background-color: #cccccc;
        color: #666666;
        cursor: not-allowed;
    }
    #timer {
        font-size: 1.1rem;
        margin-bottom: 1.5rem;
        color: #535b66;
    }

    /* Responsive */
    @media (max-width: 576px) {
        .container {
            padding: 1.5rem 1.5rem;
            max-width: 300px;
        }
        .otp-input input {
            width: 40px;
            height: 45px;
            font-size: 1rem;
        }
    }
</style>
</head>
<body>
<div class="container">
    <h1>{{ __('main.otp_verification') }}</h1>
    <p>{{ __('main.enter_code') }}</p>
    <div id="timer">3:00</div>

    <form method="post" action="{{ route('verify.store') }}" autocomplete="off">
        @csrf
        <div class="otp-input">
            <input type="number" min="0" name="verify1" max="9" required>
            <input type="number" min="0" name="verify2" max="9" required>
            <input type="number" min="0" name="verify3" max="9" required>
            <input type="number" min="0" name="verify4" max="9" required>
            <input type="number" min="0" name="verify5" max="9" required>
            <input type="number" min="0" name="verify6" max="9" required>
        </div>
        <button type="submit">{{ __('main.verify_button') }}</button>
    </form>

    <form method="post" action="{{ route('verify.send') }}" autocomplete="off">
        @csrf
        <button id="resendButton" type="button" onclick="resendOTP()" disabled>
            {{ __('main.resend_code') }}
        </button>
    </form>
</div>

<script>
const inputs = document.querySelectorAll('.otp-input input');
const timerDisplay = document.getElementById('timer');
const resendButton = document.getElementById('resendButton');
let timeLeft = 180; // 3 minutes
let timerId;

function startTimer() {
    timerId = setInterval(() => {
        if (timeLeft <= 0) {
            clearInterval(timerId);
            timerDisplay.textContent = "0:00";
            resendButton.disabled = false;
            inputs.forEach(input => input.disabled = true);
        } else {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            timerDisplay.textContent = `${minutes}:${seconds.toString().padStart(2,'0')}`;
            timeLeft--;
        }
    }, 1000);
}

function resendOTP() {
    alert("New OTP sent!");
    timeLeft = 180;
    inputs.forEach(input => {
        input.value = '';
        input.disabled = false;
    });
    resendButton.disabled = true;
    inputs[0].focus();
    clearInterval(timerId);
    startTimer();
}

inputs.forEach((input, index) => {
    input.addEventListener('input', e => {
        e.target.value = e.target.value.replace(/[^0-9]/g,'');
        if (e.target.value.length > 0 && index < inputs.length - 1) {
            inputs[index + 1].focus();
        }
    });
    input.addEventListener('keydown', e => {
        if (e.key === 'Backspace' && !e.target.value && index > 0) {
            inputs[index - 1].focus();
        }
    });
});

window.onload = () => inputs[0].focus();

startTimer();
</script>
</body>
</html>
