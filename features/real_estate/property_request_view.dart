import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/widgets/price_range_slider.dart';
import '../../core/widgets/region_picker_sheet.dart';

/// شاشة "اطلب عقارك" - المستخدم يوصف العقار اللي يبحث عنه (طلب، مو إعلان).
/// خطوتين: (1) نوع المعاملة + التصنيف + نوع العقار، (2) التفاصيل والميزانية.
class PropertyRequestView extends StatefulWidget {
  const PropertyRequestView({super.key});

  @override
  State<PropertyRequestView> createState() => _PropertyRequestViewState();
}

class _PropertyRequestViewState extends State<PropertyRequestView> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.afaq.group/api/',
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  int _step = 0;
  bool _submitting = false;

  // === الخطوة الأولى
  String? _transaction;
  String? _section;
  String? _propertyType;

  // === الخطوة الثانية
  String? _region;
  List<String> _regions = [];
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();

  int _rooms = 0;
  int _bathrooms = 0;
  int _floors = 0;
  bool _roomsAny = false;
  bool _bathroomsAny = false;
  bool _floorsAny = false;

  double _areaMin = 100;
  double _areaMax = 500;
  bool _areaAny = false;

  double _priceMin = 300;
  double _priceMax = 1000;
  bool _priceAny = false;

  bool _wantsPool = false;
  bool _wantsGarden = false;
  bool _wantsParking = false;

  String _forWhom = 'لنفسي';
  DateTime? _moveDate;

  static const List<String> _transactions = ['للبيع', 'للإيجار', 'للبدل'];
  static const List<String> _sections = ['سكني', 'تجاري', 'صناعي', 'استثماري'];

  static const Map<String, String> _labelKeys = {
    'للبيع': 'txn_sale', 'للإيجار': 'txn_rent', 'للبدل': 'txn_swap',
    'سكني': 'cat_residential', 'تجاري': 'cat_commercial',
    'صناعي': 'cat_industrial', 'استثماري': 'cat_investment',
    'شقة': 'ptype_apartment', 'بيت': 'ptype_house', 'دور': 'ptype_floor',
    'فيلا': 'ptype_villa', 'عمارة': 'ptype_building', 'دوبلكس': 'ptype_duplex',
    'استوديو': 'ptype_studio', 'أرض': 'ptype_land', 'بيت حكومي': 'ptype_gov_house',
    'سكن عمال': 'ptype_workers_housing', 'سرداب': 'ptype_basement',
    'مكتب': 'ptype_office', 'محل': 'ptype_shop', 'معرض': 'ptype_showroom',
    'مخزن': 'ptype_store', 'مستودع': 'ptype_warehouse',
    'أرض تجارية': 'ptype_commercial_land', 'شقة تجارية': 'ptype_commercial_apartment',
    'دور تجاري': 'ptype_commercial_floor', 'مجمع': 'ptype_complex',
    'مبنى تجاري': 'ptype_commercial_building', 'أرض صناعية': 'ptype_industrial_land',
    'مخزن صناعي': 'ptype_industrial_warehouse', 'ورشة': 'ptype_workshop',
    'مصنع': 'ptype_factory', 'حظيرة': 'ptype_barn',
    'عمارة استثمارية': 'ptype_investment_building', 'مجمع استثماري': 'ptype_investment_complex',
    'أرض استثمارية': 'ptype_investment_land', 'فندق': 'ptype_hotel',
  };

  String _label(String value) {
    final key = _labelKeys[value];
    return key == null ? value : AppStrings.getString(key, context.locale.languageCode);
  }

  static const Map<String, List<String>> _typesBySection = {
    'سكني': [
      'شقة', 'بيت', 'دور', 'فيلا', 'عمارة', 'دوبلكس',
      'استوديو', 'أرض', 'بيت حكومي', 'سكن عمال', 'سرداب',
    ],
    'تجاري': [
      'مكتب', 'محل', 'معرض', 'مخزن', 'مستودع', 'أرض تجارية',
      'شقة تجارية', 'دور تجاري', 'مجمع', 'مبنى تجاري', 'سرداب',
    ],
    'صناعي': ['أرض صناعية', 'مخزن صناعي', 'ورشة', 'مصنع', 'حظيرة'],
    'استثماري': ['عمارة استثمارية', 'مجمع استثماري', 'أرض استثمارية', 'فندق'],
  };

  // === أنواع فيها عدد طوابق
  static const List<String> _typesWithFloors = [
    'عمارة', 'بيت', 'فيلا', 'مبنى تجاري', 'مجمع', 'فندق',
    'عمارة استثمارية', 'مجمع استثماري', 'دوبلكس',
  ];

  bool get _hasFloors => _typesWithFloors.contains(_propertyType);

  @override
  void initState() {
    super.initState();
    _loadRegions();
  }

  // === مناطق الكويت من الباك اند (كانت القائمة فاضية فما يظهر شي)
  Future<void> _loadRegions() async {
    try {
      final response = await _dio.get('get-areas');
      final List<dynamic> data = response.data['data'] ?? [];
      final names = data
          .map((e) => (e is Map ? (e['name'] ?? '').toString() : e.toString()))
          .where((name) => name.isNotEmpty)
          .toList();
      if (mounted) setState(() => _regions = List<String>.from(names));
    } catch (_) {}
  }


  @override
  void dispose() {
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_region == null) {
      _snack('pr_pick_region'.tr());
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _snack('pr_pick_phone'.tr());
      return;
    }

    setState(() => _submitting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final response = await _dio.post('property-requests', data: {
        'user_id': userId,
        'transaction_type': _transaction,
        'property_section': _section,
        'property_type': _propertyType,
        'region': _region,
        // === "مش مهم" تُحفظ 0 بقاعدة البيانات
        'rooms': _roomsAny ? 0 : _rooms,
        'bathrooms': _bathroomsAny ? 0 : _bathrooms,
        'floors_count': (!_hasFloors || _floorsAny) ? 0 : _floors,
        'area_min': _areaAny ? 0 : _areaMin.round(),
        'area_max': _areaAny ? 0 : _areaMax.round(),
        'price_min': _priceAny ? 0 : _priceMin.round(),
        'price_max': _priceAny ? 0 : _priceMax.round(),
        'wants_pool': _wantsPool,
        'wants_garden': _wantsGarden,
        'wants_parking': _wantsParking,
        'for_whom': _forWhom,
        'move_date': _moveDate?.toIso8601String(),
        'description': _descriptionController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      if (!mounted) return;
      setState(() => _submitting = false);

      if (response.data['status'] == true) {
        _snack('pr_sent'.tr(), success: true);
        Navigator.pop(context);
      } else {
        _snack(response.data['message']?.toString() ?? 'common_server_error'.tr());
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _snack('common_server_error'.tr());
    }
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
              child: _step == 0
                  ? _buildStep1()
                  : _step == 1
                      ? _buildStep2()
                      : _buildStep3(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
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
                onTap: () {
                  if (_step > 0) {
                    setState(() => _step -= 1);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
              ),
              horizontalSpace(12),
              Text(
                'pr_title'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'pr_step_of'.tr().replaceAll('{n}', '${_step + 1}'),
                  style: TextStyle(color: Colors.white, fontSize: 11.5.sp),
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsets.only(right: 34.w),
            child: Text(
              _step == 0
                  ? 'pr_step1_sub'.tr()
                  : _step == 1
                      ? 'pr_step2_sub'.tr()
                      : 'pr_step3_sub'.tr(),
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

  // ==========================================================================
  // الخطوة الأولى: المعاملة + التصنيف + نوع العقار
  // ==========================================================================
  Widget _buildStep1() {
    final types = _section == null ? <String>[] : (_typesBySection[_section] ?? []);

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      children: [
        _card(
          icon: Icons.swap_horiz,
          title: 'pr_transaction'.tr(),
          child: _chips(
            options: _transactions,
            selected: _transaction,
            onSelected: (v) => setState(() {
              _transaction = v;
            }),
          ),
        ),
        verticalSpace(14),
        if (_transaction != null)
          _card(
            icon: Icons.category_outlined,
            title: 'pr_section'.tr(),
            child: _chips(
              options: _sections,
              selected: _section,
              onSelected: (v) => setState(() {
                _section = v;
                _propertyType = null;
              }),
            ),
          ),
        if (_section != null) ...[
          verticalSpace(14),
          _card(
            icon: Icons.home_work_outlined,
            title: 'pr_property_type'.tr(),
            child: _chips(
              options: types,
              selected: _propertyType,
              onSelected: (v) => setState(() => _propertyType = v),
            ),
          ),
        ],
        verticalSpace(24),
        _primaryButton(
          label: 'pr_next'.tr(),
          enabled: _transaction != null && _section != null && _propertyType != null,
          onTap: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  // ==========================================================================
  // الخطوة الثانية: التفاصيل والميزانية
  // ==========================================================================
  Widget _buildStep2() {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      children: [
        // === ملخص اختيارات الخطوة الأولى
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 16.sp, color: ColorManager.primary),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  '${_label(_propertyType ?? '')} ${_label(_transaction ?? '')} • ${_label(_section ?? '')}',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _step = 0),
                child: Text(
                  'pr_change'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(14),

        // === الموقع
        _card(
          icon: Icons.location_on_outlined,
          title: 'pr_location'.tr(),
          child: GestureDetector(
            onTap: _pickRegion,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE4E7EC)),
              ),
              child: Row(
                children: [
                  Icon(Icons.map_outlined, size: 18.sp, color: ColorManager.primary),
                  horizontalSpace(10),
                  Expanded(
                    child: Text(
                      _region ?? 'pm_region_hint'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: _region != null ? FontWeight.w600 : FontWeight.w400,
                        color: _region != null
                            ? const Color(0xFF101828)
                            : const Color(0xFF98A2B3),
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 20.sp, color: const Color(0xFF98A2B3)),
                ],
              ),
            ),
          ),
        ),
        verticalSpace(14),

        // === المواصفات
        _card(
          icon: Icons.tune,
          title: 'pr_specs'.tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _counterRow(
                label: 'pr_rooms'.tr(),
                value: _rooms,
                any: _roomsAny,
                onChanged: (v) => setState(() => _rooms = v),
                onAnyChanged: (v) => setState(() => _roomsAny = v),
              ),
              verticalSpace(14),
              _counterRow(
                label: 'pr_bathrooms'.tr(),
                value: _bathrooms,
                any: _bathroomsAny,
                onChanged: (v) => setState(() => _bathrooms = v),
                onAnyChanged: (v) => setState(() => _bathroomsAny = v),
              ),
              if (_hasFloors) ...[
                verticalSpace(14),
                _counterRow(
                  label: 'pr_floors'.tr(),
                  value: _floors,
                  any: _floorsAny,
                  onChanged: (v) => setState(() => _floors = v),
                  onAnyChanged: (v) => setState(() => _floorsAny = v),
                ),
              ],
              verticalSpace(18),
              _rangeBlock(
                label: 'pr_area'.tr(),
                unit: 'م²',
                any: _areaAny,
                onAnyChanged: (v) => setState(() => _areaAny = v),
                slider: PriceRangeSlider(
                  min: 0,
                  max: 2000,
                  step: 10,
                  initialMin: _areaMin,
                  initialMax: _areaMax,
                  currencyLabel: 'م²',
                  onChanged: (min, max) {
                    _areaMin = min;
                    _areaMax = max;
                  },
                ),
              ),
              verticalSpace(18),
              _rangeBlock(
                label: 'pr_budget'.tr(),
                unit: 'د.ك',
                any: _priceAny,
                onAnyChanged: (v) => setState(() => _priceAny = v),
                slider: PriceRangeSlider(
                  min: 0,
                  max: 500000,
                  step: 100,
                  initialMin: _priceMin,
                  initialMax: _priceMax,
                  currencyLabel: 'د.ك',
                  onChanged: (min, max) {
                    _priceMin = min;
                    _priceMax = max;
                  },
                ),
              ),
            ],
          ),
        ),
        verticalSpace(14),

        // === المرفقات الإضافية
        _card(
          icon: Icons.pool_outlined,
          title: 'pr_extras'.tr(),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _toggleChip('pr_pool'.tr(), Icons.pool, _wantsPool,
                  (v) => setState(() => _wantsPool = v)),
              _toggleChip('pr_garden'.tr(), Icons.grass, _wantsGarden,
                  (v) => setState(() => _wantsGarden = v)),
              _toggleChip('pr_parking'.tr(), Icons.local_parking, _wantsParking,
                  (v) => setState(() => _wantsParking = v)),
            ],
          ),
        ),
        verticalSpace(14),

        _primaryButton(
          label: 'pr_next'.tr(),
          enabled: _region != null,
          onTap: () => setState(() => _step = 2),
        ),
        verticalSpace(20),
      ],
    );
  }

  // ==========================================================================
  // الخطوة الثالثة: معلومات الطلب والتواصل
  // ==========================================================================
  Widget _buildStep3() {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      children: [
        // === معلومات الطالب
        _card(
          icon: Icons.person_outline,
          title: 'pr_request_info'.tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('pr_for_whom'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(8),
              Row(
                children: ['pr_for_me'.tr(), 'pr_for_other'.tr()].map((option) {
                  final selected = _forWhom == option;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: option == 'pr_for_me'.tr() ? 8.w : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _forWhom = option),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? ColorManager.primary
                                : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: selected
                                  ? ColorManager.primary
                                  : const Color(0xFFE4E7EC),
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected ? Colors.white : const Color(0xFF475467),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              verticalSpace(16),
              Text('pr_move_date'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(8),
              GestureDetector(
                onTap: _pickMoveDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE4E7EC)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined,
                          size: 18.sp, color: ColorManager.primary),
                      horizontalSpace(10),
                      Expanded(
                        child: Text(
                          _moveDate != null
                              ? _formatDate(_moveDate!)
                              : 'pr_pick_date'.tr(),
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: _moveDate != null
                                ? const Color(0xFF101828)
                                : const Color(0xFF98A2B3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(16),
              Text('pr_phone'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('965xxxxxxxx'),
              ),
              verticalSpace(16),
              Text('pr_desc'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration('pr_desc_hint'.tr()),
              ),
            ],
          ),
        ),
        verticalSpace(22),
        _primaryButton(
          label: _submitting ? '' : 'pr_submit'.tr(),
          enabled: !_submitting,
          loading: _submitting,
          onTap: _submit,
        ),
        verticalSpace(20),
      ],
    );
  }

  // ==========================================================================
  // عناصر مساعدة
  // ==========================================================================

  Future<void> _pickRegion() async {
    if (_regions.isEmpty) await _loadRegions();
    if (!mounted) return;
    final selected = await showRegionPickerSheet(
      context,
      regions: _regions,
      current: _region,
    );
    if (selected != null) {
      setState(() => _region = selected.isEmpty ? null : selected);
    }
  }

  Future<void> _pickMoveDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _moveDate ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      helpText: 'تاريخ الانتقال المتوقع',
      cancelText: 'إلغاء',
      confirmText: 'تحديد',
    );
    if (picked != null) setState(() => _moveDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF98A2B3)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
        ),
      );

  Widget _card({
    required IconData icon,
    required String title,
    required Widget child,
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
          verticalSpace(14),
          child,
        ],
      ),
    );
  }

  Widget _chips({
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? ColorManager.primary : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected ? ColorManager.primary : const Color(0xFFE4E7EC),
              ),
            ),
            child: Text(
              _label(option),
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xFF475467),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _toggleChip(
    String label,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: value ? ColorManager.primary : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: value ? ColorManager.primary : const Color(0xFFE4E7EC),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15.sp, color: value ? Colors.white : const Color(0xFF667085)),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                color: value ? Colors.white : const Color(0xFF475467),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// عدّاد بـ +/- مع خيار "مش مهم" (يحفظ 0)
  Widget _counterRow({
    required String label,
    required int value,
    required bool any,
    required ValueChanged<int> onChanged,
    required ValueChanged<bool> onAnyChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
            ),
            Opacity(
              opacity: any ? 0.35 : 1,
              child: Row(
                children: [
                  _counterButton(Icons.remove,
                      any || value <= 0 ? null : () => onChanged(value - 1)),
                  Container(
                    width: 42.w,
                    alignment: Alignment.center,
                    child: Text(
                      any ? '—' : '$value',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  _counterButton(Icons.add, any ? null : () => onChanged(value + 1)),
                ],
              ),
            ),
          ],
        ),
        verticalSpace(6),
        _anyCheckbox(any, onAnyChanged),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 16.sp, color: const Color(0xFF475467)),
      ),
    );
  }

  Widget _rangeBlock({
    required String label,
    required String unit,
    required bool any,
    required ValueChanged<bool> onAnyChanged,
    required Widget slider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        verticalSpace(8),
        Opacity(
          opacity: any ? 0.35 : 1,
          child: IgnorePointer(ignoring: any, child: slider),
        ),
        verticalSpace(4),
        _anyCheckbox(any, onAnyChanged),
      ],
    );
  }

  Widget _anyCheckbox(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_box : Icons.check_box_outline_blank,
            size: 19.sp,
            color: value ? ColorManager.primary : const Color(0xFF98A2B3),
          ),
          horizontalSpace(7),
          Text(
            'pr_any'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: value ? ColorManager.primary : const Color(0xFF667085),
              fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required bool enabled,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF14181F) : const Color(0xFFD0D5DD),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.4),
              )
            : Text(
                label,
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
