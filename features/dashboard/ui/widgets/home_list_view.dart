import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../data/response/response.dart';
import '../../../real_estate/property_details_view.dart';
import '../../../../core/services/favorites_service.dart';
import '../../../../core/widgets/favorite_button.dart';
import '../../../../core/widgets/share_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'build_action_button.dart';
class HomeListView extends StatelessWidget {
  final List<VipAdsDataResponse?> vipAdsDataResponseList;

  const HomeListView({
    super.key,
    required this.vipAdsDataResponseList,
  });
  @override
  Widget build(BuildContext context) {
    // 🔥 حل الفراغ الأبيض: إذا ما في بيانات لا نحجز مساحة
    if (vipAdsDataResponseList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 305.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: vipAdsDataResponseList.length,
            itemBuilder: (context, index) {
              return HomeCard(
                vipAdsDataResponse: vipAdsDataResponseList[index],
              );
            },
          ),
        ),
        if (vipAdsDataResponseList.length > 1)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swipe, size: 13.sp, color: const Color(0xFFB0B7BD)),
                SizedBox(width: 5.w),
                Text('اسحب يمين أو يسار للتصفح',
                    style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFFB0B7BD))),
              ],
            ),
          ),
      ],
    );
  }
}

class HomeCard extends StatefulWidget {
  final VipAdsDataResponse? vipAdsDataResponse;
  const HomeCard({super.key, this.vipAdsDataResponse});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  VipAdsDataResponse? get vipAdsDataResponse => widget.vipAdsDataResponse;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavorited();
  }

  Future<void> _checkFavorited() async {
    final id = vipAdsDataResponse?.id;
    if (id == null) return;
    final result = await FavoritesService.isFavorited(FavoriteType.advertisement, id);
    if (mounted) setState(() => _isFavorited = result);
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final String currency = isAr ? ' د.ك' : 'KWD';
    final ad = vipAdsDataResponse;
    final String _imgUrl = ad?.images ?? '';
    final bool hasImage = _imgUrl.startsWith('http://') || _imgUrl.startsWith('https://');

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsView(
              ad: AdsDataResponse(
                id: ad?.id,
                planPrice: ad?.planPrice,
                planName: ad?.planName,
                transactionType: ad?.transactionType,
                phone: ad?.phone,
                description: ad?.description,
                type: ad?.type,
                region: ad?.region,
                price: ad?.price,
                images: ad?.images,
                userId: ad?.userId,
                shareCode: ad?.shareCode,
                shareUrl: ad?.shareUrl,
                title: ad?.title ?? ad?.description,
                rooms: ad?.rooms,
                bathrooms: ad?.bathrooms,
                halls: ad?.halls,
                area: ad?.area,
                address: ad?.address,
                amenities: ad?.amenities,
                hasPool: ad?.hasPool,
                hasGarden: ad?.hasGarden,
                hasParking: ad?.hasParking,
                viewsCount: ad?.viewsCount,
                createdAt: ad?.createdAt,
                referenceNo: ad?.referenceNo,
                hasCommission: ad?.hasCommission,
                commissionPercent: ad?.commissionPercent,
                publisherName: ad?.publisherName,
                publisherLogo: ad?.publisherLogo,
                publisherAccountType: ad?.publisherAccountType,
              ),
            ),
          ),
        );
        if (mounted) _checkFavorited();
      },
      child: Container(
        width: 195.w,
        margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 6.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: _imgUrl,
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer.fromColors(
                            baseColor: ColorManager.lightGrey,
                            highlightColor: Colors.white,
                            child: Container(height: 120.h, width: double.infinity, color: Colors.white),
                          ),
                          errorWidget: (_, __, ___) => Image.asset(defaultPropertyImage, height: 120.h, width: double.infinity, fit: BoxFit.cover),
                        )
                      : Image.asset(defaultPropertyImage, height: 120.h, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('VIP', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Row(
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                          child: ShareButton(
                            size: 14.sp,
                            shareText: '${ad?.type ?? ''} - ${ad?.region ?? ''}\n${ad?.shareUrl ?? ''}',
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                          child: FavoriteButton(
                            key: ValueKey(_isFavorited),
                            type: FavoriteType.advertisement,
                            itemId: ad?.id ?? 0,
                            initiallyFavorited: _isFavorited,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), borderRadius: BorderRadius.circular(20.r)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.visibility, size: 11.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Text('${ad?.viewsCount ?? 0}', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                    ]),
                  ),
                ),
                if (ad?.hasCommission != null)
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: (ad!.hasCommission == true) ? const Color(0xFFB54708).withOpacity(0.92) : const Color(0xFF12B76A).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        (ad.hasCommission == true) ? 'عمولة ${ad.commissionPercent ?? ''}%' : 'بدون عمولة',
                        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _typeAndTransactionLabel(ad),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828)),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    ad?.region ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFF98A2B3)),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      if ((ad?.rooms ?? '').isNotEmpty && ad?.rooms != '0')
                        _specMini(Icons.bed_outlined, ad!.rooms!),
                      if ((ad?.bathrooms ?? '').isNotEmpty && ad?.bathrooms != '0')
                        _specMini(Icons.bathtub_outlined, ad!.bathrooms!),
                      if ((ad?.area ?? '').isNotEmpty && ad?.area != '0')
                        _specMini(Icons.crop_free, '${ad!.area} م²'),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    (ad?.transactionType?.contains('بدل') ?? false) ? 'للبدل' : '${ad?.price ?? '0'}$currency',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: ColorManager.primary),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '#${ad?.referenceNo ?? '0000000'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 9.5.sp, color: const Color(0xFFE53935)),
                        ),
                      ),
                      if (_publishedAt(ad?.createdAt).isNotEmpty)
                        Flexible(
                          child: Text(_publishedAt(ad?.createdAt),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 8.5.sp, color: const Color(0xFFB0B7BD))),
                        ),
                    ],
                  ),
                  if ((ad?.phone ?? '').isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _call(ad!.phone!),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: const Color(0xFFE8F1F8), borderRadius: BorderRadius.circular(8.r)),
                              child: Icon(Icons.call, size: 14.sp, color: const Color(0xFF2E7CB8)),
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _whatsapp(ad!.phone!),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: const Color(0xFFE7F8EE), borderRadius: BorderRadius.circular(8.r)),
                              child: Icon(Icons.chat, size: 14.sp, color: const Color(0xFF25D366)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
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

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _specMini(IconData icon, String value) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12.sp, color: const Color(0xFF344054)),
      SizedBox(width: 3.w),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 60.w),
        child: Text(value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.sp, color: const Color(0xFF344054))),
      ),
    ]);
  }

  String _typeAndTransactionLabel(VipAdsDataResponse? ad) {
    final type = ad?.type ?? '';
    final t = ad?.transactionType ?? '';
    String txn = '';
    if (t.contains('بدل')) txn = 'للبدل';
    else if (t.contains('يجار')) txn = 'للإيجار';
    else if (t.contains('بيع')) txn = 'للبيع';
    if (type.isEmpty) return txn;
    if (txn.isEmpty) return type;
    return '$type - $txn';
  }
}
