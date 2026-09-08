import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/services/payment_service.dart';
import '../../core/services/subscription_service.dart';

/// صفحة "الدفع" لباقة مختارة - تفاصيل الباقة + ملخص + كود خصم، ثم
/// شيت "اختر طريقة الدفع" (فيزا/ماستركارد فقط - كي نت لا يدعم Apple
/// Pay ضمن التكامل الحالي) قبل التحويل الفعلي للبوابة.
class SubscriptionCheckoutView extends StatefulWidget {
  final SubscriptionPlan plan;
  const SubscriptionCheckoutView({super.key, required this.plan});

  @override
  State<SubscriptionCheckoutView> createState() => _SubscriptionCheckoutViewState();
}

class _SubscriptionCheckoutViewState extends State<SubscriptionCheckoutView> {
  final TextEditingController _discountController = TextEditingController();
  double _discount = 0;
  bool _submitting = false;

  double get _total => (widget.plan.price - _discount).clamp(0, double.infinity);

  void _applyDiscount() {
    // === لا يوجد نظام أكواد خصم فعلي بعد - جاهز للربط لاحقًا بجدول
    // discount_codes بالسيرفر. حاليًا: أي كود غير معروف = بلا خصم.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.subInvalidDiscount.tr())),
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      appBar: AppBar(
        title: Text(AppStrings.subPaymentTitle.tr()),
        backgroundColor: const Color(0xFFF5F7F7),
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.75)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(color: ColorManager.primary.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(plan.name, style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                  verticalSpace(10),
                  ...plan.features.map((f) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: 13.sp, color: Colors.white.withOpacity(0.85)),
                            SizedBox(width: 6.w),
                            Expanded(child: Text(f, style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.92)))),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            verticalSpace(16),

            Text(AppStrings.subHaveDiscount.tr(), style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
            verticalSpace(8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _discountController,
                    decoration: InputDecoration(
                      hintText: AppStrings.subEnterDiscount.tr(),
                      hintStyle: TextStyle(fontSize: 12.5.sp),
                      filled: true,
                      fillColor: const Color(0xFFF7F8F9),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFE4E7EC))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFE4E7EC))),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton(
                  onPressed: _applyDiscount,
                  child: Text(AppStrings.subApply.tr(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: ColorManager.primary)),
                ),
              ],
            ),
            verticalSpace(20),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.subSummary.tr(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                  verticalSpace(10),
                  _summaryRow(AppStrings.subSubtotal.tr(), plan.price),
                  _summaryRow(AppStrings.subTotalDiscount.tr(), -_discount),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8.h), child: Divider(height: 1, color: const Color(0xFFEDEFF3))),
                  _summaryRow(AppStrings.subTotal.tr(), _total, bold: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              onPressed: _submitting ? null : _openPaymentMethodSheet,
              child: Text(
                _submitting ? AppStrings.subProcessing.tr() : AppStrings.subPayAnd.tr(namedArgs: {'n': _total.toStringAsFixed(2)}),
                style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: bold ? 14.sp : 12.5.sp, fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: bold ? ColorManager.black : const Color(0xFF667085))),
          Text('${value.toStringAsFixed(2)} د.ك', style: TextStyle(fontSize: bold ? 16.sp : 12.5.sp, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: bold ? ColorManager.primary : const Color(0xFF344054))),
        ],
      ),
    );
  }

  Future<void> _openPaymentMethodSheet() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.subCheckoutTitle.tr(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext, false),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                verticalSpace(10),
                Text(AppStrings.subChoosePaymentMethod.tr(), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF667085))),
                verticalSpace(10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F9),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorManager.primary, width: 1.4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card, color: ColorManager.primary, size: 20.sp),
                      SizedBox(width: 10.w),
                      Expanded(child: Text(AppStrings.subVisaMasterKnet.tr(), style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600))),
                      Radio<bool>(value: true, groupValue: true, onChanged: (_) {}, activeColor: ColorManager.primary),
                    ],
                  ),
                ),
                verticalSpace(20),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    ),
                    onPressed: () => Navigator.pop(sheetContext, true),
                    child: Text(AppStrings.subContinuePayment.tr(), style: TextStyle(color: Colors.white, fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _submitting = true);

    final result = await PaymentService.pay(
      context: context,
      itemType: PaymentItemType.subscription,
      itemId: widget.plan.id,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.skipped ? AppStrings.subActivatedFree.tr() : AppStrings.subActivatedPaid.tr()), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? AppStrings.subPaymentIncomplete.tr())),
      );
    }
  }
}
