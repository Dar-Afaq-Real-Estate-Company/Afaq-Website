<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">

<title>OTP Verification</title>

<style>
/* ------------------ CSS ------------------ */

body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background: linear-gradient(135deg, #0f4051 0%, #3a6a7c 100%);
    color: #fff;
}

/* صندوق الرسالة */
.container {
    width: 100%;
    max-width: 600px;
    margin: 40px auto;
    background-color: #ffffff;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    text-align: center;
    position: relative;
    color: #0f4051 !important;
}

/* اللوجو */
.logo {
    margin-bottom: 10px;
    opacity: 0;
    transform: translateY(-20px);
    transition: opacity 1s ease, transform 1s ease;
}
.logo.show {
    opacity: 1;
    transform: translateY(0);
}
.logo img {
    max-height: 60px;
}

/* اسم العلامة */
.brand-name {
    font-size: 20px;
    font-weight: bold;
    color: #0f4051;
    margin-top: 5px;
    letter-spacing: 1px;
}

/* العنوان */
.header h1 {
    color: #0f4051;
    margin: 15px 0 0 0;
    font-size: 24px;
}

/* المحتوى */
.content {
    padding: 20px 0;
    font-size: 16px;
    line-height: 1.6;
    color: #0f4051;
}

/* كود OTP */
.otp-code {
    font-size: 32px;
    font-weight: bold;
    color: #0f4051;
    margin: 20px 0;
    padding: 15px 25px;
    background-color: #d6e3eb;
    border-radius: 8px;
    display: inline-block;
    letter-spacing: 4px;
    transition: box-shadow 0.3s ease;
}

/* تأثير الوميض */
.otp-glow {
    animation: glow 0.8s ease-in-out 2;
}
@keyframes glow {
    0% { box-shadow: 0 0 5px #0f4051; }
    50% { box-shadow: 0 0 20px #3a6a7c; }
    100% { box-shadow: 0 0 5px #0f4051; }
}

/* زر النسخ */
.copy-btn {
    display: inline-block;
    margin-top: 10px;
    padding: 10px 20px;
    font-size: 14px;
    color: #fff;
    background: linear-gradient(135deg, #0f4051, #3a6a7c);
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s;
}
.copy-btn:hover {
    background: linear-gradient(135deg, #3a6a7c, #0f4051);
}

/* رسالة تم النسخ */
.toast {
    position: absolute;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%) translateY(20px);
    background-color: #0f4051;
    color: #fff;
    padding: 12px 25px;
    border-radius: 30px;
    font-size: 14px;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.4s, transform 0.4s;
}
.toast.show {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
}

/* الفوتر */
.footer {
    text-align: center;
    padding-top: 20px;
    border-top: 1px solid #d0d0d0;
    font-size: 12px;
    color: #555;
}

/* ------------------ END CSS ------------------ */
</style>

</head>
<body>

<div class="container">
    <div class="logo" id="logo">
        <img src="/img/ASETAR.jpeg" alt="ASETAR Logo">
        <div class="brand-name">DarAfaq </div>
    </div>
    <div class="header">
        <h1>One-Time Passcode (OTP)</h1>
    </div>
    <div class="content">
        <p>Hello,</p>
        <p>You have requested a One-Time Passcode for verification. Please use the following code to complete your action:</p>
        <div class="otp-code" id="otpCode">{{$msg}}</div>
        <br>
        <button class="copy-btn" onclick="copyOTP()">Copy OTP</button>
        <div class="toast" id="toast">OTP copied to clipboard!</div>
        <p>This code is valid for <strong>10 minutes</strong>. Please do not share it with anyone.</p>
        <p>If you did not request this OTP, please ignore this email.</p>
    </div>
    <div class="footer">
        <p>&copy; 2025 DarAfaq. All rights reserved.</p>
    </div>
</div>>

    <div class="footer">
        © 2025 جميع الحقوق محفوظة
    </div>

</div>


<!-- ------------------ JavaScript ------------------ -->
<script>
document.addEventListener("DOMContentLoaded", () => {
    setTimeout(() => {
        document.getElementById("logo").classList.add("show");
    }, 300);
});

function copyOTP() {
    const otp = document.getElementById("otp").innerText;
    navigator.clipboard.writeText(otp);

    let toast = document.getElementById("toast");
    toast.classList.add("show");

    setTimeout(() => {
        toast.classList.remove("show");
    }, 1500);
}
</script>

</body>
</html>
