import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helper/navigator_key.dart';
import '../resources/color_manager.dart';
import '../routing/routes.dart';

/// ينقل المستخدم لصفحة "إعلاناتي" فورًا، ثم يعرض فوقها بطاقة نجاح
/// النشر (الرقم المرجعي إن وُجد) تختفي تدريجيًا تلقائيًا بعد 3 ثوانٍ.
/// يُستخدم بعد أي عملية نشر إعلان (عقار، مقاولة، وظيفة، فندق).
void showPublishSuccessThenGoToMyAds(
  BuildContext context, {
  String? referenceNo,
  String title = 'تم نشر الإعلان بنجاح',
}) {
  // === نخلي "الرئيسية" هي جذر المكدس، وفوقها "إعلاناتي" - عشان زر
  // الرجوع يوديه للصفحة الرئيسية بدل ما يخرج من التطبيق
  Navigator.of(context).pushNamedAndRemoveUntil(Routes.dashboardRoute, (route) => false);
  Navigator.of(context).pushNamed(Routes.myAdvertisementsRoute);

  Future.delayed(const Duration(milliseconds: 80), () {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, _, __) {
        return _PublishSuccessCard(title: title, referenceNo: referenceNo);
      },
      transitionBuilder: (dialogContext, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  });
}

class _PublishSuccessCard extends StatefulWidget {
  final String title;
  final String? referenceNo;
  const _PublishSuccessCard({required this.title, this.referenceNo});

  @override
  State<_PublishSuccessCard> createState() => _PublishSuccessCardState();
}

class _PublishSuccessCardState extends State<_PublishSuccessCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2300), () async {
      if (!mounted) return;
      await _controller.reverse();
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _controller,
        child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 30.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF12B76A), boxShadow: [BoxShadow(color: const Color(0xFF12B76A).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))]),
                child: Icon(Icons.check, color: Colors.white, size: 34.sp),
              ),
              SizedBox(height: 16.h),
              Text(widget.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(color: const Color(0xFFFEF3F2), borderRadius: BorderRadius.circular(20.r)),
                child: Text('بانتظار المراجعة', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: const Color(0xFFD92D20))),
              ),
              if (widget.referenceNo != null && widget.referenceNo!.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  decoration: BoxDecoration(color: const Color(0xFFEAF1F1), borderRadius: BorderRadius.circular(20.r)),
                  child: Text('الرقم المرجعي: #${widget.referenceNo}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: const Color(0xFF12B76A))),
                ),
              ],
            ],
          ),
        ),
        ),
      ),
    );
  }
}
