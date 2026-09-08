import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/shared_pref.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/routing/routes.dart';
import '../../auth/logic/cubit_cubit.dart';
import '../../auth/logic/cubit_state.dart';

/// إعدادات الحساب — حذف الحساب مخفي هنا، بتأكيد مزدوج وعدّاد 10 ثوانٍ
class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        state.whenOrNull(
          deleteAccountLoading: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          ),
          deleteAccountSuccess: (_) async {
            Navigator.pop(context);
            await SharedPrefHelper.clearAllData();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('account_deleted_success'.tr())),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.loginRoute, (route) => false);
          },
          deleteAccountError: (error) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message ?? 'account_delete_failed'.tr())),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('danger_zone'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF04438),
                              )),
                          verticalSpace(10),
                          Text(
                            'delete_account_warning'.tr(),
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              height: 1.9,
                              color: const Color(0xFF667085),
                            ),
                          ),
                          verticalSpace(16),
                          GestureDetector(
                            onTap: () => _openDeleteFlow(context),
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3F2),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                    color: const Color(0xFFFECDCA)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 18.sp,
                                      color: const Color(0xFFF04438)),
                                  SizedBox(width: 8.w),
                                  Text('delete_account_permanently'.tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFF04438),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Text('account_settings_menu'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Future<void> _openDeleteFlow(BuildContext context) async {
    final cubit = context.read<DeleteAccountCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DeleteCountdownDialog(),
    );

    if (confirmed == true) cubit.emitDeleteAccount();
  }
}

/// نافذة تأكيد الحذف — الزر يبقى معطّلاً 10 ثوانٍ
class _DeleteCountdownDialog extends StatefulWidget {
  const _DeleteCountdownDialog();

  @override
  State<_DeleteCountdownDialog> createState() => _DeleteCountdownDialogState();
}

class _DeleteCountdownDialogState extends State<_DeleteCountdownDialog> {
  int _seconds = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        if (mounted) setState(() => _seconds = 0);
      } else {
        if (mounted) setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _ready => _seconds == 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      contentPadding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 12.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF3F2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_amber_rounded,
                size: 30.sp, color: const Color(0xFFF04438)),
          ),
          verticalSpace(16),
          Text('confirm_delete_account'.tr(),
              style: TextStyle(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101828),
              )),
          verticalSpace(10),
          Text(
            'confirm_delete_account_body'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.9,
              color: const Color(0xFF667085),
            ),
          ),
          verticalSpace(18),
          if (!_ready)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: (10 - _seconds) / 10,
                      color: const Color(0xFFF04438),
                      backgroundColor: const Color(0xFFEDEFF3),
                    ),
                  ),
                  SizedBox(width: 9.w),
                  Text(
                    'wait_n_seconds'.tr(namedArgs: {'n': '$_seconds'}),
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  minimumSize: Size.fromHeight(46.h),
                  backgroundColor: const Color(0xFFF2F4F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                ),
                child: Text('cancel'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF344054),
                    )),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextButton(
                onPressed: _ready ? () => Navigator.pop(context, true) : null,
                style: TextButton.styleFrom(
                  minimumSize: Size.fromHeight(46.h),
                  backgroundColor: _ready
                      ? const Color(0xFFF04438)
                      : const Color(0xFFFECDCA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                ),
                child: Text('delete_final'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
