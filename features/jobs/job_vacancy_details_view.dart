import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/app_text_button.dart';
import '../../core/widgets/app_text_form_field.dart';
import 'job_vacancies_browse_view.dart';

/// صفحة تفاصيل الوظيفة الكاملة (نفس فكرة صفحة تفاصيل الفنادق/الشقق) -
/// معلومات كاملة + نموذج "تقديم على الوظيفة" يرفع سيرة ذاتية (CV) ويرسلها
/// لصاحب الوظيفة على بريده الإلكتروني.
///
/// TODO: يحتاج باقة file_picker مضافة بـ pubspec.yaml:
///   file_picker: ^8.0.0+1
/// والباك اند يحتاج endpoint: POST /job-listings/{id}/apply
/// (راجع JobApplicationController بآخر رسالة بالمحادثة)
class JobVacancyDetailsView extends StatefulWidget {
  final VacancyListItem vacancy;

  const JobVacancyDetailsView({super.key, required this.vacancy});

  @override
  State<JobVacancyDetailsView> createState() => _JobVacancyDetailsViewState();
}

class _JobVacancyDetailsViewState extends State<JobVacancyDetailsView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  PlatformFile? _pickedCv;
  bool _isSubmitting = false;
  bool _showApplyForm = false;
  late int _viewsCount = widget.vacancy.viewsCount;

  @override
  void initState() {
    super.initState();
    _incrementViews();
  }

  Future<void> _incrementViews() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      final res = await dio.post('job-listings/${widget.vacancy.id}/view');
      final updated = int.tryParse('${res.data['views_count']}');
      if (updated != null && mounted) setState(() => _viewsCount = updated);
    } catch (_) {}
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickCv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedCv = result.files.first);
    }
  }

  Future<void> _submitApplication() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_pickedCv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إرفاق السيرة الذاتية (CV)')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.afaq.group/api/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        validateStatus: (_) => true,
        headers: {
          'Accept': 'application/json',
        },
      ));
      final formData = {
        'applicant_name': nameController.text,
        'applicant_email': emailController.text,
        'applicant_phone': phoneController.text,
        'cv_name': _pickedCv!.name,
        // === نرسل الملف base64 داخل JSON لأن mod_security بالاستضافة
        // يحجب رفع الملفات بصيغة multipart (خطأ 406)
        'cv_base64': base64Encode(await File(_pickedCv!.path!).readAsBytes()),
      };

      final response = await dio.post(
        'job-listings/${widget.vacancy.id}/apply',
        data: formData,
      );

      if (!mounted) return;

      // === نفحص النتيجة يدوياً لنعرض سبب الرفض الحقيقي
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال طلبك بنجاح، بالتوفيق!')),
        );
        Navigator.pop(context);
        return;
      }

      String failure = 'فشل الإرسال (رمز $code)';
      final data = response.data;
      if (data is Map) {
        if (data['errors'] is Map) {
          final firstError = (data['errors'] as Map).values.first;
          failure = firstError is List ? firstError.first.toString() : firstError.toString();
        } else if (data['message'] != null) {
          failure = data['message'].toString();
        }
      } else if (code == 413) {
        failure = 'حجم الملف كبير جداً، اختر ملف أصغر';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure), duration: const Duration(seconds: 6)),
      );
      return;
    } catch (e) {
      if (!mounted) return;
      // === نعرض السبب الحقيقي (اتصال/مهلة/ملف) بدل رسالة عامة
      String message = 'تعذر الإرسال: $e';
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            message = 'انتهت المهلة أثناء رفع الملف، جرّب ملف أصغر أو شبكة أقوى';
            break;
          case DioExceptionType.connectionError:
            message = 'تعذر الاتصال بالسيرفر، تحقق من الإنترنت';
            break;
          default:
            message = 'خطأ: ${e.message ?? e.type.name}';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vacancy;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 22.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(26.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp)),
                    ],
                  ),
                  verticalSpace(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.title, style: TextStyle(color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.w900)),
                            verticalSpace(5),
                            Text(
                              v.referenceNo != null && v.referenceNo!.isNotEmpty ? '${v.profession}  •  #${v.referenceNo}' : v.profession,
                              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.sp),
                            ),
                            verticalSpace(4),
                            Row(children: [
                              Icon(Icons.visibility, size: 13.sp, color: Colors.white.withOpacity(0.85)),
                              SizedBox(width: 4.w),
                              Text('$_viewsCount', style: TextStyle(fontSize: 11.5.sp, color: Colors.white.withOpacity(0.85))),
                            ]),
                          ],
                        ),
                      ),
                      if (v.employmentType.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20.r)),
                          child: Text(v.employmentType, style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _statBox(
                          value: (v.salary == null || v.salary!.isEmpty || v.salary == '0') ? 'عند المقابلة' : '${v.salary} د.ك',
                          label: 'الراتب',
                          bg: const Color(0xFFEAF7EF),
                          fg: const Color(0xFF12B76A),
                        ),
                        horizontalSpace(8),
                        _statBox(value: v.region, label: 'المنطقة', bg: const Color(0xFFEAF1F1), fg: ColorManager.primary),
                        horizontalSpace(8),
                        _statBox(
                          value: v.isRemote ? 'بُعد' : 'حضوري',
                          label: 'نوع العمل',
                          bg: const Color(0xFFFFF4E5),
                          fg: const Color(0xFFB54708),
                        ),
                      ],
                    ),
                    verticalSpace(20),

                    Text('وصف الوظيفة', style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
                    verticalSpace(8),
                    Text(v.description, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF475467), height: 1.7)),
                    verticalSpace(20),

                    Container(height: 1, color: const Color(0xFFEDEFF3)),
                    verticalSpace(18),

                    Text('التواصل مع صاحب الوظيفة', style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
                    verticalSpace(10),
                    _infoRow(Icons.phone_outlined, v.phone),
                    _infoRow(Icons.email_outlined, v.email),

                    verticalSpace(24),
                    Container(height: 1, color: const Color(0xFFEDEFF3)),
                    verticalSpace(18),

                    Text('تقديم على الوظيفة', style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
                    verticalSpace(4),
                    Text(
                      'بياناتك وملف السيرة الذاتية بيتم إرسالهم مباشرة لصاحب الوظيفة على بريده الإلكتروني',
                      style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF98A2B3), height: 1.5),
                    ),
                    verticalSpace(16),

                    if (!_showApplyForm)
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                          ),
                          onPressed: () => setState(() => _showApplyForm = true),
                          child: Text('تقديم على الوظيفة', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),

                    if (_showApplyForm)
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _fieldLabel('الاسم الكامل', required: true),
                          AppTextFormField(
                            controller: nameController,
                            hintText: 'مثال: محمد العتيبي',
                            keyboardType: TextInputType.name,
                            validator: (v) => (v == null || v.isEmpty) ? 'الرجاء ادخال الاسم الكامل' : null,
                          ),
                          verticalSpace(14),

                          _fieldLabel('بريدك الإلكتروني', required: true),
                          AppTextFormField(
                            controller: emailController,
                            hintText: 'example@email.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'الرجاء ادخال بريدك الإلكتروني';
                              if (!v.contains('@')) return 'بريد إلكتروني غير صحيح';
                              return null;
                            },
                          ),
                          verticalSpace(14),

                          _fieldLabel('رقم جوالك', required: true),
                          AppTextFormField(
                            controller: phoneController,
                            hintText: '965xxxxxxxx',
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.isEmpty) ? 'الرجاء ادخال رقم جوالك' : null,
                          ),
                          verticalSpace(14),

                          _fieldLabel('السيرة الذاتية (CV)', required: true),
                          InkWell(
                            onTap: _pickCv,
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: _pickedCv == null ? const Color(0xFFF9FAFB) : ColorManager.primary.withOpacity(0.06),
                                border: Border.all(color: _pickedCv == null ? const Color(0xFFE4E7EC) : ColorManager.primary),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.attach_file, color: ColorManager.primary),
                                  horizontalSpace(8),
                                  Expanded(
                                    child: Text(
                                      _pickedCv?.name ?? 'اضغط لإرفاق ملف PDF أو Word',
                                      style: TextStyle(fontSize: 13.sp, color: _pickedCv == null ? const Color(0xFF98A2B3) : Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          verticalSpace(22),

                          SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                              ),
                              onPressed: _isSubmitting ? null : _submitApplication,
                              child: Text(
                                _isSubmitting ? 'جاري الإرسال...' : 'تقديم على الوظيفة',
                                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                          verticalSpace(20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox({required String value, required String label, required Color bg, required Color fg}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          children: [
            Text(value, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w800, color: fg)),
            SizedBox(height: 3.h),
            Text(label, style: TextStyle(fontSize: 9.5.sp, color: const Color(0xFF667085))),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF344054)),
          children: required ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 13.sp))] : null,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(9.r)),
            child: Icon(icon, size: 15.sp, color: ColorManager.primary),
          ),
          horizontalSpace(8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF344054))),
          ),
        ],
      ),
    );
  }
}
