<?php $__env->startSection('content'); ?>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.2/src/regular/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.2/src/bold/style.css">

<style>
:root {
    --primary: #0d1b4c;
    --secondary: #0057ff;
    --accent: #ff7b00;
    --green: #00a859;
    --bg: #f5f7fb;
    --basic-bg: #e8f0fe;
    --extra-bg: #e6f9eb;
    --super-bg: #fff7e6;
    --premium-bg: #fce8f3;
    --vip-bg: #fef3e6;
}

/* Body & Base */
body {
    font-family: 'Tajawal', sans-serif;
    background-color: var(--bg);
    margin: 0;
    color: var(--primary);
}

/* Header */
.header {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    padding: 1rem 1.4rem;
    font-weight: 700;
    font-size: 1.2rem;
    background: #fff;
    box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    position: sticky;
    top: 0;
    z-index: 100;
}

/* Close button */
.close {
    font-size: 1.6rem;
    color: var(--primary);
    text-decoration: none;
    font-weight: bold;
    transition: 0.2s;
}
.close:hover { transform: scale(1.2); color: var(--accent); }

/* Page title card */
.page-title-card {
    max-width: 600px;
    margin: 4rem auto;
   
    padding: 1rem 2rem;
    border-radius: 16px;
    text-align: center;
    font-size: 1.6rem;
    font-weight: 700;
    color: var(--primary);
    
}

/* Container & Plans */
.container {
    padding: 1rem;
    max-width: 1000px;
    margin: auto;
    display: grid;
    grid-template-columns: repeat(4, 1fr); /* أربعة أقسام في صف واحد */
    gap: 1rem;
}

.plan {
    border-radius: 16px;
    padding: 1.2rem 1rem;
    border: 1px solid #e3e6ed;
    box-shadow: 0 6px 16px rgba(0,0,0,0.08);
    position: relative;
    transition: transform 0.2s ease, box-shadow 0.3s ease;
    cursor: pointer;
    display: block;
    width: 100%;
    box-sizing: border-box;
}
.plan.basic { background-color: var(--basic-bg); }
.plan.extra { background-color: var(--extra-bg); }
.plan.super { background-color: var(--super-bg); }
.plan.premium { background-color: var(--premium-bg); }
.plan.vip { background-color: var(--vip-bg); }

.plan h3::before {
    content: attr(data-icon);
    display: block;
    font-size: 1.6rem;
    margin-bottom: 0.3rem;
    text-align: center;
}
.plan .icon {
    font-size: 32px;
    margin-bottom: 4px;
    color: var(--primary);
    display: block;
}
.plan:hover { transform: translateY(-3px); box-shadow: 0 8px 18px rgba(0,0,0,0.12); }
.plan h3 { margin: 0.2rem 0 0.5rem; font-weight: 700; color: var(--primary); font-size: 1.1rem; }
.plan .price { font-size: 1.4rem; font-weight: 700; color: var(--secondary); }

