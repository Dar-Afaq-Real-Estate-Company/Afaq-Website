@extends('layouts.app')

@section('content')

<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">

<style>
:root {
    --navy: #0A2540;
    --gold: #CBA135;
    --custom-blue: #265362;
    --success-green: #10b981;
    --light-bg: #f8fafc;
}

body {
    font-family: 'Tajawal', sans-serif !important;
    background-color: var(--light-bg);
    direction: rtl;
    text-align: right;
    overflow-x: hidden;
}

/* الهيرو */
.hero-section {
    background: linear-gradient(rgba(10,37,64,0.9), rgba(10,37,64,0.8)), 
                url('https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg') center/cover;
    padding: 80px 0;
    color: white;
    border-radius: 0 0 30px 30px;
    margin-bottom: 30px;
}

/* الكروت */
.tool-card {
    background: white;
    border-radius: 20px;
    padding: 25px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    margin-bottom: 25px;
    border: 1px solid rgba(0,0,0,0.05);
}

.label-bold {
    font-weight: 700;
    font-size: 0.85rem;
    margin-bottom: 8px;
    display: block;
    color: var(--navy);
}

.form-control, .form-select {
    height: 48px;
    border-radius: 10px;
    border: 1.5px solid #eee;
    margin-bottom: 15px;
    transition: 0.3s;
    font-size: 0.9rem;
}

.form-control:focus, .form-select:focus {
    border-color: var(--gold);
    box-shadow: 0 0 0 0.2rem rgba(203, 161, 53, 0.15);
}

/* الأزرار */
.btn-custom-main {
    background-color: var(--custom-blue) !important;
    color: white !important;
    border: none;
    padding: 14px;
    border-radius: 12px;
    font-weight: 800;
    width: 100%;
    transition: 0.3s;
}

.btn-custom-main:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(38, 83, 98, 0.3);
}

.btn-submit-wa {
    background-color: #25D366 !important;
    color: white !important;
    width: 100%;
    padding: 16px;
    border-radius: 15px;
    font-weight: 900;
    border: none;
    font-size: 1.1rem;
}

/* زر إدارة الأملاك الجديد */
.btn-mgt-wa {
    background-color: var(--navy) !important;
    color: white !important;
    width: 100%;
    padding: 16px;
    border-radius: 15px;
    font-weight: 900;
    border: none;
    font-size: 1.1rem;
    transition: 0.3s;
}

.btn-mgt-wa:hover {
    background-color: var(--custom-blue) !important;
    transform: translateY(-2px);
}

/* العداد الرقمي */
.counter-value {
    font-size: 2.2rem;
    font-weight: 900;
    display: inline-block;
}

.result-display-area {
    background: #fdfaf3;
    border-right: 6px solid var(--gold);
    padding: 20px;
    border-radius: 15px;
    margin-top: 20px;
}

.build-result-display {
    background: #f0fdf4;
    border-right: 6px solid var(--success-green);
    padding: 20px;
    border-radius: 15px;
    margin-top: 20px;
}

@media (max-width: 768px) {
    .hero-section h1 { font-size: 2.2rem !important; }
    .counter-value { font-size: 1.8rem; }
}
</style>

