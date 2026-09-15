<?php $__env->startSection('content'); ?>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">

<style>
/* المتغيرات الأساسية */
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
    margin-bottom: 20px;
}

.custom-label {
    color: var(--brand-teal);
    font-weight: 800;
    font-size: 1.1rem;
    margin-bottom: 8px;
    display: block;
}

.custom-input {
    width: 100%;
    padding: 12px 18px;
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
    margin-top: 15px;
}

.login-btn-fakhim:hover {
    background-color: var(--brand-gold);
    border-color: var(--brand-gold);
    transform: translateY(-3px);
}

/* =========================
   الروابط
========================= */
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










.phone-wrapper{
    display:flex;
    gap:12px;
}

.country-box{
    width:180px;
}

.phone-box{
    flex:1;
}

.country-select{
    width:100%;
    height:100%;
    padding:12px 18px;
    border:2px solid var(--border-color);
    border-radius:12px;
    font-weight:700;
    font-size:1rem;
    color:var(--brand-teal);
    background:#fff;
    cursor:pointer;
    transition:.3s;
}

.country-select:focus{
    border-color:var(--brand-teal);
    outline:none;
    box-shadow:0 0 10px rgba(15,64,81,.1);
}

@media(max-width:768px){

    .phone-wrapper{
        flex-direction:column;
    }

    .country-box{
        width:100%;
    }

}
















</style>

<main class="login-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-6 col-lg-7 col-md-10 px-4">

                <div class="login-card text-center">
                    <div class="login-header mb-4">
                        <h3><?php echo e(trans('auth.Register')); ?></h3>
                        <div class="gold-line"></div>
                        <p class="text-muted fw-bold small"><?php echo e(trans('auth.Enter your data to create a new account')); ?></p>
                    </div>

                    <form method="POST" action="<?php echo e(route('register')); ?>" class="text-start">
                        <?php echo csrf_field(); ?>

                        <div class="row">
                            <div class="col-md-6 form-group-custom">
                                <label class="custom-label"><?php echo e(trans('auth.first_name')); ?></label>
                                <input type="text" name="name" class="custom-input <?php $__errorArgs = ['name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" value="<?php echo e(old('name')); ?>" required autofocus>
                                <?php $__errorArgs = ['name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> <span class="invalid-feedback"><strong><?php echo e($message); ?></strong></span> <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>

                            <div class="col-md-6 form-group-custom">
                                <label class="custom-label"><?php echo e(trans('auth.last_name')); ?></label>
                                <input type="text" name="last_name" class="custom-input <?php $__errorArgs = ['last_name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" value="<?php echo e(old('last_name')); ?>" required>
                                <?php $__errorArgs = ['last_name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> <span class="invalid-feedback"><strong><?php echo e($message); ?></strong></span> <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>
                        </div>

                        <div class="form-group-custom">
                            <label class="custom-label"><?php echo e(trans('auth.Email')); ?></label>
                            <input type="email" name="email" class="custom-input <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" value="<?php echo e(old('email')); ?>" required>
                            <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> <span class="invalid-feedback"><strong><?php echo e($message); ?></strong></span> <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                        </div>

<div class="form-group-custom">
    <label class="custom-label"><?php echo e(trans('auth.phone')); ?></label>

    <div class="phone-wrapper">

        <!-- الدولة -->
        <div class="country-box">
            <select name="country_code" class="country-select">
                <option value="+965" selected>الكويت +965</option>
                <option value="+966">السعودية +966</option>
                <option value="+971">الإمارات +971</option>
                <option value="+973">البحرين +973</option>
                <option value="+974">قطر +974</option>
                <option value="+968">عمان +968</option>
                <option value="+967">اليمن +967</option>
                <option value="+20">مصر +20</option>
                <option value="+962">الأردن +962</option>
                <option value="+961">لبنان +961</option>
                <option value="+963">سوريا +963</option>
                <option value="+964">العراق +964</option>
                <option value="+218">ليبيا +218</option>
                <option value="+212">المغرب +212</option>
                <option value="+213">الجزائر +213</option>
                <option value="+216">تونس +216</option>
                <option value="+249">السودان +249</option>
            </select>
        </div>

        <!-- رقم الهاتف -->
        <div class="phone-box">
            <input
                type="text"
                name="phone"
                class="custom-input <?php $__errorArgs = ['phone'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                value="<?php echo e(old('phone')); ?>"
                placeholder="55525030"
                required>
        </div>

    </div>

    <?php $__errorArgs = ['phone'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
        <span class="invalid-feedback d-block">
            <strong><?php echo e($message); ?></strong>
        </span>
    <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
</div>

                        <div class="row">
                            <div class="col-md-6 form-group-custom">
                                <label class="custom-label"><?php echo e(trans('auth.password')); ?></label>
                                <div class="pass-wrapper">
                                    <input type="password" id="password" name="password" class="custom-input <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" required>
                                    <span class="eye-icon" data-target="password">
                                        <i class="fa-solid fa-eye"></i>
                                    </span>
                                </div>
                                <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> <span class="invalid-feedback"><strong><?php echo e($message); ?></strong></span> <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>

                            <div class="col-md-6 form-group-custom">
                                <label class="custom-label"><?php echo e(trans('auth.password_confirmation')); ?></label>
                                <div class="pass-wrapper">
                                    <input type="password" id="password_confirmation" name="password_confirmation" class="custom-input" required>
                                    <span class="eye-icon" data-target="password_confirmation">
                                        <i class="fa-solid fa-eye"></i>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="login-btn-fakhim shadow-sm">
                            <?php echo e(trans('auth.Register')); ?>

                        </button>

                        <div class="footer-links text-center mt-4">
                            <p class="text-muted fw-bold">
                                <?php echo e(__('auth.already_have_account')); ?> 
                                <a href="<?php echo e(route('login')); ?>" class="ms-1">
                                    <?php echo e(__('auth.Login')); ?>

                                </a>
                            </p>
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
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/auth/register.blade.php ENDPATH**/ ?>