.tag {
    position: absolute;
    top: -10px;
    right: 12px;
    background: var(--accent);
    color: #fff;
    padding: 4px 10px;
    border-radius: 14px;
    font-size: 0.75rem;
    font-weight: 600;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

/* Features list */
.features {
    margin-top: 0.6rem;
    font-size: 0.85rem;
    padding: 0;
}
.features li {
    list-style: none;
    margin: .3rem 0;
    display: flex;
    align-items: center;
    color: #333;
}
.features li::before {
    content: "•";
    color: var(--accent);
    margin-left: 8px;
    font-weight: bold;
}

/* Meter & Discount */
.meter {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: .6rem 0;
    background: #eefcf3;
    border-radius: 10px;
    padding: 0.4rem 0.6rem;
    font-size: 0.8rem;
    color: var(--green);
    font-weight: 600;
}
.discount {
    background: linear-gradient(90deg, #e6f9eb, #f4fff8);
    border-radius: 10px;
    padding: .5rem;
    margin: .5rem 0;
    font-size: 0.85rem;
    color: var(--green);
    font-weight: 600;
    border: 1px dashed #b6e7c6;
}

input[type="radio"] { position: absolute; top: 18px; left: 16px; transform: scale(1.2); accent-color: var(--secondary); }

/* Open modal button */
#openModal {
    grid-column: 1/-1;
    margin-top: 0.8rem;
    padding: 0.8rem 1.5rem;
    background: var(--secondary);
    color: #fff;
    border: none;
    border-radius: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.3s;
}
#openModal:hover { background: var(--accent); }

/* Old Payment box */
.old-payment {
    grid-column: 1/-1;
    text-align: center;
    background: #fff;
    border-radius: 16px;
    padding: 1rem 1rem;
    border: 1px solid #e0e0e0;
    box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}
.old-payment a {
    display: inline-block;
    border: 2px solid var(--secondary);
    color: var(--secondary);
    padding: .6rem 1.2rem;
    border-radius: 12px;
    text-decoration: none;
    font-weight: 700;
    transition: 0.25s;
}
.old-payment a:hover { background: var(--secondary); color: #fff; }

/* Modal */
.modal-bg {
    display: none;
    position: fixed;
    z-index: 200;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.55);
    backdrop-filter: blur(4px);
}
.modal-content {
    background-color: #fff;
    margin: 6% auto;
    padding: 1.5rem 2rem;
    border-radius: 18px;
    max-width: 450px;
    width: 90%;
    position: relative;
    box-shadow: 0 10px 30px rgba(0,0,0,0.25);
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
}
.modal-close {
    position: absolute;
    top: 10px;
    right: 12px;
    font-size: 1.4rem;
    font-weight: bold;
    color: #333;
    cursor: pointer;
    transition: 0.25s;
}
.modal-close:hover { color: var(--accent); transform: scale(1.2); }
.modal-content h2 { margin-bottom: 0.8rem; color: var(--primary); text-align: center; font-size: 1.2rem; }

/* Modal inputs */
.modal-content input,
.modal-content select,
.modal-content textarea {
    width: 100%;
    padding: 0.8rem 1rem;
    margin: 0.3rem 0 0.8rem 0;
    border-radius: 12px;
    border: 1px solid #d1d5db;
    font-size: 0.95rem;
    background: #f8f9fb;
    box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
    transition: 0.2s ease, transform 0.2s ease;
}
.modal-content input:focus,
.modal-content textarea:focus,
.modal-content select:focus {
    border-color: var(--secondary);
    outline: none;
    transform: scale(1.02);
    background: #fff;
}

/* Modal button */
.modal-content button {
    background: linear-gradient(135deg, var(--secondary), var(--accent));
    color: #fff;
    padding: 0.7rem 1.2rem;
    border: none;
    border-radius: 14px;
    font-weight: 700;
    font-size: 1rem;
    cursor: pointer;
    transition: 0.3s ease;
    align-self: center;
    width: 80%;
}
.modal-content button:hover { background: var(--accent); transform: scale(1.05); }

/* Selected Plan Box */
.selected-plan {
    background: linear-gradient(135deg, #e6f0ff, #f0f7ff);
    padding: 0.8rem;
    border-radius: 14px;
    margin-bottom: 1rem;
    font-weight: 700;
    display: flex;
    justify-content: space-between;
    box-shadow: inset 0 2px 6px rgba(0,0,0,0.05);
}

/* Preview container */
.preview-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(70px, 1fr));
    gap: 0.6rem;
    margin-bottom: 0.8rem;
}
.preview-container img,
.preview-container video {
    width: 100%;
    height: 80px;
    object-fit: cover;
    border-radius: 10px;
    border: 1px solid #d1d5db;
}

/* Dropzone */
.dropzone {
    width: 100%;
    padding: 0.8rem;
    border: 2px dashed #d1d5db;
    border-radius: 10px;
    text-align: center;
    cursor: pointer;
    background: #f8f9fb;
    color: #555;
    transition: 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    font-weight: 600;
}
.dropzone.dragover { background: #e0f0ff; border-color: var(--secondary); color: var(--primary); }

/* Responsive */
@media (max-width: 600px) {
    .container { grid-template-columns: repeat(2, 1fr); gap: 0.5rem; }
    .plan { padding: 1rem; border-radius: 12px; }
    .plan h3 { font-size: 1rem; }
    .plan .price { font-size: 1.2rem; }
    .modal-content { padding: 1rem 1.2rem; width: 90%; margin: 12% auto; } /* نزول المودال أسفل قليلاً */
    .modal-content h2 { font-size: 1.1rem; }
    .modal-content button { width: 100%; padding: 0.6rem 1rem; font-size: 0.95rem; }
}

@media (max-width: 400px) {
    .container { grid-template-columns: repeat(2, 1fr); gap: 0.4rem; }
    .plan h3 { font-size: 0.95rem; }
    .plan .price { font-size: 1.1rem; }
    .preview-container img,
    .preview-container video { height: 70px; }
    .modal-content { margin: 20% auto; } /* أسفل أكثر على أصغر الشاشات */
}

/* ALERT BOX - يظهر فقط عند عدم اختيار الباقة */
.alert-box {
    display: none; /* مخفي افتراضياً */
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: #ff4d4d;
    color: #fff;
    padding: 14px 28px;
    border-radius: 14px;
    font-weight: 700;
    font-size: 1rem;
    box-shadow: 0 6px 16px rgba(0,0,0,0.25);
    z-index: 1000;
    text-align: center;
}
.alert-box.show { display: block; }
.plan .price {
    display: none;
}

#selectedPlanDisplay span:nth-child(2) {
    display: none; /* إخفاء السعر */
}


