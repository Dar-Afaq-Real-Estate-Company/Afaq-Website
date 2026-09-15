<footer class="footer-premium">
    <div class="footer-glow-effect"></div>

    <div class="footer-container">
        <div class="footer-main-grid">
            
            <div class="footer-col brand-info">
                <div class="brand-identity">
                    <h2 class="footer-logo"><?php echo e(__('main.AppName')); ?> <span class="gold-accent"><?php echo e(__('main.Real Estate')); ?></span></h2>
                    <div class="logo-underline"></div>
                </div>
                <p class="brand-text">
                    <?php echo e(__('main.company_description')); ?>

                </p>
                
                <div class="social-wrapper">
                    <h6 class="social-label"><?php echo e(__('main.Our digital presence')); ?></h6> <div class="social-glass-icons">
                        <a href="https://www.facebook.com/afaqkw.f/"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="https://www.instagram.com/afaqkw.i/"><i class="fa-brands fa-instagram"></i></a>
                        <a href="https://x.com/afaqkw_x"><i class="fa-brands fa-x-twitter"></i></a>
                        <a href="https://www.tiktok.com/@afaqkw_t?lang=ar"><i class="fa-brands fa-tiktok"></i></a>
                        <a href="https://www.snapchat.com/t/afaqkw.s"><i class="fa-brands fa-snapchat"></i></a>
                        <a href="https://www.youtube.com/@afaqkw"><i class="fa-brands fa-youtube"></i></a>
                    </div>
                </div>
            </div>

            <div class="footer-col quick-links">
                <h4 class="footer-header"><?php echo e(__('main.quick_links')); ?></h4>
                <ul class="footer-nav-links">
                    <li><a href="<?php echo e(route('Quicks')); ?>"><span class="nav-dot"></span> <?php echo e(__('main.our_services')); ?></a></li>
                    <li><a href="<?php echo e(route('Aboutus')); ?>"><span class="nav-dot"></span> <?php echo e(__('main.contact_us')); ?></a></li>
                    <li><a href="<?php echo e(route('policy')); ?>"><span class="nav-dot"></span> <?php echo e(__('main.Privacy')); ?></a></li>
                </ul>
            </div>

            <div class="footer-col contact-info">
                <h4 class="footer-header"><?php echo e(__('main.contact_info')); ?></h4>
                
                <div class="communication-card">
                    <div class="comm-icon">
                        <i class="fa-solid fa-phone-flip"></i>
                    </div>
                    <div class="comm-details">
                        <span class="comm-label"><?php echo e(__('main.call')); ?></span>
                        <a href="tel:+96555525030" class="comm-value phone-number" dir="ltr">+965 5552 5030</a>
                    </div>
                </div>

                <a href="https://wa.me/96555525030" target="_blank" class="whatsapp-premium-card">
                    <div class="wa-content">
                        <i class="fa-brands fa-whatsapp"></i>
                        <div class="wa-text">
                            <small><?php echo e(__('main.whatsapp')); ?></small>
                            <strong><?php echo e(__('main.whatsapp')); ?></strong> </div>
                    </div>
                    <i class="fa-solid fa-arrow-up-right-from-square arrow-icon"></i>
                </a>

                <a href="mailto:www.darafaqkw.com.com" class="email-premium-card mb-4">
                    <div class="email-content">
                        <div class="email-icon-box">
                            <i class="fa-regular fa-envelope-open"></i>
                        </div>
                        <div class="email-details">
                            <small class="email-label"><?php echo e(__('main.email')); ?></small>
                            <span class="email-url">www.Darafaqkw.com</span>
                        </div>
                    </div>
                    <div class="hover-indicator"></div>
                </a>

                
            </div>
        </div>

        <div class="footer-bottom-section">
            <div class="bottom-divider"></div>
            <div class="bottom-flex-container">
                <p class="copyright-text">© 2026 <strong><?php echo e(__('main.AppName')); ?></strong>. <?php echo e(__('main.all_rights_reserved')); ?>.</p>
                
                <div class="location-badge-refined">
                    <a href="https://www.google.com/maps/search/?api=1&query=دار+آفاق+العقارية+الكويت" target="_blank" class="map-link">
                        <span class="map-icon-wrapper">
                            <i class="fa-solid fa-location-dot"></i>
                            <span class="ping"></span>
                        </span>
                        <span class="map-text"><?php echo e(__('main.map_location')); ?></span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
/* القسم الخاص بالـ CSS لم يتغير لضمان بقاء التصميم كما هو */
.footer-premium, .footer-premium * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    list-style: none;
    text-decoration: none;
}

:root {
    --footer-bg: #0f4051;
    --gold-clr: #cba135;
    --text-silver: #94a3b8;
    --wa-green: #25d366;
}

.footer-premium {
    background-color: var(--footer-bg);
    color: #ffffff;
    padding: 80px 0 40px;
    border-radius: 60px 60px 0 0;
    margin-top: 60px;
    position: relative;
    overflow: hidden;
    direction: rtl; /* سيتم تعديلها تلقائياً عند تغيير لغة الصفحة إذا كنت تستخدم سمة dir في وسم html */
    width: 100%;
    font-family: 'Tajawal', sans-serif;
}

