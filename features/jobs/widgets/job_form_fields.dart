import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/widgets/region_picker_sheet.dart';

/// قوائم مشتركة بين نموذج "وظائف شاغرة" و"باحث عن عمل"
class JobOptions {
  static const List<String> professions = [
    'مهندس',
    'محاسب',
    'مبرمج / مطور',
    'مندوب مبيعات',
    'سكرتير / إداري',
    'فني كهرباء',
    'فني تكييف',
    'سائق',
    'حارس أمن',
    'عامل نظافة',
    'طباخ / شيف',
    'مصمم',
    'مسوّق',
    'وسيط عقاري',
    'معلم / مدرّس',
    'أخرى',
  ];

  static const List<String> qualifications = [
    'ثانوي',
    'دبلوم',
    'بكالوريوس',
    'ماجستير فأعلى',
  ];

  static const List<String> experienceLevels = [
    'بدون خبرة',
    '1-3 سنوات',
    '4-7 سنوات',
    '8+ سنوات',
  ];

  static const List<String> employmentTypes = [
    'دوام كامل',
    'دوام جزئي',
    'عن بُعد',
  ];

  static const List<String> governorates = [
    'العاصمة',
    'حولي',
    'الفروانية',
    'مبارك الكبير',
    'الأحمدي',
    'الجهراء',
  ];
}

Widget jobFieldLabel(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(text, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
  );
}

/// قائمة منسدلة بسيطة موحّدة الشكل لكل حقول الاختيار
class JobDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool isRequired;

  const JobDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      items: options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: onChanged,
      validator: isRequired
          ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null
          : null,
    );
  }
}

/// حقل "المنطقة" (اختيار من شيت المناطق) + تشيك "يشمل مناطق أخرى" تحته
class JobRegionField extends StatelessWidget {
  final String? selectedRegion;
  final bool servesOtherRegions;
  final ValueChanged<String> onRegionSelected;
  final ValueChanged<bool> onServesOtherRegionsChanged;
  final String checkboxLabel;

  const JobRegionField({
    super.key,
    required this.selectedRegion,
    required this.servesOtherRegions,
    required this.onRegionSelected,
    required this.onServesOtherRegionsChanged,
    this.checkboxLabel = 'يشمل مناطق أخرى غير المحددة',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final selected = await showRegionPickerSheet(
              context,
              regions: JobOptions.governorates,
              current: selectedRegion,
              governorateOnly: true,
            );
            if (selected != null) onRegionSelected(selected);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedRegion ?? 'اختر المنطقة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedRegion == null ? Colors.grey : Colors.black87,
                  ),
                ),
                const Icon(Icons.location_on_outlined, color: Colors.green),
              ],
            ),
          ),
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: () => onServesOtherRegionsChanged(!servesOtherRegions),
          child: Row(
            children: [
              Checkbox(
                value: servesOtherRegions,
                activeColor: ColorManager.primary,
                onChanged: (v) => onServesOtherRegionsChanged(v ?? false),
              ),
              Expanded(
                child: Text(
                  checkboxLabel,
                  style: TextStyle(fontSize: 12.5.sp, color: ColorManager.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
