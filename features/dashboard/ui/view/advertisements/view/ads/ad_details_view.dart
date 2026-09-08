import 'package:afaq_real_estate/core/resources/strings_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../core/helper/extensions.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../../../core/resources/styles_manager.dart';
import '../../../../../../../core/services/favorites_service.dart';
import '../../../../../../../core/widgets/favorite_button.dart';
import '../../../../../../../core/widgets/share_button.dart';
import '../../../../../data/response/response.dart';
import '../../../../widgets/build_action_button.dart';

class AdDetailsView extends StatelessWidget {
  final AdModel adsData;

  const AdDetailsView({super.key, required this.adsData});

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final String currency = isAr ? 'د.ك' : 'KWD';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(adsData.type ?? "تفاصيل الإعلان"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'ad-image-${adsData.id}',
                  child: CachedNetworkImage(
                    imageUrl: adsData.images ?? '',
                    width: double.infinity,
                    height: 300.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 300.h,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 300.h,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        size: 50.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (adsData.hasCommission != null)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: (adsData.hasCommission == true)
                            ? const Color(0xFFB54708).withOpacity(0.92)
                            : const Color(0xFF12B76A).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        (adsData.hasCommission == true)
                            ? '${AppStrings.getString('commission_with_percent', context.locale.languageCode).replaceFirst('{p}', '${adsData.commissionPercent ?? ''}')}'
                            : AppStrings.getString('no_commission', context.locale.languageCode),
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                // === زر المفضلة + المشاركة أسفل يسار الصورة
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  child: Row(
                    children: [
                      _iconCircle(
                        child: FavoriteButton(
                          type: FavoriteType.advertisement,
                          itemId: adsData.id ?? 0,
                          size: 18,
                        ),
                      ),
                      horizontalSpace(8),
                      _iconCircle(
                        child: ShareButton(
                          size: 18,
                          shareText:
                              '${adsData.title ?? adsData.type ?? ''}\n${adsData.shareUrl ?? ''}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${adsData.price ?? '0'} $currency',
                        style: StylesManager.font16White.copyWith(
                          color: ColorManager.primary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          adsData.transactionType ?? "",
                          style: TextStyle(
                            color: ColorManager.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorManager.primary,
                        size: 20.sp,
                      ),
                      horizontalSpace(8),
                      Text(
                        adsData.region ?? "الموقع غير محدد",
                        style: StylesManager.font12GrayRegular.copyWith(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(10),
                  const Divider(),
                  verticalSpace(10),
                  Text(
                    AppStrings.description.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(10),
                  Text(
                    adsData.description ?? "لا يوجد وصف متاح لهذا الإعلان.",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  if (_hasAnyFacility) ...[
                    verticalSpace(20),
                    const Divider(),
                    verticalSpace(10),
                    Text(
                      'المرافق',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    verticalSpace(10),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        if (adsData.hasPool == true)
                          _facilityChip(Icons.pool, 'مسبح'),
                        if (adsData.hasGarden == true)
                          _facilityChip(Icons.park, 'حديقة'),
                        if (adsData.hasParking == true)
                          _facilityChip(Icons.local_parking, 'مواقف'),
                        ...?adsData.amenities?.map(
                          (a) => _facilityChip(Icons.check_circle_outline, a.name ?? ''),
                        ),
                      ],
                    ),
                  ],
                  verticalSpace(30),
                  Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15.r,
                          backgroundImage: AssetImage(
                            'assets/images/splash_image.jpg',
                          ),
                          backgroundColor: ColorManager.primary,
                          child: const Icon(
                            Icons.business,
                            color: Colors.white,
                          ),
                        ),
                        horizontalSpace(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.appName.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(70),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  AuthGuard.runAction(context, onAuthenticated: () {
                    makePhoneCall(adsData.phone ?? "");
                  });
                },
                icon: const Icon(Icons.phone),
                label: Text(AppStrings.call.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  AuthGuard.runAction(context, onAuthenticated: () {
                    launchWhatsAppAd(
                      context,
                      phone: adsData.phone ?? "",
                      adId: "${adsData.shareCode}",
                    );
                  });
                },
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: ColorManager.white,
                ),
                label: Text(AppStrings.whatsapp.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasAnyFacility =>
      adsData.hasPool == true ||
      adsData.hasGarden == true ||
      adsData.hasParking == true ||
      (adsData.amenities?.isNotEmpty ?? false);

  Widget _facilityChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: ColorManager.primary),
          horizontalSpace(6),
          Text(label, style: TextStyle(fontSize: 12.5.sp, color: ColorManager.primary)),
        ],
      ),
    );
  }

  Widget _iconCircle({required Widget child}) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
