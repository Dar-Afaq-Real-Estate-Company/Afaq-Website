import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/services/payment_service.dart';

/// صفحة "استشارة عقارية" - حجز موعد استشارة + دفع إلكتروني
/// (مبنية بناءً على تصميم الصورة المرسلة)
class RealEstateConsultationView extends StatefulWidget {
  const RealEstateConsultationView({super.key});

  @override
  State<RealEstateConsultationView> createState() =>
      _RealEstateConsultationViewState();
}

class _RealEstateConsultationViewState
    extends State<RealEstateConsultationView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool _bookingExpanded = true;
  bool _userDataExpanded = true;
  bool _hasPromoCode = false;

  // === سعر الاستشارة - ثابت حالياً بـ 30 د.ك. الدفع إلزامي لكل المستخدمين،
  // ما عدا حساب الأدمن (السيرفر وحده يقرر الإعفاء عبر PaymentService).
  static const double consultationPrice = 30.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  String get _formattedDate {
    if (selectedDate == null) return '';
    const arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return '${selectedDate!.day} ${arabicMonths[selectedDate!.month - 1]}, ${selectedDate!.year}';
  }

  String get _formattedTime {
    if (selectedTime == null) return '';
    final hour = selectedTime!.hourOfPeriod == 0 ? 12 : selectedTime!.hourOfPeriod;
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    final period = selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$period ${hour.toString().padLeft(2, '0')}:$minute';
  }

  void _onPayPressed() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.consultPickDatetimeError.tr())),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // === الدفع إلزامي لكل المستخدمين - السيرفر وحده يستثني حساب الأدمن
    _payAndBook();
  }

  Future<void> _payAndBook() async {
    final result = await PaymentService.pay(
      context: context,
      itemType: PaymentItemType.consultation,
    );
    if (!mounted) return;
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.skipped ? AppStrings.consultBookedFree.tr() : AppStrings.consultBookedPaid.tr()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.consultation.tr()),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === قسم: حجز استشارة عقارية (تاريخ + وقت) ===
              _SectionHeader(
                title: AppStrings.consultBookingSection.tr(),
                expanded: _bookingExpanded,
                onTap: () =>
                    setState(() => _bookingExpanded = !_bookingExpanded),
              ),
              if (_bookingExpanded) ...[
                verticalSpace(12),
                _fieldLabel(AppStrings.consultPickDate.tr()),
                verticalSpace(6),
                _PickerField(
                  hintText: AppStrings.consultChooseDate.tr(),
                  value: _formattedDate,
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
                verticalSpace(14),
                _fieldLabel(AppStrings.consultPickTime.tr()),
                verticalSpace(6),
                _PickerField(
                  hintText: AppStrings.consultChooseTime.tr(),
                  value: _formattedTime,
                  icon: Icons.access_time,
                  onTap: _pickTime,
                ),
              ],

              verticalSpace(20),
              Divider(color: ColorManager.lighterGray, height: 1),
              verticalSpace(16),

              // === قسم: بيانات المستخدم ===
              _SectionHeader(
                title: AppStrings.consultUserDataSection.tr(),
                expanded: _userDataExpanded,
                onTap: () => setState(
                    () => _userDataExpanded = !_userDataExpanded),
              ),
              if (_userDataExpanded) ...[
                verticalSpace(12),
                _fieldLabel(AppStrings.consultFullName.tr()),
                verticalSpace(6),
                AppTextFormField(
                  controller: nameController,
                  hintText: AppStrings.consultFullName.tr(),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.consultNameError.tr();
                    }
                    return null;
                  },
                ),
                verticalSpace(14),
                _fieldLabel(AppStrings.consultPhone.tr()),
                verticalSpace(6),
                AppTextFormField(
                  controller: phoneController,
                  hintText: AppStrings.consultPhoneHint.tr(),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.consultPhoneError.tr();
                    }
                    return null;
                  },
                ),
                verticalSpace(14),
                _fieldLabel(AppStrings.consultNotes.tr()),
                verticalSpace(6),
                TextFormField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppStrings.consultNotesHint.tr(),
                    hintStyle: TextStyle(color: ColorManager.grey),
                    filled: true,
                    fillColor: ColorManager.lighterGray,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],

              verticalSpace(20),

              // === هل لديك رمز ترويجي؟ ===
              GestureDetector(
                onTap: () =>
                    setState(() => _hasPromoCode = !_hasPromoCode),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.consultHasPromo.tr(),
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasPromoCode) ...[
                verticalSpace(10),
                AppTextFormField(
                  controller: promoCodeController,
                  hintText: AppStrings.consultPromoHint.tr(),
                  keyboardType: TextInputType.text,
                  validator: (_) => null,
                ),
              ],

              verticalSpace(30),
              AppTextButton(
                buttonText: AppStrings.getString('request_consultation_btn', context.locale.languageCode),
                backgroundColor: ColorManager.black,
                buttonHeight: 52.h,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: _onPayPressed,
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          horizontalSpace(6),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
          ),
          SizedBox(width: 24.w), // موازنة بصرية مع الأيقونة اليسرى
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String hintText;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerField({
    required this.hintText,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorManager.lighterGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorManager.grey, size: 18.sp),
            horizontalSpace(8),
            Text(
              hasValue ? value : hintText,
              style: TextStyle(
                color: hasValue ? ColorManager.black : ColorManager.grey,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
