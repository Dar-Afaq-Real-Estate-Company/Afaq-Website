import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../core/helper/extensions.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../../../core/resources/strings_manager.dart';
import '../../../../../../../core/resources/styles_manager.dart';
import '../../../../../../../core/services/favorites_service.dart';
import '../../../../../../../core/widgets/favorite_button.dart';
import '../../../../../../../core/widgets/share_button.dart';
import '../../../../../data/response/response.dart';
import '../../../../widgets/build_action_button.dart';
import '../../view/ads/ad_details_view.dart';

class AdCard extends StatelessWidget {
  final AdModel? adsData;
  const AdCard({super.key, this.adsData});

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final String currency = isAr ? 'د.ك' : 'KWD';

    return GestureDetector(
      onTap: () {
        if (adsData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdDetailsView(adsData: adsData!),
            ),
          );
        }
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 14.0.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // FIX: Fixed size container to prevent "RenderBox was not laid out"
                  SizedBox(
                    width: 110.w,
                    height: 120.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0.r),
                      child: CachedNetworkImage(
                        imageUrl: adsData?.images ?? "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: ColorManager.lightGrey,
                          highlightColor: Colors.white,
                          child: Container(color: Colors.white),
                        ),
                        // FIX: Added errorWidget to handle missing files/cache issues
                        errorWidget: (context, url, error) => Container(
                          color: ColorManager.lightGrey,
                          child: Icon(Icons.broken_image,
                              color: Colors.grey, size: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX: Use Wrap to prevent overflow from tags
                        Wrap(
                          spacing: 4.w,
                          runSpacing: 4.h,
                          children: [
                            if (adsData?.transactionType != null)
                              _buildTag(adsData!.transactionType!,
                                  color: Colors.blue),
                            if (adsData?.type != null)
                              _buildTag(adsData!.type!, color: Colors.brown),
                          ],
                        ),
                        verticalSpace(10),
                        Text(
                          adsData?.type ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        verticalSpace(4),
                        if ((adsData?.hasPool ?? false) ||
                            (adsData?.hasGarden ?? false) ||
                            (adsData?.hasParking ?? false) ||
                            (adsData?.amenities?.isNotEmpty ?? false))
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: [
                              if (adsData?.hasPool ?? false)
                                _amenityChip(Icons.pool, 'مسبح'),
                              if (adsData?.hasGarden ?? false)
                                _amenityChip(Icons.grass, 'حديقة'),
                              if (adsData?.hasParking ?? false)
                                _amenityChip(Icons.local_parking, 'مواقف'),
                              ...?adsData?.amenities?.map(
                                (a) => _amenityChip(Icons.check_circle_outline, a.name ?? ''),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Icon(Icons.star_half,
                                color: Colors.amber, size: 16.sp),
                            horizontalSpace(4),
                            Expanded(
                              child: Text(
                                adsData?.description ?? "",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(10),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: ColorManager.primary, size: 16.sp),
                            horizontalSpace(4),
                            Expanded(
                              child: Text(
                                adsData?.region ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Text(
                (adsData?.transactionType?.contains('بدل') ?? false)
                    ? 'للبدل'
                    : '${adsData?.price ?? '0'} $currency',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
            ),
            verticalSpace(10),
            Divider(height: 1.h, thickness: 1),
            // Footer Section
            Padding(
              padding: EdgeInsets.all(12.0.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.appName.tr(),
                      style: StylesManager.font12GrayRegular.copyWith(
                        color: ColorManager.black,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthGuard.runAction(context, onAuthenticated: () {
                        makePhoneCall(adsData?.phone ?? "");
                      });
                    },
                    child: buildActionButton(Icons.phone, ColorManager.primary),
                  ),
                  horizontalSpace(10),
                  GestureDetector(
                    onTap: () {
                      AuthGuard.runAction(context, onAuthenticated: () {
                        launchWhatsAppAd(
                          context,
                          phone: adsData?.phone ?? "",
                          adId: "${adsData?.shareCode}",
                        );
                      });
                    },
                    child: buildActionButton(
                        FontAwesomeIcons.whatsapp, ColorManager.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, {required Color color}) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _amenityChip(IconData icon, String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: ColorManager.primary),
          horizontalSpace(3),
          Text(label, style: TextStyle(fontSize: 10.sp, color: ColorManager.primary)),
        ],
      ),
    );
  }

  Widget _badgeCircle({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: ColorManager.lighterGray,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
