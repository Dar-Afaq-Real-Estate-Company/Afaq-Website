import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/services/favorites_service.dart';
import '../../../../core/widgets/favorite_button.dart';
import '../../../../core/widgets/share_button.dart';
import '../../data/response/response.dart';
import '../../../real_estate/property_details_view.dart';

/// قسم "أحدث الإعلانات" - شريط أفقي بمربعات صغيرة (نفس فكرة "المشاريع
/// المميزة") مع تلميح بصري إنه يُسحب يمين/يسار.
class LatestAdsListView extends StatelessWidget {
  final List<AdsDataResponse?> adsList;

  const LatestAdsListView({super.key, required this.adsList});

  @override
  Widget build(BuildContext context) {
    if (adsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: adsList.length,
            itemBuilder: (context, index) {
              final ad = adsList[index];
              if (ad == null) return const SizedBox.shrink();
              return LatestAdCard(ad: ad);
            },
          ),
        ),
        // === تلميح "اسحب للتصفح" - يظهر بس لو فيه أكثر من إعلان
        if (adsList.length > 1)
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

class LatestAdCard extends StatefulWidget {
  final AdsDataResponse ad;
  const LatestAdCard({super.key, required this.ad});

  @override
  State<LatestAdCard> createState() => _LatestAdCardState();
}

class _LatestAdCardState extends State<LatestAdCard> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavorited();
  }

  Future<void> _checkFavorited() async {
    final id = widget.ad.id;
    if (id == null) return;
    final result = await FavoritesService.isFavorited(FavoriteType.advertisement, id);
    if (mounted) setState(() => _isFavorited = result);
  }

  String _typeAndTransactionLabel() {
    final type = widget.ad.type ?? '';
    final t = widget.ad.transactionType ?? '';
    String txn = '';
    if (t.contains('بدل')) txn = 'للبدل';
    else if (t.contains('يجار')) txn = 'للإيجار';
    else if (t.contains('بيع')) txn = 'للبيع';
    if (type.isEmpty) return txn;
    if (txn.isEmpty) return type;
    return '$type - $txn';
  }

  String _publishedAt() {
    final raw = widget.ad.createdAt;
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

  @override
  Widget build(BuildContext context) {
    final ad = widget.ad;
    final bool hasImage = (ad.images ?? '').isNotEmpty;
    final bool isSwap = (ad.transactionType ?? '').contains('بدل');

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PropertyDetailsView(ad: ad)),
        );
        if (mounted) _checkFavorited();
      },
      child: Container(
        width: 148.w,
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: ad.images!,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer.fromColors(
                            baseColor: ColorManager.lightGrey,
                            highlightColor: Colors.white,
                            child: Container(height: 150.h, width: double.infinity, color: Colors.white),
                          ),
                          errorWidget: (_, __, ___) => Image.asset(defaultPropertyImage, height: 150.h, width: double.infinity, fit: BoxFit.cover),
                        )
                      : Image.asset(defaultPropertyImage, height: 150.h, width: double.infinity, fit: BoxFit.cover),
                ),
                if (ad.isFeatured == true)
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                      decoration: BoxDecoration(color: const Color(0xFFF5A623), borderRadius: BorderRadius.circular(20.r)),
                      child: Text('VIP', style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                Positioned(
                  top: 6.h,
                  left: 6.w,
                  child: Row(
                    children: [
                      Container(
                        width: 23.w,
                        height: 23.w,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                          child: ShareButton(size: 11.sp, shareText: '${ad.type ?? ''} - ${ad.region ?? ''}\n${ad.shareUrl ?? ''}'),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Container(
                        width: 23.w,
                        height: 23.w,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                          child: FavoriteButton(
                            key: ValueKey(_isFavorited),
                            type: FavoriteType.advertisement,
                            itemId: ad.id ?? 0,
                            initiallyFavorited: _isFavorited,
                            size: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 6.h,
                  right: 6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), borderRadius: BorderRadius.circular(20.r)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.visibility, size: 10.sp, color: Colors.white),
                      SizedBox(width: 3.w),
                      Text('${ad.viewsCount ?? 0}', style: TextStyle(fontSize: 9.sp, color: Colors.white)),
                    ]),
                  ),
                ),
                if (ad.hasCommission != null)
                  Positioned(
                    bottom: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: (ad.hasCommission == true) ? const Color(0xFFB54708).withOpacity(0.92) : const Color(0xFF12B76A).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        (ad.hasCommission == true) ? 'عمولة ${ad.commissionPercent ?? ''}%' : 'بدون عمولة',
                        style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(9.w, 8.h, 9.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _typeAndTransactionLabel(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828)),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    ad.region ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9.5.sp, color: const Color(0xFF98A2B3)),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      if ((ad.rooms ?? '').isNotEmpty && ad.rooms != '0') ...[
                        _specMini(Icons.bed_outlined, ad.rooms!),
                        SizedBox(width: 8.w),
                      ],
                      if ((ad.bathrooms ?? '').isNotEmpty && ad.bathrooms != '0') ...[
                        _specMini(Icons.bathtub_outlined, ad.bathrooms!),
                        SizedBox(width: 8.w),
                      ],
                      if ((ad.area ?? '').isNotEmpty && ad.area != '0')
                        _specMini(Icons.crop_free, '${ad.area} م²'),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    isSwap ? 'للبدل' : '${ad.price ?? '0'} د.ك',
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w800, color: ColorManager.primary),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('#${ad.referenceNo ?? '0000000'}',
                          style: TextStyle(fontSize: 8.5.sp, color: const Color(0xFFE53935))),
                      if (_publishedAt().isNotEmpty)
                        Text(_publishedAt(),
                            style: TextStyle(fontSize: 7.5.sp, color: const Color(0xFFB0B7BD))),
                    ],
                  ),
                  if ((ad.phone ?? '').isNotEmpty) ...[
                    SizedBox(height: 7.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _call(ad.phone!),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: const Color(0xFFE8F1F8), borderRadius: BorderRadius.circular(8.r)),
                              child: Icon(Icons.call, size: 13.sp, color: const Color(0xFF2E7CB8)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _whatsapp(ad.phone!),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: const Color(0xFFE7F8EE), borderRadius: BorderRadius.circular(8.r)),
                              child: Icon(Icons.chat, size: 13.sp, color: const Color(0xFF25D366)),
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

  Widget _specMini(IconData icon, String value) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11.sp, color: const Color(0xFF344054)),
      SizedBox(width: 3.w),
      Text(value, style: TextStyle(fontSize: 9.5.sp, color: const Color(0xFF344054))),
    ]);
  }
}
