<!DOCTYPE html>
<html lang="<?php echo e(str_replace('_', '-', app()->getLocale())); ?>" dir="<?php echo e(LaravelLocalization::getCurrentLocaleDirection()); ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSRF Token -->
    <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">

    <title><?php echo e(app()->getLocale() == 'ar' ? 'آفاق العقارية' : 'AFAQ Real Estate'); ?></title>
    
    <!--  <link href="/image/afaq.jpeg "rel="icon" calt="Logo" class="logo-professional" type="image/png"> -->
    <link rel="icon" type="image/jpeg" href="<?php echo e(asset('image/afaq.jpeg')); ?>?v=2">
   
<link href="https://cdn.datatables.net/2.3.4/css/dataTables.dataTables.css" rel="stylesheet">
<link href="https://cdn.datatables.net/searchpanes/2.3.5/css/searchPanes.dataTables.css" rel="stylesheet">
<link href="https://cdn.datatables.net/select/3.1.3/css/select.dataTables.css" rel="stylesheet">
    <!-- Fonts -->
    <link rel="dns-prefetch" href="//fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=Nunito" rel="stylesheet">

    
    <!-- Scripts -->
       <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;600;700&display=swap" rel="stylesheet">
<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

</head>
<body>
    <div id="app">
        
                        <!-- Authentication Links -->
                        <?php if(auth()->guard()->guest()): ?>
                        <main>
                             <?php echo $__env->make('layouts.guest', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                             <?php echo $__env->yieldContent('content'); ?>
                             <?php echo $__env->make('layouts.footer', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </main>
                     <?php endif; ?>              
                           <?php if(auth()->guard()->check()): ?>
                                <main >
                            <?php echo $__env->make('layouts.navbar', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            <?php echo $__env->yieldContent('content'); ?>
                            <?php echo $__env->make('layouts.footer', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                </main>
                            <?php endif; ?>      
                

        
    </div>
</body>
</html>
<?php /**PATH /home/frudlhds/public_html/resources/views/layouts/app.blade.php ENDPATH**/ ?>