<?php $__env->startSection('content'); ?>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.2/src/fill/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<style>
:root {
    --primary: #265362;
    --accent: #CBA135;
    --success: #10b981;
    --bg: #f4f7f9;
    --white: #ffffff;
    --dark-blue: #194554;
}

body { font-family: 'Tajawal', sans-serif; background: var(--bg); color: #1f2937; margin: 0; overflow-x: hidden; }

/* الهيدر الفخم */
.page-header {
    background: linear-gradient(135deg, var(--primary) 0%, #122a32 100%);
    color: white; padding: 100px 20px 160px; border-radius: 0 0 60px 60px;
    text-align: center; position: relative; overflow: hidden;
}
.page-header::before {
    content: ""; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%;
    background: radial-gradient(circle, rgba(203,161,53,0.1) 0%, transparent 70%);
    animation: rotate 20s linear infinite;
}
@keyframes rotate { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

/* الشبكة */
.ads-grid { 
    display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); 
    gap: 25px; padding: 20px; max-width: 1400px; margin: -80px auto 50px;
    position: relative; z-index: 10;
}

/* بطاقة الإعلان الزجاجية */
.ad-card {
    background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(10px);
    border-radius: 30px; overflow: hidden; transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    border: 1px solid rgba(255,255,255,0.6); display: flex; flex-direction: column; 
    height: 100%; position: relative; padding: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05);
}
.ad-card:hover { transform: translateY(-12px) scale(1.02); box-shadow: 0 30px 60px -15px rgba(38, 83, 98, 0.2); }

.card-media { position: relative; height: 190px; width: 100%; border-radius: 22px; overflow: hidden; }
.card-media img { width: 100%; height: 100%; object-fit: cover; transition: 0.6s; }

/* العداد المطور */
.timer-ui {
    margin: 15px 0; padding: 12px; border-radius: 18px;
    font-weight: 800; font-size: 0.8rem; display: flex; align-items: center; justify-content: center; gap: 8px;
    background: #f0fdf4; color: #166534; border: 1px dashed rgba(0,0,0,0.05);
}
.timer-num { color: var(--accent); font-family: 'Arial', sans-serif; font-size: 1rem; }

/* تصميم المودال المتوافق مع الجوال */
.modal-overlay {
    display: none; position: fixed; inset: 0; z-index: 9999;
    background: rgba(15, 23, 42, 0.8); backdrop-filter: blur(12px);
    justify-content: center; align-items: center; padding: 15px;
}
.modal-box {
    background: rgba(255, 255, 255, 0.98); border-radius: 40px;
    padding: 30px; width: 100%; max-width: 600px; max-height: 90vh; overflow-y: auto;
    box-shadow: 0 50px 100px rgba(0,0,0,0.3); animation: modalShow 0.4s;
}
@keyframes modalShow { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }

/* الحقول داخل المودال */
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px; }
.form-input { 
    width: 100%; padding: 14px; border: 2px solid #edf2f7; border-radius: 16px; 
    background: #f8fafc; font-family: 'Tajawal'; font-weight: 600; box-sizing: border-box;
}

/* حقل الرفع الحديث */
.upload-zone {
    border: 2px dashed var(--dark-blue); background: #f8fafc; padding: 25px;
    border-radius: 24px; text-align: center; cursor: pointer; margin: 15px 0;
    transition: 0.3s;
}
.upload-zone:hover { border-color: var(--accent); background: #f0f4f5; }

/* حاوية المعاينة */
#imagePreviewContainer {
    display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px; justify-content: center;
}
.preview-img-wrapper {
    position: relative; width: 70px; height: 70px; border-radius: 12px; overflow: hidden; border: 2px solid var(--accent);
}
.preview-img-wrapper img { width: 100%; height: 100%; object-fit: cover; }

/* تنسيق الصورة الحالية في المودال */
.current-image-preview {
    width: 100%; height: 120px; border-radius: 20px; object-fit: cover; margin-bottom: 15px; border: 2px solid #edf2f7;
}

.btn-ui { border: none; padding: 12px; border-radius: 15px; font-weight: 800; cursor: pointer; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; }
.btn-save { background: var(--dark-blue); color: white; width: 100%; padding: 18px; font-size: 1.1rem; }
.btn-save:hover { background: var(--primary); transform: translateY(-3px); }

@media (max-width: 600px) {
    .form-row { grid-template-columns: 1fr; }
    .modal-box { padding: 20px; border-radius: 30px; }
    .page-header { padding: 80px 15px 130px; }
}
</style>
</head>
<body>

