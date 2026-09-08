import 'package:afaq_real_estate/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afaq_real_estate/features/hotels/ui/add_hotel_view.dart';
import 'package:afaq_real_estate/core/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../real_estate/real_estate_category_entry_view.dart';
import '../services_grid.dart';

class SectionServices {
  final IconData icon;
  final String label;
  final String dbValue;

  final List<SubCategoryModel> subCategories;

  SectionServices({
    required this.label,
    required this.icon,
    required this.subCategories,
    required this.dbValue,
  });
}

List<SectionServices> get sectionServicesList => [
      SectionServices(
        icon: Icons.home_work_outlined,
        label: AppStrings.sectionRealEstate.tr(),
        dbValue: "عقار",
        subCategories: const [],
      ),
      SectionServices(
        icon: Icons.engineering,
        label: AppStrings.sectionContracting.tr(),
        dbValue: "سادة مقاولين",
        subCategories: const [],
      ),
      SectionServices(
        icon: Icons.work_outline,
        label: AppStrings.jobs.tr(),
        dbValue: "وظائف",
        subCategories: const [],
      ),
      SectionServices(
        icon: Icons.business,
        label: AppStrings.sectionRealEstateCompanies.tr(),
        dbValue: "شركات عقارية",
        subCategories: const [],
      ),
      SectionServices(
        icon: Icons.architecture,
        label: AppStrings.engineeringOffices.tr(),
        dbValue: "مكاتب هندسية",
        subCategories: const [],
      ),
      SectionServices(
        icon: Icons.hotel,
        label: AppStrings.hotels.tr(),
        dbValue: "فنادق",
        subCategories: const [],
      ),
    ];

Widget buildSectionItem(BuildContext context, SectionServices item,
    List<SubCategoryModel> subOptions) {
  return GestureDetector(
    onTap: () {
      switch (item.dbValue) {
        case 'عقار':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RealEstateCategoryEntryView()));
          break;
        case 'سادة مقاولين':
          Navigator.pushNamed(context, Routes.contractingSectionRoute);
          break;
        case 'وظائف':
          Navigator.pushNamed(context, Routes.jobsSectionRoute);
          break;
        case 'شركات عقارية':
          Navigator.pushNamed(context, Routes.realEstateCompaniesSectionRoute);
          break;
        case 'مكاتب هندسية':
          Navigator.pushNamed(context, Routes.engineeringOfficesSectionRoute);
          break;
        case 'فنادق':
          Navigator.pushNamed(context, Routes.hotelsSectionRoute);
          break;
      }
    },
    child: Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ColorManager.primary, width: 2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: ColorManager.primary.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, size: 24, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

// === لون ثابت لكل قسم (حسب اسمه) - يعطي تنوّع بصري خفيف بدل لون واحد للكل
Color _sectionColor(String label) {
  const palette = [
    Color(0xFF2E6D71),
    Color(0xFFB54708),
    Color(0xFF1570CD),
    Color(0xFF7A5AF8),
    Color(0xFFD92D20),
    Color(0xFF12B76A),
  ];
  final index = label.codeUnits.fold<int>(0, (a, b) => a + b) % palette.length;
  return palette[index];
}
