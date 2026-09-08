import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/subscription_gate_button.dart';

/// معاينة إعلان "وظيفة شاغرة" قبل النشر — البطاقة المصغّرة مطابقة
/// لبطاقة قائمة الوظائف، وصفحة "التفاصيل" مطابقة لصفحة تفاصيل
/// الوظيفة الحقيقية بعد النشر بالضبط.
class JobVacancyPreviewView extends StatelessWidget {
  final String title;
  final String profession;
  final String employmentType;
  final String region;
  final String salary;
  final String description;
  final String phone;
  final String email;
  final VoidCallback onPublish;

  const JobVacancyPreviewView({
    super.key,
    required this.title,
    required this.profession,
    required this.employmentType,
    required this.region,
    required this.salary,
    required this.description,
    required this.phone,
    this.email = '',
    required this.onPublish,
  });

  String get _initials {
    final words = title.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '؟';
    if (words.length == 1) return words.first.characters.take(2).toString();
    return '${words[0].characters.first}${words[1].characters.first}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      appBar: AppBar(title: const Text('معاينة الوظيفة'), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: const Color(0xFFEDEFF3)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 46.w,
                          height: 46.w,
                          decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.10), borderRadius: BorderRadius.circular(12.r)),
                          alignment: Alignment.center,
                          child: Text(_initials, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: ColorManager.primary)),
                        ),
                        horizontalSpace(12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(title.isEmpty ? '—' : title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                            verticalSpace(3),
                            Text(profession, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085))),
                          ]),
                        ),
                        Text('الآن', style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFF98A2B3))),
                      ]),
                      verticalSpace(12),
                      Divider(height: 1, color: const Color(0xFFF2F4F7)),
                      verticalSpace(11),
                      Wrap(spacing: 8.w, runSpacing: 8.h, children: [
                        _pill(Icons.location_on_outlined, region),
                        _pill(Icons.schedule, employmentType),
                        _pill(Icons.payments_outlined, salary.isEmpty ? 'الراتب عند المقابلة' : salary),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _bottomBar(context),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(color: const Color(0xFFF7F9F9), borderRadius: BorderRadius.circular(20.r)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13.5.sp, color: ColorManager.primary),
          SizedBox(width: 5.w),
          Text(label, style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF344054))),
        ]),
      );

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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _JobFullPreview(title: title, profession: profession, employmentType: employmentType, region: region, salary: salary, description: description, phone: phone, email: email),
                  ),
                ),
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

/// نسخة طبق الأصل من صفحة تفاصيل الوظيفة (job_vacancy_details_view.dart)
class _JobFullPreview extends StatelessWidget {
  final String title, profession, employmentType, region, salary, description, phone, email;
  const _JobFullPreview({required this.title, required this.profession, required this.employmentType, required this.region, required this.salary, required this.description, required this.phone, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(title: Text(title.isEmpty ? '—' : title), backgroundColor: ColorManager.white, elevation: 0, foregroundColor: ColorManager.black),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r), border: Border.all(color: ColorManager.lighterGray)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(title.isEmpty ? '—' : title, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold))),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                      child: Text(employmentType, style: TextStyle(fontSize: 12.sp, color: ColorManager.primary)),
                    ),
                  ]),
                  verticalSpace(10),
                  _infoRow(Icons.work_outline, profession),
                  _infoRow(Icons.location_on_outlined, region),
                  _infoRow(Icons.payments_outlined, salary.isEmpty ? 'الراتب غير محدد' : salary),
                ],
              ),
            ),
            verticalSpace(20),
            Text('وصف الوظيفة', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            verticalSpace(8),
            Text(description.isEmpty ? '—' : description, style: TextStyle(fontSize: 13.5.sp, color: Colors.black87, height: 1.6)),
            verticalSpace(20),
            Text('التواصل مع صاحب الوظيفة', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            verticalSpace(8),
            _infoRow(Icons.phone_outlined, phone),
            _infoRow(Icons.email_outlined, email.isEmpty ? '—' : email),
            verticalSpace(28),
            Divider(color: ColorManager.lighterGray),
            verticalSpace(10),
            Text('تقديم على الوظيفة', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            verticalSpace(4),
            Text('بياناتك وملف السيرة الذاتية بيتم إرسالهم مباشرة لصاحب الوظيفة على بريده الإلكتروني', style: TextStyle(fontSize: 12.sp, color: ColorManager.grey)),
            verticalSpace(16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10.r)),
              child: Row(children: [
                Icon(Icons.attach_file, color: ColorManager.primary),
                horizontalSpace(8),
                Text('اضغط لإرفاق ملف PDF أو Word', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
              ]),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(children: [
          Icon(icon, size: 16.sp, color: ColorManager.grey),
          horizontalSpace(6),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13.sp, color: Colors.black87))),
        ]),
      );
}