<div class="container-fluid p-0">
    <section class="hero-section text-center">
        <div class="container" data-aos="zoom-in">
            <h1 class="fw-bold mb-3" style="font-size: 3.5rem;">دار آفاق للتقييم العقاري</h1>
            <p class="lead" style="font-size: 1.4rem; opacity: 0.9;">دقة هندسية شاملة في حساب تكاليف البناء والتقييم وإدارة الأملاك</p>
        </div>
    </section>

    <div class="container px-3">
        
        <section class="tool-card shadow-lg" data-aos="fade-up">
            <h4 class="fw-bold mb-4 text-center">
                <i class="fa fa-home text-warning me-2"></i> حاسبة القيمة السوقية العادلة
            </h4>
            <div class="row">
                <div class="col-md-4 col-12">
                    <label class="label-bold">مساحة الأرض (م²)</label>
                    <input type="number" id="qArea" class="form-control" placeholder="مثال: 400">
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">الموقع الجغرافي</label>
                    <select id="qRegion" class="form-select">
                        <option value="800">العاصمة - مناطق داخلية</option>
                        <option value="650">حولي - جنوب السرة</option>
                        <option value="500">مبارك الكبير</option>
                        <option value="400">الفروانية / الأحمدي</option>
                        <option value="300">الجهراء والمناطق البعيدة</option>
                    </select>
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">موقع القسيمة والارتداد</label>
                    <select id="qLocation" class="form-select">
                        <option value="1.0">شارع واحد</option>
                        <option value="1.12">زاوية</option>
                        <option value="1.18">بطن وظهر</option>
                        <option value="1.30">رأس 3 جهات</option>
                    </select>
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">عمر البناء</label>
                    <select id="qAge" class="form-select">
                        <option value="1.0">جديد (0-3 سنوات)</option>
                        <option value="0.85">حديث (4-12 سنة)</option>
                        <option value="0.65">متوسط</option>
                        <option value="0.40">قديم جداً / هدام</option>
                    </select>
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">نوع ومستوى التشطيب</label>
                    <select id="qFinish" class="form-select">
                        <option value="0">أرض فضاء</option>
                        <option value="150">عادي</option>
                        <option value="250">ديلوكس</option>
                        <option value="400">سوبر ديلوكس</option>
                    </select>
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">المميزات الإضافية</label>
                    <select id="qExtra" class="form-select">
                        <option value="0">لا يوجد</option>
                        <option value="12000">سرداب</option>
                        <option value="18000">سرداب + مصعد</option>
                        <option value="30000">سرداب + مصعد + مسبح</option>
                    </select>
                </div>
                <div class="col-12 mt-2">
                    <button class="btn-custom-main py-3" onclick="animateValuation()">
                        <i class="fa fa-sync-alt me-2"></i> احسب القيمة الآن
                    </button>
                </div>
            </div>

            <div id="valResultArea" class="d-none">
                <div class="result-display-area text-center">
                    <h5 class="text-muted mb-2 small">القيمة التقديرية للعقار</h5>
                    <div class="counter-value" id="valCounter" style="color: var(--navy);">0</div>
                    <span class="counter-value" style="color: var(--navy); font-size: 1.5rem;"> د.ك</span>
                </div>
            </div>
        </section>

        <section class="tool-card shadow-lg" data-aos="fade-up">
            <h4 class="fw-bold mb-4 text-center">
                <i class="fa fa-hammer text-success me-2"></i> حاسبة ميزانية البناء التفصيلية
            </h4>
            <div class="row g-2">
                <div class="col-md-3 col-12">
                    <label class="label-bold">إجمالي المسطحات (م²)</label>
                    <input type="number" id="bArea" class="form-control" placeholder="مثال: 1200">
                </div>
                <div class="col-md-3 col-6">
                    <label class="label-bold">الهيكل (الأسود)</label>
                    <select id="bStructure" class="form-select">
                        <option value="95">أسود عادي</option>
                        <option value="125">هوردي عازل</option>
                        <option value="145">سيغما وتكسية خارجية</option>
                    </select>
                </div>
                <div class="col-md-3 col-6">
                    <label class="label-bold">نوع التشطيب</label>
                    <select id="bFinish" class="form-select">
                        <option value="115">اقتصادي</option>
                        <option value="190">ديلوكس</option>
                        <option value="320">سوبر ديلوكس فاخر</option>
                    </select>
                </div>
                <div class="col-md-3 col-12">
                    <label class="label-bold">نظام التكييف</label>
                    <select id="bAC" class="form-select">
                        <option value="25">وحدات منفصلة</option>
                        <option value="55">مركزي (كولكس/يورك)</option>
                        <option value="85">مركزي VRF (توفير طاقة)</option>
                    </select>
                </div>
                
                <div class="col-md-4 col-12">
                    <label class="label-bold">تأسيس المصاعد</label>
                    <select id="bElevator" class="form-select">
                        <option value="0">بدون مصعد</option>
                        <option value="8500">مصعد واحد (3 أدوار)</option>
                        <option value="15000">مصعدين (للأدوار المتعددة)</option>
                    </select>
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">الأعمال الصحية والكهربائية</label>
                    <select id="bPlumbing" class="form-select">
                        <option value="35">تأسيس عادي</option>
                        <option value="60">تأسيس معلق (عدساني/بايبرز)</option>
                        <option value="90">أنظمة ذكية Smart Home</option>
                    </select>
                </div>
                <div class="col-md-4 col-12">
                    <label class="label-bold">نظام السرداب (إن وجد)</label>
                    <select id="bBasement" class="form-select">
                        <option value="0">لا يوجد سرداب</option>
                        <option value="1.2">سرداب عادي</option>
                        <option value="1.4">سرداب مع حفر عميق وعزل</option>
                    </select>
                </div>

                <div class="col-12 mt-3">
                    <button class="btn-custom-main" style="background-color: var(--success-green) !important;" onclick="animateBuildCalc()">
                        <i class="fa fa-calculator me-2"></i> تقدير ميزانية البناء الإجمالية
                    </button>
                </div>
            </div>

            <div id="buildResultArea" class="d-none">
                <div class="build-result-display text-center">
                    <h5 class="text-muted mb-2 small">إجمالي التكلفة التقديرية (على المفتاح)</h5>
                    <div class="counter-value" id="buildCounter" style="color: #065f46;">0</div>
                    <span class="counter-value" style="color: #065f46; font-size: 1.5rem;"> د.ك</span>
                    <p class="mt-2 text-dark small fw-bold">شاملة (الهيكل، التشطيب، التكييف، الصحي، والمصاعد)</p>
                </div>
            </div>
        </section>

        <section class="tool-card shadow-lg" style="border-right: 8px solid var(--navy); background-color: #fcfcfc;" data-aos="fade-up">
            <div class="d-flex align-items-center mb-4">
                <div class="bg-navy p-3 rounded-circle text-white me-3" style="background: var(--navy); width: 60px; height: 60px; display: flex; align-items: center; justify-content: center;">
                    <i class="fa fa-building-circle-check fa-2x"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0" style="color: var(--navy);">إدارة أملاك الغير</h4>
                    <p class="text-muted mb-0 small">نضمن لك تحصيل الإيجارات بانتظام، الصيانة الفورية، والتقارير المالية الدقيقة.</p>
                </div>
            </div>
            
            <form onsubmit="sendPropertyMgtRequest(event)">
                <div class="row g-3">
                    <div class="col-md-6 col-12">
                        <label class="label-bold">اسم مالك العقار</label>
                        <input name="ownerName" required type="text" class="form-control" placeholder="الاسم الثلاثي">
                    </div>
                    <div class="col-md-6 col-12">
                        <label class="label-bold">تصنيف العقار</label>
                        <select name="mgtPropType" class="form-select">
                            <option value="عمارة استثمارية">عمارة استثمارية</option>
                            <option value="مجمع تجاري">مجمع تجاري</option>
                            <option value="قسيمة صناعية">قسيمة صناعية</option>
                            <option value="بيت مؤجر">بيت / فيلا مؤجرة</option>
                        </select>
                    </div>
                    <div class="col-md-4 col-12">
                        <label class="label-bold">عدد الوحدات الإجمالي</label>
                        <input name="unitsCount" required type="number" class="form-control" placeholder="عدد الشقق أو المحلات">
                    </div>
                    <div class="col-md-4 col-12">
                        <label class="label-bold">موقع العقار</label>
                        <input name="mgtLocation" required type="text" class="form-control" placeholder="المنطقة والقطعة">
                    </div>
                    <div class="col-md-4 col-12">
                        <label class="label-bold">رقم هاتف المالك</label>
                        <input name="ownerPhone" required type="tel" class="form-control" placeholder="965xxxxxxx">
                    </div>
                    <div class="col-12 mt-4">
                        <button type="submit" class="btn-mgt-wa">
                            <i class="fab fa-whatsapp me-2"></i> إرسال طلب إدارة الأملاك عبر واتساب
                        </button>
                    </div>
                </div>
            </form>
        </section>

        <section class="tool-card shadow-lg mb-5" style="border-top: 5px solid var(--custom-blue);">
            <h3 class="fw-bold mb-4"><i class="fa fa-file-contract text-primary me-2"></i> طلب تقييم رسمي معتمد</h3>
            <p class="text-muted mb-4 small">للبنوك، الورثة، أو الجهات الحكومية - املأ البيانات وسنتواصل معك فوراً.</p>
            <form onsubmit="sendOfficialRequest(event)">
                <div class="row g-2">
                    <div class="col-md-6 col-12">
                        <label class="label-bold">اسم مقدم الطلب</label>
                        <input name="name" required type="text" class="form-control" placeholder="الاسم الكامل">
                    </div>
                    <div class="col-md-6 col-12">
                        <label class="label-bold">الغرض من التقييم</label>
                        <select name="purpose" class="form-select">
                            <option>للبيع والشراء</option>
                            <option>للبنك / تمويل عقاري</option>
                            <option>حصر ورثة / فرز</option>
                            <option>قضايا وتثمين</option>
                        </select>
                    </div>
                    <div class="col-md-4 col-12">
                        <label class="label-bold">رقم التواصل</label>
                        <input name="phone" required type="tel" class="form-control" placeholder="965xxxxxxx">
                    </div>
                    <div class="col-md-4 col-12">
                        <label class="label-bold">المنطقة والقطعة</label>
                        <input name="address" required type="text" class="form-control" placeholder="مثال: كيفان ق3">
                    </div>
                    <div class="col-md-4 col-12">
                        <label class="label-bold">نوع العقار</label>
                        <select name="propertyType" class="form-select">
                            <option>سكني خاص</option>
                            <option>عمارة استثمارية</option>
                            <option>تجاري / مجمع</option>
                            <option>شاليه / مزرعة</option>
                        </select>
                    </div>
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn-submit-wa">
                            <i class="fab fa-whatsapp me-2"></i> إرسال الطلب الرسمي عبر واتساب
                        </button>
                    </div>
                </div>
            </form>
        </section>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>