<div class="page-header">
    <div class="animate__animated animate__fadeInDown">
        <h1 style="font-size: 2.5rem; font-weight: 900;"><i class="ph-fill ph-house-line"></i> <?php echo e(__('main.my_properties')); ?></h1>
        <p class="opacity-75"><?php echo e(__('main.manage_ads_subtitle')); ?></p>
    </div>
</div>

<div class="container">
    <div class="ads-grid">
    <?php $__currentLoopData = $details; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $index => $detail): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
      <div class="ad-card animate__animated animate__fadeInUp" style="animation-delay: <?php echo e($index * 0.1); ?>s">
        <div class="card-media">
          <img src="<?php echo e($detail->images ?? 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800'); ?>">
        </div>

        <div class="ad-body">
            <div style="font-size: 1.2rem; font-weight: 900; color: var(--primary); margin: 10px 0;"><?php echo e($detail->type); ?></div>
            <div style="color: #64748b; font-size: 0.85rem; margin-bottom: 8px;"><i class="ph-fill ph-map-pin-line" style="color:var(--accent)"></i> <?php echo e($detail->region); ?></div>
            
            <div class="timer-ui countdown-box" data-date="<?php echo e($detail->auction_date); ?>">
                <i class="ph-duotone ph-hourglass-high" style="font-size: 1.2rem;"></i>
                <span class="time-label"><?php echo e(__('main.calculating')); ?></span>
            </div>

            <div style="background: #f8fafc; padding: 15px; border-radius: 20px; display: flex; justify-content: space-between; align-items: center; border: 1px solid #edf2f7;">
                <div>
                    <span style="font-size: 0.65rem; font-weight: 800; color: var(--accent); display: block;"><?php echo e(__('main.target_price')); ?></span>
                    <span style="font-size: 1.2rem; font-weight: 900;"><?php echo e(number_format($detail->price)); ?> <?php echo e(__('main.kwd')); ?></span>
                </div>
                <div style="background: var(--primary); color: white; width: 35px; height: 35px; border-radius: 12px; display: flex; align-items: center; justify-content: center; cursor: pointer;" onclick="generateShare('<?php echo e($detail->id); ?>')">
                    <i class="ph ph-share-network"></i>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 15px;">
          <button onclick="openEditModal(<?php echo e(json_encode($detail)); ?>)" class="btn-ui" style="background: #f1f5f9; color: var(--primary);"><?php echo e(__('main.edit')); ?></button>
          <a href="<?php echo e(route('destroy.detail',$detail->id)); ?>" class="btn-ui" style="background: #fff1f2; color: #e11d48;" onclick="return confirm('<?php echo e(__('main.confirm_delete')); ?>')"><?php echo e(__('main.delete')); ?></a>
        </div>
      </div>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    </div>
</div>