</style>

<div class="page-title-card"><?php echo e(trans('main.Choose_one_of_the_suggested_packages')); ?></div>

<label style="font-size:20px; font-weight:700; color:#0A2540; display:block; text-align:center; margin-bottom:10px;">
    <?php echo e(trans('main.Transaction_Sections')); ?>

</label>
<?php if($errors->has('error')): ?>
    <div class="alert alert-danger"><?php echo e($errors->first('error')); ?></div>
<?php endif; ?>

<div class="container transaction-types" style="margin-top: -10px; margin-bottom: 20px;">

    <label class="plan basic">
        <input type="radio" name="transaction_type" value="عقارات للبيع">
        <i class="fa-solid fa-hand-holding-dollar icon"></i>
        <h3><?php echo e(trans('main.For_Sale_Property')); ?></h3>
    </label>

    <label class="plan extra">
        <input type="radio" name="transaction_type" value="عقارات للإيجار">
        <i class="fa-solid fa-key icon"></i>
        <h3><?php echo e(trans('main.For_Rent_Property')); ?></h3>
    </label>

    <label class="plan super">
        <input type="radio" name="transaction_type" value="عقارات للإيجار">
        <i class="fa-solid fa-repeat icon"></i>
        <h3><?php echo e(trans('main.Exchange')); ?></h3>
    </label>

    <label class="plan vip">
        <input type="radio" name="transaction_type" value="عقارات للإيجار">
        <i class="fa-solid fa-globe icon"></i>
        <h3><?php echo e(trans('main.International_Property')); ?></h3>
    </label>

    <label class="plan basic">
        <input type="radio" name="transaction_type" value="مكاتب عقارية">
        <i class="fa-solid fa-building icon"></i>
        <h3><?php echo e(trans('main.Real_Estate_Office')); ?></h3>
    </label>

    

    <label class="plan super">
        <input type="radio" name="transaction_type" value="مقاولون">
        <i class="fa-solid fa-hammer icon"></i>
        <h3><?php echo e(trans('main.Contractors')); ?></h3>
    </label>

    <label class="plan premium">
        <input type="radio" name="transaction_type" value="مكاتب هندسية">
        <i class="fa-solid fa-drafting-compass icon"></i>
        <h3><?php echo e(trans('main.Engineering_Offices')); ?></h3>
    </label>

    <label class="plan vip">
        <input type="radio" name="transaction_type" value="مزاد">
        <i class="fa-solid fa-gavel icon"></i>
        <h3><?php echo e(trans('main.Auction')); ?></h3>
    </label>

</div>

<style>
.transaction-types {
    display: grid;
    grid-template-columns: repeat(4, 1fr); /* 4 أعمدة للشاشة الكبيرة */
    gap: 10px;
}

.plan {
    background: #fff;
    border-radius: 10px;
    padding: 10px 5px;
    text-align: center;
    cursor: pointer;
    border: 2px solid transparent;
    transition: 0.3s;
}

.plan .icon {
    font-size: 22px;
    margin-bottom: 5px;
    display: block;
    color: #000;
}

.plan h3 {
    font-size: 13px;
    margin: 0;
}

.plan input[type="radio"]:checked + .icon,
.plan input[type="radio"]:checked + h3 {
    color: #007bff;
}

.plan input {
    display: none;
}

/* Responsive for smaller screens */
@media (max-width: 768px) { /* جهاز لوحي / شاشة صغيرة */
    .transaction-types {
        grid-template-columns: repeat(4, 1fr);
    }
    .plan .icon {
        font-size: 18px;
    }
    .plan h3 {
        font-size: 12px;
    }
}

@media (max-width: 480px) { /* موبايل */
    .transaction-types {
        grid-template-columns: repeat(4, 1fr);
        gap: 5px;
    }
    .plan {
        padding: 5px 2px;
    }
    .plan .icon {
        font-size: 16px;
        margin-bottom: 3px;
    }
    .plan h3 {
        font-size: 10px;
    }
}
</style>



