import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/helper/shared_pref.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/resources/color_manager.dart';

/// حاسبة تقدير القيمة العقارية - نفس تصميم حاسبتي البناء والإيجار.
/// المعادلة: القيمة = المساحة × السعر الأساسي (حسب تصنيف المنطقة)
/// × معامل عمر المبنى × معامل التشطيب + قيمة إضافية ثابتة للمرافق.
class CalculateMarketValueView extends StatefulWidget {
  const CalculateMarketValueView({super.key});

  @override
  State<CalculateMarketValueView> createState() => _CalculateMarketValueViewState();
}

class _CalculateMarketValueViewState extends State<CalculateMarketValueView> {
  final TextEditingController _areaController = TextEditingController();

  int _regionTier = 1; // راقية / متوسطة / اقتصادية
  int _age = 1; // جديد / متوسط العمر / قديم
  int _finishing = 1; // اقتصادي / ديلوكس / سوبر ديلوكس
  bool _hasPool = false;
  bool _hasGarden = false;

  static const List<Map<String, dynamic>> _regionOptions = [
    {'label': 'منطقة راقية', 'rate': 850.0},
    {'label': 'منطقة متوسطة', 'rate': 550.0},
    {'label': 'منطقة اقتصادية', 'rate': 350.0},
  ];
  static const List<Map<String, dynamic>> _ageOptions = [
    {'label': 'جديد (أقل من 5 سنوات)', 'factor': 1.1},
    {'label': 'متوسط العمر (5-15 سنة)', 'factor': 1.0},
    {'label': 'قديم (أكثر من 15 سنة)', 'factor': 0.85},
  ];
  static const List<Map<String, dynamic>> _finishingOptions = [
    {'label': 'اقتصادي', 'factor': 0.9},
    {'label': 'ديلوكس', 'factor': 1.0},
    {'label': 'سوبر ديلوكس', 'factor': 1.15},
  ];

  double get _area => double.tryParse(_areaController.text.trim()) ?? 0;
  double get _baseRate => _regionOptions[_regionTier]['rate'] as double;
  double get _ageFactor => _ageOptions[_age]['factor'] as double;
  double get _finishingFactor => _finishingOptions[_finishing]['factor'] as double;
  double get _amenitiesAddition => (_hasPool ? 8000 : 0) + (_hasGarden ? 4000 : 0);

  double get _estimatedValue => (_area * _baseRate * _ageFactor * _finishingFactor) + _amenitiesAddition;

