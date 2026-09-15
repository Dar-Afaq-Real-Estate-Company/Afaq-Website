

<?php $__env->startSection('content'); ?>
<main class="pt-5 mt-5">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="card shadow-lg border-0 rounded-4 p-4 fancy-card">
                <div class="text-center mb-4">
                    <h3 class="fw-bold text-white">
                        تفعيل البريد الإلكتروني
                    </h3>

                    <p class="text-white-50">
                        تم إرسال رابط التفعيل إلى بريدك الإلكتروني.
                        يرجى فتح البريد والضغط على رابط التفعيل لإكمال إنشاء الحساب.
                    </p>
                </div>

                <?php if(session('message')): ?>
                    <div class="alert alert-success">
                        <?php echo e(session('message')); ?>

                    </div>
                <?php endif; ?>

                <div class="text-center">

                   <form method="POST" action="<?php echo e(route('verification.resend')); ?>">
                        <?php echo csrf_field(); ?>

                        <button type="submit"
                                class="btn fw-bold text-white px-5 py-2 rounded-3 shadow fancy-submit">
                            إعادة إرسال رابط التفعيل
                        </button>
                    </form>

                </div>

            </div>

        </div>
    </div>
</div>
</main>

<style>
.fancy-card {
    background: linear-gradient(145deg, #0f4051, #ffffff);
    box-shadow: 0 25px 60px rgba(15,64,81,0.4);
    border-radius: 20px;
    color: #fff;
}

.fancy-submit {
    background: linear-gradient(135deg, #0f4051, #2c6b85);
}
</style>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/auth/verify.blade.php ENDPATH**/ ?>