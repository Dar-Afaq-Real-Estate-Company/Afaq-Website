<?php $__env->startSection('content'); ?>

<div class="container-fluid mt--7">

    <!-- هيدر التنبيهات -->
    <div class="row justify-content-center mb-5" style="margin-top:120px;">
        <div class="col-12">
            <div class="text-center py-5">
                <h1 class="fw-bold mb-0 display-2" style="color:#0A2540;">
                    <?php echo e(trans('main.notifications')); ?>

                </h1>
            </div>
        </div>
    </div>

    <!-- قائمة الإشعارات -->
    <div class="row justify-content-center mb-5 notifications-container">
        <div class="col-12 col-xl-10">

            <?php if(session('status')): ?>
                <div class="alert alert-success alert-dismissible fade show">
                    <?php echo e(session('status')); ?>

                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
            <?php endif; ?>

            <?php if($notifications->isEmpty()): ?>
                <p class="text-center text-muted fs-5">
                    <?php echo e(trans('main.notifications')); ?>

                </p>
            <?php else: ?>
                <div class="row g-4">

                    <?php $__currentLoopData = $notifications; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $notification): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <div class="col-12">
                            <div class="card notification-card shadow-lg rounded p-4 h-100">
                                
                                <!-- رأس البطاقة: Subject + تاريخ -->
                                <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-bell text-warning fs-3"></i>
                                        <h4 class="fw-bold mb-0 fs-2">
                                            <?php echo e($notification->Message); ?>

                                        </h4>
                                    </div>
                                    <small class="text-muted fs-6"><?php echo e($notification->created_at->diffForHumans()); ?></small>
                                </div>

                                <!-- محتوى الرسالة -->
                                <div class="notification-content fs-5">
                                    <p><strong><?php echo e(trans('main.Message')); ?>:</strong> <?php echo e($notification->Subject); ?></p>
                                </div>

                                <!-- علامة جديد -->
                               
                            </div>
                        </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                </div>
            <?php endif; ?>

        </div>
    </div>

</div>

<style>
/* الهيدر */
.card-header.text-center h1 {
    color: #0A2540;
}

/* تصميم بطاقات الإشعارات */
.notification-card {
    background: #ffffff;
    border-left: 6px solid #0A2540;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    transition: transform 0.3s, box-shadow 0.3s, border-left-color 0.3s;
    cursor: pointer;
    padding: 3rem;
    border-radius: 15px;
}

.notification-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 20px 40px rgba(0,0,0,0.25);
    border-left-color: #d4af37;
}

.notification-card h4 {
    font-size: 2rem;
    color: #0A2540;
}

.notification-card .notification-content p {
    font-size: 1.15rem;
    color: #333;
    margin-bottom: 0;
}

.notification-card .badge {
    font-size: 15px;
    padding: 8px 16px;
    border-radius: 12px;
}

/* أيقونة التنبيه */
.notification-card i.fa-bell {
    color: #f0ad4e;
}

/* إضافة مسافة أسفل الإشعارات قبل الفوتر */
.notifications-container {
    padding-bottom: 100px;
}

/* استجابة البطاقات للشاشات الصغيرة */
@media(max-width:1200px){
    .notification-card {
        padding: 2.5rem;
    }
}

@media(max-width:768px){
    .notification-card {
        padding: 2rem;
        width: 100%;
    }

    .notification-card h4 {
        font-size: 1.75rem;
    }

    .notification-card .notification-content p {
        font-size: 1rem;
    }
}
</style>

<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', ['title' => __('Notifications | التنبيهات')], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/page/notifications.blade.php ENDPATH**/ ?>