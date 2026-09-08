import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helper/amenity_icons.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../../../core/widgets/subscription_gate_button.dart';
import '../../../../../logic/home_cubit.dart';
import '../../widgets/add_ads/add_ads_BlocListener.dart';
import 'ad_full_preview_view.dart';

/// صفحة معاينة الإعلان قبل النشر — تعرض بطاقة مصغّرة بنفس شكل الإعلان
/// النهائي بالضبط، مع 3 أزرار: رجوع (تعديل)، التفاصيل (يفتح شكل الإعلان
/// الكامل كما يظهر بعد النشر)، ونشر (يتحقق من الاشتراك ثم ينشر فعليًا).
class AdPreviewView extends StatelessWidget {
  final String? transactionType;
  final String? categoryName;
  final double? latitude;
  final double? longitude;

  const AdPreviewView({
    super.key,
    this.transactionType,
    this.categoryName,
    this.latitude,
    this.longitude,
  });

  bool get _isExchange => (transactionType ?? '').contains('بدل');
  bool get _isRent => (transactionType ?? '').contains('إيجار');

  String _priceText(AddAdvertisementCubit cubit) {
    if (_isExchange) return 'للبدل';
    final price = cubit.priceController.text.trim();
    if (price.isEmpty) return '—';
    return _isRent ? '$price د.ك/شهرياً' : '$price د.ك';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddAdvertisementCubit>();
    final typeLine = [
      (transactionType ?? '').replaceAll('عقارات ', '').replaceAll('عقار ', '').replaceAll('لل', ''),
      if ((cubit.selectedPropertyType ?? '').isNotEmpty) cubit.selectedPropertyType!,
    ].join(' | ');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      appBar: AppBar(
        title: const Text('معاينة الإعلان'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 190.h,
                        width: double.infinity,
                        child: cubit.selectedImage != null
                            ? Image.file(cubit.selectedImage!, fit: BoxFit.cover)
                            : Container(
                                color: const Color(0xFFF2F4F7),
                                child: Icon(Icons.home_work_outlined, size: 44.sp, color: ColorManager.grey),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_priceText(cubit),
                                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: ColorManager.primary)),
                                      SizedBox(height: 4.h),
                                      Text(typeLine, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: const Color(0xFF101828))),
                                    ],
                                  ),
                                ),
                                if (categoryName != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                    decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10.r)),
                                    child: Text(categoryName!, style: TextStyle(fontSize: 11.sp, color: ColorManager.primary, fontWeight: FontWeight.w700)),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 15.sp, color: ColorManager.primary),
                                SizedBox(width: 5.w),
                                Expanded(child: Text(cubit.selectedRegion ?? '', style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF475467)))),
                              ],
                            ),
                            if (cubit.titleController.text.trim().isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              Text(cubit.titleController.text.trim(),
                                  style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: const Text('رجوع'),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: AdFullPreviewView(transactionType: transactionType, categoryName: categoryName),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        side: BorderSide(color: ColorManager.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text('التفاصيل', style: TextStyle(color: ColorManager.primary)),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    flex: 2,
                    child: SubscriptionGateButton(
                      buttonText: 'نشر',
                      buttonHeight: 48.h,
                      onPublish: () {
                        cubit.getAddAdvertisement(latitude: latitude, longitude: longitude);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const AddAdsBloclistener(),
        ],
      ),
    );
  }
}