<script>
    AOS.init({ once: true });

    // دالة العداد الرقمي
    function animateValue(obj, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            const current = Math.floor(progress * (end - start) + start);
            obj.innerHTML = current.toLocaleString();
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    // حساب التقييم
    function animateValuation() {
        const area = parseFloat(document.getElementById('qArea').value) || 0;
        const base = parseFloat(document.getElementById('qRegion').value);
        const loc = parseFloat(document.getElementById('qLocation').value);
        const age = parseFloat(document.getElementById('qAge').value);
        const finish = parseFloat(document.getElementById('qFinish').value);
        const extra = parseFloat(document.getElementById('qExtra').value);

        if(area <= 0) return alert("يرجى إدخال المساحة");

        let total = (area * base * loc) + ((area * finish) * age) + extra;

        document.getElementById('valResultArea').classList.remove('d-none');
        animateValue(document.getElementById('valCounter'), 0, total, 1500);
    }

    // حساب تكاليف البناء
    function animateBuildCalc() {
        const bArea = parseFloat(document.getElementById('bArea').value) || 0;
        const bStruct = parseFloat(document.getElementById('bStructure').value);
        const bFin = parseFloat(document.getElementById('bFinish').value);
        const bAC = parseFloat(document.getElementById('bAC').value);
        const bElevator = parseFloat(document.getElementById('bElevator').value);
        const bPlumbing = parseFloat(document.getElementById('bPlumbing').value);
        const bBasementMult = parseFloat(document.getElementById('bBasement').value);

        if(bArea <= 0) return alert("يرجى إدخال مسطح البناء");

        let costPerMeter = bStruct + bFin + bAC + bPlumbing;
        let baseCost = bArea * costPerMeter;
        
        if(bBasementMult > 0) baseCost = baseCost * bBasementMult;

        let finalTotal = baseCost + bElevator;

        document.getElementById('buildResultArea').classList.remove('d-none');
        animateValue(document.getElementById('buildCounter'), 0, finalTotal, 1500);
    }

    // إرسال طلب إدارة الأملاك (واتساب)
    function sendPropertyMgtRequest(e) {
        e.preventDefault();
        const f = e.target;
        const msg = `*طلب إدارة أملاك جديد (دار آفاق)*\n\n` +
                    `👤 المالك: ${f.ownerName.value}\n` +
                    `🏘 النوع: ${f.mgtPropType.value}\n` +
                    `🔢 الوحدات: ${f.unitsCount.value}\n` +
                    `📍 الموقع: ${f.mgtLocation.value}\n` +
                    `📱 الهاتف: ${f.ownerPhone.value}`;
        
        window.open(`https://wa.me/96555525030?text=${encodeURIComponent(msg)}`, '_blank');
    }

    // إرسال طلب التقييم الرسمي (واتساب)
    function sendOfficialRequest(e) {
        e.preventDefault();
        const f = e.target;
        const msg = `*طلب تقييم رسمي جديد*\n👤 العميل: ${f.name.value}\n🎯 الغرض: ${f.purpose.value}\n📱 الهاتف: ${f.phone.value}\n📍 الموقع: ${f.address.value}\n🏠 النوع: ${f.propertyType.value}`;
        window.open(`https://wa.me/96555525030?text=${encodeURIComponent(msg)}`, '_blank');
    }
</script>

@endsection