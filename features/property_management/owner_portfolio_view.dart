import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/app_loading_indicator.dart';
import 'managed_unit_details_view.dart';
import 'add_managed_property_view.dart';

final Dio pmDio = Dio(BaseOptions(
  baseUrl: 'https://api.afaq.group/api/',
  connectTimeout: const Duration(seconds: 20),
  receiveTimeout: const Duration(seconds: 20),
));

/// محفظة المالك — عقاراته المُدارة مع دخل الشهر وحالة الوحدات
class OwnerPortfolioView extends StatefulWidget {
  const OwnerPortfolioView({super.key});

  @override
  State<OwnerPortfolioView> createState() => _OwnerPortfolioViewState();
}

class _OwnerPortfolioViewState extends State<OwnerPortfolioView> {
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _properties = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      if (userId == 0) {
        if (!mounted) return;
        setState(() {
          _error = 'pm_login_first'.tr();
          _loading = false;
        });
        return;
      }
      final response = await pmDio.get('pm/owner-portfolio', queryParameters: {
        'user_id': userId,
      });
      final List<dynamic> data = response.data['data'] ?? [];
      if (!mounted) return;
      setState(() {
        _summary = Map<String, dynamic>.from(response.data['summary'] ?? {});
        _properties = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      // === نعرض السبب الحقيقي بدل رسالة عامة
      String message = 'تعذر تحميل محفظتك: $e';
      if (e is DioException) {
        final code = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        } else if (code != null) {
          message = 'فشل الاتصال (رمز $code)';
        } else {
          message = 'تعذر الاتصال بالسيرفر، تحقق من الإنترنت';
        }
      }
      setState(() {
        _error = message;
        _loading = false;
      });
    }
  }

  String _money(dynamic v) {
    final value = double.tryParse((v ?? 0).toString()) ?? 0;
    return value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2);
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
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 20.h),
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
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
              ),
              horizontalSpace(12),
              Text(
                'pm_my_properties_title'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'pm_month_income'.tr(),
                  '${_money(_summary['month_income'])} د.ك',
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: _summaryCard(
                  'pm_rented_units'.tr(),
                  '${_summary['rented_units'] ?? 0} ${'pm_of'.tr()} ${_summary['total_units'] ?? 0}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
          verticalSpace(3),
          Text(value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
              )),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: AppLoadingIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: TextStyle(fontSize: 13.sp, color: ColorManager.grey)),
            verticalSpace(12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
              onPressed: _fetch,
              child: Text('pm_retry'.tr(), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetch,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
        children: [
          Row(
            children: [
              Text('pm_my_properties'.tr(),
                  style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w900)),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddManagedPropertyView()),
                  );
                  _fetch();
                },
                child: Text('pm_hand_over'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.primary,
                    )),
              ),
            ],
          ),
          verticalSpace(12),
          if (_properties.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Column(
                children: [
                  Icon(Icons.home_work_outlined,
                      size: 48.sp, color: const Color(0xFFD0D5DD)),
                  verticalSpace(12),
                  Text('pm_no_properties'.tr(),
                      style: TextStyle(fontSize: 14.sp, color: ColorManager.grey)),
                ],
              ),
            )
          else
            ..._properties.map(_propertyCard),
        ],
      ),
    );
  }

  Widget _propertyCard(Map<String, dynamic> p) {
    final int status = int.tryParse((p['status'] ?? 0).toString()) ?? 0;
    final labels = {
      0: ['pm_status_pending'.tr(), const Color(0xFFF79009)],
      1: ['pm_status_managed'.tr(), const Color(0xFF12B76A)],
      2: ['pm_status_paused'.tr(), const Color(0xFF98A2B3)],
    };
    final label = labels[status]?[0] as String? ?? '';
    final color = labels[status]?[1] as Color? ?? const Color(0xFF98A2B3);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ManagedPropertyUnitsView(
              propertyId: int.tryParse((p['id'] ?? 0).toString()) ?? 0,
              propertyName: (p['name'] ?? '').toString(),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0xFFEDEFF3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (p['name'] ?? '').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(label,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          color: color,
                        )),
                  ),
                ],
              ),
              verticalSpace(5),
              Text(
                '📍 ${p['region'] ?? '-'} — ${p['rented_count'] ?? 0} مؤجرة من ${p['units_count'] ?? 0}',
                style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085)),
              ),
              verticalSpace(10),
              Divider(height: 1, color: const Color(0xFFF2F4F7)),
              verticalSpace(9),
              Row(
                children: [
                  Text('${'pm_collected'.tr()}: ',
                      style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
                  Text('${_money(p['collected'])} د.ك',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF12B76A),
                      )),
                  horizontalSpace(16),
                  Text('${'pm_overdue'.tr()}: ',
                      style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085))),
                  Text('${_money(p['due'])} د.ك',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF04438),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// وحدات عقار معيّن
class ManagedPropertyUnitsView extends StatefulWidget {
  final int propertyId;
  final String propertyName;

  const ManagedPropertyUnitsView({
    super.key,
    required this.propertyId,
    required this.propertyName,
  });

  @override
  State<ManagedPropertyUnitsView> createState() => _ManagedPropertyUnitsViewState();
}

class _ManagedPropertyUnitsViewState extends State<ManagedPropertyUnitsView> {
  List<Map<String, dynamic>> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final response = await pmDio.get('pm/properties/${widget.propertyId}/units');
      final List<dynamic> units = response.data['data']?['units'] ?? [];
      if (!mounted) return;
      setState(() {
        _units = units.map((e) => Map<String, dynamic>.from(e as Map)).toList();
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
        title: Text(widget.propertyName,
            style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: AppLoadingIndicator())
          : _units.isEmpty
              ? Center(
                  child: Text('pm_no_units'.tr(),
                      style: TextStyle(fontSize: 14.sp, color: ColorManager.grey)),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _units.length,
                  separatorBuilder: (_, __) => verticalSpace(10),
                  itemBuilder: (context, index) => _unitCard(_units[index]),
                ),
    );
  }

  Widget _unitCard(Map<String, dynamic> unit) {
    final contract = unit['contract'];
    final bool rented = contract != null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ManagedUnitDetailsView(
            unitId: int.tryParse((unit['id'] ?? 0).toString()) ?? 0,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFEDEFF3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: (rented ? const Color(0xFF12B76A) : const Color(0xFF98A2B3))
                    .withOpacity(0.10),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(
                rented ? Icons.person : Icons.meeting_room_outlined,
                size: 20.sp,
                color: rented ? const Color(0xFF12B76A) : const Color(0xFF98A2B3),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((unit['unit_name'] ?? '').toString(),
                      style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700)),
                  verticalSpace(3),
                  Text(
                    rented
                        ? '${'pm_tenant_label'.tr()}: ${contract['tenant_name']}'
                        : '${'pm_vacant'.tr()} — ${unit['rent_amount']}',
                    style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left, color: const Color(0xFF98A2B3), size: 20.sp),
          ],
        ),
      ),
    );
  }
}