<div class="old-payment">
      <button id="openModal"><?php echo e(trans('main.Add_Ad')); ?></button>
    </div>
<!-- المودال -->
<div id="modal" class="modal-bg">
    <div class="modal-content">
        <span class="modal-close" id="closeModal">&times;</span>
        <h2><?php echo e(trans('main.Add_Ad')); ?></h2>

       <form action="<?php echo e(route('advertisement.stor')); ?>" method="POST" enctype="multipart/form-data">
    <?php echo csrf_field(); ?>

    
    <input type="hidden" name="selected_plan_name" value="الباقة الأساسية">
    <input type="hidden" name="selected_plan_price" value="0">
    <input type="hidden" name="auction_date" value="<?php echo e(now()->addDays(30)->format('Y-m-d')); ?>">

    
    <div class="selected-plan">
        <span><?php echo e(trans('main.Selected_Plan')); ?>:</span>
        <strong><?php echo e(trans('main.Basic')); ?></strong>
    </div>



            <div class="selected-transaction-box" id="selectedTransactionDisplay">
                <i class="ph-check-circle"></i>
                <span><?php echo e(trans('main.Selected_Section')); ?>: <strong id="selectedTransactionText">-</strong></span>
            </div>

            <input type="hidden" name="transaction_type" id="selectedTransactionInput" value="">

            <input type="hidden" name="title" id="title" required placeholder="<?php echo e(trans('main.Example_Title')); ?>">

            <label for="description"><?php echo e(trans('main.Ad_Description')); ?></label>
            <textarea name="description" id="description" rows="4" required placeholder="<?php echo e(trans('main.Property_Details')); ?>"></textarea>

            <label for="type"><?php echo e(trans('main.Property_Type')); ?></label>
           
<select name="type" id="section_type" required class="form-select">
 
    <option value=""><?php echo e(trans('main.Property_Type') ?? 'اختر القسم والنوع'); ?></option>
    <?php
        $sections = [
            [
                'icon'=>'fa-home',
                'types'=>[
                    ['icon'=>'fa-building','name'=>__('main.بيت للبيع')],
                    ['icon'=>'fa-home','name'=>__('main.دور')],
                    ['icon'=>'fa-door-closed','name'=>__('main.شقة مفروشة')],
                    ['icon'=>'fa-house-chimney','name'=>__('main.شقة دوبلكس')],
                    ['icon'=>'fa-store','name'=>__('main.محل للبيع')],
                    ['icon'=>'fa-warehouse','name'=>__('main.مخازن')],
                    ['icon'=>'fa-tractor','name'=>__('main.مزرعة')],
                    ['icon'=>'fa-industry','name'=>__('main.قسيمة صناعية')],
                    ['icon'=>'fa-campground','name'=>__('main.استراحة')],
                    ['icon'=>'fa-suitcase','name'=>__('main.شاليه')]
                ]
            ],
            [
                'icon'=>'fa-key',
                'types'=>[
                    ['icon'=>'fa-building','name'=>__('main.بيت للإيجار')],
                    ['icon'=>'fa-home','name'=>__('main.دور للإيجار')],
                    ['icon'=>'fa-door-closed','name'=>__('main.شقة مفروشة للإيجار')],
                    ['icon'=>'fa-house-chimney','name'=>__('main.شقة دوبلكس للإيجار')],
                    ['icon'=>'fa-store','name'=>__('main.محل للإيجار')],
                    ['icon'=>'fa-warehouse','name'=>__('main.مخازن للإيجار')],
                    ['icon'=>'fa-tractor','name'=>__('main.مزرعة للإيجار')],
                    ['icon'=>'fa-industry','name'=>__('main.قسيمة صناعية للإيجار')],
                    ['icon'=>'fa-campground','name'=>__('main.استراحة للإيجار')],
                    ['icon'=>'fa-suitcase','name'=>__('main.شاليه للإيجار')]
                ]
            ],
            [
                'icon'=>'fa-exchange-alt',
                'types'=>[
                    ['icon'=>'fa-building','name'=>__('main.تبادل بيت')],
                    ['icon'=>'fa-home','name'=>__('main.تبادل دور')],
                    ['icon'=>'fa-door-closed','name'=>__('main.تبادل شقة مفروشة')],
                    ['icon'=>'fa-house-chimney','name'=>__('main.تبادل دوبلكس')],
                ]
            ],
            [
                'icon'=>'fa-globe',
                'types'=>[
                    ['icon'=>'fa-building','name'=>__('main.عقارات في الإمارات')],
                    ['icon'=>'fa-building','name'=>__('main.عقارات في السعودية')],
                    ['icon'=>'fa-building','name'=>__('main.عقارات في قطر')],
                ]
            ],
            [
                'icon'=>'fa-building',
                'types'=>[
                    ['icon'=>'fa-building','name'=>__('main.مكاتب للإيجار')],
                    ['icon'=>'fa-cogs','name'=>__('main.مكاتب مجهزة')],
                    ['icon'=>'fa-door-open','name'=>__('main.مكاتب للاستثمار')]
                ]
            ],
            [
                'icon'=>'fa-cogs',
                'types'=>[
                    ['icon'=>'fa-building','name'=>__('main.إدارة عقارات سكنية')],
                    ['icon'=>'fa-store','name'=>__('main.إدارة محلات تجارية')],
                    ['icon'=>'fa-warehouse','name'=>__('main.إدارة مخازن')]
                ]
            ],
            [
                'icon'=>'fa-tools',
                'types'=>[
                    ['icon'=>'fa-tools','name'=>__('main.خدمات البناء')],
                    ['icon'=>'fa-paint-roller','name'=>__('main.خدمات التشطيب')],
                    ['icon'=>'fa-hard-hat','name'=>__('main.استشارات هندسية')]
                ]
            ],
            [
                'icon'=>'fa-drafting-compass',
                'types'=>[
                    ['icon'=>'fa-pencil-ruler','name'=>__('main.تصميم معماري')],
                    ['icon'=>'fa-ruler-combined','name'=>__('main.تصميم هندسي')],
                    ['icon'=>'fa-eye','name'=>__('main.إشراف ومتابعة')]
                ]
            ],
        ];
    ?>

    <?php $__currentLoopData = $sections; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $sec): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
        <?php $__currentLoopData = $sec['types']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $type): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <option value="<?php echo e($type['name']); ?>">
                <?php echo e($type['name']); ?>

            </option>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
