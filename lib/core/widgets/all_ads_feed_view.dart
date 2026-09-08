import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/dashboard/data/response/response.dart';
import '../helper/spacing.dart';
import 'package:easy_localization/easy_localization.dart';

import '../resources/color_manager.dart';
import 'map_search_view.dart';

/// قائمة عمودية عادية لكل الإعلانات (بطاقات فوق بعض، تسحب لفوق عادي) -
/// نفس شكل الفيديو المرجعي بالضبط. فيه زر عائم "ابحث في الخريطة" +
/// أيقونة فلترة يظهر وانت تسكرول، يفتح خريطة الكويت الكاملة.
/// هذي صفحة مستقلة (Navigator.push) فما فيها شريط سفلي أصلاً.
class AllAdsFeedView extends StatefulWidget {
  final List<AdsDataResponse?> adsList;

  const AllAdsFeedView({super.key, required this.adsList});

  @override
  State<AllAdsFeedView> createState() => _AllAdsFeedViewState();
}

class _AllAdsFeedViewState extends State<AllAdsFeedView> {
  final ScrollController _scrollController = ScrollController();
  bool _showMapBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // === الزر يطلع أول ما تبدأ تسحب لفوق (بعد أول شوي سكرول)، ويضل
    // ظاهر طول القائمة - نفس سلوك الفيديو المرجعي
    final shouldShow = _scrollController.offset > 80;
    if (shouldShow != _showMapBar) {
      setState(() => _showMapBar = shouldShow);
    }
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapSearchView(ads: widget.adsList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text('all_ads_title'.tr()),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: Stack(
        children: [
          widget.adsList.isEmpty
              ? Center(child: Text('no_ads_to_show'.tr()))
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
                  itemCount: widget.adsList.length,
                  itemBuilder: (context, index) {
                    return _AdListCard(ad: widget.adsList[index]);
                  },
                ),

          // === الشريط العائم "ابحث في الخريطة" + الفلترة
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            bottom: _showMapBar ? 20.h : -80,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleIconButton(
                  icon: Icons.tune,
                  onTap: _openMap,
                ),
                horizontalSpace(10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _openMap,
                    icon: const Icon(Icons.map_outlined, color: Colors.white),
                    label: Text(
                      'search_on_map'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                horizontalSpace(10),
                _CircleIconButton(
                  icon: Icons.swap_vert,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6),
          ],
        ),
        child: Icon(icon, color: ColorManager.primary),
      ),
    );
  }
}

/// بطاقة إعلان عادية بعرض كامل (نفس تصميم بطاقات الفيديو المرجعي):
/// صورة كبيرة بالأعلى + قلب المفضلة، وتحتها السعر والتفاصيل.
class _AdListCard extends StatelessWidget {
  final AdsDataResponse? ad;

  const _AdListCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final String currency = isAr ? ' د.ك' : 'KWD';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: CachedNetworkImage(
                  imageUrl: ad?.images ?? '',
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) =>
                      Shimmer.fromColors(
                    baseColor: ColorManager.lightGrey,
                    highlightColor: Colors.white,
                    child: Container(height: 200.h, color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200.h,
                    color: ColorManager.lighterGray,
                    child: Icon(Icons.broken_image,
                        color: Colors.grey, size: 32.sp),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Icon(Icons.favorite_border,
                      color: ColorManager.grey, size: 20.sp),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ad?.price ?? '0'}$currency',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),
                verticalSpace(6),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: ColorManager.grey, size: 14.sp),
                    horizontalSpace(4),
                    Expanded(
                      child: Text(
                        '${ad?.transactionType ?? ''} | ${ad?.type ?? ''}   ${ad?.region ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.sp, color: ColorManager.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
