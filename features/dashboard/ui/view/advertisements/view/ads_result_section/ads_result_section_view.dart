import 'package:afaq_real_estate/core/resources/strings_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../../core/helper/extensions.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../data/response/response.dart';
import '../../../../../logic/home_cubit.dart';
import '../../../../../logic/home_state.dart';
import '../../../../widgets/build_action_button.dart';
import '../../../home_details_view.dart';

import '../../../../../../../core/widgets/app_loading_indicator.dart';
class AdsResultSectionView extends StatelessWidget {
  const AdsResultSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.searchResults.tr()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<FilterSctionCubit, FilterSectionState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text("اختر قسماً لبدء العرض")),
            filterSectionLoading: () =>
                const Center(child: AppLoadingIndicator()),
            filterSectionError: (error) =>
                Center(child: Text("حدث خطأ: $error")),
            filterSectionSuccess: (adsList) {
              if (adsList.data == null || adsList.data!.isEmpty) {
                return Center(child: Text(AppStrings.noAdsAvailable.tr()));
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                itemCount: adsList.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: GridHomeCard(
                      vipAdsDataResponse: adsList.data![index],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GridHomeCard extends StatelessWidget {
  final FilterSectionModel? vipAdsDataResponse;
  const GridHomeCard({super.key, this.vipAdsDataResponse});

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final String currency = isAr ? 'د.ك' : 'KWD';

    return GestureDetector(
      onTap: () {
        if (vipAdsDataResponse != null) {
          final detailData = vipAdsDataResponse!.toVipResponse();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDetailsView(
                vipAdsDataResponse: detailData,
              ),
            ),
          );
        }
      },
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 130.w,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: isAr
                    ? BorderRadius.horizontal(right: Radius.circular(12.r))
                    : BorderRadius.horizontal(left: Radius.circular(12.r)),
                child: CachedNetworkImage(
                  imageUrl: vipAdsDataResponse?.images ?? "",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vipAdsDataResponse?.type ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      '${vipAdsDataResponse?.price ?? '0'} $currency',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: ColorManager.primary,
                          size: 14.sp,
                        ),
                        horizontalSpace(4),
                        Expanded(
                          child: Text(
                            vipAdsDataResponse?.region ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AuthGuard.runAction(context, onAuthenticated: () {
                              makePhoneCall(vipAdsDataResponse?.phone ?? "");
                            });
                          },
                          child: buildActionButton(
                              Icons.phone, ColorManager.primary),
                        ),
                        horizontalSpace(10),
                        GestureDetector(
                          onTap: () {
                            AuthGuard.runAction(context, onAuthenticated: () {
                              launchWhatsAppAd(
                                context,
                                phone: vipAdsDataResponse?.phone ?? "",
                                adId: "${vipAdsDataResponse?.shareCode}",
                              );
                            });
                          },
                          child: buildActionButton(
                              FontAwesomeIcons.whatsapp, ColorManager.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