</select>


            <label for="region"><?php echo e(trans('main.Region')); ?></label>
<select id="filterDistrict" name="region" required>
    <option value=""><?php echo e(trans('main.Region')); ?></option>

    <!-- Capital Governorate -->
    <optgroup label="<?php echo e(trans('main.Capital')); ?>">
        <option value="الشرق"><?php echo e(trans('main.Sharq')); ?></option>
        <option value="القبلة"><?php echo e(trans('main.Qibla')); ?></option>
        <option value="الصالحية"><?php echo e(trans('main.Salhiya')); ?></option>
        <option value="المرقاب"><?php echo e(trans('main.Mirqab')); ?></option>
        <option value="بنيد القار"><?php echo e(trans('main.Bneid Al Gar')); ?></option>
        <option value="الدسمة"><?php echo e(trans('main.Dasma')); ?></option>
        <option value="الدعية"><?php echo e(trans('main.Daiya')); ?></option>
        <option value="الشامية"><?php echo e(trans('main.Shamiya')); ?></option>
        <option value="الروضة"><?php echo e(trans('main.Rawdah')); ?></option>
        <option value="العديلية"><?php echo e(trans('main.Adailiya')); ?></option>
        <option value="الخالدية"><?php echo e(trans('main.Khaldiya')); ?></option>
        <option value="القادسية"><?php echo e(trans('main.Qadsiya')); ?></option>
        <option value="المنصورية"><?php echo e(trans('main.Mansouriya')); ?></option>
        <option value="النزهة"><?php echo e(trans('main.Nuzha')); ?></option>
        <option value="قرطبة"><?php echo e(trans('main.Qurtuba')); ?></option>
        <option value="اليرموك"><?php echo e(trans('main.Yarmouk')); ?></option>
        <option value="الصليبخات"><?php echo e(trans('main.Sulaibikhat')); ?></option>
        <option value="الدوحة"><?php echo e(trans('main.Doha')); ?></option>
        <option value="غرناطة"><?php echo e(trans('main.Granada')); ?></option>
    </optgroup>

    <!-- Hawalli Governorate -->
    <optgroup label="<?php echo e(trans('main.Hawalli')); ?>">
        <option value="حولي"><?php echo e(trans('main.Hawalli')); ?></option>
        <option value="السالمية"><?php echo e(trans('main.Salmiya')); ?></option>
        <option value="البيان"><?php echo e(trans('main.Bayan')); ?></option>
        <option value="مشرف"><?php echo e(trans('main.Mishref')); ?></option>
        <option value="سلوى"><?php echo e(trans('main.Salwa')); ?></option>
        <option value="الرميثية"><?php echo e(trans('main.Rumaithiya')); ?></option>
        <option value="الجابرية"><?php echo e(trans('main.Jabriya')); ?></option>
        <option value="النقره"><?php echo e(trans('main.Al Nugra')); ?></option>
        <option value="ميدان حولي"><?php echo e(trans('main.Maidan Hawalli')); ?></option>
        <option value="الشعب"><?php echo e(trans('main.Shaab')); ?></option>
        <option value="الشهداء"><?php echo e(trans('main.Shuhada')); ?></option>
    </optgroup>

    <!-- Farwaniya Governorate -->
    <optgroup label="<?php echo e(trans('main.Farwaniya')); ?>">
        <option value="الفروانية"><?php echo e(trans('main.Farwaniya')); ?></option>
        <option value="خيطان"><?php echo e(trans('main.Khaitan')); ?></option>
        <option value="الأندلس"><?php echo e(trans('main.Andalous')); ?></option>
        <option value="الرقعي"><?php echo e(trans('main.Riqai')); ?></option>
        <option value="العارضية"><?php echo e(trans('main.Ardiya')); ?></option>
        <option value="العمرية"><?php echo e(trans('main.Omariya')); ?></option>
        <option value="الرابية"><?php echo e(trans('main.Rabiya')); ?></option>
        <option value="جليب الشيوخ"><?php echo e(trans('main.Jleeb Al Shuyoukh')); ?></option>
        <option value="اشبيلية"><?php echo e(trans('main.Ishbiliya')); ?></option>
        <option value="السغر"><?php echo e(trans('main.Sughar')); ?></option>
    </optgroup>

    <!-- Ahmadi Governorate -->
    <optgroup label="<?php echo e(trans('main.Ahmadi')); ?>">
        <option value="الأحمدي"><?php echo e(trans('main.Ahmadi')); ?></option>
        <option value="الفحيحيل"><?php echo e(trans('main.Fahaheel')); ?></option>
        <option value="المنقف"><?php echo e(trans('main.Mangaf')); ?></option>
        <option value="الفنطاس"><?php echo e(trans('main.Fintas')); ?></option>
        <option value="أبو حليفة"><?php echo e(trans('main.Abu Hulaifa')); ?></option>
        <option value="هدية"><?php echo e(trans('main.Hadiya')); ?></option>
        <option value="الصباحية"><?php echo e(trans('main.Sabahiya')); ?></option>
        <option value="الرقة"><?php echo e(trans('main.Riqqa')); ?></option>
        <option value="جابر العلي"><?php echo e(trans('main.Jaber Al Ali')); ?></option>
        <option value="المقوع"><?php echo e(trans('main.Maqwa')); ?></option>
        <option value="الأحمدي الجديدة"><?php echo e(trans('main.New Ahmadi')); ?></option>
        <option value="أم الهيمان"><?php echo e(trans('main.Um Al Haiman')); ?></option>
        <option value="الوفرة"><?php echo e(trans('main.Wafra')); ?></option>
        <option value="الخيران"><?php echo e(trans('main.Khairan')); ?></option>
        <option value="النويصب"><?php echo e(trans('main.Nwaiseeb')); ?></option>
        <option value="الزور"><?php echo e(trans('main.Zur')); ?></option>
    </optgroup>

    <!-- Jahra Governorate -->
    <optgroup label="<?php echo e(trans('main.Jahra')); ?>">
        <option value="الجهراء"><?php echo e(trans('main.Jahra')); ?></option>
        <option value="القصر"><?php echo e(trans('main.Qasr')); ?></option>
        <option value="تيماء"><?php echo e(trans('main.Tima')); ?></option>
        <option value="العيون"><?php echo e(trans('main.Ayyoun')); ?></option>
        <option value="النسيم"><?php echo e(trans('main.Naseem')); ?></option>
        <option value="الصليبية"><?php echo e(trans('main.Sulaibiya')); ?></option>
        <option value="أمغرة"><?php echo e(trans('main.Amghara')); ?></option>
        <option value="كبد"><?php echo e(trans('main.Kabd')); ?></option>
        <option value="المطلاع"><?php echo e(trans('main.Mutlaa')); ?></option>
        <option value="الواحة"><?php echo e(trans('main.Waha')); ?></option>
    </optgroup>

    <!-- Mubarak Al Kabeer Governorate -->
    <optgroup label="<?php echo e(trans('main.Mubarak Al Kabeer')); ?>">
        <option value="مبارك الكبير"><?php echo e(trans('main.Mubarak Al Kabeer')); ?></option>
        <option value="العدان"><?php echo e(trans('main.Adan')); ?></option>
        <option value="القصور"><?php echo e(trans('main.Qusour')); ?></option>
        <option value="القرين"><?php echo e(trans('main.Qurain')); ?></option>
        <option value="أبو فطيرة"><?php echo e(trans('main.Abu Fatira')); ?></option>
        <option value="الفنيطيس"><?php echo e(trans('main.Funaitees')); ?></option>
        <option value="صبحان"><?php echo e(trans('main.Sabhan')); ?></option>
    </optgroup>
