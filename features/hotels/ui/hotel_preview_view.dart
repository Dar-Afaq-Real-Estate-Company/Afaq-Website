import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/widgets/subscription_gate_button.dart';
import '../data/hotel_model.dart';
import '../logic/hotels_cubit.dart';

/// معاينة إعلان "فندق" قبل النشر — البطاقة المصغّرة مطابقة لبطاقة
/// قائمة الفنادق (_HotelCard)، وصفحة "التفاصيل" مطابقة لصفحة تفاصيل
/// الفندق الحقيقية (HotelDetailView) بعد النشر بالضبط.
class HotelPreviewView extends StatelessWidget {
  final AddHotelCubit cubit;
  final VoidCallback onPublish;

  const HotelPreviewView({super.key, required this.cubit, required this.onPublish});

  @override
  Widget build(BuildContext context) {
    final cover = cubit.images.isNotEmpty ? cubit.images.first : null;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(title: const Text('معاينة الفندق'), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: ColorManager.lighterGray)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Stack(children: [
                      SizedBox(
                        height: 190.h,
                        width: double.infinity,
                        child: cover != null
                            ? Image.file(cover, fit: BoxFit.cover)
                            : Container(color: ColorManager.lighterGray, child: Icon(Icons.hotel, size: 44.sp, color: ColorManager.grey)),
                      ),
                      Positioned(top: 10.h, right: 10.w, child: CircleAvatar(radius: 16.r, backgroundColor: Colors.white, child: Icon(Icons.favorite_border, color: Colors.red, size: 16.sp))),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(cubit.name.isEmpty ? '—' : cubit.name, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4.h),
                        Row(children: [
                          Icon(Icons.location_on, size: 14.sp, color: ColorManager.primary),
                          SizedBox(width: 4.w),
                          Text(cubit.region.isEmpty ? '—' : cubit.region, style: TextStyle(fontSize: 12.5.sp, color: ColorManager.grey)),
                        ]),
                        if (cubit.amenities.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            children: cubit.amenities.take(3).map((k) {
                              final label = HotelAmenities.options[k]?['label'] as String? ?? k;
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(color: ColorManager.lighterGray, borderRadius: BorderRadius.circular(10.r)),
                                child: Text(label, style: TextStyle(fontSize: 10.5.sp, color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ],
                        SizedBox(height: 10.h),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                            decoration: BoxDecoration(color: ColorManager.primary, borderRadius: BorderRadius.circular(12.r)),
                            child: Text('التفاصيل', style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w700)),
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('${cubit.roomPrice.isEmpty ? '0' : cubit.roomPrice} د.ك', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: ColorManager.primary)),
                            Text('/ الليلة', style: TextStyle(fontSize: 10.5.sp, color: ColorManager.grey)),
                          ]),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          _bottomBar(context),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.h), side: BorderSide(color: Colors.grey.shade400), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                child: const Text('رجوع'),
              ),
            ),
            horizontalSpace(8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _HotelFullPreview(cubit: cubit))),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.h), side: BorderSide(color: ColorManager.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                child: Text('التفاصيل', style: TextStyle(color: ColorManager.primary)),
              ),
            ),
            horizontalSpace(8),
            Expanded(
              flex: 2,
              child: SubscriptionGateButton(buttonText: 'نشر الفندق', buttonHeight: 48.h, onPublish: onPublish),
            ),
          ]),
        ),
      );
}

Widget horizontalSpace(double w) => SizedBox(width: w);

/// نسخة طبق الأصل من صفحة تفاصيل الفندق (hotel_detail_view.dart)
class _HotelFullPreview extends StatelessWidget {
  final AddHotelCubit cubit;
  const _HotelFullPreview({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: cubit.images.isEmpty
                  ? Container(color: ColorManager.lighterGray, child: Icon(Icons.hotel, size: 60, color: ColorManager.grey))
                  : PageView.builder(
                      itemCount: cubit.images.length,
                      itemBuilder: (context, i) => Image.file(cubit.images[i], fit: BoxFit.cover),
                    ),
            ),
            Positioned(top: 46, right: 16, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_forward, color: Colors.black), onPressed: () => Navigator.pop(context)))),
            Positioned(bottom: 12, right: 16, child: Row(children: const [
              CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.share, size: 16, color: Colors.black54)),
              SizedBox(width: 8),
              CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.favorite_border, size: 16, color: Colors.red)),
            ])),
          ]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cubit.name.isEmpty ? '—' : cubit.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.location_on, size: 16, color: ColorManager.primary),
                const SizedBox(width: 4),
                Expanded(child: Text(cubit.region.isEmpty ? '—' : cubit.region, style: TextStyle(fontSize: 13, color: ColorManager.grey))),
              ]),
              const SizedBox(height: 16),
              const Text('أنواع الغرف والأسعار', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFFF7F8F9), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('غرفة عادية', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  Text('${cubit.roomPrice.isEmpty ? '0' : cubit.roomPrice} د.ك / الليلة', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: ColorManager.primary)),
                ]),
              ),
              if (cubit.hasSuites)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xFFF7F8F9), borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('جناح', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    Text('${cubit.suitePrice.isEmpty ? '0' : cubit.suitePrice} د.ك / الليلة', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: ColorManager.primary)),
                  ]),
                ),
              const SizedBox(height: 16),
              if (cubit.description.trim().isNotEmpty) ...[
                Text(cubit.description.trim(), style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87)),
                const SizedBox(height: 18),
              ],
              if (cubit.amenities.isNotEmpty) ...[
                const Text('المرافق والمميزات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: cubit.amenities.map((k) => _pill(HotelAmenities.options[k]?['label'] as String? ?? k)).toList()),
                const SizedBox(height: 16),
              ],
              if (cubit.views.isNotEmpty) ...[
                const Text('الإطلالة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: cubit.views.map((k) => _pill(HotelViews.options[k]?['label'] as String? ?? k)).toList()),
                const SizedBox(height: 16),
              ],
              const Text(
                'الحجز يتم مباشرة مع الفندق — تطبيق أفاق يعرض بيانات الفندق فقط ويسهّل التواصل، بدون معالجة حجز أو دفع داخل التطبيق.',
                style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3), height: 1.6),
              ),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
        child: SafeArea(
          top: false,
          child: Row(children: [
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(13)),
                alignment: Alignment.center,
                child: const Text('واتساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(color: ColorManager.primary, borderRadius: BorderRadius.circular(13)),
                alignment: Alignment.center,
                child: const Text('اتصال', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _pill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
        child: Text(label, style: TextStyle(fontSize: 12, color: ColorManager.primary)),
      );
}
