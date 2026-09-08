import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/helper/extensions.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../dashboard/data/response/response.dart';
import '../../dashboard/ui/widgets/build_action_button.dart';

class SerachDetails extends StatelessWidget {
  final SearchFilterData? searchFilterData;
  const SerachDetails({super.key, required this.searchFilterData});

  @override
  Widget build(BuildContext context) {
      final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final String currency = isAr ? 'د.ك' : 'KWD';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(searchFilterData!.type ?? "تفاصيل الإعلان"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'ad-image-${searchFilterData?.id}',
              child: CachedNetworkImage(
                imageUrl: searchFilterData?.images ?? '',
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
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${searchFilterData?.price ?? '0'} $currency',
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
                          searchFilterData?.transactionType ?? "",
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
                        searchFilterData?.region ?? "الموقع غير محدد",
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
                    searchFilterData?.description ?? "لا يوجد وصف متاح لهذا الإعلان.",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
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
                    makePhoneCall(searchFilterData?.phone ?? "");
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
                      phone: searchFilterData?.phone ?? "",
                      adId: "${searchFilterData?.shareCode}",
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
}