</select>


            <label for="price"><?php echo e(trans('main.Price')); ?> </label>
            <input type="number" name="price" id="price" min="1" placeholder="<?php echo e(trans('main.Price')); ?>" required>

            <label><?php echo e(trans('main.Upload_Images')); ?></label>
            <div id="imageDropzone" class="dropzone"><i class="ph-image"></i> <?php echo e(trans('main.Drag_Images_Here')); ?></div>
            <input type="file" name="images" id="imageInput" multiple accept="image/*" style="display:none;" required>

            <div class="preview-container" id="previewContainer"></div>

            <button type="submit"><?php echo e(trans('main.Add_Ad')); ?></button>
        </form>
    </div>
</div>

<div class="alert-box" id="alertBox"><?php echo e(trans('main.Please_select_plan_first')); ?></div>
<script>
document.querySelector('form').addEventListener('submit', function (e) {
    const imageInput = document.getElementById('imageInput');
    const imageError = document.getElementById('imageError');

    if (!imageInput.files || imageInput.files.length === 0) {
        e.preventDefault(); // منع الإرسال
        imageError.style.display = 'block';
        imageError.scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else {
        imageError.style.display = 'none';
    }
});
</script>

<script>
    // اختر كل خيارات المعاملة
    const transactionRadios = document.querySelectorAll('input[name="transaction_type"]');
    const selectedTransactionDisplay = document.getElementById('selectedTransactionDisplay');
    const selectedTransactionInput = document.getElementById('selectedTransactionInput');

    transactionRadios.forEach(radio => {
        radio.addEventListener('change', () => {
            if (radio.checked) {
                selectedTransactionDisplay.innerText = " القسم المختار: " + radio.value;
                selectedTransactionInput.value = radio.value; // لتخزين القيمة في الفورم
            }
        });
    });
</script>
<script>
// منع فتح المودال بدون اختيار نوع المعاملة
function openFormModal() {
    const selected = document.querySelector('input[name="transaction_type"]:checked');

    if (!selected) {
        alert("الرجاء اختيار نوع المعاملة أولاً قبل المتابعة!");
        return; // يمنع فتح المودال
    }

    // إذا تم الاختيار — افتح المودال
    document.getElementById('formModal').style.display = 'block';
}
</script>

<script>
    
</script>

<script>
const modal = document.getElementById('modal');
const openBtn = document.getElementById('openModal');
const closeBtn = document.getElementById('closeModal');
const alertBox = document.getElementById('alertBox');
const selectedPlanDisplay = document.getElementById('selectedPlanDisplay');
const imageInput = document.getElementById('imageInput');
const videoInput = document.getElementById('videoInput');
const previewContainer = document.getElementById('previewContainer');
const titleInput = document.getElementById('title');

// دالة لتحويل الأرقام العربية/هندية إلى لاتينية
function arabicToEnglishDigits(str) {
    return str.replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d));
}

