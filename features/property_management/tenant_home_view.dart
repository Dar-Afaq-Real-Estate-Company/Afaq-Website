import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/widgets/app_loading_indicator.dart';
import 'owner_portfolio_view.dart' show pmDio;

/// شاشة المستأجر — عقده والإيجار المستحق وطلبات الصيانة
class TenantHomeView extends StatefulWidget {
  const TenantHomeView({super.key});

  @override
  State<TenantHomeView> createState() => _TenantHomeViewState();
}

class _TenantHomeViewState extends State<TenantHomeView> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final response = await pmDio.get('pm/tenant-home', queryParameters: {
        'user_id': userId,
      });
      if (!mounted) return;
      setState(() {
        _data = response.data['data'] == null
            ? null
            : Map<String, dynamic>.from(response.data['data']);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: AppLoadingIndicator())
            : _data == null
                ? _noContract()
                : RefreshIndicator(
                    onRefresh: _fetch,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _header(),
                        _rentCard(),
                        _quickActions(),
                        _openRequests(),
                        _paymentHistory(),
                        verticalSpace(24),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _noContract() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_outlined, size: 52.sp, color: const Color(0xFFD0D5DD)),
            verticalSpace(14),
            Text('pm_no_contract'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600)),
            verticalSpace(8),
            Text(
              'pm_no_contract_sub'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.5.sp, color: ColorManager.grey, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 20.h),
      color: const Color(0xFF14181F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('pm_your_home'.tr(),
              style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
          verticalSpace(4),
          Text('${_data!['property'] ?? ''} — ${_data!['unit_name'] ?? ''}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              )),
        ],
      ),
    );
  }

  Widget _rentCard() {
    final payment = _data!['current_payment'];
    if (payment == null) {
      return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEDEFF3)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: const Color(0xFF12B76A), size: 22.sp),
            horizontalSpace(10),
            Text('pm_all_paid'.tr(),
                style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    final int? daysToDue = int.tryParse((payment['days_to_due'] ?? '').toString());

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDEFF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${'pm_rent_of'.tr()} ${payment['due_month']}',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085))),
          verticalSpace(4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${payment['amount']}',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF101828),
                  )),
              horizontalSpace(5),
              Text('د.ك', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          verticalSpace(9),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: (daysToDue != null && daysToDue < 0)
                  ? const Color(0xFFFEF3F2)
                  : const Color(0xFFFFFAEB),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              daysToDue == null
                  ? 'pm_due'.tr()
                  : daysToDue < 0
                      ? 'pm_late_by_days'.tr().replaceAll('{n}', '${daysToDue.abs()}')
                      : 'pm_due_in_days'.tr().replaceAll('{n}', '$daysToDue'),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: (daysToDue != null && daysToDue < 0)
                    ? const Color(0xFFB42318)
                    : const Color(0xFFB54708),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDEFF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('pm_quick_actions'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: _action('pm_request_maintenance'.tr(), Icons.build_outlined, () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MaintenanceRequestView(
                        unitId: int.tryParse((_data!['unit_id'] ?? 0).toString()) ?? 0,
                      ),
                    ),
                  );
                  _fetch();
                }),
              ),
              horizontalSpace(10),
              Expanded(
                child: _action('pm_contract_details'.tr(), Icons.description_outlined,
                    _showContractSheet),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20.sp, color: ColorManager.primary),
            verticalSpace(6),
            Text(label,
                style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showContractSheet() {
    final c = _data!['contract'];
    if (c == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            verticalSpace(18),
            Text('pm_contract_details'.tr(),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            verticalSpace(16),
            _row('pm_monthly_rent'.tr(), '${c['rent_amount']}'),
            _row('pm_deposit'.tr(), '${c['deposit']}'),
            _row('pm_start_date'.tr(), '${c['start_date'] ?? '-'}'),
            _row('pm_end_date'.tr(), '${c['end_date'] ?? '-'}'),
            _row('pm_days_left'.tr(), '${c['days_left'] ?? 0}'),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF667085))),
          Text(value,
              style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _openRequests() {
    final List requests = _data!['open_requests'] ?? [];
    if (requests.isEmpty) return verticalSpace(14);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('pm_open_requests'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          verticalSpace(10),
          ...requests.map((r) {
            final status = (r['status'] ?? '').toString();
            final labels = {
              'new': ['pm_new'.tr(), const Color(0xFF667085)],
              'assigned': ['pm_assigned'.tr(), const Color(0xFFB54708)],
              'in_progress': ['pm_in_progress'.tr(), const Color(0xFF175CD3)],
            };
            final label = labels[status]?[0] as String? ?? status;
            final color = labels[status]?[1] as Color? ?? const Color(0xFF667085);

            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFEDEFF3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF8FF),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.build_outlined,
                        size: 17.sp, color: const Color(0xFF175CD3)),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${r['category']}',
                            style: TextStyle(
                                fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
                        verticalSpace(2),
                        Text(
                          r['vendor_name'] != null
                              ? '${'pm_assigned_to'.tr()}: ${r['vendor_name']}'
                              : 'pm_awaiting_assign'.tr(),
                          style: TextStyle(
                              fontSize: 11.sp, color: const Color(0xFF667085)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(label,
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: color)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _paymentHistory() {
    final List payments = _data!['payments'] ?? [];
    if (payments.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEDEFF3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('pm_payments_log'.tr(),
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
            verticalSpace(10),
            ...payments.map((p) {
              final paid = (p['status'] ?? '') == 'paid';
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${p['due_month']}',
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xFF344054))),
                    ),
                    Text('${p['amount']} د.ك',
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w700)),
                    horizontalSpace(9),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: paid
                            ? const Color(0xFFECFDF3)
                            : const Color(0xFFFFFAEB),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(paid ? 'pm_paid'.tr() : 'pm_due'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: paid
                                ? const Color(0xFF027A48)
                                : const Color(0xFFB54708),
                          )),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// نموذج رفع طلب صيانة
class MaintenanceRequestView extends StatefulWidget {
  final int unitId;

  const MaintenanceRequestView({super.key, required this.unitId});

  @override
  State<MaintenanceRequestView> createState() => _MaintenanceRequestViewState();
}

class _MaintenanceRequestViewState extends State<MaintenanceRequestView> {
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  String _category = 'pm_ac';
  String _priority = 'عادي';
  final List<File> _images = [];
  bool _submitting = false;

  static const List<String> _categoryKeys = [
    'pm_ac', 'pm_plumbing', 'pm_electricity', 'pm_carpentry', 'pm_painting', 'pm_other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) setState(() => _images.add(File(picked.path)));
  }

  Future<void> _submit() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pm_problem_desc'.tr())),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final images = <String>[];
      for (final file in _images) {
        images.add(base64Encode(await file.readAsBytes()));
      }

      final response = await pmDio.post('pm/maintenance-requests', data: {
        'unit_id': widget.unitId,
        'tenant_user_id': userId,
        'category': AppStrings.getString(_category, 'ar'),
        'priority': _priority,
        'description': _descriptionController.text.trim(),
        'images': images,
      });

      if (!mounted) return;
      setState(() => _submitting = false);

      if (response.data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('pm_maintenance_sent'.tr()),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('common_server_error'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181F),
        elevation: 0,
        title: Text('pm_new_maintenance'.tr(),
            style: TextStyle(color: Colors.white, fontSize: 15.5.sp)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text('pm_fault_type'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          verticalSpace(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _categoryKeys.map((c) {
              final selected = _category == c;
              return GestureDetector(
                onTap: () => setState(() => _category = c),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF1E5FBF) : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF1E5FBF)
                          : const Color(0xFFE4E7EC),
                    ),
                  ),
                  child: Text(c.tr(),
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        color: selected ? Colors.white : const Color(0xFF475467),
                      )),
                ),
              );
            }).toList(),
          ),
          verticalSpace(20),
          Text('pm_priority'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          verticalSpace(10),
          Row(
            children: ['pm_normal'.tr(), 'pm_urgent'.tr()].map((p) {
              final selected = _priority == p;
              final isUrgent = p == 'pm_urgent'.tr();
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: p == 'عادي' ? 8.w : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? (isUrgent
                                ? const Color(0xFFFEF3F2)
                                : ColorManager.primary.withOpacity(0.08))
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: selected
                              ? (isUrgent
                                  ? const Color(0xFFF04438)
                                  : ColorManager.primary)
                              : const Color(0xFFE4E7EC),
                        ),
                      ),
                      child: Text(p,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                            color: selected
                                ? (isUrgent
                                    ? const Color(0xFFF04438)
                                    : ColorManager.primary)
                                : const Color(0xFF475467),
                          )),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          verticalSpace(20),
          Text('pm_problem_desc'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          verticalSpace(10),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'pm_problem_hint'.tr(),
              hintStyle: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF98A2B3)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
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
          verticalSpace(20),
          Text('pm_photos'.tr(),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          verticalSpace(10),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 66.w,
                  height: 66.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.r),
                    border: Border.all(
                      color: const Color(0xFFD0D5DD),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(Icons.add, size: 22.sp, color: const Color(0xFF98A2B3)),
                ),
              ),
              ..._images.asMap().entries.map((e) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11.r),
                        child: Image.file(e.value,
                            width: 66.w, height: 66.w, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 2,
                        left: 2,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.removeAt(e.key)),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close,
                                size: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          verticalSpace(26),
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
                  : Text('إرسال الطلب',
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
    );
  }
}
