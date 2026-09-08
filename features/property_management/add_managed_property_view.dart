import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/region_picker_sheet.dart';
import 'owner_portfolio_view.dart' show pmDio;

/// تسليم عقار للإدارة — بيانات العقار + وحداته
class AddManagedPropertyView extends StatefulWidget {
  const AddManagedPropertyView({super.key});

  @override
  State<AddManagedPropertyView> createState() => _AddManagedPropertyViewState();
}

class _UnitDraft {
  final TextEditingController name = TextEditingController();
  final TextEditingController rent = TextEditingController();
  int rooms = 0;
  int bathrooms = 0;
}

class _AddManagedPropertyViewState extends State<AddManagedPropertyView> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String? _region;
  String? _type;
  List<String> _regions = [];
  final List<_UnitDraft> _units = [_UnitDraft()];
  bool _submitting = false;

  static const List<String> _types = ['عمارة', 'بيت', 'فيلا', 'شقة', 'دور', 'مجمع تجاري'];

  @override
  void initState() {
    super.initState();
    _loadRegions();
  }

  Future<void> _loadRegions() async {
    try {
      final response = await pmDio.get('get-areas');
      final List<dynamic> data = response.data['data'] ?? [];
      final names = data
          .map((e) => (e is Map ? (e['name'] ?? '').toString() : e.toString()))
          .where((n) => n.isNotEmpty)
          .toList();
      if (mounted) setState(() => _regions = List<String>.from(names));
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    for (final u in _units) {
      u.name.dispose();
      u.rent.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty) {
      _snack('pm_property_name'.tr());
      return;
    }
    if (_region == null) {
      _snack('pr_pick_region'.tr());
      return;
    }

    setState(() => _submitting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final response = await pmDio.post('pm/properties', data: {
        'owner_id': userId,
        'name': _nameController.text.trim(),
        'region': _region,
        'address': _addressController.text.trim(),
        'property_type': _type,
        'units': _units
            .where((u) => u.name.text.trim().isNotEmpty)
            .map((u) => {
                  'unit_name': u.name.text.trim(),
                  'rooms': u.rooms,
                  'bathrooms': u.bathrooms,
                  'rent_amount': double.tryParse(u.rent.text.trim()) ?? 0,
                })
            .toList(),
      });

      if (!mounted) return;
      setState(() => _submitting = false);

      if (response.data['status'] == true) {
        _snack('pm_received'.tr(), success: true);
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

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: success ? Colors.green : null),
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 18.h),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(22.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 22.sp),
                      ),
                      horizontalSpace(12),
                      Text('pm_hand_over_title'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  verticalSpace(8),
                  Padding(
                    padding: EdgeInsets.only(right: 34.w),
                    child: Text(
                      'pm_hand_over_sub'.tr(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                children: [
                  _card(
                    icon: Icons.home_work_outlined,
                    title: 'pm_property_data'.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('pm_property_name'.tr()),
                        TextField(
                          controller: _nameController,
                          decoration: _dec('pm_property_name_hint'.tr()),
                        ),
                        verticalSpace(14),
                        _label('pm_property_type'.tr()),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _types.map((t) {
                            final selected = _type == t;
                            return GestureDetector(
                              onTap: () => setState(() => _type = t),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 9.h),
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
                                child: Text(t,
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF475467),
                                    )),
                              ),
                            );
                          }).toList(),
                        ),
                        verticalSpace(14),
                        _label('pm_region'.tr()),
                        GestureDetector(
                          onTap: () async {
                            if (_regions.isEmpty) await _loadRegions();
                            if (!mounted) return;
                            final selected = await showRegionPickerSheet(
                              context,
                              regions: _regions,
                              current: _region,
                            );
                            if (selected != null) {
                              setState(() =>
                                  _region = selected.isEmpty ? null : selected);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: const Color(0xFFE4E7EC)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.map_outlined,
                                    size: 18.sp, color: ColorManager.primary),
                                horizontalSpace(10),
                                Expanded(
                                  child: Text(
                                    _region ?? 'pm_region_hint'.tr(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: _region != null
                                          ? const Color(0xFF101828)
                                          : const Color(0xFF98A2B3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalSpace(14),
                        _label('pm_address'.tr()),
                        TextField(
                          controller: _addressController,
                          decoration: _dec('pm_address_hint'.tr()),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(14),
                  _card(
                    icon: Icons.meeting_room_outlined,
                    title: 'pm_units'.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(_units.length, (i) => _unitRow(i)),
                        verticalSpace(6),
                        GestureDetector(
                          onTap: () => setState(() => _units.add(_UnitDraft())),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorManager.primary.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(11.r),
                            ),
                            child: Text('pm_add_unit'.tr(),
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.primary,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(22),
                  GestureDetector(
                    onTap: _submitting ? null : _submit,
                    child: Container(
                      height: 54.h,
                      decoration: BoxDecoration(
                        color: _submitting
                            ? const Color(0xFF98A2B3)
                            : const Color(0xFF14181F),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      alignment: Alignment.center,
                      child: _submitting
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.4),
                            )
                          : Text('pm_send_request'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              )),
                    ),
                  ),
                  verticalSpace(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unitRow(int index) {
    final unit = _units[index];
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('${'pm_unit'.tr()} ${index + 1}',
                  style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (_units.length > 1)
                GestureDetector(
                  onTap: () => setState(() => _units.removeAt(index)),
                  child: Icon(Icons.close, size: 17.sp, color: const Color(0xFFF04438)),
                ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: unit.name,
                  decoration: _dec('pm_unit_name_hint'.tr(), filled: Colors.white),
                ),
              ),
              horizontalSpace(8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: unit.rent,
                  keyboardType: TextInputType.number,
                  decoration: _dec('pm_rent_hint'.tr(), filled: Colors.white),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: _counter('pm_rooms'.tr(), unit.rooms,
                    (v) => setState(() => unit.rooms = v)),
              ),
              horizontalSpace(10),
              Expanded(
                child: _counter('pm_bathrooms'.tr(), unit.bathrooms,
                    (v) => setState(() => unit.bathrooms = v)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counter(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
        const Spacer(),
        GestureDetector(
          onTap: value > 0 ? () => onChanged(value - 1) : null,
          child: Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: Icon(Icons.remove, size: 13.sp, color: const Color(0xFF475467)),
          ),
        ),
        Container(
          width: 28.w,
          alignment: Alignment.center,
          child: Text('$value',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
        ),
        GestureDetector(
          onTap: () => onChanged(value + 1),
          child: Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: Icon(Icons.add, size: 13.sp, color: const Color(0xFF475467)),
          ),
        ),
      ],
    );
  }

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
              Text(title,
                  style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
            ],
          ),
          verticalSpace(14),
          child,
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Text(text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          )),
    );
  }

  InputDecoration _dec(String hint, {Color filled = const Color(0xFFF9FAFB)}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF98A2B3)),
        filled: true,
        fillColor: filled,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11.r),
          borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11.r),
          borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
        ),
      );
}
