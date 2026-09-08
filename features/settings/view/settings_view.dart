import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../../core/di/di.dart';
import '../../../core/helper/constants.dart';
import '../../../core/helper/extensions.dart';
import '../../../core/helper/shared_pref.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/routing/routes.dart';
import '../../auth/logic/cubit_cubit.dart';
import 'account_settings_view.dart';

/// الإعدادات — تصميم مجموعات مرتّبة، وحذف الحساب مخفي داخل "إعدادات الحساب"
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
                children: [
                  _group('الحساب', [
                    _Row(
                      icon: Icons.person_outline,
                      label: 'الملف الشخصي',
                      onTap: () => Navigator.pushNamed(context, Routes.profileRoute),
                    ),
                    _Row(
                      icon: Icons.campaign_outlined,
                      label: 'إعلاناتي',
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.myAdvertisementsRoute),
                    ),
                    _Row(
                      icon: Icons.favorite_border,
                      label: 'المفضلة',
                      onTap: () => Navigator.pushNamed(context, Routes.favoritesRoute),
                    ),
                  ]),
                  verticalSpace(14),
                  _group('التفضيلات', [
                    _Row(
                      icon: Icons.language_outlined,
                      label: 'لغة التطبيق',
                      trailing: Text(
                        isArabic ? 'العربية' : 'English',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.primary,
                        ),
                      ),
                      onTap: _openLanguageSheet,
                    ),
                  ]),
                  verticalSpace(14),
                  _group('عن التطبيق', [
                    _Row(
                      icon: Icons.info_outline,
                      label: 'من نحن',
                      onTap: () => Navigator.pushNamed(context, Routes.aboutUsRoute),
                    ),
                    _Row(
                      icon: Icons.privacy_tip_outlined,
                      label: 'سياسة الخصوصية',
                      onTap: () => Navigator.pushNamed(context, Routes.privacyRoute),
                    ),
                  ]),
                  verticalSpace(14),
                  // === حذف الحساب مخفي داخل هذي الصفحة
                  _group('متقدّم', [
                    _Row(
                      icon: Icons.manage_accounts_outlined,
                      label: 'إعدادات الحساب',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => di<DeleteAccountCubit>(),
                            child: const AccountSettingsView(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  verticalSpace(20),
                  _logoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Text(
            'الإعدادات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _group(String title, List<_Row> rows) {
    return Container(
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
          ...List.generate(rows.length, (i) {
            final row = rows[i];
            return Column(
              children: [
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.only(right: 60.w),
                    child: Divider(height: 1, color: const Color(0xFFF2F4F7)),
                  ),
                InkWell(
                  onTap: row.onTap,
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
                          child: Icon(row.icon,
                              size: 18.sp, color: ColorManager.primary),
                        ),
                        SizedBox(width: 13.w),
                        Expanded(
                          child: Text(
                            row.label,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ),
                        if (row.trailing != null) row.trailing!,
                        SizedBox(width: 6.w),
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

  Widget _logoutButton() {
    return GestureDetector(
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
            Text('تسجيل الخروج',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF04438),
                )),
          ],
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
      builder: (sheetContext) => SafeArea(
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
              Text('لغة التطبيق',
                  style: TextStyle(
                      fontSize: 15.sp, fontWeight: FontWeight.w700)),
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

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('متأكد إنك تبي تسجّل خروج؟'),
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

class _Row {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  _Row({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });
}
