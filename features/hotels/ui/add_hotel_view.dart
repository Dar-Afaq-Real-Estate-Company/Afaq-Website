import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/subscription_gate_button.dart';
import '../../../core/widgets/region_picker_sheet.dart';
import '../../../core/widgets/location_picker_view.dart';
import '../data/hotel_model.dart';
import '../logic/hotels_cubit.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/publish_success_view.dart';
import 'hotel_preview_view.dart';

class AddHotelView extends StatelessWidget {
  const AddHotelView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddHotelCubit(),
      child: BlocConsumer<AddHotelCubit, AddHotelState>(
        listener: (context, state) {
          if (state is AddHotelSuccess) {
            showPublishSuccessThenGoToMyAds(context, title: 'تم إضافة الفندق بنجاح');
          }
          if (state is AddHotelFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddHotelCubit>();
          final loading = state is AddHotelSubmitting;
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7F7),
            body: SafeArea(
              child: Column(children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(26.r)),
                  ),
                  child: Row(children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp)),
                    SizedBox(width: 12.w),
                    Text('أضف فندقك', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('اسم الفندق'),
                      AppTextFormField(hintText: 'مثال: فندق الخليج', onChanged: (v) => cubit.name = v, validator: (v) => null),
                      SizedBox(height: 14.h),

                      _label('المنطقة'),
                      GestureDetector(
                        onTap: () async {
                          final regions = ['حولي', 'السالمية', 'الجهراء', 'الفروانية', 'الأحمدي', 'مبارك الكبير'];
                          final selected = await showRegionPickerSheet(context, regions: regions, current: cubit.region.isEmpty ? null : cubit.region);
                          if (selected != null) {
                            cubit.region = selected;
                            (context as Element).markNeedsBuild();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                          decoration: BoxDecoration(color: ColorManager.lighterGray, borderRadius: BorderRadius.circular(12.r)),
                          child: Text(cubit.region.isEmpty ? 'اختر المنطقة' : cubit.region, style: TextStyle(fontSize: 14.sp, color: cubit.region.isEmpty ? ColorManager.grey : Colors.black87)),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      _label('الموقع على الخريطة'),
                      GestureDetector(
                        onTap: () async {
                          final picked = await Navigator.push<LatLng>(context, MaterialPageRoute(builder: (_) => LocationPickerView(initialLocation: cubit.latitude != null ? LatLng(cubit.latitude!, cubit.longitude!) : null)));
                          if (picked != null) {
                            cubit.latitude = picked.latitude;
                            cubit.longitude = picked.longitude;
                            (context as Element).markNeedsBuild();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 80.h,
                          decoration: BoxDecoration(color: cubit.latitude != null ? ColorManager.primary.withOpacity(0.08) : ColorManager.lighterGray, borderRadius: BorderRadius.circular(12.r)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.location_on, color: ColorManager.primary),
                            SizedBox(width: 8.w),
                            Text(cubit.latitude != null ? 'تم تحديد الموقع ✓' : 'حدد موقع الفندق على الخريطة', style: TextStyle(fontSize: 13.sp, color: cubit.latitude != null ? ColorManager.primary : ColorManager.grey)),
                          ]),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              cubit.hasSuites = !cubit.hasSuites;
                              (context as Element).markNeedsBuild();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              decoration: BoxDecoration(
                                color: cubit.hasSuites ? ColorManager.primary.withOpacity(0.08) : ColorManager.lighterGray,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(cubit.hasSuites ? Icons.check_box : Icons.check_box_outline_blank, color: cubit.hasSuites ? ColorManager.primary : ColorManager.grey, size: 18.sp),
                                SizedBox(width: 6.w),
                                Text('الفندق يحتوي على أجنحة', style: TextStyle(fontSize: 12.5.sp, color: cubit.hasSuites ? ColorManager.primary : Colors.black87)),
                              ]),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: 14.h),

                      _label('المميزات'),
                      SizedBox(height: 8.h),
                      Wrap(spacing: 8.w, runSpacing: 8.h, children: HotelAmenities.options.entries.map((e) => _toggleChip(e.value['label'] as String, cubit.amenities.contains(e.key), () {
                            cubit.amenities.contains(e.key) ? cubit.amenities.remove(e.key) : cubit.amenities.add(e.key);
                            (context as Element).markNeedsBuild();
                          })).toList()),
                      SizedBox(height: 14.h),

                      _label('الإطلالة'),
                      SizedBox(height: 8.h),
                      Wrap(spacing: 8.w, runSpacing: 8.h, children: HotelViews.options.entries.map((e) => _toggleChip(e.value['label'] as String, cubit.views.contains(e.key), () {
                            cubit.views.contains(e.key) ? cubit.views.remove(e.key) : cubit.views.add(e.key);
                            (context as Element).markNeedsBuild();
                          })).toList()),
                      SizedBox(height: 14.h),

                      _label('رقم الهاتف'),
                      AppTextFormField(hintText: '99999999', keyboardType: TextInputType.phone, onChanged: (v) => cubit.phone = v, validator: (v) => null),
                      SizedBox(height: 14.h),

                      _label('سعر الليلة للغرفة (د.ك)'),
                      AppTextFormField(hintText: '35', keyboardType: TextInputType.number, onChanged: (v) => cubit.roomPrice = v, validator: (v) => null),
                      SizedBox(height: 14.h),

                      if (cubit.hasSuites) ...[
                        _label('سعر الليلة للجناح (د.ك)'),
                        AppTextFormField(hintText: '55', keyboardType: TextInputType.number, onChanged: (v) => cubit.suitePrice = v, validator: (v) => null),
                        SizedBox(height: 14.h),
                      ],

                      _label('الوصف'),
                      AppTextFormField(hintText: 'اكتب وصف مختصر عن الفندق...', onChanged: (v) => cubit.description = v, validator: (v) => null),
                      SizedBox(height: 14.h),

                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickMultiImage(imageQuality: 70, maxWidth: 1280);
                          for (final p in picked.take(6 - cubit.images.length)) {
                            cubit.images.add(File(p.path));
                          }
                          (context as Element).markNeedsBuild();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(border: Border.all(color: ColorManager.lightGrey), borderRadius: BorderRadius.circular(12.r)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.add_photo_alternate_outlined, color: ColorManager.primary),
                            SizedBox(width: 8.w),
                            Text('إضافة صور (${cubit.images.length}/6 - بحد أدنى 3)', style: TextStyle(color: ColorManager.primary)),
                          ]),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      SubscriptionGateButton(
                        buttonText: loading ? 'جاري النشر...' : 'نشر الفندق',
                        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                        onPublish: () {
                          if (cubit.name.isEmpty || cubit.region.isEmpty || cubit.phone.isEmpty || cubit.roomPrice.isEmpty || cubit.images.length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة وإضافة 3 صور على الأقل')));
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HotelPreviewView(cubit: cubit, onPublish: () => cubit.submit()),
                            ),
                          );
                        },
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) => Text(text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600));

  Widget _toggleChip(String label, bool selected, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: selected ? ColorManager.primary.withOpacity(0.1) : Colors.white, border: Border.all(color: selected ? ColorManager.primary : ColorManager.lightGrey), borderRadius: BorderRadius.circular(20)),
          child: Text(label, style: TextStyle(fontSize: 12, color: selected ? ColorManager.primary : ColorManager.grey)),
        ),
      );
}
