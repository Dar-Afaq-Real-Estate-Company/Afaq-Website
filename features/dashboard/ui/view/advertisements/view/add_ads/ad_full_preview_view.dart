import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helper/amenity_icons.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../logic/home_cubit.dart';

/// معاينة كاملة لشكل الإعلان بعد النشر — نفس تخطيط صفحة تفاصيل العقار
/// الحقيقية (صورة + بطاقة منزلقة + مواصفات ومرافق ووصف)، لكن تُقرأ
/// بياناتها مباشرة من نموذج الإضافة الحالي قبل إرساله للسيرفر.
class AdFullPreviewView extends StatelessWidget {
  final String? transactionType;
  final String? categoryName;

  const AdFullPreviewView({super.key, this.transactionType, this.categoryName});

  bool get _isExchange => (transactionType ?? '').contains('بدل');
  bool get _isRent => (transactionType ?? '').contains('إيجار');

  String _priceText(AddAdvertisementCubit cubit) {
    if (_isExchange) return 'للبدل';
    final price = cubit.priceController.text.trim();
    if (price.isEmpty) return '—';
    return _isRent ? '$price د.ك/شهرياً' : '$price د.ك';
  }

  List<String> _amenityLabels(AddAdvertisementCubit cubit) {
    final list = <String>[];
    if (cubit.hasPool) list.add('مسبح');
    if (cubit.hasGarden) list.add('حديقة');
    if (cubit.hasParking) list.add('مواقف للسيارات');
    for (final a in cubit.amenities) {
      if (cubit.selectedAmenityIds.contains(a.id)) {
        final name = a.name?.toString();
        if (name != null && name.isNotEmpty) list.add(name);
      }
    }
    return list;
  }

  List<(String, String, IconData)> _specs(AddAdvertisementCubit cubit) {
    final list = <(String, String, IconData)>[];
    void add(String label, String value, IconData icon) {
      final v = value.trim();
      if (v.isEmpty || v == '0') return;
      list.add((label, v, icon));
    }
    add('الغرف', cubit.roomsController.text, Icons.bed_outlined);
    add('الحمامات', cubit.bathroomsController.text, Icons.bathtub_outlined);
    final area = cubit.areaController.text.trim();
    if (area.isNotEmpty && area != '0') list.add(('المساحة', '$area م²', Icons.crop_free));
    add('الطوابق', cubit.floorsCountController.text, Icons.layers_outlined);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddAdvertisementCubit>();
    final typeLine = [
      (transactionType ?? '').replaceAll('عقارات ', '').replaceAll('عقار ', '').replaceAll('لل', ''),
      if ((cubit.selectedPropertyType ?? '').isNotEmpty) cubit.selectedPropertyType!,
    ].join(' | ');
    final specs = _specs(cubit);
    final amenities = _amenityLabels(cubit);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280.h,
                  width: double.infinity,
                  child: cubit.selectedImage != null
                      ? Image.file(cubit.selectedImage!, fit: BoxFit.cover)
                      : Container(color: const Color(0xFFF2F4F7), child: Icon(Icons.home_work_outlined, size: 60.sp, color: ColorManager.grey)),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: Offset(0, -28.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, -6))],
                    ),
                    padding: EdgeInsets.fromLTRB(18.w, 26.h, 18.w, 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 44.w,
                            height: 4.5.h,
                            margin: EdgeInsets.only(bottom: 18.h),
                            decoration: BoxDecoration(color: const Color(0xFFE4E7EC), borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_priceText(cubit), style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w900, color: ColorManager.primary)),
                                  verticalSpace(5),
                                  Row(
                                    children: [
                                      Container(width: 7.w, height: 7.w, decoration: const BoxDecoration(color: Color(0xFFF5A524), shape: BoxShape.circle)),
                                      SizedBox(width: 6.w),
                                      Text(typeLine, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF101828))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                              decoration: BoxDecoration(color: const Color(0xFFFEF3F2), borderRadius: BorderRadius.circular(7.r)),
                              child: Text('عند النشر', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFFE53935))),
                            ),
                          ],
                        ),
                        verticalSpace(14),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                          decoration: BoxDecoration(color: const Color(0xFFF7F9F9), borderRadius: BorderRadius.circular(12.r)),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 16.sp, color: ColorManager.primary),
                              SizedBox(width: 6.w),
                              Expanded(child: Text(cubit.selectedRegion ?? '', maxLines: 2, style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF475467)))),
                            ],
                          ),
                        ),
                        verticalSpace(16),
                        if (specs.isNotEmpty) ...[
                          Wrap(spacing: 8.w, runSpacing: 8.h, children: specs.map((s) => _pill(s)).toList()),
                          verticalSpace(16),
                        ],
                        if (amenities.isNotEmpty) ...[
                          Wrap(spacing: 8.w, runSpacing: 8.h, children: amenities.map(_chip).toList()),
                          verticalSpace(16),
                        ],
                        if (cubit.titleController.text.trim().isNotEmpty) ...[
                          Text(cubit.titleController.text.trim(), style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
                          verticalSpace(10),
                        ],
                        if (cubit.descriptionController.text.trim().isNotEmpty) ...[
                          Text('الوصف', style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
                          verticalSpace(7),
                          Text(cubit.descriptionController.text.trim(), style: TextStyle(fontSize: 13.5.sp, height: 1.8, color: const Color(0xFF475467))),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 14.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward, size: 21.sp, color: const Color(0xFF344054)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill((String, String, IconData) spec) => Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: const Color(0xFFE4E7EC), width: 1.4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(spec.$3, size: 13.5.sp, color: ColorManager.primary),
            SizedBox(width: 5.w),
            Text(spec.$2, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
            SizedBox(width: 3.w),
            Text(spec.$1, style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF475467))),
          ],
        ),
      );

  Widget _chip(String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        decoration: BoxDecoration(color: const Color(0xFFEDF5F4), borderRadius: BorderRadius.circular(9.r)),
        child: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: ColorManager.primary)),
      );
}