openBtn.onclick = () => {
    const transactionRadios = document.querySelectorAll('input[name="transaction_type"]');
    const selectedTransactionDisplay = document.getElementById('selectedTransactionDisplay');
    const selectedTransactionInput = document.getElementById('selectedTransactionInput');

    let selectedTransaction = '';
    transactionRadios.forEach(radio => {
        if (radio.checked) selectedTransaction = radio.value;
    });

    if (!selectedTransaction) {
        // عرض الرسالة داخل alertBox
        const alertBox = document.getElementById('alertBox');
        alertBox.classList.add('show');

        // اخفاء الرسالة بعد 3 ثواني
        setTimeout(() => {
            alertBox.classList.remove('show');
        }, 3000);

        return; // يمنع فتح المودال
    }

    selectedTransactionDisplay.innerText = "القسم المختار: " + selectedTransaction;
    selectedTransactionInput.value = selectedTransaction;

    // افتح المودال مباشرة
    modal.style.display = 'block';
};


// تحويل الأرقام العربية للإنجليزية
function arabicToEnglishDigits(str) {
    return str.replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d));
}




closeBtn.onclick = () => modal.style.display = 'none';
window.onclick = (e) => { if (e.target == modal) modal.style.display = 'none'; }

// transaction highlight
const transactionOptions = document.querySelectorAll('.transaction-option');
transactionOptions.forEach(opt => {
    opt.onclick = () => {
        transactionOptions.forEach(o => o.classList.remove('active'));
        opt.classList.add('active');
        opt.querySelector('input').checked = true;
    }
});

