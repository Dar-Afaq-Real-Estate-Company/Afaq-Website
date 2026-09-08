import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/di/di.dart';
import '../../../core/helper/kuwait_governorates.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../dashboard/data/response/response.dart';
import '../../real_estate/property_details_view.dart';
import '../../real_estate/property_details_view.dart';
import '../../dashboard/logic/home_cubit.dart';
import '../../dashboard/logic/home_state.dart';

class ShowUserAdCard extends StatelessWidget {
  final ShowUserAdvertisementData? showUserAdvertisementData;
  const ShowUserAdCard({super.key, this.showUserAdvertisementData});

  ShowUserAdvertisementData get ad => showUserAdvertisementData ?? ShowUserAdvertisementData();

  bool get _isRent => ad.transactionType?.contains('يجار') ?? false;
  bool get _isSwap => ad.transactionType?.contains('بدل') ?? false;

  String _priceText(BuildContext context) {
    if (_isSwap) return AppStrings.getString('for_swap', context.locale.languageCode);
    final price = ad.price ?? '0';
    return _isRent ? '$price د.ك/شهرياً' : '$price د.ك';
  }

  String get _transactionOnly {
    final t = ad.transactionType ?? '';
    if (t.contains('بدل')) return 'بدل';
    if (t.contains('يجار')) return 'ايجار';
    if (t.contains('بيع')) return 'بيع';
    return t;
  }

  Color get _transactionColor {
    if (_isSwap) return const Color(0xFF7C3AED);
    if (_isRent) return const Color(0xFF2E6D71);
    return const Color(0xFFE07A1F);
  }

