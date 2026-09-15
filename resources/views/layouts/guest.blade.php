<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">

<style>
    :root {
        --brand-teal: #0f4051;
        --brand-gold: #cba135;
        --crystal-bg: rgba(255, 255, 255, 0.15);
        --crystal-border: rgba(255, 255, 255, 0.3);
        --transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
    }

    body { font-family: 'Tajawal', sans-serif; }

    /* --- Navbar Styling --- */
    .navbar-modern {
        background: var(--brand-teal) !important;
        padding: 0.6rem 0;
        border-bottom: 1px solid var(--crystal-border);
        min-height: 70px;
        backdrop-filter: blur(10px);
    }

    .nav-link {
        color: #ffffff !important;
        font-weight: 700 !important;
        transition: var(--transition);
    }

    .nav-link:hover {
        color: var(--brand-gold) !important;
        opacity: 0.8;
    }

    /* --- Crystal Buttons Style (تأثير الكريستال الشفاف) --- */
    .btn-crystal {
        background: var(--crystal-bg);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        border: 1px solid var(--crystal-border);
        color: #ffffff !important;
        font-weight: 600;
        border-radius: 50px;
        padding: 8px 20px;
        transition: var(--transition);
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-crystal:hover {
        background: rgba(255, 255, 255, 0.25);
        border-color: #ffffff;
        transform: translateY(-2px);
        color: #ffffff !important;
    }

    /* أزرار الأدوات الدائرية بالنمط الكريستالي */
    .btn-tool-crystal {
        width: 40px;
        height: 40px;
        background: var(--crystal-bg);
        backdrop-filter: blur(5px);
        border: 1px solid var(--crystal-border);
        color: #ffffff !important;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        transition: var(--transition);
    }

    .btn-tool-crystal:hover {
        background: var(--brand-gold);
        border-color: var(--brand-gold);
        color: var(--brand-teal) !important;
    }

    /* مبدل اللغة الكريستالي */
    .lang-switch-crystal {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid var(--crystal-border);
        color: #ffffff !important;
        padding: 5px 15px;
        border-radius: 50px;
        font-weight: 800;
        font-size: 0.85rem;
        text-decoration: none !important;
        transition: var(--transition);
    }

    .lang-switch-crystal:hover {
        background: #ffffff;
        color: var(--brand-teal) !important;
    }

    .brand-logo {
        width: 45px;
        height: 45px;
        border: 1px solid var(--crystal-border);
    }

    @media (max-width: 991.98px) {
        .navbar-modern { min-height: 60px; }
    }
</style>

<header>
    <nav id="mainNavbar" class="navbar navbar-expand-lg navbar-modern fixed-top shadow-sm">
        <div class="container d-flex justify-content-between align-items-center">

            <a class="navbar-brand d-flex align-items-center gap-2" href="{{ route('welcome') }}">
                <img src="/image/afaq.jpeg" alt="Logo" class="rounded-circle brand-logo">
            </a>

            <div class="collapse navbar-collapse justify-content-center">
                <ul class="navbar-nav align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link" href="{{ route('welcome') }}">{{trans('main.Home')}}</a></li>
                    <li class="nav-item"><a class="nav-link" href="{{ route('search') }}">{{trans('main.Advertisements')}}</a></li>
                    <li class="nav-item"><a class="nav-link" href="{{ route('advertisement') }}">{{trans('main.Add an advertisement')}}</a></li>
                </ul>
            </div>

            <div class="d-flex align-items-center gap-3">

                <div class="d-none d-lg-flex gap-2 align-items-center">
                    <a href="tel:+96555525030" class="btn-tool-crystal"><i class="fa-solid fa-phone"></i></a>
                    <a href="https://wa.me/96555525030" target="_blank" class="btn-tool-crystal"><i class="fa-brands fa-whatsapp"></i></a>

                    <a href="javascript:void(0)" onclick="switchLocale()" class="lang-switch-crystal">
                        {{ App::getLocale() == 'ar' ? 'EN' : 'AR' }}
                    </a>
                </div>

                <a href="{{ route('login') }}" class="btn-crystal">
                    <i class="fa-solid fa-user-circle"></i>
                    {{trans('auth.Login')}}
                </a>

                <button class="navbar-toggler border-0 shadow-none p-0 d-lg-none" type="button" data-bs-toggle="offcanvas" data-bs-target="#mobileMenu">
                    <i class="bi bi-list text-white" style="font-size: 2.2rem;"></i>
                </button>
            </div>

        </div>
    </nav>

    <div class="offcanvas offcanvas-start border-0" id="mobileMenu" style="background: var(--brand-teal); width: 280px;">
        <div class="offcanvas-header p-4 border-bottom border-white border-opacity-10">
            <h5 class="offcanvas-title text-white fw-bold">القائمة</h5>
            <button class="btn-close btn-close-white shadow-none" data-bs-dismiss="offcanvas"></button>
        </div>
        <div class="offcanvas-body p-4 d-flex flex-column h-100">
            <div class="navbar-nav gap-2">
                <a href="{{ route('welcome') }}" class="nav-link fs-5 py-3 border-bottom border-white border-opacity-10"><i class="fa-solid fa-house me-3"></i> {{trans('main.Home')}}</a>
                <a href="{{ route('search') }}" class="nav-link fs-5 py-3 border-bottom border-white border-opacity-10"><i class="fa-solid fa-bullhorn me-3"></i> {{trans('main.Advertisements')}}</a>
                <a href="{{ route('advertisement') }}" class="nav-link fs-5 py-3 border-bottom border-white border-opacity-10"><i class="fa-solid fa-plus-circle me-3"></i> {{trans('main.Add an advertisement')}}</a>

                <div class="d-flex gap-2 mt-4">
                    <a href="tel:+96555525030" class="btn btn-crystal w-50 justify-content-center"><i class="fa-solid fa-phone"></i></a>
                    <a href="https://wa.me/96555525030" class="btn btn-crystal w-50 justify-content-center"><i class="fa-brands fa-whatsapp"></i></a>
                </div>
            </div>

            <div class="mt-auto pt-4 text-center">
                <div class="d-flex justify-content-center gap-4">
                    @foreach(LaravelLocalization::getSupportedLocales() as $localeCode => $properties)
                        <a href="{{ LaravelLocalization::getLocalizedURL($localeCode, null, [], true) }}" class="text-decoration-none fw-bold {{ App::getLocale() == $localeCode ? 'text-white' : 'text-white-50' }} fs-5">
                            {{ strtoupper($localeCode) }}
                        </a>
                    @endforeach
                </div>
            </div>
        </div>
    </div>
</header>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function switchLocale() {
        const currentLocale = '{{ App::getLocale() }}';
        const targetLocale = currentLocale === 'ar' ? 'en' : 'ar';
        const locales = {
            'ar': '{{ LaravelLocalization::getLocalizedURL("ar", null, [], true) }}',
            'en': '{{ LaravelLocalization::getLocalizedURL("en", null, [], true) }}'
        };
        window.location.href = locales[targetLocale];
    }
</script>