  bool _sending = false;

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _openOfficialRequestSheet() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22.r))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('طلب تقييم عقاري رسمي', style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w800)),
                    verticalSpace(4),
                    Text('سيتواصل معك أحد مقيّمينا المعتمدين لتأكيد التفاصيل والزيارة الميدانية',
                        style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF98A2B3))),
                    verticalSpace(16),
                    _sheetField(controller: nameController, hint: 'الاسم الكامل', icon: Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null),
                    verticalSpace(10),
                    _sheetField(controller: phoneController, hint: 'رقم الهاتف', icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null),
                    verticalSpace(10),
                    _sheetField(controller: emailController, hint: 'البريد الإلكتروني', icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'مطلوب';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) return 'بريد غير صحيح';
                          return null;
                        }),
                    verticalSpace(18),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                        ),
                        onPressed: _sending
                            ? null
                            : () async {
                                if (!(formKey.currentState?.validate() ?? false)) return;
                                setState(() => _sending = true);
                                await _submitOfficialRequest(
                                  name: nameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  email: emailController.text.trim(),
                                );
                                setState(() => _sending = false);
                                if (mounted) Navigator.pop(sheetContext);
                              },
                        child: _sending
                            ? SizedBox(width: 20.w, height: 20.w, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2))
                            : Text('إرسال الطلب', style: TextStyle(color: Colors.white, fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sheetField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp),
        prefixIcon: Icon(icon, size: 19.sp, color: const Color(0xFF98A2B3)),
        filled: true,
        fillColor: const Color(0xFFF7F8F9),
        contentPadding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 14.w),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: const BorderSide(color: Color(0xFFE4E7EC))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: const BorderSide(color: Color(0xFFE4E7EC))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: ColorManager.primary, width: 1.6)),
      ),
    );
  }

  Future<void> _submitOfficialRequest({required String name, required String phone, required String email}) async {
    try {
      final int userId = await SharedPrefHelper.getInt('userId');
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.apiBaseUrl));
      await dio.post('property-valuation-request', data: {
        'user_id': userId,
        'name': name,
        'phone': phone,
        'email': email,
        'area': _area,
        'region_tier': _regionOptions[_regionTier]['label'],
        'age': _ageOptions[_age]['label'],
        'finishing': _finishingOptions[_finishing]['label'],
        'has_pool': _hasPool,
        'has_garden': _hasGarden,
        'estimated_value': _estimatedValue,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            content: const Text('تم إرسال طلب التقييم الرسمي بنجاح، سيتواصل معك فريقنا قريبًا'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            content: const Text('تعذر إرسال الطلب، تأكد من اتصالك بالإنترنت وحاول مرة أخرى'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('حاسبة القيمة العقارية'),
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
            _label('مساحة العقار (م²)'),
            verticalSpace(8),
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'مثال: 400',
                filled: true,
                fillColor: const Color(0xFFF7F8F9),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: const BorderSide(color: Color(0xFFE4E7EC))),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: const BorderSide(color: Color(0xFFE4E7EC))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: ColorManager.primary, width: 1.6)),
              ),
            ),
            verticalSpace(18),
            _label('تصنيف المنطقة'),
            verticalSpace(8),
            _optionPicker(_regionOptions.map((o) => o['label'] as String).toList(), _regionTier, (v) => setState(() => _regionTier = v)),
            verticalSpace(14),
            _label('عمر المبنى'),
            verticalSpace(8),
            _optionPicker(_ageOptions.map((o) => o['label'] as String).toList(), _age, (v) => setState(() => _age = v)),
            verticalSpace(14),
            _label('نوع التشطيب'),
            verticalSpace(8),
            _optionPicker(_finishingOptions.map((o) => o['label'] as String).toList(), _finishing, (v) => setState(() => _finishing = v)),
            verticalSpace(14),
            _label('مرافق إضافية'),
            verticalSpace(8),
            Row(
              children: [
                Expanded(
                  child: _toggleChip('مسبح', _hasPool, (v) => setState(() => _hasPool = v)),
                ),
                horizontalSpace(10),
                Expanded(
                  child: _toggleChip('حديقة', _hasGarden, (v) => setState(() => _hasGarden = v)),
                ),
              ],
            ),
            verticalSpace(24),

            if (_area > 0) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: const Color(0xFFF6F8F8), borderRadius: BorderRadius.circular(18.r)),
                child: Column(
                  children: [
                    Text('القيمة السوقية التقديرية', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF98A2B3))),
                    verticalSpace(6),
                    Text('${_estimatedValue.toStringAsFixed(0)} د.ك',
                        style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w900, color: ColorManager.primary)),
                    verticalSpace(10),
                    _breakdownRow('المساحة × السعر الأساسي (${_area.toStringAsFixed(0)}×$_baseRate)', _area * _baseRate),
                    _breakdownRow('بعد معامل العمر والتشطيب (×${(_ageFactor * _finishingFactor).toStringAsFixed(2)})',
                        _area * _baseRate * _ageFactor * _finishingFactor),
                    if (_amenitiesAddition > 0) _breakdownRow('إضافة المرافق', _amenitiesAddition),
                  ],
                ),
              ),
              verticalSpace(16),
            ],

            Text(
              'الأرقام تقديرية بناءً على متوسط أسعار السوق، ولا تُعتبر تقييمًا رسميًا معتمدًا.',
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF98A2B3)),
            ),
            verticalSpace(24),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: _openOfficialRequestSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                icon: Icon(Icons.verified_outlined, color: Colors.white, size: 19.sp),
                label: Text('طلب تقييم عقاري رسمي', style: TextStyle(color: Colors.white, fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
              ),
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
          Text('${value.toStringAsFixed(0)} د.ك', style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
        ],
      ),
    );
  }

  Widget _toggleChip(String label, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: value ? ColorManager.primary : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: value ? Colors.white : const Color(0xFF344054))),
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
