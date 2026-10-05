@php $isAr = app()->getLocale() === 'ar'; @endphp
<footer dir="{{ $isAr ? 'rtl' : 'ltr' }}" style="margin-top:64px;background:#0b3442;color:rgba(255,255,255,.75)">
    <div class="af-wrap" style="padding-top:40px;padding-bottom:40px;display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:28px">
        <div>
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:12px">
                <img src="{{ asset('image/afaq.jpeg') }}" style="width:42px;height:42px;border-radius:11px;background:#fff;object-fit:contain;padding:3px" alt="AFAQ">
                <div style="color:#fff;font-weight:900;font-size:19px">{{ $isAr ? 'آفاق' : 'AFAQ' }}</div>
            </div>
            <div style="font-size:13.5px;line-height:1.8">{{ $isAr ? 'منصة عقارية كويتية تجمع العقارات والمقاولات والوظائف والشركات في مكان واحد.' : 'A Kuwaiti real estate platform bringing properties, contracting, jobs and companies together.' }}</div>
        </div>
        <div>
            <div style="color:#e6c76a;font-weight:800;margin-bottom:10px">{{ $isAr ? 'الأقسام' : 'Sections' }}</div>
            <div style="display:flex;flex-direction:column;gap:7px;font-size:14px">
                <a style="color:inherit" href="{{ route('site.properties') }}">{{ $isAr ? 'العقارات' : 'Properties' }}</a>
                <span>{{ $isAr ? 'مقاولات البناء' : 'Contracting' }}</span>
                <span>{{ $isAr ? 'الوظائف' : 'Jobs' }}</span>
                <span>{{ $isAr ? 'الشركات العقارية' : 'Companies' }}</span>
            </div>
        </div>
        <div>
            <div style="color:#e6c76a;font-weight:800;margin-bottom:10px">{{ $isAr ? 'آفاق' : 'AFAQ' }}</div>
            <div style="display:flex;flex-direction:column;gap:7px;font-size:14px">
                <a style="color:inherit" href="{{ route('Aboutus') }}">{{ $isAr ? 'من نحن' : 'About us' }}</a>
                <a style="color:inherit" href="{{ route('policy') }}">{{ $isAr ? 'سياسة الخصوصية والشروط' : 'Privacy & Terms' }}</a>
            </div>
        </div>
        <div>
            <div style="color:#e6c76a;font-weight:800;margin-bottom:10px">{{ $isAr ? 'تواصل معنا' : 'Contact' }}</div>
            <div style="display:flex;flex-direction:column;gap:7px;font-size:14px">
                <a style="color:inherit" href="mailto:info@afaq.group">info@afaq.group</a>
                <a style="color:inherit" href="https://wa.me/96555525030" dir="ltr">+965 5552 5030</a>
            </div>
        </div>
    </div>
    <div style="border-top:1px solid rgba(255,255,255,.08);text-align:center;padding:16px;font-size:13px">© {{ date('Y') }} {{ $isAr ? 'آفاق. جميع الحقوق محفوظة.' : 'AFAQ. All rights reserved.' }}</div>
</footer>
