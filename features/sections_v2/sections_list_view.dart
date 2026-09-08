import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/home_selection_notifier.dart';
import '../../core/helper/onboarding_keys.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/routing/routes.dart';
import '../dashboard/ui/widgets/category/category_items_widget.dart';
import 'models/section_item_model.dart';

// === قائمة "الأقسام" الجديدة (حسب الطلب) - كل قسم له صفحة مستقلة تمامًا
// القائمة القديمة (sectionServicesList بملف section_services.dart) باقية
// بدون حذف، بس غير مستخدمة بالصفحة الرئيسية حالياً.
final List<SectionItemModel> newSectionsList = [
  const SectionItemModel(
    labelKey: 'section_real_estate',
    icon: Icons.home_work_outlined,
    route: Routes.realEstateSectionRoute,
    color: Color(0xFF2E6D71),
  ),
  const SectionItemModel(
    labelKey: 'section_contracting',
    icon: Icons.engineering_outlined,
    route: Routes.contractingSectionRoute,
    color: Color(0xFFE8934A),
  ),
  const SectionItemModel(
    labelKey: 'section_jobs',
    icon: Icons.work_outline,
    route: Routes.jobsSectionRoute,
    color: Color(0xFF3E7CB1),
  ),
  const SectionItemModel(
    labelKey: 'section_real_estate_companies',
    icon: Icons.business_outlined,
    route: Routes.realEstateCompaniesSectionRoute,
    color: Color(0xFF8B5FBF),
  ),
  const SectionItemModel(
    labelKey: 'section_engineering_offices',
    icon: Icons.architecture_outlined,
    route: Routes.engineeringOfficesSectionRoute,
    color: Color(0xFFC0554B),
  ),
  const SectionItemModel(
    labelKey: 'section_hotels',
    icon: Icons.hotel_outlined,
    route: Routes.hotelsSectionRoute,
    color: Color(0xFF2C8C7A),
  ),
];

/// صف "الأقسام" بالصفحة الرئيسية - نفس شكل "خدماتنا" بالضبط (دوائر)
/// كل الأقسام تظهر مرة واحدة بدون تمرير - تلتف لسطر جديد عند الحاجة
class SectionsListView extends StatelessWidget {
  const SectionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLang = Localizations.localeOf(context).languageCode;

    return ValueListenableBuilder<HomeSelection?>(
      valueListenable: HomeSelectionNotifier.selected,
      builder: (context, selection, _) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            mainAxisExtent: 94.h,
          ),
          itemCount: newSectionsList.length,
          itemBuilder: (context, i) {
            final section = newSectionsList[i];
            final String localizedLabel =
                AppStrings.getString(section.labelKey, currentLang);
            return StaggeredEntrance(
              index: i,
              baseDelay: const Duration(milliseconds: 180),
              child: SectionCardItem(
                key: OnboardingKeys.sectionKey(section.labelKey),
                label: localizedLabel,
                icon: section.icon,
                color: section.color,
                onTap: () {
                  AuthGuard.runAction(context, onAuthenticated: () {
                    context.pushNamed(section.route);
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
