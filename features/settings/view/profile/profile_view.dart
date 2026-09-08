import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/account_types.dart';
import '../../../../core/helper/constants.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/shared_pref.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/routes.dart';
import '../../../subscription/subscription_plans_view.dart';
import '../../../auth/data/models/response/response.dart';
import '../../../auth/logic/cubit_cubit.dart' show DeleteAccountCubit;
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../subscription/subscription_plans_view.dart';
import '../account_settings_view.dart';
import 'personal_info_view.dart';

/// بروفايل المستخدم — بياناته، إحصائيات إعلاناته، والوصول السريع لخدماته
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.afaq.group/api/',
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Map<String, dynamic>? _user;
  int _adsCount = 0;
  int _totalViews = 0;
  bool _loading = true;

  Map<String, String> get _typeLabels => {
    'seeker': AppStrings.typeSeeker.tr(),
    'owner': AppStrings.typeOwner.tr(),
    'office': AppStrings.typeOffice.tr(),
    'company': AppStrings.getString('acc_type_company_title', context.locale.languageCode),
    'developer': AppStrings.typeDeveloper.tr(),
    'broker': AppStrings.typeBroker.tr(),
  };

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);

      final info = await _dio.get('userinfo/$userId');
      final user = Map<String, dynamic>.from(info.data['user'] ?? {});

      // إحصائيات إعلاناته
      int ads = 0;
      int views = 0;
      try {
        final pub = await _dio.get('publisher/$userId');
        final List<dynamic> list = pub.data['data']?['ads'] ?? [];
        ads = list.length;
        for (final a in list) {
          views += int.tryParse((a['views_count'] ?? 0).toString()) ?? 0;
        }
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _user = user;
        _adsCount = ads;
        _totalViews = views;
        _loading = false;
      });
    } catch (e) {
      debugPrint('ProfileView _fetch error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _name => (_user?['name'] ?? '').toString();
  String get _accountType =>
      (_user?['account_type'] ?? AccountType.seeker).toString();
  bool get _verified =>
      (_user?['email_verified_at'] ?? '').toString().isNotEmpty;
  bool get _licenseVerified =>
      (_user?['license_status'] ?? 0).toString() == '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: _loading
          ? const Center(child: AppLoadingIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(),
                  Transform.translate(
                    offset: Offset(0, -34.h),
                    child: Column(
                      children: [
                        if (isLoggedInUser) ...[
                          _buildStats(),
                          verticalSpace(18),
                          _buildSection(
                            title: AppStrings.myAccountSection.tr(),
                            items: [
                              _Item(Icons.edit_outlined, 'edit_personal_info'.tr(),
                                  () => _openPersonalInfo()),
                              _Item(Icons.campaign_outlined, AppStrings.myAdsMenu.tr(),
                                  () => Navigator.pushNamed(
                                      context, Routes.myAdvertisementsRoute)),
                              _Item(Icons.favorite_border, AppStrings.favorites.tr(),
                                  () => Navigator.pushNamed(
                                      context, Routes.favoritesRoute)),
                              _Item(Icons.workspace_premium_outlined, AppStrings.packages.tr(),
                                  () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SubscriptionPlansView()))),
                              _Item(Icons.receipt_long_outlined, 'my_requests_menu'.tr(),
                                  () => Navigator.pushNamed(
                                      context, Routes.myServiceRequestsRoute)),
                              _Item(Icons.support_agent_outlined, 'consultation'.tr(),
                                  () => Navigator.pushNamed(
                                      context, Routes.realEstateConsultationRoute)),
                            ],
                          ),
                          verticalSpace(14),
                        ],
                        _buildSection(
                          title: AppStrings.appSection.tr(),
                          items: [
                            _Item(
                              Icons.language_outlined,
                              'العربية / English',
                              _openLanguageSheet,
                            ),
                            _Item(Icons.info_outline, AppStrings.aboutApp.tr(),
                                () => Navigator.pushNamed(
                                    context, Routes.aboutUsRoute)),
                            _Item(Icons.privacy_tip_outlined, AppStrings.privacyPolicyMenu.tr(),
                                () => Navigator.pushNamed(
                                    context, Routes.privacyRoute)),
                            if (isLoggedInUser)
                              _Item(Icons.manage_accounts_outlined, AppStrings.accountSettingsMenu.tr(),
                                  () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) => di<DeleteAccountCubit>(),
                                            child: const AccountSettingsView(),
                                          ),
                                        ),
                                      )),
                          ],
                        ),
                        verticalSpace(18),
                        isLoggedInUser ? _buildLogout() : _buildLoginButton(),
                        verticalSpace(28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ======================================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 52.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_forward,
                      color: Colors.white, size: 22.sp),
                ),
                const Spacer(),
              ],
            ),
            verticalSpace(14),
            if (!isLoggedInUser) ...[
              verticalSpace(30),
              Icon(Icons.person_outline, size: 64.sp, color: Colors.white),
              verticalSpace(14),
              Text(
                AppStrings.browsingAsGuest.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              verticalSpace(6),
              Text(
                AppStrings.pleaseLoginToViewData.tr(),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85), fontSize: 12.5.sp),
              ),
              verticalSpace(30),
            ] else ...[
            Stack(
              children: [
                Container(
                  width: 104.w,
                  height: 104.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (_user?['logo'] ?? '').toString().isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _user!['logo'].toString(),
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _avatar(),
                        )
                      : _avatar(),
                ),
                if (_licenseVerified)
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.verified,
                          size: 19.sp, color: const Color(0xFF12B76A)),
                    ),
                  ),
              ],
            ),
            verticalSpace(12),
            Text(
              _name.isEmpty ? 'مستخدم' : _name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                _typeLabels[_accountType] ?? 'مستخدم',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
            verticalSpace(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _verified ? Icons.check_circle : Icons.error_outline,
                  size: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
                SizedBox(width: 5.w),
                Text(
                  _verified ? AppStrings.emailVerifiedLabel.tr() : AppStrings.emailNotVerifiedLabel.tr(),
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9), fontSize: 11.5.sp),
                ),
              ],
            ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    final initials = _name.trim().isEmpty
        ? '؟'
        : _name.trim().split(RegExp(r'\s+')).first.characters.take(2).toString();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w900,
          color: ColorManager.primary,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _stat('$_adsCount', AppStrings.myAdsMenu.tr(), Icons.campaign_outlined),
          _divider(),
          _stat('$_totalViews', AppStrings.viewsStat.tr(), Icons.visibility_outlined),
          _divider(),
          _stat('${_user?['points'] ?? 0}', AppStrings.pointsStat.tr(), Icons.stars_outlined),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 38.h,
        color: const Color(0xFFEDEFF3),
      );

  Widget _stat(String value, String label, IconData icon) => Expanded(
        child: Column(
          children: [
            Icon(icon, size: 19.sp, color: ColorManager.primary),
            verticalSpace(7),
            Text(value,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF101828),
                )),
            verticalSpace(2),
            Text(label,
                style: TextStyle(
                    fontSize: 11.5.sp, color: const Color(0xFF98A2B3))),
          ],
        ),
      );

  Widget _buildSection({required String title, required List<_Item> items}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF98A2B3),
              ),
            ),
          ),
          ...List.generate(items.length, (i) {
            final item = items[i];
            return Column(
              children: [
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.only(right: 60.w),
                    child: Divider(height: 1, color: const Color(0xFFF2F4F7)),
                  ),
                InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: ColorManager.primary.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                          child: Icon(item.icon,
                              size: 18.sp, color: ColorManager.primary),
                        ),
                        SizedBox(width: 13.w),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_left,
                            size: 21.sp, color: const Color(0xFFD0D5DD)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          verticalSpace(8),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.loginRoute),
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: ColorManager.primary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login, size: 18.sp, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                AppStrings.loginBtn.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: _confirmLogout,
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3F2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 18.sp, color: const Color(0xFFF04438)),
              SizedBox(width: 8.w),
              Text(
                AppStrings.logoutBtn.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF04438),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              verticalSpace(16),
              Text(AppStrings.appLanguageLabel.tr(),
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
              verticalSpace(12),
              _languageTile('العربية', const Locale('ar')),
              _languageTile('English', const Locale('en')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageTile(String label, Locale locale) {
    final selected = context.locale.languageCode == locale.languageCode;
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        await context.setLocale(locale);
        if (mounted) Phoenix.rebirth(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20.sp,
              color: selected ? ColorManager.primary : const Color(0xFFD0D5DD),
            ),
            SizedBox(width: 12.w),
            Text(label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: const Color(0xFF101828),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _openPersonalInfo() async {
    final didUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PersonalInfoView(user: _user ?? {})),
    );
    if (didUpdate == true) _fetch();
  }

  Future<void> _openEdit() async {
    final user = UserResponse(
      id: int.tryParse('${_user?['id'] ?? ''}'),
      name: _name,
      phone: (_user?['phone'] ?? '').toString(),
      email: (_user?['email'] ?? '').toString(),
      logo: (_user?['logo'] ?? '').toString(),
      accountType: (_user?['account_type'] ?? '').toString(),
      gender: (_user?['Gender'] ?? _user?['gender'] ?? '').toString(),
    );
    await Navigator.pushNamed(
      context,
      Routes.editProfileRoute,
      arguments: EditProfileArgs(userData: UserInfoResponse(user: user)),
    );
    _fetch();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.logoutBtn.tr()),
        content: Text(AppStrings.logoutConfirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('خروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    performLogout(context);
  }
}

class _Item {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _Item(this.icon, this.label, this.onTap);
}
