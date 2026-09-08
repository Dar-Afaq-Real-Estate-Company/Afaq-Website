import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../subscription/subscription_plans_view.dart';

/// نقطة الدخول لباقات المستخدم بالبروفايل:
/// - عنده باقة فعّالة الآن؟ نعرضها مع تاريخ انتهائها.
/// - ما عنده باقة (أو انتهت)؟ نعرض زر يفتح شاشة اختيار الباقة → الدفع.
class PackagesView extends StatefulWidget {
  const PackagesView({super.key});

  @override
  State<PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView> {
  late Future<ActiveSubscription?> _future;

  @override
  void initState() {
    super.initState();
    _future = SubscriptionService.fetchStatus();
  }

  void _refresh() => setState(() => _future = SubscriptionService.fetchStatus());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ActiveSubscription?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final active = snapshot.data;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.getString('offers_subscriptions', context.locale.languageCode),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
              verticalSpace(12),
              if (active != null) ...[
                Row(
                  children: [
                    Icon(Icons.verified, color: ColorManager.primary, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(active.plan.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
                  ],
                ),
                verticalSpace(6),
                if (active.expiresAt != null)
                  Text(
                    'تنتهي في ${active.expiresAt!.day}/${active.expiresAt!.month}/${active.expiresAt!.year}',
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085)),
                  ),
                verticalSpace(12),
              ] else ...[
                Text('لا توجد باقة فعّالة حاليًا', style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700)),
                verticalSpace(4),
                Text('اشترك بباقة لتفعيل مزايا إضافية على إعلاناتك', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085))),
                verticalSpace(12),
              ],
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorManager.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SubscriptionPlansView()),
                    );
                    _refresh();
                  },
                  child: Text(
                    active != null ? 'تغيير الباقة' : 'اشترك في باقة',
                    style: TextStyle(color: ColorManager.primary, fontSize: 13.5.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
