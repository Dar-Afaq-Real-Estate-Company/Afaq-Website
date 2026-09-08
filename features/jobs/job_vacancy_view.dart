import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/services/payment_service.dart';
import '../../core/services/subscription_service.dart';
import '../../core/routing/routes.dart';
import '../../core/widgets/app_text_form_field.dart';
import '../../core/widgets/payment_webview_screen.dart';
import '../../core/widgets/publish_success_view.dart';
import '../subscription/subscription_plans_view.dart';
import 'widgets/job_form_fields.dart';
import 'job_vacancy_preview_view.dart';

/// نموذج نشر "وظيفة شاغرة" - تصميم بخطوات (معلومات الوظيفة، المتطلبات،
/// التواصل) بنفس هوية صفحة تصفح الوظائف، ويحفظ فعليًا بالباك اند.
class JobVacancyView extends StatefulWidget {
  const JobVacancyView({super.key});

  @override
  State<JobVacancyView> createState() => _JobVacancyViewState();
}

class _JobVacancyViewState extends State<JobVacancyView> {
  final _formKey = GlobalKey<FormState>();
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.afaq.group/api/',
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  final titleController = TextEditingController();
  final salaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String? _profession;
  String? _employmentType;
  String? _qualification;
  String? _experience;
  String? _region;
  bool _servesOtherRegions = false;
  bool _isFreeAccount = false;
  bool? _hasActivePlan;
  bool _submitting = false;
  bool _salaryOnInterview = false;
  DateTime? _expiryDate;

  // === عدد الأيام المتبقية حتى تاريخ الانتهاء المختار
  int get _durationDays {
    if (_expiryDate == null) return 0;
    final today = DateTime.now();
    final diff = _expiryDate!.difference(DateTime(today.year, today.month, today.day)).inDays;
    return diff < 1 ? 1 : diff;
  }

  static const double price = 15.0;

  @override
  void initState() {
    super.initState();
    _checkUserType();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    final active = await SubscriptionService.fetchStatus();
    if (mounted) setState(() => _hasActivePlan = active != null);
  }

  Future<void> _checkUserType() async {
    final type = await SharedPrefHelper.getUserType();
    if (mounted) setState(() => _isFreeAccount = type == '2');
  }

