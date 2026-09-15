<div class="darafaq-ui" dir="rtl">
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --brand-teal: #0f4051;
            --brand-gold: #cba135;
            --glass-bg: rgba(15, 64, 81, 0.9);
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            --card-shadow: 0 10px 30px rgba(0,0,0,0.05);
            --border-radius: 15px; /* تصغير الحواف قليلاً */
        }

        body { font-family: 'Tajawal', sans-serif; background-color: #f8f9fa; color: #333; }

        /* --- مؤشر التقدم العلوي --- */
        .scroll-progress {
            position: fixed; top: 0; right: 0; height: 3px;
            background: linear-gradient(to left, var(--brand-gold), #fff);
            width: 0%; z-index: 9999; transition: width 0.1s ease;
        }

        /* --- الهيدر (Navbar) --- */
        .navbar-custom {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            padding: 15px 0;
            transition: var(--transition);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .navbar-scrolled {
            padding: 8px 0;
            background: rgba(15, 64, 81, 0.98);
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }

        .nav-link-custom {
            color: #ffffff !important;
            font-weight: 700;
            font-size: 1.05rem;
            letter-spacing: 0.3px;
            position: relative;
            padding: 8px 15px !important;
            transition: var(--transition);
            text-decoration: none !important;
        }
        .nav-link-custom:hover { color: var(--brand-gold) !important; transform: translateY(-1px); }

        .lang-switch-btn {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid var(--brand-gold);
            color: var(--brand-gold) !important;
            width: 42px; height: 42px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 0.8rem;
            text-decoration: none !important;
            transition: var(--transition);
        }
        .lang-switch-btn:hover { background: var(--brand-gold); color: var(--brand-teal) !important; }

        .tools-container { display: flex; align-items: center; gap: 12px; }

        .btn-tool-circle {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: white; background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.1);
            transition: var(--transition);
        }
        .btn-tool-circle:hover { background: var(--brand-gold); color: var(--brand-teal); }

        .btn-wa-pulse { position: relative; }
        .btn-wa-pulse::before {
            content: ''; position: absolute; width: 100%; height: 100%;
            background: #25D366; opacity: 0.3; border-radius: 50%;
            animation: pulse-ring 2s infinite; z-index: -1;
        }
        @keyframes pulse-ring { 0% { transform: scale(0.8); opacity: 0.5; } 100% { transform: scale(1.5); opacity: 0; } }

        .search-box-wrapper { position: relative; display: flex; align-items: center; }
        .search-input-inner {
            width: 0; overflow: hidden; transition: var(--transition);
            background: white; border-radius: 50px;
        }
        .search-box-wrapper.active .search-input-inner {
            width: 150px; padding: 4px 15px; margin-inline-end: 8px;
        }
        .search-input-inner input { border: none; outline: none; width: 100%; font-size: 0.9rem; color: #333; }

        .user-profile-btn {
            background: linear-gradient(45deg, rgba(203, 161, 53, 0.2), rgba(255,255,255,0.05));
            border: 1px solid var(--brand-gold);
            color: white !important; padding: 7px 18px !important; border-radius: 50px;
            display: flex; align-items: center; gap: 10px; font-weight: 700;
        }

        .premium-dropdown {
            border: none; border-radius: 24px; box-shadow: 0 25px 60px rgba(0,0,0,0.15);
            min-width: 260px; padding: 12px; margin-top: 15px !important; background: #fff;
        }

        .dropdown-item-custom {
            border-radius: 15px; padding: 12px 15px; color: var(--brand-teal);
            font-weight: 700; display: flex; align-items: center; gap: 12px;
            transition: var(--transition); text-decoration: none;
        }
        .dropdown-item-custom:hover { background: rgba(15, 64, 81, 0.05); }

        /* --- السايد بار المطور --- */
        .offcanvas-premium {
            background: linear-gradient(180deg, var(--brand-teal) 0%, #061d25 100%) !important;
            width: 320px !important;
            border-left: 2px solid var(--brand-gold) !important;
        }

        .sidebar-user-header {
            padding: 40px 20px 30px;
            background: rgba(255, 255, 255, 0.02);
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .user-avatar-circle {
            width: 85px; height: 85px;
            background: var(--brand-gold);
            color: var(--brand-teal);
            font-size: 2.2rem; font-weight: 900;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; margin: 0 auto 15px;
            box-shadow: 0 10px 25px rgba(203, 161, 53, 0.3);
            border: 3px solid rgba(255, 255, 255, 0.15);
        }

        .sidebar-user-name { color: white; font-weight: 800; font-size: 1.2rem; margin-bottom: 4px; }
        .sidebar-user-email { color: #ccc; opacity: 0.7; font-size: 0.85rem; font-weight: 500; }

        .sidebar-link {
            display: flex; align-items: center; gap: 15px; padding: 14px 18px;
            color: white !important; text-decoration: none !important;
            font-weight: 700; border-radius: 12px; transition: 0.3s;
            margin-bottom: 8px; border: 1px solid transparent;
        }
        .sidebar-link i { color: var(--brand-gold); font-size: 1.1rem; width: 25px; text-align: center; }
        .sidebar-link:hover { background: rgba(203, 161, 53, 0.1); border-color: rgba(203, 161, 53, 0.3); transform: translateX(-5px); }

        /* --- مودال التعديل والتصميم الجديد للملف الشخصي --- */
        .modal-content { border: none; border-radius: 30px; overflow: hidden; background: #fff; box-shadow: 0 25px 80px rgba(0,0,0,0.1); }
        .modal-header-premium { background: var(--brand-teal); color: white; border: none; }

        .profile-input-group label { display: block; font-weight: 700; font-size: 0.9rem; color: #555; margin-bottom: 8px; }
        .profile-input-group input { width: 100%; padding: 14px; border-radius: 12px; border: 1px solid #e0e0e0; margin-bottom: 18px; background: #fafafa; transition: var(--transition); color: #333; }
        .profile-input-group input:focus { border-color: var(--brand-gold); outline: none; background: #fff; box-shadow: 0 0 0 4px rgba(203, 161, 53, 0.1); }
        .profile-input-group input:disabled { background: #f0f0f0; cursor: not-allowed; border-color: #ddd; }

        /* --- تصميم الباقات المحدث (تم تصغير الخطوط والعناصر) --- */
        .pkg-card {
            border-radius: var(--border-radius);
            border: 1px solid rgba(0, 0, 0, 0.03);
            background: #fff;
            transition: var(--transition);
            height: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }
        .pkg-card:hover { transform: translateY(-7px); box-shadow: 0 15px 30px rgba(0,0,0,0.08); }

        .pkg-header {
            padding: 18px 10px; /* تصغير التباعد */
            text-align: center;
            background: linear-gradient(135deg, #fdfdfd 0%, #fafafa 100%);
            border-bottom: 1px solid #eee;
            position: relative;
        }

        .pkg-icon { font-size: 2rem; display: block; margin-bottom: 8px; }
        .pkg-title { font-weight: 800; font-size: 0.95rem; color: #333; margin-bottom: 10px; }

        .pkg-price {
            background: var(--brand-teal);
            color: var(--brand-gold);
            padding: 4px 14px;
            border-radius: 50px;
            font-weight: 800;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            box-shadow: 0 5px 15px rgba(15, 64, 81, 0.1);
        }
        .pkg-price::after { content: 'نقاط'; font-size: 0.65rem; font-weight: 500; }

        .pkg-body { padding: 18px 15px; flex-grow: 1; }
        .pkg-feature {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-size: 0.8rem;
            color: #444;
            font-weight: 600;
        }
        .pkg-feature i { color: #ccc; font-size: 0.75rem; }
        .pkg-feature.checked i { color: var(--brand-gold); }

        .pkg-footer {
            padding: 12px;
            background: #fdfdfd;
            border-top: 1px dashed #eee;
            text-align: center;
            font-size: 0.75rem;
            font-weight: 800;
            color: #888;
        }

        /* ألوان التدرجات والحواف للباقات */
        .pkg-basic { border-top: 4px solid #6c757d; }
        .pkg-basic .pkg-header { background: linear-gradient(135deg, #f1f3f5 0%, #e9ecef 100%); }

        .pkg-bronze { border-top: 4px solid #cd7f32; }
        .pkg-bronze .pkg-header { background: linear-gradient(135deg, #fff2e0 0%, #ffebcc 100%); }

        .pkg-silver { border-top: 4px solid #adb5bd; }
        .pkg-silver .pkg-header { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); }

        .pkg-gold { border-top: 4px solid #ffd700; }
        .pkg-gold .pkg-header { background: linear-gradient(135deg, #fffef0 0%, #fff8cc 100%); }

        /* باقة VIP المتميزة */
        .pkg-vip {
            border: 2px solid var(--brand-gold);
            background: linear-gradient(180deg, #102636 0%, var(--brand-teal) 100%);
        }
        .pkg-vip .pkg-header {
            background: transparent;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .pkg-vip .pkg-title { color: white; }
        .pkg-vip .pkg-icon { color: #fff; }
        .pkg-vip .pkg-price { background: var(--brand-gold); color: var(--brand-teal); }
        .pkg-vip .pkg-body { color: rgba(255, 255, 255, 0.8); }
        .pkg-vip .pkg-feature { color: rgba(255, 255, 255, 0.8); }
        .pkg-vip .pkg-feature i { color: rgba(255, 255, 255, 0.2); }
        .pkg-vip .pkg-feature.checked i { color: var(--brand-gold); }
        .pkg-vip .pkg-footer { background: transparent; border-top: 1px dashed rgba(255, 255, 255, 0.05); color: #fff; }

        @media (max-width: 991px) {
            .navbar-custom { padding: 10px 0; }
            .user-profile-btn span { display: none; }
            @media (min-width: 450px) { .user-profile-btn span { display: inline; } }
        }

        @media (max-width: 575px) {
            .pkg-card { margin-bottom: 15px; }
        }
    </style>

    <div class="scroll-progress" id="scrollBar"></div>

    <header>
        <nav class="navbar navbar-expand-lg navbar-custom fixed-top" id="mainNavbar">
            <div class="container">
                <a class="navbar-brand" href="{{ route('welcome') }}">
                    <img src="/image/afaq.jpeg" alt="Logo" width="50" height="50" class="rounded-circle shadow-sm">
                </a>

                <div class="tools-container ms-auto me-2 order-lg-3">


                    <div class="d-none d-lg-flex gap-2">
                        <a href="tel:+96555525030" class="btn-tool-circle"><i class="fa-solid fa-phone"></i></a>
                        <a href="https://wa.me/96555525030" target="_blank" class="btn-tool-circle btn-wa-pulse"><i class="fa-brands fa-whatsapp"></i></a>
                    </div>

                    <a href="javascript:void(0)" onclick="switchLocale()" class="lang-switch-btn">
                        <span class="small">{{ App::getLocale() == 'ar' ? 'EN' : 'AR' }}</span>
                    </a>

                    @auth
                    <div class="dropdown ms-2">
                        <a href="#" class="user-profile-btn dropdown-toggle text-decoration-none shadow-sm" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-user-gear text-warning"></i>
                            <span>{{ Auth::user()->name }}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end premium-dropdown">
                            <div class="px-3 py-3 mb-2 border-bottom bg-light rounded-4 mx-2">
                                <small class="text-muted d-block fw-bold">البريد الإلكتروني:</small>
                                <span class="text-dark small">{{ Auth::user()->email }}</span>
                            </div>
                            <li><a class="dropdown-item dropdown-item-custom" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#profileModal"><i class="fa-solid fa-id-card text-primary"></i> {{ trans('main.Edit Profile') }}</a></li>
                            <li><a class="dropdown-item dropdown-item-custom" href="{{ route('notifications') }}"><i class="fa-solid fa-bell text-danger"></i> {{ trans('main.notifications') }}</a></li>
                            <li><a class="dropdown-item dropdown-item-custom" href="{{ route('details') }}"><i class="fa-solid fa-briefcase text-success"></i> {{ trans('main.Reserved_Ads') }}</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item dropdown-item-custom text-danger" href="{{ route('logout') }}" onclick="event.preventDefault(); document.getElementById('logout-form').submit();"><i class="fa-solid fa-power-off"></i> {{ trans('main.logout') }}</a></li>
                        </ul>
                    </div>
                    @endauth
                </div>

                <button class="navbar-toggler border-0 shadow-none order-lg-4" type="button" data-bs-toggle="offcanvas" data-bs-target="#mobileSidebar">
                    <span class="fa-solid fa-bars-staggered text-white fs-2"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-center order-lg-2">
                    <ul class="navbar-nav">
                        <li class="nav-item"><a class="nav-link nav-link-custom" href="{{ route('welcome') }}">{{trans('main.Home')}}</a></li>
                        <li class="nav-item"><a class="nav-link nav-link-custom" href="{{ route('search') }}">{{trans('main.Advertisements')}}</a></li>
                        <li class="nav-item"><a class="nav-link nav-link-custom" href="{{ route('advertisement') }}">{{trans('main.Add an advertisement')}}</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="offcanvas offcanvas-start offcanvas-premium" tabindex="-1" id="mobileSidebar">
            <div class="sidebar-user-header position-relative">
                <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3 shadow-none" data-bs-dismiss="offcanvas" style="font-size: 0.8rem;"></button>
                <div class="user-avatar-circle">
                    @auth {{ mb_substr(Auth::user()->name, 0, 1, 'utf-8') }} @else <i class="fa-solid fa-user"></i> @endauth
                </div>
                <div class="sidebar-user-name">@auth {{ Auth::user()->name }} @else زائر @endauth</div>
                <div class="sidebar-user-email">@auth {{ Auth::user()->email }} @else مرحباً بك في دار آفاق @endauth</div>
            </div>
            <div class="offcanvas-body p-4">
                <div class="d-flex flex-column gap-1 text-end">
                    <a href="{{ route('welcome') }}" class="sidebar-link"><i class="fa-solid fa-house"></i> {{ trans('main.Home') }}</a>
                    <a href="{{ route('search') }}" class="sidebar-link"><i class="fa-solid fa-bullhorn"></i> {{ trans('main.Advertisements') }}</a>
                    <a href="{{ route('advertisement') }}" class="sidebar-link"><i class="fa-solid fa-plus-circle"></i> {{ trans('main.Add an advertisement') }}</a>
                    <a href="{{ route('Aboutus') }}" class="sidebar-link"><i class="fa-solid fa-circle-info"></i> {{ trans('main.about') }}</a>
                    @auth
                    <hr class="text-white opacity-10 my-3">
                    <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#profileModal" class="sidebar-link"><i class="fa-solid fa-id-card"></i> {{ trans('main.Edit Profile') }}</a>
                    <a href="{{ route('logout') }}" onclick="event.preventDefault(); document.getElementById('logout-form').submit();" class="sidebar-link text-danger"><i class="fa-solid fa-power-off"></i> {{ trans('main.logout') }}</a>
                    @endauth
                    <hr class="text-white opacity-10 my-3">
                    <div class="menu-label small text-warning fw-bold mb-3 px-2 text-end">تواصل سريع</div>
                    <div class="d-flex gap-3 px-2 justify-content-end">
                        <a href="tel:+96555525030" class="btn btn-warning rounded-circle p-3 shadow-sm d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;"><i class="fa-solid fa-phone text-dark"></i></a>
                        <a href="https://wa.me/96555525030" class="btn btn-success rounded-circle p-3 shadow-sm d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;"><i class="fa-brands fa-whatsapp text-white"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="modal fade" id="profileModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content">
                <div class="modal-header modal-header-premium p-4">
                    <div class="text-end w-100">
                        <h4 class="fw-black mb-1">لوحة التحكم الشخصية</h4>
                        <p class="small opacity-75 mb-0">إدارة البيانات ونقاط الترويج</p>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 p-lg-5">
                    @auth
                    <div class="row g-5">
                        <div class="col-lg-3 border-start"> <form method="POST" action="{{ route('profile.update') }}" id="updateProfileForm">
                                @csrf @method('PUT')
                                <div class="text-center mb-5">
                                    <div class="position-relative d-inline-block">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center shadow-sm" style="width: 90px; height: 90px; border: 4px solid var(--brand-gold);">
                                            <i class="fa-solid fa-user text-muted fs-2"></i>
                                        </div>
                                        <button type="button" id="editProfileBtn" class="btn btn-warning btn-sm position-absolute bottom-0 end-0 rounded-circle shadow-lg"><i class="fa-solid fa-pen p-1"></i></button>
                                    </div>

                                    <div class="mt-4 bg-white p-3 rounded-4 shadow-sm border border-light d-inline-flex flex-column align-items-center" style="width: 120px;">
                                        <div class="bg-warning p-2 rounded-3 mb-2 d-flex align-items-center justify-content-center" style="width: 35px; height: 35px;">
                                            <i class="fa-solid fa-star text-dark fs-6"></i>
                                        </div>
                                        <span class="text-dark fw-black x-small">رصيد النقاط</span>
                                        <span class="text-warning fw-bold h5 mb-0">{{ Auth::user()->points ?? 0 }}</span>
                                    </div>
                                </div>

                                <div class="text-end profile-input-group">
                                    <div class="mb-1"><label>الاسم الأول</label><input type="text" name="name" value="{{ Auth::user()->name }}" disabled></div>
                                    <div class="mb-1"><label>البريد الإلكتروني</label><input type="email" name="email" value="{{ Auth::user()->email }}" disabled></div>
                                    <div class="mb-1"><label>رقم الهاتف</label><input type="text" name="phone" value="{{ Auth::user()->phone ?? '' }}" disabled></div>

                                    <div class="password-fields" style="display:none;">
                                        <div class="mb-1"><label>كلمة مرور جديدة</label><input type="password" name="password" placeholder="********"></div>
                                    </div>

                                    <div class="d-grid mt-4">
                                        <button type="submit" id="saveProfileBtn" class="btn btn-primary rounded-pill py-2 fw-bold" style="display:none; background: var(--brand-teal); border:none;">حفظ</button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="col-lg-9">
                            <h5 class="fw-bold text-dark mb-4 text-end"><i class="fa-solid fa-rocket text-warning me-2"></i> باقات الترويج والتميز</h5>
                            <div class="row g-3 text-end" dir="rtl">

                                <div class="col-lg-4 col-md-6">
                                    <div class="pkg-card pkg-basic">
                                        <div class="pkg-header">
                                            <span class="pkg-icon">📄</span>
                                            <div class="pkg-title">الأساسية</div>
                                            <div class="pkg-price">25</div>
                                        </div>
                                        <div class="pkg-body">
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> رفع يدوي</div>
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> شهر كامل</div>
                                        </div>
                                        <div class="pkg-footer">اعتيادي 🗓️</div>
                                    </div>
                                </div>

                                <div class="col-lg-4 col-md-6">
                                    <div class="pkg-card pkg-bronze">
                                        <div class="pkg-header">
                                            <span class="pkg-icon">🥉</span>
                                            <div class="pkg-title">البرونزية</div>
                                            <div class="pkg-price">35</div>
                                        </div>
                                        <div class="pkg-body">
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> 5 رفع آلي</div>
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> أعلى القسم</div>
                                        </div>
                                        <div class="pkg-footer text-success">2x مشاهدات 📈</div>
                                    </div>
                                </div>

                                <div class="col-lg-4 col-md-6">
                                    <div class="pkg-card pkg-silver">
                                        <div class="pkg-header">
                                            <span class="pkg-icon">🥈</span>
                                            <div class="pkg-title">الفضية</div>
                                            <div class="pkg-price">45</div>
                                        </div>
                                        <div class="pkg-body">
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> 9 رفع آلي</div>
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> صدارة القسم</div>
                                        </div>
                                        <div class="pkg-footer text-primary">10x وصول 🔥</div>
                                    </div>
                                </div>

                                <div class="col-lg-4 col-md-6">
                                    <div class="pkg-card pkg-gold">
                                        <div class="pkg-header">
                                            <span class="pkg-icon">🥇</span>
                                            <div class="pkg-title">الذهبية</div>
                                            <div class="pkg-price">55</div>
                                        </div>
                                        <div class="pkg-body">
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> 15 رفع آلي</div>
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> نتائج بحث</div>
                                        </div>
                                        <div class="pkg-footer text-warning">استهداف 🚀</div>
                                    </div>
                                </div>

                                <div class="col-lg-8 col-md-12"> <div class="pkg-card pkg-vip shadow">
                                        <div class="pkg-header">
                                            <span class="pkg-icon">💎</span>
                                            <div class="pkg-title">VIP النخبوية</div>
                                            <div class="pkg-price">65</div>
                                        </div>
                                        <div class="pkg-body">
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> 20 رفع تلقائي</div>
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> أولوية مطلقة</div>
                                            <div class="pkg-feature checked"><i class="fa-solid fa-check-circle"></i> تثبيت شامل</div>
                                        </div>
                                        <div class="pkg-footer fw-black text-white">أسرع عملية بيع 🔥</div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    @endauth
                </div>
            </div>
        </div>
    </div>

    <form id="logout-form" action="{{ route('logout') }}" method="POST" class="d-none">@csrf</form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.onscroll = function() {
            let winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            let height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            document.getElementById("scrollBar").style.width = (winScroll / height) * 100 + "%";
            const nav = document.getElementById('mainNavbar');
            window.scrollY > 50 ? nav.classList.add('navbar-scrolled') : nav.classList.remove('navbar-scrolled');
        };

        function toggleSearch() {
            const wrapper = document.getElementById('searchWrapper');
            wrapper.classList.toggle('active');
            if(wrapper.classList.contains('active')) wrapper.querySelector('input').focus();
        }

        document.getElementById('editProfileBtn')?.addEventListener('click', function() {
            const form = document.getElementById('updateProfileForm');
            const saveBtn = document.getElementById('saveProfileBtn');
            const isEditing = saveBtn.style.display === 'block';

            if(isEditing) {
                form.querySelectorAll('input').forEach(input => input.disabled = true);
                document.querySelectorAll('.password-fields').forEach(el => el.style.display = 'none');
                saveBtn.style.display = 'none';
                this.innerHTML = '<i class="fa-solid fa-pen p-1"></i>';
                this.classList.remove('btn-danger');
                this.classList.add('btn-warning');
            } else {
                form.querySelectorAll('input').forEach(input => input.disabled = false);
                document.querySelectorAll('.password-fields').forEach(el => el.style.display = 'block');
                saveBtn.style.display = 'block';
                this.innerHTML = '<i class="fa-solid fa-xmark p-1"></i>';
                this.classList.remove('btn-warning');
                this.classList.add('btn-danger');
            }
        });

        function switchLocale() {
            const currentLocale = "{{ App::getLocale() }}";
            const newLocale = currentLocale === 'ar' ? 'en' : 'ar';
            window.location.href = "{{ url('/') }}/" + newLocale;
        }
    </script>
</div>
