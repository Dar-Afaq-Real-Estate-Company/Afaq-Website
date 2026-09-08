import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import 'property_list_view.dart';

/// خطوة الدخول لقسم "عقار": يجيب التصنيفات وأنواعها من لوحة الإدارة
/// (API)، يختار التصنيف (سكني/تجاري/استثماري/صناعي...) ثم نوع المعاملة
/// (بيع/إيجار/بدل)، وبعدها يوديه لصفحة الاستعراض مفلترة بأنواع العقار
/// الخاصة بهذا التصنيف فقط.
class RealEstateCategoryEntryView extends StatefulWidget {
  const RealEstateCategoryEntryView({super.key});

  @override
  State<RealEstateCategoryEntryView> createState() => _RealEstateCategoryEntryViewState();
}

class _RealEstateCategoryEntryViewState extends State<RealEstateCategoryEntryView> {
  static const List<String> _transactionTypes = [
    'عقارات للبيع',
    'عقارات للإيجار',
    'عقار للبدل',
  ];

  late List<Map<String, dynamic>> _categories;
  Map<String, dynamic>? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categories = _fallbackCategories;
  }

  static const List<Map<String, dynamic>> _fallbackCategories = [
    {'name': 'سكني', 'icon': 'home_outlined', 'types': ['شقة', 'بيت', 'دور', 'فيلا', 'عمارة', 'دوبلكس', 'استوديو']},
    {'name': 'تجاري', 'icon': 'storefront_outlined', 'types': ['محل', 'مكتب', 'معرض', 'مخزن', 'أرض تجارية', 'شقة تجارية', 'دور تجاري', 'مبنى تجاري']},
    {'name': 'استثماري', 'icon': 'trending_up_outlined', 'types': ['شقق استثمارية', 'عمارة استثمارية', 'أرض استثمارية', 'مجمع استثماري']},
    {'name': 'صناعي', 'icon': 'factory_outlined', 'types': ['مصنع', 'أرض صناعية', 'مستودع صناعي', 'ورشة']},
  ];

  IconData _iconFor(String? key) {
    switch (key) {
      case 'storefront_outlined':
        return Icons.storefront_outlined;
      case 'trending_up_outlined':
        return Icons.trending_up_outlined;
      case 'factory_outlined':
        return Icons.factory_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('عقار'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedCategory = null),
              )
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: _selectedCategory == null
            ? _buildCategoryStep(_categories)
            : _buildTransactionStep(),
      ),
    );
  }

  void _pickTransaction(String transactionType) {
    final types = (_selectedCategory!['types'] as List).cast<String>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyListView(
          initialTransactionType: transactionType,
          allowedPropertyTypes: types,
        ),
      ),
    );
  }

  Widget _buildCategoryStep(List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر تصنيف العقار',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        verticalSpace(20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 1.05,
            children: categories.map((c) {
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = c),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: ColorManager.lighterGray),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: ColorManager.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_iconFor(c['icon'] as String?),
                            color: ColorManager.primary, size: 28.sp),
                      ),
                      verticalSpace(12),
                      Text(c['name'] as String? ?? '',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('عقار ${_selectedCategory!['name']}',
            style: TextStyle(fontSize: 14.sp, color: ColorManager.grey)),
        verticalSpace(6),
        Text('اختر نوع المعاملة',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        verticalSpace(20),
        ..._transactionTypes.map((t) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: () => _pickTransaction(t),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: ColorManager.lighterGray),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                    Icon(Icons.arrow_forward_ios, size: 14.sp, color: ColorManager.grey),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