  @override
  void dispose() {
    titleController.dispose();
    salaryController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  int _currentStep = 0;

  void _goNextStep() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_profession == null || _employmentType == null || _region == null) {
      _snack('يرجى اختيار المهنة ونوع الدوام والمنطقة');
      return;
    }
    setState(() => _currentStep = 1);
  }

  void _showPreview() {
    if (_expiryDate == null) {
      _snack('يرجى تحديد تاريخ انتهاء نشر الوظيفة');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobVacancyPreviewView(
          title: titleController.text,
          profession: _profession!,
          employmentType: _employmentType!,
          region: _region!,
          salary: _salaryOnInterview ? '' : salaryController.text,
          description: descriptionController.text,
          phone: phoneController.text,
          email: emailController.text,
          onPublish: _submit,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_isFreeAccount && _hasActivePlan == false) {
      final subscribed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionPlansView()),
      );
      if (subscribed != true || !mounted) return;
      setState(() => _hasActivePlan = true);
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_profession == null || _employmentType == null || _region == null) {
      _snack('يرجى اختيار المهنة ونوع الدوام والمنطقة');
      return;
    }
    if (_expiryDate == null) {
      _snack('يرجى تحديد تاريخ انتهاء نشر الوظيفة');
      return;
    }

    setState(() => _submitting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final response = await _dio.post('job-listings', data: {
        'user_id': userId,
        'listing_type': 'vacancy',
        'title': titleController.text.trim(),
        'profession': _profession,
        'employment_type': _employmentType,
        'qualification': _qualification,
        'experience': _experience,
        'region': _region,
        'serves_other_regions': _servesOtherRegions,
        'salary': _salaryOnInterview
            ? '0'
            : (salaryController.text.trim().isEmpty
                ? null
                : salaryController.text.trim()),
        'description': descriptionController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'duration_days': _durationDays,
      });

      if (!mounted) return;
      setState(() => _submitting = false);

      if (response.data['status'] == true) {
        final dynamic rawData = response.data['data'];
        final int? newId = int.tryParse(
          (rawData is Map ? (rawData['id'] ?? response.data['id']) : response.data['id'])?.toString() ?? '',
        );
        final String? refNo = (rawData is Map ? rawData['reference_no']?.toString() : null) ?? newId?.toString();

        // === الدفع الإلكتروني: الأدمن معفى، والباقي يدفع قبل النشر
        if (!_isFreeAccount && newId != null) {
          final result = await PaymentService.pay(
            context: context,
            itemType: PaymentItemType.job,
            itemId: newId,
          );
          if (!mounted) return;
          if (result.success) {
            showPublishSuccessThenGoToMyAds(context, referenceNo: refNo);
          } else {
            _snack(result.message ?? 'لم تكتمل عملية الدفع');
          }
          return;
        }

        if (_isFreeAccount) {
          showPublishSuccessThenGoToMyAds(context, referenceNo: refNo);
        } else {
          _openPayment();
        }
      } else {
        _snack(response.data['message']?.toString() ?? 'تعذر حفظ الوظيفة');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _snack('تعذر الاتصال بالسيرفر، حاول مرة أخرى');
    }
  }

  void _openPayment() {
    final paymentUrl = 'https://example-payment-gateway.com/pay'
        '?amount=$price&currency=KWD'
        '&title=${Uri.encodeComponent(titleController.text)}'
        '&phone=${Uri.encodeComponent(phoneController.text)}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(url: paymentUrl, title: 'الدفع الإلكتروني'),
      ),
    );
  }

  void _snack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  children: _currentStep == 0 ? _stepOneFields() : _stepTwoFields(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _stepOneFields() {
    return [
                    _section(
                      icon: Icons.work_outline,
                      title: 'معلومات الوظيفة',
                      children: [
                        _label('المسمى الوظيفي', required: true),
                        AppTextFormField(
                          controller: titleController,
                          hintText: 'مثال: محاسب أول',
                          keyboardType: TextInputType.text,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'الرجاء ادخال المسمى الوظيفي'
                              : null,
                        ),
                        verticalSpace(14),
                        _label('المهنة / التخصص', required: true),
                        JobDropdownField(
                          hint: 'اختر المهنة',
                          value: _profession,
                          options: JobOptions.professions,
                          onChanged: (v) => setState(() => _profession = v),
                        ),
                        verticalSpace(14),
                        _label('نوع الدوام', required: true),
                        _employmentTypeSelector(),
                        verticalSpace(14),
                        _label('المنطقة', required: true),
                        JobRegionField(
                          selectedRegion: _region,
                          servesOtherRegions: _servesOtherRegions,
                          onRegionSelected: (v) => setState(() => _region = v),
                          onServesOtherRegionsChanged: (v) =>
                              setState(() => _servesOtherRegions = v),
                          checkboxLabel: 'الوظيفة تشمل مناطق أخرى غير المحددة',
                        ),
                        verticalSpace(14),
                        _label('الراتب'),
                        AppTextFormField(
                          controller: salaryController,
                          hintText: _salaryOnInterview
                              ? 'يُحدّد عند المقابلة'
                              : 'مثال: 500 (بالدينار)',
                          keyboardType: TextInputType.number,
                          readOnly: _salaryOnInterview,
                          validator: (_) => null,
                        ),
                        verticalSpace(8),
                        GestureDetector(
                          onTap: () => setState(() {
                            _salaryOnInterview = !_salaryOnInterview;
                            if (_salaryOnInterview) salaryController.clear();
                          }),
                          child: Row(
                            children: [
                              Icon(
                                _salaryOnInterview
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 20.sp,
                                color: _salaryOnInterview
                                    ? ColorManager.primary
                                    : const Color(0xFF98A2B3),
                              ),
                              horizontalSpace(8),
                              Text(
                                'الراتب يُحدّد عند المقابلة',
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  color: const Color(0xFF475467),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(14),
                    _section(
                      icon: Icons.school_outlined,
                      title: 'المتطلبات',
                      children: [
                        _label('المؤهل المطلوب'),
                        JobDropdownField(
                          hint: 'اختر المؤهل',
                          value: _qualification,
                          options: JobOptions.qualifications,
                          onChanged: (v) => setState(() => _qualification = v),
                        ),
                        verticalSpace(14),
                        _label('سنوات الخبرة'),
                        JobDropdownField(
                          hint: 'اختر سنوات الخبرة',
                          value: _experience,
                          options: JobOptions.experienceLevels,
                          onChanged: (v) => setState(() => _experience = v),
                        ),
                        verticalSpace(14),
                        _label('وصف الوظيفة'),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'تفاصيل المهام والمتطلبات...',
                            hintStyle: TextStyle(fontSize: 12.5.sp),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    GestureDetector(
                      onTap: _goNextStep,
                      child: Container(
                        height: 54.h,
                        decoration: BoxDecoration(color: const Color(0xFF14181F), borderRadius: BorderRadius.circular(16.r)),
                        alignment: Alignment.center,
                        child: Text('التالي', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    verticalSpace(20),
    ];
  }

  List<Widget> _stepTwoFields() {
    return [
                    _section(
                      icon: Icons.contact_phone_outlined,
                      title: 'بيانات التواصل',
                      children: [
                        _label('رقم التواصل', required: true),
                        AppTextFormField(
                          controller: phoneController,
                          hintText: '965xxxxxxxx',
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'الرجاء ادخال رقم التواصل'
                              : null,
                        ),
                        verticalSpace(14),
                        _label('البريد الإلكتروني', required: true),
                        AppTextFormField(
                          controller: emailController,
                          hintText: 'تصلك عليه السير الذاتية',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'الرجاء ادخال البريد الإلكتروني';
                            }
                            if (!v.contains('@')) return 'بريد إلكتروني غير صحيح';
                            return null;
                          },
                        ),
                      ],
                    ),
                    verticalSpace(14),
                    _section(
                      icon: Icons.event_available_outlined,
                      title: 'مدة النشر',
                      children: [
                        _label('كم يوم تبي الوطيفة تبقى منشورة؟', required: true),
                        _durationSelector(),
                        verticalSpace(10),
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 14.sp, color: const Color(0xFF98A2B3)),
                            horizontalSpace(6),
                            Expanded(
                              child: Text(
                                'تختفي الوطيفة تلقائياً بعد انتهاء المدة، وتقدر تمدّدها من "إعلاناتي"',
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: const Color(0xFF98A2B3),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentStep = 0),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            ),
                            child: const Text('السابق'),
                          ),
                        ),
                        horizontalSpace(10),
                        Expanded(flex: 2, child: _submitButton()),
                      ],
                    ),
                    verticalSpace(20),
    ];
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
              ),
              horizontalSpace(12),
              Text(
                'نشر وظيفة شاغرة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsets.only(right: 34.w),
            child: Text(
              _isFreeAccount
                  ? 'حسابك يسمح بالنشر المباشر مجاناً'
                  : 'اعرض وظيفتك على آلاف الباحثين عن عمل في الكويت',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12.5.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDEFF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(icon, size: 17.sp, color: ColorManager.primary),
              ),
              horizontalSpace(10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101828),
                ),
              ),
            ],
          ),
          verticalSpace(16),
          ...children,
        ],
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 13.sp),
                  )
                ]
              : null,
        ),
      ),
    );
  }

  // === نوع الدوام كشرائح بدل قائمة منسدلة (أسرع بالاختيار)
  Widget _employmentTypeSelector() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: JobOptions.employmentTypes.map((type) {
        final selected = _employmentType == type;
        return GestureDetector(
          onTap: () => setState(() => _employmentType = type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: selected ? ColorManager.primary : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: selected ? ColorManager.primary : const Color(0xFFE4E7EC),
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? Colors.white : const Color(0xFF475467),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // === تاريخ انتهاء النشر - يختاره الناشر من التقويم
  Widget _durationSelector() {
    final selected = _expiryDate != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickExpiryDate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: selected
                  ? ColorManager.primary.withOpacity(0.06)
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: selected ? ColorManager.primary : const Color(0xFFE4E7EC),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_outlined,
                    size: 18.sp,
                    color: selected ? ColorManager.primary : const Color(0xFF98A2B3)),
                horizontalSpace(10),
                Expanded(
                  child: Text(
                    selected
                        ? 'ينتهي بتاريخ ${_formatDate(_expiryDate!)}'
                        : 'اختر آخر يوم لنشر الوظيفة',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? const Color(0xFF101828) : const Color(0xFF98A2B3),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    size: 20.sp, color: const Color(0xFF98A2B3)),
              ],
            ),
          ),
        ),
        if (selected) ...[
          verticalSpace(8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'باقي $_durationDays يوم',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now.add(const Duration(days: 30)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'آخر يوم لنشر الوظيفة',
      cancelText: 'إلغاء',
      confirmText: 'تحديد',
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  Widget _submitButton() {
    return GestureDetector(
      onTap: _submitting ? null : _showPreview,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: _submitting ? const Color(0xFF98A2B3) : const Color(0xFF14181F),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: _submitting
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Text(
                _isFreeAccount
                    ? 'نشر الوظيفة'
                    : (_hasActivePlan == false
                        ? 'نشر الوظيفة'
                        : 'ادفع ${price.toStringAsFixed(0)} د.ك وانشر'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