/* بقية الستايل الخاص بك دون أي حذف */
.footer-container { width: 90%; max-width: 1200px; margin: 0 auto; position: relative; z-index: 5; }
.footer-main-grid { display: flex; flex-wrap: wrap; gap: 40px; }
.footer-col { flex: 1; min-width: 280px; }
.brand-info { flex: 1.5; }
.footer-logo { font-weight: 900; font-size: 2rem; color: #fff; }
.gold-accent { color: var(--gold-clr); }
.logo-underline { width: 50px; height: 4px; background: var(--gold-clr); border-radius: 10px; margin: 10px 0 25px; }
.brand-text { color: #cbd5e1; line-height: 1.8; font-size: 0.95rem; margin-bottom: 30px; }
.social-glass-icons { display: flex; gap: 12px; flex-wrap: wrap; }
.social-glass-icons a { width: 42px; height: 42px; background: rgba(255,255,255,0.05); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; border: 1px solid rgba(255,255,255,0.1); transition: 0.3s; }
.social-glass-icons a:hover { background: var(--gold-clr); transform: translateY(-5px); color: var(--footer-bg); }
.footer-header { font-weight: 800; font-size: 1.2rem; margin-bottom: 25px; border-right: 3px solid var(--gold-clr); padding-right: 15px; }
.footer-nav-links li { margin-bottom: 15px; }
.footer-nav-links li a { color: var(--text-silver); display: flex; align-items: center; gap: 10px; font-size: 0.95rem; transition: 0.3s; }
.footer-nav-links li a:hover { color: #fff; padding-right: 8px; }
.nav-dot { width: 6px; height: 6px; background: var(--gold-clr); border-radius: 50%; }
.communication-card { background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255, 255, 255, 0.08); padding: 15px; border-radius: 20px; display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
.comm-icon { width: 45px; height: 45px; background: var(--gold-clr); color: #fff; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
.comm-label { display: block; font-size: 0.75rem; color: var(--text-silver); }
.comm-value { font-size: 1.2rem; font-weight: 800; color: #fff; direction: ltr; }
.whatsapp-premium-card { background: linear-gradient(135deg, #128c7e 0%, #25d366 100%); padding: 15px 20px; border-radius: 20px; display: flex; justify-content: space-between; align-items: center; color: white !important; margin-bottom: 15px; transition: 0.3s; }
.wa-content { display: flex; align-items: center; gap: 15px; }
.wa-content i { font-size: 2rem; }
.wa-text strong { display: block; font-size: 1.1rem; }
.email-premium-card { background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255, 255, 255, 0.1); padding: 15px 20px; border-radius: 20px; display: flex; align-items: center; justify-content: space-between; position: relative; overflow: hidden; color: white !important; }
.email-icon-box { width: 40px; height: 40px; background: rgba(203, 161, 53, 0.15); border: 1px solid var(--gold-clr); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--gold-clr); }
.apk-premium-button { display: flex; align-items: center; background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(203, 161, 53, 0.3); padding: 12px 20px; border-radius: 20px; color: white !important; position: relative; overflow: hidden; transition: all 0.4s ease; }
.apk-icon-area { font-size: 1.8rem; color: #a4c639; margin-left: 15px; }
.apk-text-area { flex-grow: 1; text-align: right; }
.apk-label { display: block; font-size: 0.7rem; color: var(--text-silver); }
.apk-title { display: block; font-size: 1rem; font-weight: 700; color: var(--gold-clr); }
.apk-download-icon { font-size: 1.2rem; color: var(--gold-clr); opacity: 0.6; transition: 0.3s; }
.apk-premium-button:hover { background: rgba(203, 161, 53, 0.1); border-color: var(--gold-clr); transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2); }
.apk-premium-button:hover .apk-download-icon { transform: translateY(3px); opacity: 1; }
.location-badge-refined .map-link { display: inline-flex; align-items: center; gap: 12px; background: rgba(203, 161, 53, 0.12); border: 1px solid rgba(203, 161, 53, 0.2); padding: 10px 20px; border-radius: 50px; color: var(--gold-clr); font-weight: 700; transition: 0.3s; }
.location-badge-refined .map-link:hover { background: var(--gold-clr); color: var(--footer-bg); }
.map-icon-wrapper { position: relative; display: flex; }
.ping { position: absolute; width: 100%; height: 100%; background: var(--gold-clr); border-radius: 50%; animation: map-ping 1.8s infinite; }
@keyframes map-ping { 0% { transform: scale(1); opacity: 0.8; } 100% { transform: scale(2.5); opacity: 0; } }
.footer-bottom-section { margin-top: 50px; }
.bottom-divider { height: 1px; background: rgba(255,255,255,0.08); margin-bottom: 25px; }
.bottom-flex-container { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px; }

@media (max-width: 768px) {
    .footer-premium { border-radius: 40px 40px 0 0; padding: 60px 0 30px; }
    .footer-main-grid { flex-direction: column; text-align: center; }
    .logo-underline { margin: 10px auto 25px; }
    .social-glass-icons, .footer-nav-links li a, .communication-card, .whatsapp-premium-card, .email-premium-card, .bottom-flex-container, .apk-premium-button { justify-content: center; }
    .footer-header { border-right: none; border-bottom: 2px solid var(--gold-clr); padding-right: 0; padding-bottom: 8px; display: inline-block; }
}
</style><?php /**PATH /home/frudlhds/public_html/resources/views/layouts/footer.blade.php ENDPATH**/ ?>