<div id="editModal" class="modal-overlay">
    <div class="modal-box">
        <h3 style="color:var(--primary); font-weight:900; margin-bottom:25px; display:flex; align-items:center; gap:10px;">
            <i class="ph-fill ph-note-pencil" style="color:var(--accent)"></i> <?php echo e(__('main.update_property_info')); ?>

        </h3>
        
        <label style="display:block; margin-bottom:5px; font-weight:700; font-size:0.8rem;"><?php echo e(__('main.current_image')); ?></label>
        <img id="m_current_img" src="" class="current-image-preview">

        <form id="updateAdForm" action="<?php echo e(route('advertisement.update')); ?>" method="POST" enctype="multipart/form-data">
            <?php echo csrf_field(); ?>
            <input type="hidden" name="ad_id" id="m_id">
            
            <div class="form-row">
                <div><label style="display:block; margin-bottom:5px; font-weight:700; font-size:0.8rem;"><?php echo e(__('main.property_type')); ?></label><input type="text" name="type" id="m_type" class="form-input"></div>
                <div><label style="display:block; margin-bottom:5px; font-weight:700; font-size:0.8rem;"><?php echo e(__('main.region')); ?></label><input type="text" name="region" id="m_region" class="form-input"></div>
            </div>

            <div class="form-row">
                <div><label style="display:block; margin-bottom:5px; font-weight:700; font-size:0.8rem;"><?php echo e(__('main.price')); ?></label><input type="number" name="price" id="m_price" class="form-input"></div>
                <div><label style="display:block; margin-bottom:5px; font-weight:700; font-size:0.8rem;"><?php echo e(__('main.phone')); ?></label><input type="text" name="phone" id="m_phone" class="form-input"></div>
            </div>

            <div><label style="display:block; margin-bottom:5px; font-weight:700; font-size:0.8rem;"><?php echo e(__('main.description')); ?></label><textarea name="description" id="m_desc" class="form-input" rows="3" style="resize:none;"></textarea></div>

            <div class="upload-zone" onclick="document.getElementById('fileInput').click()">
                <input type="file" name="images[]" id="fileInput" multiple style="display:none;" onchange="handleFileSelect(this)">
                <div id="uploadPlaceholder">
                    <i class="ph-fill ph-cloud-arrow-up" style="font-size: 2.5rem; color: var(--accent); display: block; margin: 0 auto 10px;"></i>
                    <span id="uploadText" style="font-weight:800; color: var(--primary);"><?php echo e(__('main.upload_new_images')); ?></span>
                </div>
                <div id="imagePreviewContainer"></div>
            </div>

            <button type="submit" class="btn-ui btn-save"><?php echo e(__('main.save_changes')); ?></button>
            <button type="button" onclick="closeEditModal()" style="width:100%; background:none; border:none; color:#64748b; margin-top:15px; cursor:pointer; font-weight:700;"><?php echo e(__('main.cancel_close')); ?></button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function startCountdowns() {
    setInterval(() => {
        document.querySelectorAll('.countdown-box').forEach(box => {
            const dateStr = box.dataset.date;
            if (!dateStr) return;
            const expiry = new Date(dateStr.replace(/-/g, "/")).getTime();
            const now = new Date().getTime();
            const diff = expiry - now;
            const label = box.querySelector('.time-label');

            if (isNaN(expiry) || diff <= 0) {
                label.innerHTML = `<span style="color:#e11d48">منتهي</span>`;
                return;
            }

            const d = Math.floor(diff / (1000 * 60 * 60 * 24));
            const h = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const s = Math.floor((diff % (1000 * 60)) / 1000);

            label.innerHTML = `<span class="timer-num">${d}</span> يوم و <span class="timer-num">${h.toString().padStart(2,'0')}:${m.toString().padStart(2,'0')}:${s.toString().padStart(2,'0')}</span>`;
        });
    }, 1000);
}

// دالة لمعالجة الملفات المختار وعرضها
function handleFileSelect(input) {
    const previewContainer = document.getElementById('imagePreviewContainer');
    const uploadText = document.getElementById('uploadText');
    previewContainer.innerHTML = ''; // تنظيف المعاينة القديمة

    if (input.files.length > 0) {
        uploadText.innerText = `تم اختيار ${input.files.length} صور`;
        uploadText.style.color = "var(--success)";

        Array.from(input.files).forEach(file => {
            const reader = new FileReader();
            reader.onload = function(e) {
                const wrapper = document.createElement('div');
                wrapper.className = 'preview-img-wrapper';
                wrapper.innerHTML = `<img src="${e.target.result}">`;
                previewContainer.appendChild(wrapper);
            }
            reader.readAsDataURL(file);
        });
    }
}

// منع الإرسال إذا كان الحقل فارغاً
document.getElementById('updateAdForm').onsubmit = function(e) {
    const fileInput = document.getElementById('fileInput');
    if (fileInput.files.length === 0) {
        e.preventDefault();
        Swal.fire({
            title: 'صور المعرض مطلوبة!',
            text: 'يرجى اختيار صور جديدة للعقار قبل الحفظ.',
            icon: 'warning',
            confirmButtonText: 'حسناً',
            confirmButtonColor: '#194554',
        });
        return false;
    }
};

function openEditModal(data) {
    document.getElementById('m_id').value = data.id || '';
    document.getElementById('m_type').value = data.type || '';
    document.getElementById('m_region').value = data.region || '';
    document.getElementById('m_price').value = data.price || '';
    document.getElementById('m_phone').value = data.phone || '';
    document.getElementById('m_desc').value = data.description || '';
    
    // إظهار الصورة الحالية في المودال
    const currentImg = data.images ? data.images : 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800';
    document.getElementById('m_current_img').src = currentImg;

    // إعادة ضبط حقل الصور عند فتح المودال
    document.getElementById('fileInput').value = '';
    document.getElementById('imagePreviewContainer').innerHTML = '';
    document.getElementById('uploadText').innerText = "اضغط لرفع صور جديدة للمعرض";
    document.getElementById('uploadText').style.color = "var(--primary)";

    document.getElementById('editModal').style.display = 'flex';
}

function closeEditModal() { document.getElementById('editModal').style.display = 'none'; }

document.addEventListener('DOMContentLoaded', startCountdowns);
</script>

</body>
</html>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /home/frudlhds/public_html/resources/views/page/details.blade.php ENDPATH**/ ?>