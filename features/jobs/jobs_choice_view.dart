import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/routing/routes.dart';

/// شاشة اختيار نوع خدمة الوظائف: "وظائف شاغرة" (لأصحاب العمل) أو
/// "باحث عن عمل" (للأفراد) - نفس فكرة "الفنادق والشقق" بالتصميم.
class JobsChoiceView extends StatelessWidget {
  const JobsChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('وظائف'),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'اختر الخدمة اللي تناسبك',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorManager.grey, fontSize: 13.sp),
            ),
            verticalSpace(20),
            _ChoiceCard(
              icon: Icons.work_outline,
              title: 'انشر وظيفة',
              subtitle: 'لأصحاب العمل - انشر وظيفة تبيها',
              iconBgColor: ColorManager.primary.withOpacity(0.1),
              iconColor: ColorManager.primary,
              onTap: () => Navigator.pushNamed(context, Routes.jobVacancyRoute),
            ),
            verticalSpace(14),
            _ChoiceCard(
              icon: Icons.search,
              title: 'وظيفة شاغرة',
              subtitle: 'تصفح الوظائف الشاغرة المتاحة',
              iconBgColor: Colors.green.withOpacity(0.1),
              iconColor: Colors.green.shade700,
              onTap: () =>
                  Navigator.pushNamed(context, Routes.jobVacanciesBrowseRoute),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(color: ColorManager.lighterGray),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                  verticalSpace(2),
                  Text(subtitle,
                      style: TextStyle(color: ColorManager.grey, fontSize: 12.sp)),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_left, color: ColorManager.grey),
          ],
        ),
      ),
    );
  }
}
