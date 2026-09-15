<?php $__env->startSection('content'); ?>
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700;900&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>

<style>
    :root {
        --primary-color: #0a2d39;
        --accent-color: #cba135;
        --danger-color: #d63031;
        --bg-gray: #f4f7f6;
        --safe-green: #27ae60;
    }

    body { 
        font-family: 'Tajawal', sans-serif; 
        direction: <?php echo e(app()->getLocale() == 'ar' ? 'rtl' : 'ltr'); ?>; 
        background: var(--bg-gray); 
        color: #2d3436; 
        text-align: <?php echo e(app()->getLocale() == 'ar' ? 'right' : 'left'); ?>;
        margin: 0; /* إلغاء أي هوامش افتراضية للجسم */
        padding: 0;
    }

    /* الحاوية تملأ الشاشة */
    .policy-wrapper { 
        width: 100%; 
        min-height: 100vh; 
        margin: 0; 
        padding: 0; 
    }
    
    .policy-card {
        background: #fff; 
        min-height: 100vh; /* تجعل البطاقة بطول الشاشة */
        border-radius: 0; /* إزالة الحواف الدائرية لتناسب ملء الشاشة */
        box-shadow: none; 
        border: none;
        display: flex;
        flex-direction: column;
    }

    .policy-header { 
        background: linear-gradient(135deg, var(--primary-color) 0%, #051920 100%); 
        padding: 80px 20px; 
        text-align: center; 
        color: #fff;
    }

    .policy-header h1 { font-weight: 900; font-size: 3rem; margin-bottom: 15px; }
    
    /* جعل المحتوى في المنتصف مع عرض كبير */
    .content-area { 
        padding: 60px; 
        max-width: 1200px; /* جعل النص مريحاً للقراءة في المنتصف */
        margin: 0 auto; 
        flex-grow: 1; /* يدفع الفوتر للأسفل */
        width: 100%;
    }
    
    .section-box { margin-bottom: 50px; }
    
    .title-row { 
        display: flex; align-items: center; gap: 15px; margin-bottom: 20px; 
        padding-bottom: 10px; border-bottom: 2px solid var(--accent-color);
        width: fit-content;
    }
    
    .title-row i { color: var(--accent-color); font-size: 1.8rem; }
    .title-row h2 { margin: 0; font-weight: 900; font-size: 1.8rem; color: var(--primary-color); }

    .text-content { line-height: 2; font-size: 1.2rem; color: #2d3436; }

    .sub-title { font-weight: 700; color: var(--primary-color); margin-bottom: 10px; display: block; font-size: 1.3rem; }

    .deletion-notice {
        background: #fff5f5; border-radius: 20px; border: 1px solid #feb2b2;
        padding: 35px; margin-top: 30px;
    }

    .security-highlight {
        background: #f0fff4; border: 1px solid #c6f6d5; border-radius: 20px;
        padding: 35px;
    }

    ul { padding-inline-start: 35px; list-style-type: square; }
    ul li { margin-bottom: 15px; }

    /* للهواتف */
    @media (max-width: 768px) {
        .content-area { padding: 30px 20px; }
        .policy-header h1 { font-size: 2rem; }
        .title-row h2 { font-size: 1.4rem; }
    }
</style>

<div class="policy-wrapper">
    <div class="policy-card">
        <div class="policy-header">
            <h1><?php echo e(__('main.privacy_policy_title')); ?></h1>
            <p style="font-size: 1.3rem; opacity: 0.9;"><?php echo e(__('main.dar_afaq_real_estate')); ?></p>
        </div>

        <div class="content-area">
            
            <div class="section-box">
                <div class="title-row">
                    <i class="fas fa-database"></i>
                    <h2><?php echo e(__('main.data_collection_title')); ?></h2>
                </div>
                <div class="text-content">
                    <span class="sub-title"><?php echo e(__('main.data_collection_subtitle')); ?></span>
                    <?php echo e(__('main.data_collection_desc')); ?>

                    <ul>
                        <li><strong><?php echo e(__('main.user_info_label')); ?></strong> <?php echo e(__('main.user_info_detail')); ?></li>
                        <li><strong><?php echo e(__('main.device_data_label')); ?></strong> <?php echo e(__('main.device_data_detail')); ?></li>
                        <li><strong><?php echo e(__('main.user_activity_label')); ?></strong> <?php echo e(__('main.user_activity_detail')); ?></li>
                    </ul>
                </div>
            </div>

            <div class="section-box">
                <div class="title-row">
                    <i class="fas fa-cogs"></i>
                    <h2><?php echo e(__('main.data_usage_title')); ?></h2>
                </div>
                <div class="text-content">
                    <?php echo e(__('main.data_usage_desc')); ?>

                </div>
            </div>

            <div class="section-box">
                <div class="title-row">
                    <i class="fas fa-share-alt"></i>
                    <h2><?php echo e(__('main.data_sharing_title')); ?></h2>
                </div>
                <div class="text-content">
                    <?php echo e(__('main.data_sharing_desc')); ?>

                </div>
            </div>

            <div class="section-box security-highlight">
                <div class="title-row" style="border-bottom-color: var(--safe-green);">
                    <i class="fas fa-shield-check" style="color: var(--safe-green);"></i>
                    <h2 style="color: var(--safe-green);"><?php echo e(__('main.data_security_title')); ?></h2>
                </div>
                <div class="text-content">
                    <?php echo e(__('main.data_security_desc')); ?>

                </div>
            </div>

            <div class="section-box deletion-notice">
                <div class="title-row" style="border-bottom-color: var(--danger-color);">
                    <i class="fas fa-user-times" style="color: var(--danger-color);"></i>
                    <h2 style="color: var(--danger-color);"><?php echo e(__('main.user_rights_title')); ?></h2>
                </div>
                <div class="text-content">
                    <?php echo e(__('main.user_rights_desc')); ?>

                </div>
            </div>

        </div>

      
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/page/privacypolicy.blade.php ENDPATH**/ ?>