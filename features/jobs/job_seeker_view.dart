import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/app_text_button.dart';
import '../../core/widgets/subscription_gate_button.dart';
import '../../core/widgets/app_text_form_field.dart';
import 'widgets/job_form_fields.dart';

/// نموذج "باحث عن عمل" - مجاني حالياً (بدون دفع)، عكس "وظائف شاغرة"
/// اللي لسا فيها دفع.
///
/// TODO: البيانات لازم ترسل مباشرة لـ endpoint النشر بالباك اند (بدون
/// المرور ببوابة الدفع) - راجع قسم "الباك اند" بآخر رسالة بالمحادثة.
class JobSeekerView extends StatefulWidget {
  const JobSeekerView({super.key});

  @override
  State<JobSeekerView> createState() => _JobSeekerViewState();
}

class _JobSeekerViewState extends State<JobSeekerView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  String? _profession;
  String? _qualification;
  String? _experience;
  String? _region;
  bool _servesOtherRegions = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _onPublishPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_profession == null || _region == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار المهنة والمنطقة')),
      );
      return;
    }

    // TODO: استدعاء API الباك اند لنشر الإعلان مباشرة (بدون دفع) -
    // POST /job-listings مع listing_type = 'seeker'
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال طلبك بنجاح، بانتظار المراجعة')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('باحث عن عمل'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              jobFieldLabel('الاسم الكامل *'),
              AppTextFormField(
                controller: nameController,
                hintText: 'مثال: محمد العتيبي',
                keyboardType: TextInputType.name,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'الرجاء ادخال الاسم الكامل' : null,
              ),
              verticalSpace(14),

              jobFieldLabel('المهنة / الحرفة *'),
              JobDropdownField(
                hint: 'اختر المهنة',
                value: _profession,
                options: JobOptions.professions,
                onChanged: (v) => setState(() => _profession = v),
              ),
              verticalSpace(14),

              jobFieldLabel('المؤهل الدراسي'),
              JobDropdownField(
                hint: 'اختر المؤهل',
                value: _qualification,
                options: JobOptions.qualifications,
                onChanged: (v) => setState(() => _qualification = v),
              ),
              verticalSpace(14),

              jobFieldLabel('سنوات الخبرة'),
              JobDropdownField(
                hint: 'اختر سنوات الخبرة',
                value: _experience,
                options: JobOptions.experienceLevels,
                onChanged: (v) => setState(() => _experience = v),
              ),
              verticalSpace(14),

              jobFieldLabel('المنطقة المفضلة للعمل *'),
              JobRegionField(
                selectedRegion: _region,
                servesOtherRegions: _servesOtherRegions,
                onRegionSelected: (v) => setState(() => _region = v),
                onServesOtherRegionsChanged: (v) =>
                    setState(() => _servesOtherRegions = v),
                checkboxLabel: 'أقبل العمل بمناطق أخرى غير المحددة',
              ),
              verticalSpace(14),

              jobFieldLabel('نبذة مختصرة'),
              TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'اكتب نبذة عن خبرتك ومهاراتك...',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              verticalSpace(14),

              jobFieldLabel('رقم الجوال *'),
              AppTextFormField(
                controller: phoneController,
                hintText: '965xxxxxxxx',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'الرجاء ادخال رقم الجوال' : null,
              ),
              verticalSpace(28),

              SubscriptionGateButton(
                buttonText: 'نشر الإعلان',
                backgroundColor: ColorManager.black,
                buttonHeight: 52.h,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onPublish: _onPublishPressed,
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
