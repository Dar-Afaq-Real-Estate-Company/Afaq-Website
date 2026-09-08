import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/subscription_gate_button.dart';

/// معاينة إعلان "مقاولة" قبل النشر — البطاقة المصغّرة مطابقة لبطاقة
/// قائمة المقاولين، وصفحة "التفاصيل" مطابقة لصفحة تفاصيل المقاول
/// الحقيقية بعد النشر بالضبط.
class ContractingPreviewView extends StatelessWidget {
  final String? logoPath;
  final String category;
  final String region;
  final String name;
  final String phone;
  final String bio;
  final VoidCallback onPublish;

  const ContractingPreviewView({
    super.key,
    this.logoPath,
    required this.category,
    required this.region,
    required this.name,
    required this.phone,
    required this.bio,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      appBar: AppBar(title: const Text('معاينة الإعلان'), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 38.r,
                      backgroundColor: ColorManager.primary.withOpacity(0.08),
                      backgroundImage: logoPath != null ? FileImage(File(logoPath!)) : null,
                      child: logoPath == null ? Icon(Icons.handyman_outlined, color: ColorManager.primary, size: 32.sp) : null,
                    ),
                    verticalSpace(12),
                    Text(name.isEmpty ? '—' : name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp)),
                    verticalSpace(6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(20.r)),
                      child: Text(category, style: TextStyle(fontSize: 11.5.sp, color: ColorManager.primary, fontWeight: FontWeight.w600)),
                    ),
                    verticalSpace(10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.location_on_outlined, size: 14.sp, color: ColorManager.grey),
                      SizedBox(width: 4.w),
                      Text(region, style: TextStyle(fontSize: 11.5.sp, color: ColorManager.grey)),
                    ]),
                    verticalSpace(14),
                    Divider(color: const Color(0xFFF0F2F1), height: 1),
                    verticalSpace(14),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.phone_outlined, size: 15.sp, color: ColorManager.grey),
                      SizedBox(width: 6.w),
                      Text(phone.isEmpty ? '—' : phone, style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF475467))),
                    ]),
                    if (bio.trim().isNotEmpty) ...[
                      verticalSpace(12),
                      Text(bio.trim(), textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, height: 1.6, color: const Color(0xFF667085))),
                    ],
                  ],
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ContractingFullPreview(logoPath: logoPath, category: category, region: region, name: name, phone: phone, bio: bio))),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.h), side: BorderSide(color: ColorManager.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                child: Text('التفاصيل', style: TextStyle(color: ColorManager.primary)),
              ),
            ),
            horizontalSpace(8),
            Expanded(
              flex: 2,
              child: SubscriptionGateButton(buttonText: 'نشر', buttonHeight: 48.h, onPublish: onPublish),
            ),
          ]),
        ),
      );
}

/// نسخة طبق الأصل من صفحة تفاصيل المقاول (contractor_details_view.dart)
/// بنفس التخطيط والترتيب، لكن للمعاينة قبل النشر فقط.
class _ContractingFullPreview extends StatelessWidget {
  final String? logoPath;
  final String category;
  final String region;
  final String name;
  final String phone;
  final String bio;

  const _ContractingFullPreview({this.logoPath, required this.category, required this.region, required this.name, required this.phone, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(title: Text(name.isEmpty ? '—' : name), backgroundColor: ColorManager.white, elevation: 0, foregroundColor: ColorManager.black),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55.r,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: logoPath != null ? FileImage(File(logoPath!)) : null,
                    child: logoPath == null ? Icon(Icons.handyman_outlined, color: ColorManager.grey, size: 44.sp) : null,
                  ),
                  verticalSpace(10),
                  Text(name.isEmpty ? '—' : name, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  verticalSpace(4),
                  Text(category, style: TextStyle(fontSize: 13.sp, color: ColorManager.grey)),
                  verticalSpace(6),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.location_on_outlined, size: 14.sp, color: ColorManager.grey),
                    SizedBox(width: 4.w),
                    Text(region, style: TextStyle(fontSize: 12.sp, color: ColorManager.grey)),
                  ]),
                ],
              ),
            ),
            verticalSpace(24),
            Divider(color: ColorManager.lighterGray),
            verticalSpace(16),
            Text('نبذة عن الأعمال السابقة', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            verticalSpace(8),
            Text(bio.isEmpty ? '—' : bio, style: TextStyle(fontSize: 13.5.sp, color: Colors.black87, height: 1.6)),
            verticalSpace(28),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: ColorManager.black, minimumSize: Size.fromHeight(52.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('هذا مثال للمعاينة، سيعمل الزر بعد نشر الإعلان'))),
              icon: const Icon(Icons.work_outline, color: Colors.white),
              label: const Text('اطلب الخدمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
