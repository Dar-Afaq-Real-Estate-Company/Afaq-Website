import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/routing/routes.dart';

class ContractingCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ContractingCategory({required this.name, required this.icon, required this.color});
}

/// صفحة "مقاولات" - شبكة أقسام + بحث يفلتر مباشرة + زر إضافة صغير جنب البحث
class ContractingCategoriesView extends StatefulWidget {
  const ContractingCategoriesView({super.key});

  @override
  State<ContractingCategoriesView> createState() =>
      _ContractingCategoriesViewState();
}

class _ContractingCategoriesViewState extends State<ContractingCategoriesView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<ContractingCategory> _allCategories = [
    ContractingCategory(name: 'الأقفال', icon: Icons.lock_outline, color: Color(0xFF6B7A99)),
    ContractingCategory(name: 'مقاول صحي', icon: Icons.plumbing, color: Color(0xFF4C8C8B)),
    ContractingCategory(name: 'تسليك مجاري', icon: Icons.water_damage_outlined, color: Color(0xFF5A93A8)),
    ContractingCategory(name: 'مكافحة الحشرات', icon: Icons.pest_control_outlined, color: Color(0xFF8B7355)),
    ContractingCategory(name: 'صيانة أجهزة منزلية', icon: Icons.kitchen_outlined, color: Color(0xFF7C7C9E)),
    ContractingCategory(name: 'أعمال الديكور', icon: Icons.wallpaper_outlined, color: Color(0xFFA0708A)),
    ContractingCategory(name: 'أصباغ', icon: Icons.format_paint_outlined, color: Color(0xFFB08968)),
    ContractingCategory(name: 'التكييف', icon: Icons.ac_unit_outlined, color: Color(0xFF5B8FA8)),
    ContractingCategory(name: 'نجار', icon: Icons.carpenter_outlined, color: Color(0xFF9C7A54)),
    ContractingCategory(name: 'حدادة', icon: Icons.construction_outlined, color: Color(0xFF7A7268)),
    ContractingCategory(name: 'مقاول كهرباء', icon: Icons.electrical_services_outlined, color: Color(0xFFAB8A3F)),
    ContractingCategory(name: 'مشاتل وحدائق', icon: Icons.local_florist_outlined, color: Color(0xFF6E9B6E)),
    ContractingCategory(name: 'فني زجاج', icon: Icons.window_outlined, color: Color(0xFF5F92A0)),
    ContractingCategory(name: 'عازل', icon: Icons.layers_outlined, color: Color(0xFF7D8B99)),
    ContractingCategory(name: 'ألمنيوم', icon: Icons.view_agenda_outlined, color: Color(0xFF8A9199)),
    ContractingCategory(name: 'كاشي وسيراميك', icon: Icons.grid_view_outlined, color: Color(0xFF9C8768)),
    ContractingCategory(name: 'أعمال التهوية', icon: Icons.air_outlined, color: Color(0xFF6A9DB0)),
    ContractingCategory(name: 'مصاعد', icon: Icons.elevator_outlined, color: Color(0xFF71828C)),
    ContractingCategory(name: 'الأبواب', icon: Icons.sensor_door_outlined, color: Color(0xFF8C7A6B)),
    ContractingCategory(name: 'مقاولات بناء', icon: Icons.foundation_outlined, color: Color(0xFF7E8D6F)),
    ContractingCategory(name: 'مواد بناء', icon: Icons.inventory_2_outlined, color: Color(0xFF8F8365)),
    ContractingCategory(name: 'منتجات زراعية', icon: Icons.grass_outlined, color: Color(0xFF6F9B71)),
    ContractingCategory(name: 'خزانات مياه', icon: Icons.water_drop_outlined, color: Color(0xFF5C93A3)),
  ];

  List<ContractingCategory> get _filtered {
    if (_query.trim().isEmpty) return _allCategories;
    return _allCategories
        .where((c) => c.name.contains(_query.trim()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('سادة المقاولين'),
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: ColorManager.grey, size: 20.sp),
                        horizontalSpace(8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: 'ابحث عن مقاولة...',
                              hintStyle: TextStyle(
                                  color: ColorManager.grey, fontSize: 13.sp),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            child: Icon(Icons.close,
                                color: ColorManager.grey, size: 18.sp),
                          ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(10),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, Routes.myServiceRequestsRoute),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.receipt_long_outlined,
                        color: ColorManager.primary, size: 18.sp),
                  ),
                ),
                horizontalSpace(10),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.addContractingRoute),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                  ),
                ),
              ],
            ),
            verticalSpace(20),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text('ما فيه نتائج مطابقة',
                          style: TextStyle(color: ColorManager.grey)))
                  : GridView.builder(
                      itemCount: _filtered.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final category = _filtered[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.contractorsListRoute,
                              arguments: category.name,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 52.w,
                                height: 52.w,
                                decoration: BoxDecoration(
                                  color: category.color.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(category.icon,
                                    color: category.color, size: 24.sp),
                              ),
                              verticalSpace(6),
                              Text(
                                category.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10.5.sp),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
