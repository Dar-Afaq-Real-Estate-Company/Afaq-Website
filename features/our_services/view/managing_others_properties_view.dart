import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/routing/routes.dart';

/// مدخل خدمة إدارة الأملاك — يختار المستخدم دوره:
/// مالك (يسلّم عقاره ويتابع دخله) أو مستأجر (يتابع عقده ويطلب صيانة)
class ManagingOthersPropertiesView extends StatelessWidget {
  const ManagingOthersPropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 22.sp),
                      ),
                      horizontalSpace(12),
                      Text('pm_title'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  verticalSpace(10),
                  Padding(
                    padding: EdgeInsets.only(right: 34.w),
                    child: Text(
                      'pm_intro'.tr(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 12.5.sp,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                children: [
                  Text('pm_choose_role'.tr(),
                      style:
                          TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900)),
                  verticalSpace(14),
                  _roleCard(
                    context,
                    icon: Icons.home_work_outlined,
                    title: 'pm_i_am_owner'.tr(),
                    subtitle: 'pm_owner_sub'.tr(),
                    color: ColorManager.primary,
                    route: Routes.ownerPortfolioRoute,
                  ),
                  verticalSpace(12),
                  _roleCard(
                    context,
                    icon: Icons.person_outline,
                    title: 'pm_i_am_tenant'.tr(),
                    subtitle: 'pm_tenant_sub'.tr(),
                    color: const Color(0xFF1E5FBF),
                    route: Routes.tenantHomeRoute,
                  ),
                  verticalSpace(26),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFEDEFF3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('pm_why'.tr(),
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w700)),
                        verticalSpace(14),
                        _benefit(Icons.payments_outlined, 'pm_benefit_1'.tr()),
                        _benefit(Icons.build_outlined, 'pm_benefit_2'.tr()),
                        _benefit(Icons.description_outlined, 'pm_benefit_3'.tr()),
                        _benefit(Icons.notifications_active_outlined, 'pm_benefit_4'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEDEFF3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(icon, size: 23.sp, color: color),
            ),
            horizontalSpace(13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
                  verticalSpace(4),
                  Text(subtitle,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF667085),
                        height: 1.6,
                      )),
                ],
              ),
            ),
            Icon(Icons.chevron_left, size: 21.sp, color: const Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }

  Widget _benefit(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: ColorManager.primary),
          horizontalSpace(10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF475467),
                  height: 1.7,
                )),
          ),
        ],
      ),
    );
  }
}
