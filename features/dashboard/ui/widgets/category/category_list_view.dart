import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/routing/routes.dart';
import 'category_items_widget.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  // Menu items for the horizontal scroller (same as previous example)
  final List<Map<String, dynamic>> _menuItems = [
    {
      'label': "request_property",
      'icon': Icons.home_work_outlined,
      'index': 0,
      'route': Routes.propertyRequestRoute,
      'color': const Color(0xFF2E9E6D),
    },
    {
      'label': "property_mgmt",
      'icon': Icons.apartment,
      'index': 1,
      'route': Routes.managingOthersPropertiesRoute,
      'color': const Color(0xFF8B5FBF),
    },
    {
      'label': "consultation",
      'icon': Icons.support_agent,
      'index': 2,
      'route': Routes.realEstateConsultationRoute,
      'color': const Color(0xFFC0554B),
    },
    {
      'label': "valuation",
      'icon': Icons.calendar_month,
      'index': 3,
      'route': Routes.officialRequestRoute,
      'color': const Color(0xFF3E7CB1),
    },
    {
      'label': "rent_calc",
      'icon': Icons.request_quote_outlined,
      'index': 4,
      'route': Routes.calculateRentRoute,
      'color': const Color(0xFF2E6D71),
    },
    {
      'label': "build_calc",
      'icon': Icons.construction,
      'index': 5,
      'route': Routes.calculateConstructionCostRoute,
      'color': const Color(0xFFB54708),
    },
  ];

  final List<Map<String, dynamic>> _calcSubItems = [
    {
      'label': "rent_calc",
      'icon': Icons.request_quote_outlined,
      'route': Routes.calculateRentRoute,
    },
    {
      'label': "build_calc",
      'icon': Icons.construction,
      'route': Routes.calculateConstructionCostRoute,
    },
  ];

  int _selectedIndex = 0;

  void _showCalcSheet(BuildContext context, String currentLang) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'calc',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, __, ___) {
        return Opacity(
          opacity: anim.value,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 260.w,
                  padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calculate_outlined,
                          size: 30.sp, color: const Color(0xFF2E6D71)),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.getString('calc_group', currentLang),
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF101828)),
                      ),
                      SizedBox(height: 16.h),
                      ..._calcSubItems.map((item) {
                        final String label = AppStrings.getString(
                            item['label'] as String, currentLang);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              AuthGuard.runAction(context,
                                  onAuthenticated: () {
                                context.pushNamed(item['route'] as String);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 13.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E6D71).withOpacity(0.07),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: const Color(0xFF2E6D71)
                                        .withOpacity(0.25)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item['icon'] as IconData,
                                      size: 18.sp,
                                      color: const Color(0xFF2E6D71)),
                                  SizedBox(width: 8.w),
                                  Text(
                                    label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2E6D71),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 8.h,
        mainAxisExtent: 118.h,
      ),
      itemCount: _menuItems.length,
      itemBuilder: (context, i) {
        final category = _menuItems[i];
        final String localizedLabel = AppStrings.getString(
          category['label'] as String,
          currentLang,
        );
        final bool isCalc = category['isCalcGroup'] == true;
        return StaggeredEntrance(
          index: i,
          child: ServiceCardItem(
            label: localizedLabel,
            icon: category['icon'] as IconData,
            color: category['color'] as Color?,
            onTap: () {
              if (isCalc) {
                _showCalcSheet(context, currentLang);
                return;
              }
              AuthGuard.runAction(context, onAuthenticated: () {
                if (category['route'] != null) {
                  context.pushNamed(category['route'] as String);
                }
              });
            },
          ),
        );
      },
    );
  }
}
