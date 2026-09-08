import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/app_loading_indicator.dart';
import 'owner_portfolio_view.dart' show pmDio;

/// تفاصيل الوحدة: المستأجر + العقد + سجل الدفعات
class ManagedUnitDetailsView extends StatefulWidget {
  final int unitId;

  const ManagedUnitDetailsView({super.key, required this.unitId});

  @override
  State<ManagedUnitDetailsView> createState() => _ManagedUnitDetailsViewState();
}

class _ManagedUnitDetailsViewState extends State<ManagedUnitDetailsView> {
  Map<String, dynamic>? _unit;
  Map<String, dynamic>? _contract;
  List<Map<String, dynamic>> _payments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final response = await pmDio.get('pm/units/${widget.unitId}');
      final data = response.data['data'] ?? {};
      if (!mounted) return;
      setState(() {
        _unit = data['unit'] == null ? null : Map<String, dynamic>.from(data['unit']);
        _contract =
            data['contract'] == null ? null : Map<String, dynamic>.from(data['contract']);
        _payments = ((data['payments'] ?? []) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
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
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 0,
        title: Text(
          _unit == null
              ? 'pm_unit_details'.tr()
              : '${_unit!['property'] ?? ''} — ${_unit!['unit_name'] ?? ''}',
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: AppLoadingIndicator())
          : ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                if (_contract != null) ...[
                  _tenantCard(),
                  verticalSpace(12),
                  _contractCard(),
                  verticalSpace(12),
                  _paymentsCard(),
                ] else
                  _vacantCard(),
              ],
            ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFEDEFF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: ColorManager.primary,
              )),
          verticalSpace(12),
          child,
        ],
      ),
    );
  }

  Widget _tenantCard() {
    final name = (_contract!['tenant_name'] ?? '').toString();
    final initials = name.trim().isEmpty
        ? '؟'
        : name.trim().split(RegExp(r'\s+')).take(1).first.characters.take(2).toString();

    return _card(
      title: 'pm_current_tenant'.tr(),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11.r),
            ),
            alignment: Alignment.center,
            child: Text(initials,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: ColorManager.primary,
                  fontSize: 13.sp,
                )),
          ),
          horizontalSpace(11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700)),
                verticalSpace(3),
                Text('📞 ${_contract!['tenant_phone'] ?? '-'}',
                    style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contractCard() {
    final daysLeft = int.tryParse((_contract!['days_left'] ?? 0).toString()) ?? 0;

    return _card(
      title: 'pm_contract'.tr(),
      child: Column(
        children: [
          _row('pm_monthly_rent'.tr(), '${_contract!['rent_amount']}'),
          _row('pm_deposit'.tr(), '${_contract!['deposit']}'),
          _row('pm_start_date'.tr(), '${_contract!['start_date'] ?? '-'}'),
          _row('pm_end_date'.tr(), '${_contract!['end_date'] ?? '-'}',
              valueColor: daysLeft <= 30 ? const Color(0xFFF79009) : null),
          verticalSpace(10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: daysLeft <= 30 ? const Color(0xFFFFFAEB) : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Text(
              daysLeft > 0
                  ? '⏰ ' + 'pm_contract_ends_in'.tr().replaceAll('{n}', '$daysLeft')
                  : 'pm_contract_ended'.tr(),
              style: TextStyle(
                fontSize: 11.5.sp,
                color: daysLeft <= 30 ? const Color(0xFFB54708) : const Color(0xFF667085),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentsCard() {
    return _card(
      title: 'pm_payments_log'.tr(),
      child: Column(
        children: _payments.map((p) {
          final status = (p['status'] ?? '').toString();
          late final String label;
          late final Color bg;
          late final Color fg;
          if (status == 'paid') {
            label = 'pm_paid'.tr();
            bg = const Color(0xFFECFDF3);
            fg = const Color(0xFF027A48);
          } else {
            label = 'pm_due'.tr();
            bg = const Color(0xFFFFFAEB);
            fg = const Color(0xFFB54708);
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            child: Row(
              children: [
                Expanded(
                  child: Text('${p['due_month']}',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF344054))),
                ),
                Text('${p['amount']} د.ك',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
                horizontalSpace(9),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(label,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      )),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _vacantCard() {
    return _card(
      title: 'pm_unit_status'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.meeting_room_outlined,
                  size: 19.sp, color: const Color(0xFF98A2B3)),
              horizontalSpace(9),
              Text('pm_unit_vacant_now'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
            ],
          ),
          verticalSpace(10),
          Text(
            '${'pm_suggested_rent'.tr()}: ${_unit?['rent_amount'] ?? 0}',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085), height: 1.7),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085))),
          Text(value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF101828),
              )),
        ],
      ),
    );
  }
}