// الصور Drag & Drop
const imageDropzone = document.getElementById('imageDropzone');
imageDropzone.onclick = () => imageInput.click();
imageDropzone.ondragover = e => { e.preventDefault(); imageDropzone.classList.add('dragover'); }
imageDropzone.ondragleave = e => { imageDropzone.classList.remove('dragover'); }
imageDropzone.ondrop = e => {
    e.preventDefault();
    imageDropzone.classList.remove('dragover');
    imageInput.files = e.dataTransfer.files;
    updatePreview();
};
imageInput.onchange = updatePreview;

function updatePreview() {
    previewContainer.innerHTML = '';
    for (let file of imageInput.files) {
        const reader = new FileReader();
        reader.onload = e => {
            const img = document.createElement('img');
            img.src = e.target.result;
            previewContainer.appendChild(img);
        }
        reader.readAsDataURL(file);
    }
}

// فيديو Drag & Drop
const videoDropzone = document.getElementById('videoDropzone');
videoDropzone.onclick = () => videoInput.click();
videoDropzone.ondragover = e => { e.preventDefault(); videoDropzone.classList.add('dragover'); }
videoDropzone.ondragleave = e => { videoDropzone.classList.remove('dragover'); }
videoDropzone.ondrop = e => {
    e.preventDefault();
    videoDropzone.classList.remove('dragover');
    videoInput.files = e.dataTransfer.files;
    updateVideo();
};
videoInput.onchange = updateVideo;

function updateVideo() {
    previewContainer.querySelectorAll('video').forEach(v => v.remove());
    if (videoInput.files.length) {
        const file = videoInput.files[0];
        const vid = document.createElement('video');
        vid.controls = true;
        vid.style.width = '100%';
        vid.style.height = '120px';
        vid.style.borderRadius = '12px';

        const reader = new FileReader();
        reader.onload = e => {
            const tmpVideo = document.createElement('video');
            tmpVideo.src = e.target.result;
            tmpVideo.onloadedmetadata = function () {
                if (tmpVideo.duration > 30) {
                    const videoAlert = document.createElement('div');
                    videoAlert.innerHTML = `⏱️ <strong>مدة الفيديو طويلة!</strong> الرجاء رفع فيديو أقل من 30 ثانية.`;
                    videoAlert.classList.add('alert-box-modern');
                    document.body.appendChild(videoAlert);
                    setTimeout(() => {
                        videoAlert.style.opacity = "1";
                        videoAlert.style.transform = "translateX(-50%) translateY(0)";
                    }, 50);
                    setTimeout(() => {
                        videoAlert.style.opacity = "0";
                        videoAlert.style.transform = "translateX(-50%) translateY(-20px)";
                        setTimeout(() => videoAlert.remove(), 400);
                    }, 3000);
                    videoInput.value = '';
                } else {
                    vid.src = e.target.result;
                    previewContainer.appendChild(vid);
                }
            }
        }
        reader.readAsDataURL(file);
    }
}
</script>
<script>
    // اختر كل خيارات المعاملة
    const transactionRadios = document.querySelectorAll('input[name="transaction_type"]');
    const selectedTransactionDisplay = document.getElementById('selectedTransactionDisplay');
    const selectedTransactionInput = document.getElementById('selectedTransactionInput');

    transactionRadios.forEach(radio => {
        radio.addEventListener('change', () => {
            if (radio.checked) {
                selectedTransactionDisplay.innerText = "نوع المعاملة المختارة: " + radio.value;
                selectedTransactionInput.value = radio.value; // لتخزين القيمة في الفورم
            }
        });
    });
</script>

<script>
    const cards = document.querySelectorAll('.transaction-card');
    const input = document.getElementById('transactionType');

    cards.forEach(card => {
        card.addEventListener('click', function () {

            // إزالة التحديد من جميع الكروت
            cards.forEach(c => {
                c.style.border = "2px solid #ccc";
                c.style.background = "#fff";
            });

            // إضافة التحديد للكارد المختار
            this.style.border = "2px solid #CBA135";
            this.style.background = "#fdf7e6";

            // حفظ القيمة في الحقل المخفي
            input.value = this.dataset.value;
        });
    });
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/page/advertisement.blade.php ENDPATH**/ ?>