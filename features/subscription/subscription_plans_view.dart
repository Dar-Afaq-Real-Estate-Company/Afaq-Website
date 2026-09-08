import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/services/subscription_service.dart';
import 'subscription_checkout_view.dart';

/// شاشة "اختر الباقة" - عرض الباقات المتاحة والانتقال لصفحة الدفع
/// بعد الاختيار. تُغلق بـ Navigator.pop(context, true) فقط عند
/// اكتمال الدفع بنجاح من صفحة الدفع.
class SubscriptionPlansView extends StatefulWidget {
  const SubscriptionPlansView({super.key});

  @override
  State<SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<SubscriptionPlansView> {
  late Future<List<SubscriptionPlan>> _future;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _future = SubscriptionService.fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      body: FutureBuilder<List<SubscriptionPlan>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final plans = snapshot.data ?? [];
          if (plans.isEmpty) {
            return Center(child: Text(AppStrings.subNoPlans.tr()));
          }
          if (_selectedIndex >= plans.length) _selectedIndex = 0;
          final selected = plans[_selectedIndex];

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 26.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
                          ),
                          SizedBox(width: 12.w),
                          Text(AppStrings.subChoosePlan.tr(),
                              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      verticalSpace(6),
                      Padding(
                        padding: EdgeInsets.only(right: 34.w),
                        child: Text(AppStrings.subChoosePlanSub.tr(),
                            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.sp)),
                      ),
                    ],
                  ),
                ),
              ),

              Transform.translate(
                offset: Offset(0, -18.h),
                child: SizedBox(
                  height: 132.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: plans.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final bool isSelected = index == _selectedIndex;
                      final bool isFeatured = index == 1;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          width: 148.w,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: isSelected ? ColorManager.primary : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? ColorManager.primary.withOpacity(0.35)
                                    : Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              if (isFeatured)
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white.withOpacity(0.22) : const Color(0xFFFEF3F2),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(AppStrings.subMostPopular.tr(),
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected ? Colors.white : const Color(0xFFF04438))),
                                  ),
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.workspace_premium_rounded,
                                      size: 20.sp, color: isSelected ? Colors.white : ColorManager.primary),
                                  SizedBox(height: 8.h),
                                  Text(plan.displayName(context.locale.languageCode),
                                      style: TextStyle(
                                          fontSize: 12.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected ? Colors.white : const Color(0xFF101828))),
                                  SizedBox(height: 6.h),
                                  Text('${plan.price.toStringAsFixed(2)} ${AppStrings.currency.tr()}',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected ? Colors.white : ColorManager.primary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(AppStrings.subFeaturesOf.tr(namedArgs: {'n': selected.displayName(context.locale.languageCode)}),
                      style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: selected.displayFeatures(context.locale.languageCode)
                      .map((f) => Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26.w,
                                  height: 26.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF12B76A).withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check, size: 14.sp, color: const Color(0xFF12B76A)),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                    child: Text(f,
                                        style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF344054)))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    ),
                    onPressed: () async {
                      final paid = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => SubscriptionCheckoutView(plan: selected)),
                      );
                      if (paid == true && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: Text(AppStrings.subChooseYours.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
