import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/constants_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/services/subscription_service.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../subscription/subscription_plans_view.dart';
import '../widget/build_dropdown.dart';
import '../widget/build_label.dart';

class RequestOfficialEvaluationView extends StatefulWidget {
  const RequestOfficialEvaluationView({super.key});

  @override
  State<RequestOfficialEvaluationView> createState() =>
      _RequestOfficialEvaluationViewState();
}

class _RequestOfficialEvaluationViewState
    extends State<RequestOfficialEvaluationView> {
  final _formKey = GlobalKey<FormState>();
  // Controllers & Selection Variables
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  String? selectedLocation;
  String? selectedPosition;
  String? _evaluationText;
  bool _submitting = false;

  // === تحليل نصي مبسّط للمدخلات (نوع العقار + الغرض + تفاصيله) يرجّع
  // تقييمًا لفظيًا وصفيًا بدون رقم جاهز - بديل عن حساب رقمي مباشر.
  void _runQuickEvaluation() {
    if (selectedPosition == null || areaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل المنطقة والقطعة واختر نوع العقار أولاً للحصول على تقييم أولي')),
      );
      return;
    }

    final String details = detailsController.text.trim().toLowerCase();
    final String purpose = selectedLocation ?? "للبيع والشراء";
    final String propertyType = selectedPosition!;

    // === مؤشرات تُستخرج من النص الحر بدون حاجة لأرقام محددة
    final bool soundsNewOrDeluxe = details.contains('جديد') || details.contains('ديلوكس') || details.contains('سوبر') || details.contains('لوكس');
    final bool soundsOld = details.contains('قديم') || details.contains('يحتاج تجديد') || details.contains('ترميم');
    final bool primeLocation = details.contains('رئيسي') || details.contains('واجهة') || details.contains('شارع رئيسي') || details.contains('قريب');
    final bool hasExtras = details.contains('مسبح') || details.contains('حديقة') || details.contains('مصعد') || details.contains('سرداب');

    String tier;
    String reasoning;
    if (soundsOld && !primeLocation) {
      tier = 'متوسطة إلى منخفضة';
      reasoning = 'حالة العقار ووصفه يشيران إلى الحاجة لتجديد أو تحديث، وهذا يقلل من جاذبيته السوقية الحالية';
    } else if (soundsNewOrDeluxe && (primeLocation || hasExtras)) {
      tier = 'مرتفعة';
      reasoning = 'حداثة البناء والتشطيب مع موقع مميز و/أو مرافق إضافية تجعله من العقارات الجذابة في فئته';
    } else if (primeLocation || hasExtras || soundsNewOrDeluxe) {
      tier = 'جيدة إلى مرتفعة';
      reasoning = 'وجود ميزة واحدة أو أكثر (موقع مميز، تشطيب حديث، أو مرافق إضافية) يرفع من القيمة النسبية للعقار';
    } else {
      tier = 'متوسطة';
      reasoning = 'المعطيات المتاحة تصف عقارًا عاديًا بلا مؤشرات واضحة على ميزة أو عيب استثنائي';
    }

    final String purposeNote = purpose == 'للبنك/تمويل عقاري'
        ? 'بما أن الغرض تمويل بنكي، سيحتاج البنك تقريرًا رسميًا معتمدًا موثقًا بختم مقيّم مرخّص، لا تقديرًا مبدئيًا فقط'
        : (purpose.contains('ورثة')
            ? 'لأغراض حصر الورثة يُفضّل تقييم رسمي محايد يعتمده جميع الورثة لتفادي أي خلاف لاحق'
            : 'هذا يناسب عادة استخدامه كسعر تفاوضي مبدئي قبل التفاوض الفعلي مع الطرف الآخر');

    setState(() {
      _evaluationText =
          'بناءً على أنه عقار من نوع "$propertyType"، تشير المعطيات إلى أن قيمته السوقية التقديرية تقع في الفئة "$tier" مقارنة بمثيلاته في نفس الفئة.\n\n'
          '$reasoning.\n\n'
          '$purposeNote.\n\n'
          'هذا تحليل مبدئي استرشادي فقط بناءً على الوصف المُدخل، ولا يُعتمد رسميًا إلا بعد معاينة ميدانية من مقيّم مرخّص.';
    });
  }

  Widget _sectionCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
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
              SizedBox(width: 10.w),
              Text(title, style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
            ],
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 22.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(26.r)),
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
                      SizedBox(width: 12.w),
                      Text(AppStrings.evalPageTitle.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(right: 34.w),
                    child: Text(AppStrings.evalPageSub.tr(),
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.sp, height: 1.5)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionCard(
                        icon: Icons.person_outline,
                        title: AppStrings.evalApplicantSection.tr(),
                        children: [
                          _fieldLabel(AppStrings.evalApplicantName.tr(), required: true),
                          AppTextFormField(
                            controller: nameController,
                            hintText: AppStrings.evalNameHint.tr(),
                            keyboardType: TextInputType.text,
                            validator: (value) => (value == null || value.isEmpty) ? AppStrings.evalNameError.tr() : null,
                          ),
                          SizedBox(height: 14.h),
                          _fieldLabel(AppStrings.evalContactNumber.tr(), required: true),
                          AppTextFormField(
                            controller: phoneController,
                            hintText: '965xxxxxxxxxxx',
                            keyboardType: TextInputType.number,
                            validator: (value) => (value == null || value.isEmpty) ? AppStrings.evalPhoneError.tr() : null,
                          ),
                        ],
                      ),
                      _sectionCard(
                        icon: Icons.home_work_outlined,
                        title: AppStrings.evalPropertySection.tr(),
                        children: [
                          _fieldLabel(AppStrings.evalPurpose.tr(), required: true),
                          buildDropdown(
                            hint: AppStrings.evalPurposeSale.tr(),
                            items: [
                              AppStrings.evalPurposeSale.tr(),
                              AppStrings.evalPurposeBank.tr(),
                              AppStrings.evalPurposeInheritance.tr(),
                              AppStrings.evalPurposeLitigation.tr(),
                            ],
                            onChanged: (val) => setState(() => selectedLocation = val),
                          ),
                          SizedBox(height: 14.h),
                          _fieldLabel(AppStrings.evalAreaPlot.tr(), required: true),
                          AppTextFormField(
                            controller: areaController,
                            hintText: AppStrings.evalAreaHint.tr(),
                            keyboardType: TextInputType.text,
                            validator: (value) => (value == null || value.isEmpty) ? AppStrings.evalAreaError.tr() : null,
                          ),
                          SizedBox(height: 14.h),
                          _fieldLabel(AppStrings.evalPropertyType.tr(), required: true),
                          buildDropdown(
                            hint: AppStrings.evalTypeResidential.tr(),
                            items: [
                              AppStrings.evalTypeResidential.tr(),
                              AppStrings.evalTypeInvestment.tr(),
                              AppStrings.evalTypeCommercial.tr(),
                              AppStrings.evalTypeChalet.tr(),
                            ],
                            onChanged: (val) => setState(() => selectedPosition = val),
                          ),
                          SizedBox(height: 14.h),
                          _fieldLabel(AppStrings.evalPropertyDetails.tr(), required: true),
                          AppTextFormField(
                            controller: detailsController,
                            hintText: AppStrings.evalDetailsHint.tr(),
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            validator: (value) => (value == null || value.isEmpty) ? AppStrings.evalDetailsError.tr() : null,
                          ),
                          SizedBox(height: 14.h),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: OutlinedButton.icon(
                              onPressed: _runQuickEvaluation,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ColorManager.primary,
                                side: BorderSide(color: ColorManager.primary, width: 1.3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                              ),
                              icon: Icon(Icons.calculate_outlined, size: 16.sp),
                              label: Text(AppStrings.evalQuickEvalBtn.tr(), style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
                            ),
                          ),
                          if (_evaluationText != null) ...[
                            SizedBox(height: 10.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: ColorManager.primary.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: ColorManager.primary.withOpacity(0.25)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.auto_awesome, size: 15.sp, color: ColorManager.primary),
                                      SizedBox(width: 6.w),
                                      Text(AppStrings.evalInitialResult.tr(),
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: ColorManager.primary)),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(_evaluationText!,
                                      style: TextStyle(fontSize: 12.5.sp, height: 1.6, color: const Color(0xFF344054))),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                          ),
                          onPressed: _submitting ? null : _payThenSendRequest,
                          child: Text(
                            _submitting ? AppStrings.evalProcessing.tr() : AppStrings.evalSubmitBtn.tr(),
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _payThenSendRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedLocation == null || selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى اختيار الغرض من التقييم ونوع العقار أولاً"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _submitting = true);

    final active = await SubscriptionService.fetchStatus();
    if (active == null) {
      setState(() => _submitting = false);
      if (!mounted) return;
      final subscribe = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Container(
            padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 32.sp),
                ),
                verticalSpace(16),
                Text(AppStrings.subNotSubscribedTitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
                verticalSpace(8),
                Text(
                  AppStrings.subNotSubscribedBody.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5.sp, height: 1.6, color: const Color(0xFF667085)),
                ),
                verticalSpace(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          side: const BorderSide(color: Color(0xFFD0D5DD)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(AppStrings.subBack.tr(), style: TextStyle(color: const Color(0xFF475467), fontWeight: FontWeight.w600, fontSize: 13.5.sp)),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(AppStrings.subSubscribeNow.tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5.sp)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (subscribe == true && mounted) {
        final subscribed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const SubscriptionPlansView()),
        );
        if (subscribed != true || !mounted) return;
      } else {
        return;
      }

      setState(() => _submitting = true);
    }

    final result = await PaymentService.pay(
      context: context,
      itemType: PaymentItemType.officialEvaluation,
      payload: {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'purpose': selectedLocation,
        'area_plot': areaController.text.trim(),
        'property_type': selectedPosition,
        'details': detailsController.text.trim(),
        'to_email': 'info@afaq.group',
      },
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.skipped
              ? 'تم إرسال طلب التقييم الرسمي إلى info@afaq.group بدون دفع (حساب إداري)'
              : 'تم الدفع وإرسال طلب التقييم الرسمي إلى info@afaq.group'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'لم تكتمل عملية الدفع')),
      );
    }
  }
}
