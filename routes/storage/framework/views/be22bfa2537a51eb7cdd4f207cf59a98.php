<?php $__env->startSection('content'); ?>
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
                        <h3><?php echo e(trans('auth.Login')); ?></h3>
                        <div class="gold-line"></div>
                    </div>

                    <form method="POST" action="<?php echo e(route('login')); ?>" class="text-start">
                        <?php echo csrf_field(); ?>

                        <div class="form-group-custom">
                            <label class="custom-label"><?php echo e(trans('auth.Email')); ?></label>
                            <input id="email" type="email" class="custom-input <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" 
                                   name="email" value="<?php echo e(old('email')); ?>" required autofocus placeholder="example@mail.com">
                            <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <span class="invalid-feedback" role="alert" style="display:block; font-size:0.8rem; font-weight:bold; margin-top:5px;">
                                    <strong><?php echo e($message); ?></strong>
                                </span>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                        </div>

                        <div class="form-group-custom">
                            <label class="custom-label"><?php echo e(trans('auth.password')); ?></label>
                            <div class="pass-wrapper">
                                <input type="password" id="password" name="password" 
                                       class="custom-input <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" required placeholder="••••••••">
                                <span class="eye-icon" data-target="password">
                                    <i class="fa-solid fa-eye"></i>
                                </span>
                            </div>
                            <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <span class="invalid-feedback" role="alert" style="display:block; font-size:0.8rem; font-weight:bold; margin-top:5px;">
                                    <strong><?php echo e($message); ?></strong>
                                </span>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                        </div>

                        <button type="submit" class="login-btn-fakhim">
                            <?php echo e(trans('auth.Login')); ?>

                        </button>

                        <div class="footer-links d-flex justify-content-between mt-4">
                            <?php if(Route::has('password.request')): ?>
                                <a href="<?php echo e(route('password.request')); ?>">
                                    <?php echo e(trans('auth.Forgot Your Password?')); ?>

                                </a>
                            <?php endif; ?>
                            <a href="<?php echo e(route('register')); ?>" style="color: var(--brand-gold);">
                                <?php echo e(trans('auth.Register')); ?>

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
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/auth/login.blade.php ENDPATH**/ ?>