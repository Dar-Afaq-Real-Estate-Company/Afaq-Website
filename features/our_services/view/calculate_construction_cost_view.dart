import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';

/// حاسبة تكلفة البناء - معادلة: المساحة × (سعر التشطيب + إضافات التكييف
/// والكهرباء لكل م²) + تكلفة ثابتة للمصاعد والسرداب.
class CalculateConstructionCostView extends StatefulWidget {
  const CalculateConstructionCostView({super.key});

  @override
  State<CalculateConstructionCostView> createState() => _CalculateConstructionCostViewState();
}

class _CalculateConstructionCostViewState extends State<CalculateConstructionCostView> {
  final TextEditingController _areaController = TextEditingController();

  // === خيار 0/1/2 لكل بند - القيم بالدينار الكويتي
  int _finishing = 0; // اقتصادي / ديلوكس / سوبر ديلوكس
  int _ac = 0; // وحدات منفصلة / مركزي / مركزي توفير طاقة
  int _plumbing = 0; // عادي / معلق / أنظمة ذكية
  int _elevators = 0; // بدون / مصعد واحد / مصعدين
  int _basement = 0; // لا يوجد / عادي / مع عزل وحفر

  List<Map<String, dynamic>> get _finishingOptions => [
    {'label': AppStrings.ccFinishEconomic.tr(), 'rate': 180},
    {'label': AppStrings.ccFinishDeluxe.tr(), 'rate': 230},
    {'label': AppStrings.ccFinishSuperDeluxe.tr(), 'rate': 300},
  ];
  List<Map<String, dynamic>> get _acOptions => [
    {'label': AppStrings.ccAcSplit.tr(), 'rate': 0},
    {'label': AppStrings.ccAcCentral.tr(), 'rate': 15},
    {'label': AppStrings.ccAcCentralSaving.tr(), 'rate': 25},
  ];
  List<Map<String, dynamic>> get _plumbingOptions => [
    {'label': AppStrings.ccPlumbingNormal.tr(), 'rate': 0},
    {'label': AppStrings.ccPlumbingConcealed.tr(), 'rate': 10},
    {'label': AppStrings.ccPlumbingSmart.tr(), 'rate': 20},
  ];
  List<Map<String, dynamic>> get _elevatorOptions => [
    {'label': AppStrings.ccElevatorNone.tr(), 'fixed': 0},
    {'label': AppStrings.ccElevatorOne.tr(), 'fixed': 6000},
    {'label': AppStrings.ccElevatorTwo.tr(), 'fixed': 11000},
  ];
  List<Map<String, dynamic>> get _basementOptions => [
    {'label': AppStrings.ccBasementNone.tr(), 'fixed': 0},
    {'label': AppStrings.ccBasementNormal.tr(), 'fixed': 8000},
    {'label': AppStrings.ccBasementDeepInsulated.tr(), 'fixed': 15000},
  ];

  double get _area => double.tryParse(_areaController.text.trim()) ?? 0;
  int get _baseRate => _finishingOptions[_finishing]['rate'] as int;
  int get _acRate => _acOptions[_ac]['rate'] as int;
  int get _plumbingRate => _plumbingOptions[_plumbing]['rate'] as int;
  int get _elevatorFixed => _elevatorOptions[_elevators]['fixed'] as int;
  int get _basementFixed => _basementOptions[_basement]['fixed'] as int;

  double get _structureCost => _area * _baseRate;
  double get _acPlumbingCost => _area * (_acRate + _plumbingRate);
  double get _totalCost => _structureCost + _acPlumbingCost + _elevatorFixed + _basementFixed;

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
        title: Text(AppStrings.calcConstructionTitle.tr()),
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
            _label(AppStrings.calcConstructionAreaLabel.tr()),
            verticalSpace(8),
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: AppStrings.calcConstructionAreaHint.tr(),
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
            _label(AppStrings.calcConstructionFinishing.tr()),
            verticalSpace(8),
            Row(
              children: List.generate(_finishingOptions.length, (i) {
                final opt = _finishingOptions[i];
                final selected = _finishing == i;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 8.w),
                    child: GestureDetector(
                      onTap: () => setState(() => _finishing = i),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: selected ? ColorManager.primary : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Text(opt['label'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: selected ? Colors.white : const Color(0xFF344054))),
                            SizedBox(height: 3.h),
                            Text('${opt['rate']} ${AppStrings.calcConstructionRateSuffix.tr()}',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: selected ? Colors.white.withOpacity(0.85) : const Color(0xFF98A2B3))),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            verticalSpace(18),
            _label(AppStrings.calcConstructionAc.tr()),
            verticalSpace(8),
            _optionPicker(_acOptions.map((o) => o['label'] as String).toList(), _ac, (v) => setState(() => _ac = v)),
            verticalSpace(14),
            _label(AppStrings.calcConstructionPlumbing.tr()),
            verticalSpace(8),
            _optionPicker(_plumbingOptions.map((o) => o['label'] as String).toList(), _plumbing,
                (v) => setState(() => _plumbing = v)),
            verticalSpace(14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(AppStrings.calcConstructionElevators.tr()),
                      verticalSpace(8),
                      _optionPicker(_elevatorOptions.map((o) => o['label'] as String).toList(), _elevators,
                          (v) => setState(() => _elevators = v), compact: true),
                    ],
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(AppStrings.calcConstructionBasement.tr()),
                      verticalSpace(8),
                      _optionPicker(_basementOptions.map((o) => o['label'] as String).toList(), _basement,
                          (v) => setState(() => _basement = v), compact: true),
                    ],
                  ),
                ),
              ],
            ),
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
                    Text(AppStrings.calcConstructionTotalResult.tr(),
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF98A2B3))),
                    verticalSpace(6),
                    Text('${_totalCost.toStringAsFixed(0)} ${AppStrings.currency.tr()}',
                        style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w900, color: ColorManager.primary)),
                    verticalSpace(10),
                    _breakdownRow('${AppStrings.calcConstructionStructureRow.tr()} (${_area.toStringAsFixed(0)}×$_baseRate)', _structureCost),
                    _breakdownRow(AppStrings.calcConstructionAcRow.tr(), _acPlumbingCost),
                    if (_elevatorFixed > 0) _breakdownRow(AppStrings.calcConstructionElevators.tr(), _elevatorFixed.toDouble()),
                    if (_basementFixed > 0) _breakdownRow(AppStrings.calcConstructionBasement.tr(), _basementFixed.toDouble()),
                  ],
                ),
              ),
              verticalSpace(16),
            ],

            Text(
              AppStrings.calcConstructionDisclaimer.tr(),
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF98A2B3)),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1D2939)));

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

  Widget _optionPicker(List<String> labels, int current, ValueChanged<int> onChanged, {bool compact = false}) {
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
            Expanded(
              child: Text(labels[current],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: compact ? TextAlign.center : TextAlign.start,
                  style: TextStyle(fontSize: compact ? 12.sp : 13.5.sp, color: const Color(0xFF1D2939))),
            ),
            if (!compact) Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}
