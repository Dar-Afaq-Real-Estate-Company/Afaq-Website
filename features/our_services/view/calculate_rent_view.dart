import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';

/// حاسبة تقدير الإيجار الشهري - نفس تصميم حاسبة تكلفة البناء بالضبط.
/// المعادلة: الإيجار الشهري = المساحة × السعر الأساسي (حسب نوع العقار)
/// × معامل المنطقة × معامل حالة العقار.
class CalculateRentView extends StatefulWidget {
  const CalculateRentView({super.key});

  @override
  State<CalculateRentView> createState() => _CalculateRentViewState();
}

class _CalculateRentViewState extends State<CalculateRentView> {
  final TextEditingController _areaController = TextEditingController();

  int _propertyType = 0; // شقة / فيلا / دور / مكتب / محل
  int _regionTier = 1; // راقية / متوسطة / اقتصادية
  int _condition = 1; // جديد / متوسط / يحتاج تجديد

  List<Map<String, dynamic>> get _typeOptions => [
    {'label': AppStrings.rentTypeApartment.tr(), 'rate': 4.5},
    {'label': AppStrings.rentTypeVilla.tr(), 'rate': 3.0},
    {'label': AppStrings.rentTypeFloor.tr(), 'rate': 3.5},
    {'label': AppStrings.rentTypeOffice.tr(), 'rate': 7.0},
    {'label': AppStrings.rentTypeShop.tr(), 'rate': 10.0},
  ];
  List<Map<String, dynamic>> get _regionOptions => [
    {'label': AppStrings.rentRegionPrime.tr(), 'factor': 1.3},
    {'label': AppStrings.rentRegionMid.tr(), 'factor': 1.0},
    {'label': AppStrings.rentRegionEconomic.tr(), 'factor': 0.75},
  ];
  List<Map<String, dynamic>> get _conditionOptions => [
    {'label': AppStrings.rentConditionNew.tr(), 'factor': 1.1},
    {'label': AppStrings.rentConditionMid.tr(), 'factor': 1.0},
    {'label': AppStrings.rentConditionOld.tr(), 'factor': 0.85},
  ];

  double get _area => double.tryParse(_areaController.text.trim()) ?? 0;
  double get _baseRate => _typeOptions[_propertyType]['rate'] as double;
  double get _regionFactor => _regionOptions[_regionTier]['factor'] as double;
  double get _conditionFactor => _conditionOptions[_condition]['factor'] as double;

  double get _monthlyRent => _area * _baseRate * _regionFactor * _conditionFactor;
  double get _yearlyRent => _monthlyRent * 12;

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.calcRentTitle.tr()),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(AppStrings.calcRentAreaLabel.tr()),
            verticalSpace(8),
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: AppStrings.calcRentAreaHint.tr(),
                filled: true,
                fillColor: const Color(0xFFF7F8F9),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: ColorManager.primary, width: 1.6),
                ),
              ),
            ),
            verticalSpace(18),
            _label(AppStrings.calcRentPropertyType.tr()),
            verticalSpace(8),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(_typeOptions.length, (i) {
                final opt = _typeOptions[i];
                final selected = _propertyType == i;
                return GestureDetector(
                  onTap: () => setState(() => _propertyType = i),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: selected ? ColorManager.primary : const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Text(opt['label'] as String,
                            style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: selected ? Colors.white : const Color(0xFF344054))),
                        SizedBox(height: 3.h),
                        Text('${opt['rate']} ${AppStrings.calcRentRateSuffix.tr()}',
                            style: TextStyle(
                                fontSize: 9.5.sp,
                                color: selected ? Colors.white.withOpacity(0.85) : const Color(0xFF98A2B3))),
                      ],
                    ),
                  ),
                );
              }),
            ),
            verticalSpace(18),
            _label(AppStrings.calcRentRegionTier.tr()),
            verticalSpace(8),
            _optionPicker(_regionOptions.map((o) => o['label'] as String).toList(), _regionTier,
                (v) => setState(() => _regionTier = v)),
            verticalSpace(14),
            _label(AppStrings.calcRentCondition.tr()),
            verticalSpace(8),
            _optionPicker(_conditionOptions.map((o) => o['label'] as String).toList(), _condition,
                (v) => setState(() => _condition = v)),
            verticalSpace(24),

            if (_area > 0) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8F8),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: [
                    Text(AppStrings.calcRentMonthlyResult.tr(),
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF98A2B3))),
                    verticalSpace(6),
          Text('${_monthlyRent.toStringAsFixed(0)} ${AppStrings.currency.tr()}',
                        style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w900, color: ColorManager.primary)),
                    verticalSpace(10),
                    _breakdownRow('${AppStrings.calcRentAreaTimesRate.tr()} (${_area.toStringAsFixed(0)}×$_baseRate)', _area * _baseRate),
                    _breakdownRow('${AppStrings.calcRentRegionFactor.tr()} (×$_regionFactor)', _area * _baseRate * _regionFactor),
                    _breakdownRow(AppStrings.calcRentYearlyResult.tr(), _yearlyRent),
                  ],
                ),
              ),
              verticalSpace(16),
            ],

            Text(
              AppStrings.calcRentDisclaimer.tr(),
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF98A2B3)),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1D2939)));

  Widget _breakdownRow(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
          Text('${value.toStringAsFixed(0)} ${AppStrings.currency.tr()}', style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
        ],
      ),
    );
  }

  Widget _optionPicker(List<String> labels, int current, ValueChanged<int> onChanged) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () async {
        final selected = await showModalBottomSheet<int>(
          context: context,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
          builder: (sheetContext) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: labels.asMap().entries.map((e) {
                    final selected = e.key == current;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () => Navigator.pop(sheetContext, e.key),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                          decoration: BoxDecoration(
                            color: selected ? ColorManager.primary.withOpacity(0.08) : const Color(0xFFF7F8F9),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: selected ? ColorManager.primary : Colors.transparent),
                          ),
                          child: Text(e.value,
                              style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                  color: selected ? ColorManager.primary : const Color(0xFF344054))),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
        if (selected != null) onChanged(selected);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          border: Border.all(color: const Color(0xFFE4E7EC)),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(labels[current], style: TextStyle(fontSize: 13.5.sp, color: const Color(0xFF1D2939))),
            Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}