  Widget _pill(String text, {Color? bg, Color? fg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
          color: fg ?? const Color(0xFF344054),
        ),
      ),
    );
  }

  String _publishedAt(String? raw) {
    if (raw == null) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return '';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = ad.status == "1";
    final bool isExpired = ad.isExpired == true;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PropertyDetailsView(
            ad: AdsDataResponse(
              id: ad.id,
              planPrice: ad.planPrice,
              planName: ad.planName,
              transactionType: ad.transactionType,
              phone: ad.phone,
              description: ad.description,
              type: ad.type,
              region: ad.region,
              price: ad.price,
              images: ad.images,
              userId: ad.userId,
              shareCode: ad.shareCode,
              shareUrl: ad.shareUrl,
              title: ad.title,
              rooms: ad.rooms,
              bathrooms: ad.bathrooms,
              halls: ad.halls,
              area: ad.area,
              address: ad.address,
              amenities: ad.amenities,
              hasPool: ad.hasPool,
              hasGarden: ad.hasGarden,
              hasParking: ad.hasParking,
              viewsCount: int.tryParse(ad.viewsCount ?? ''),
              createdAt: ad.createdAt,
              referenceNo: ad.referenceNo,
              hasCommission: ad.hasCommission,
              commissionPercent: ad.commissionPercent,
              isFeatured: ad.isFeatured,
              publisherName: ad.publisherName,
              publisherLogo: ad.publisherLogo,
              publisherAccountType: ad.publisherAccountType,
            ),
          ),
        ),
      ),
      child: Container(
      margin: EdgeInsets.only(bottom: 16.h, left: 12.w, right: 12.w, top: 4.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8F8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === الصورة + عدد المشاهدات (نفس تصميم بطاقة العقار)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: (ad.images == null || ad.images!.isEmpty)
                    ? Image.asset(
                        defaultPropertyImage,
                        width: double.infinity,
                        height: 140.h,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: "${ad.images}?t=${DateTime.now().millisecondsSinceEpoch}",
                        width: double.infinity,
                        height: 140.h,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white, height: 140.h, width: double.infinity),
                        ),
                        errorWidget: (_, __, ___) => Image.asset(
                          defaultPropertyImage,
                          width: double.infinity,
                          height: 140.h,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? Colors.grey.withOpacity(0.9)
                        : isActive
                            ? Colors.green.withOpacity(0.9)
                            : Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isExpired
                            ? Icons.event_busy_rounded
                            : isActive
                                ? Icons.check_circle_rounded
                                : Icons.access_time_filled_rounded,
                        size: 12.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isExpired ? 'expired'.tr() : (isActive ? 'active'.tr() : 'under_review'.tr()),
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              if (ad.hasCommission != null)
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: (ad.hasCommission == true)
                          ? const Color(0xFFB54708).withOpacity(0.92)
                          : const Color(0xFF12B76A).withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      (ad.hasCommission == true)
                          ? '${AppStrings.getString('commission_with_percent', context.locale.languageCode).replaceFirst('{p}', '${ad.commissionPercent ?? ''}')}'
                          : AppStrings.getString('no_commission', context.locale.languageCode),
                      style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              if (ad.isFeatured == true)
                Positioned(
                  bottom: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('VIP', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
              Positioned(
                bottom: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, size: 11.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Text('${ad.viewsCount ?? 0}',
                          style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(10),

          if ((ad.publisherName ?? '').isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundColor: ColorManager.primary.withOpacity(0.1),
                    backgroundImage: (ad.publisherLogo ?? '').isNotEmpty
                        ? CachedNetworkImageProvider(ad.publisherLogo!)
                        : null,
                    child: (ad.publisherLogo ?? '').isEmpty
                        ? Icon(Icons.person, size: 13.sp, color: ColorManager.primary)
                        : null,
                  ),
                  SizedBox(width: 6.w),
                  Text(ad.publisherName!, style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600, color: const Color(0xFF344054))),
                ],
              ),
            ),

          // === بادجات: نوع المعاملة + نوع العقار + التصنيف
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _pill(_transactionOnly, bg: _transactionColor.withOpacity(0.12), fg: _transactionColor),
              if ((ad.type ?? '').isNotEmpty) _pill(ad.type!),
              if ((ad.propertySection ?? '').isNotEmpty)
                _pill(ad.propertySection!, bg: const Color(0xFFEFF3FF), fg: const Color(0xFF3E5FC1)),
              if ((ad.landType ?? '').isNotEmpty)
                _pill(ad.landType!, bg: const Color(0xFFEFF3FF), fg: const Color(0xFF3E5FC1)),
            ],
          ),
          verticalSpace(10),

          // === السعر + المواصفات المختصرة
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _priceText(context),
                  style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w900, color: ColorManager.primary),
                ),
              ),
              if ((ad.rooms ?? '').isNotEmpty) ...[
                Icon(Icons.bed_outlined, size: 17.sp, color: const Color(0xFF344054)),
                SizedBox(width: 5.w),
                Text('${ad.rooms}', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF344054))),
                SizedBox(width: 16.w),
              ],
              if ((ad.area ?? '').isNotEmpty) ...[
                Icon(Icons.crop_free, size: 17.sp, color: const Color(0xFF344054)),
                SizedBox(width: 5.w),
                Text('${ad.area} م²', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF344054))),
              ],
            ],
          ),
          verticalSpace(7),

          // === المنطقة
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 15.sp, color: const Color(0xFF98A2B3)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  regionWithGovernorate(ad.region ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF98A2B3)),
                ),
              ),
            ],
          ),
          verticalSpace(5),

          // === الرقم المرجعي + العمولة + تاريخ النشر
          Wrap(
            spacing: 10.w,
            runSpacing: 4.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('#${ad.referenceNo ?? '0000000'}',
                  style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFFE53935))),
              Text(
                ad.hasCommission == null
                    ? ''
                    : (ad.hasCommission == true)
                        ? '${AppStrings.getString('commission_with_percent', context.locale.languageCode).replaceFirst('{p}', '${ad.commissionPercent ?? ''}')}'
                        : AppStrings.getString('no_commission', context.locale.languageCode),
                style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFFB0B7BD)),
              ),
              if (ad.auctionDate != null)
                Text("${AppStrings.expiryDate.tr()}: ${ad.auctionDate}",
                    style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB0B7BD))),
              if (ad.createdAt != null)
                Text("${AppStrings.getString('published_on', context.locale.languageCode)}: ${_publishedAt(ad.createdAt)}",
                    style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB0B7BD))),
            ],
          ),
          verticalSpace(14),

          // === وصف مختصر (خاص بصفحة إعلاناتي فقط)
          if ((ad.description ?? '').isNotEmpty) ...[
            Text(
              ad.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.font13Grey.copyWith(fontSize: 13.sp, height: 1.5),
            ),
            verticalSpace(12),
          ],

          // === أزرار التعديل والحذف
          Row(
            children: [
              Expanded(
                child: AppTextButton(
                  buttonText: AppStrings.edit.tr(),
                  textStyle: StylesManager.font16White,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.editAdRoute,
                      arguments: {
                        'adData': showUserAdvertisementData,
                        'showUserAdCubit': context.read<ShowUserAdCubit>(),
                      },
                    );
                  },
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: BlocProvider(
                  create: (context) => di<DeleteAdCubit>(),
                  child: BlocConsumer<DeleteAdCubit, DeleteState>(
                    listener: (context, state) {
                      if (state is DeleteSuccess) {
                        Navigator.of(context, rootNavigator: true).pop();
                        context.pushReplacementNamed(Routes.myAdvertisementsRoute);
                      }
                    },
                    builder: (context, state) {
                      return Builder(builder: (newcontext) {
                        return AppTextButton(
                          buttonText: AppStrings.delete.tr(),
                          backgroundColor: Colors.red.shade400,
                          textStyle: StylesManager.font16White,
                          onPressed: () {
                            final deleteCubit = newcontext.read<DeleteAdCubit>();
                            showDialogWidget(newcontext, deleteCubit);
                          },
                        );
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Future<dynamic> showDialogWidget(BuildContext context, DeleteAdCubit type) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppStrings.confirmDeleteTitle.tr(),
            textAlign: TextAlign.right,
            style: StylesManager.font12GrayRegular.copyWith(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          content: Text(
            AppStrings.confirmDeleteMessage.tr(),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppStrings.cancel.tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                type.emitDeleteAds(showUserAdvertisementData?.id ?? 0);
              },
              child: Text(AppStrings.confirm.tr()),
            ),
          ],
        );
      },
    );
  }
}

class MyAdShimmerLoading extends StatelessWidget {
  const MyAdShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 150, // نفس ارتفاع البطاقة الأصلية تقريباً
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
