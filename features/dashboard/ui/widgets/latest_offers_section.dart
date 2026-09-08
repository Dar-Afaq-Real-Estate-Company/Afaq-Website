import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../real_estate/property_details_view.dart';
import '../../../jobs/job_vacancies_browse_view.dart' show VacancyListItem;
import '../../../jobs/job_vacancy_details_view.dart';
import '../../../contracting/contractors_list_view.dart' show ContractorItem;
import '../../../contracting/contractor_details_view.dart';
import '../../../hotels/data/hotel_model.dart';
import '../../../hotels/ui/hotel_detail_view.dart';
import '../../data/response/response.dart';
import '../../../../core/widgets/favorite_button.dart';
import '../../../../core/widgets/share_button.dart';
import '../../../../core/services/favorites_service.dart';
import '../../../../core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'latest_ads_list_view.dart' show LatestAdCard;

/// "أحدث العروض" - آخر ما يُنشر بكل التطبيق (عقار، مقاول، وظيفة، فندق)
/// بشكل موحّد مرتّب بالأحدث أولاً، بدون خيار نشر منفصل.
class LatestOffersSection extends StatefulWidget {
  const LatestOffersSection({super.key});

  @override
  State<LatestOffersSection> createState() => _LatestOffersSectionState();
}

class _FeedItem {
  final String type; // property | job | contracting | hotel
  final DateTime date;
  final dynamic data;
  _FeedItem(this.type, this.date, this.data);
}

class _LatestOffersSectionState extends State<LatestOffersSection> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
  List<_FeedItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _retry() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    await _fetchAll();
  }

  DateTime _parseDate(String? raw) => DateTime.tryParse(raw ?? '') ?? DateTime(2000);

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsappPhone(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _fetchAll() async {
    final List<_FeedItem> merged = [];

    try {
      final res = await _dio.get('advertisements');
      final List<dynamic> data = res.data['advertisements'] ?? [];
      for (final e in data) {
        try {
          final ad = AdsDataResponse.fromJson(e);
          merged.add(_FeedItem('property', _parseDate(ad.createdAt), ad));
        } catch (err) {
          debugPrint('LatestOffersSection: skip bad ad -> $err');
        }
      }
    } catch (_) {}

    try {
      final res = await _dio.get('job-listings');
      final List<dynamic> data = res.data['data'] ?? [];
      for (final e in data) {
        try {
          if (e['listing_type'] != 'vacancy') continue;
          final item = VacancyListItem(
            id: int.tryParse('${e['id']}') ?? 0,
            title: e['title']?.toString() ?? '',
            profession: e['profession']?.toString() ?? '',
            employmentType: e['employment_type']?.toString() ?? '',
            region: e['region']?.toString() ?? '',
            salary: e['salary']?.toString(),
            description: e['description']?.toString() ?? '',
            phone: e['phone']?.toString() ?? '',
            email: e['email']?.toString() ?? '',
            createdAt: e['created_at']?.toString(),
            referenceNo: (e['reference_no'] ?? e['id'])?.toString(),
            viewsCount: int.tryParse('${e['views_count'] ?? 0}') ?? 0,
          );
          merged.add(_FeedItem('job', _parseDate(e['created_at']?.toString()), item));
        } catch (err) {
          debugPrint('LatestOffersSection: skip bad job -> $err');
        }
      }
    } catch (_) {}

    try {
      final res = await _dio.get('contracting-listings');
      final List<dynamic> data = res.data['data'] ?? [];
      for (final e in data) {
        try {
          merged.add(_FeedItem('contracting', _parseDate(e['created_at']?.toString()), ContractorItem.fromJson(e)));
        } catch (err) {
          debugPrint('LatestOffersSection: skip bad contractor -> $err');
        }
      }
    } catch (_) {}

    try {
      final res = await _dio.get('hotels');
      final List<dynamic> data = res.data['data'] ?? [];
      for (final e in data) {
        try {
          merged.add(_FeedItem('hotel', _parseDate(e['created_at']?.toString()), HotelModel.fromJson(e)));
        } catch (err) {
          debugPrint('LatestOffersSection: skip bad hotel -> $err');
        }
      }
    } catch (_) {}

    merged.sort((a, b) => b.date.compareTo(a.date));

    debugPrint('LatestOffersSection: merged ${merged.length} items');
    if (!mounted) return;
    setState(() {
      _items = merged.take(15).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return SizedBox(height: 120.h, child: const Center(child: AppLoadingIndicator()));
    if (_items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GestureDetector(
          onTap: _retry,
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(color: const Color(0xFFF6F8F8), borderRadius: BorderRadius.circular(14.r)),
            child: Row(
              children: [
                Icon(Icons.refresh_rounded, size: 16.sp, color: const Color(0xFF98A2B3)),
                horizontalSpace(8),
                Text('تعذر تحميل العروض، اضغط لإعادة المحاولة', style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF98A2B3))),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Container(
                width: 5.w,
                height: 20.h,
                decoration: BoxDecoration(color: ColorManager.primary, borderRadius: BorderRadius.circular(4.r)),
              ),
              horizontalSpace(8),
              Icon(Icons.local_offer_rounded, size: 18.sp, color: ColorManager.primary),
              horizontalSpace(6),
              Text(AppStrings.latestOffers.tr(),
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
            ],
          ),
        ),
        verticalSpace(10),
        SizedBox(
          height: 300.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              try {
                return _card(_items[index]);
              } catch (e, st) {
                debugPrint('LatestOffersSection card error: $e\n$st');
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        if (_items.length > 1)
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

  Widget _card(_FeedItem item) {
    // === بطاقة عقار: نفس تصميم "أحدث الإعلانات" بالضبط
    if (item.type == 'property') {
      return SizedBox(width: 148.w, height: 300.h, child: LatestAdCard(ad: item.data as AdsDataResponse));
    }

    // === بطاقة مقاول: نفس حجم/تصميم بطاقة العقار بالضبط (صورة 150، اتصال/واتساب)
    if (item.type == 'contracting') {
      final c = item.data as ContractorItem;
      return Container(
        width: 148.w,
        height: 300.h,
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => ContractorDetailsView(contractor: c, categoryName: c.bio)));
                if (!mounted) return;
                setState(() {
                  final idx = _items.indexWhere((it) => it.type == 'contracting' && (it.data as ContractorItem).id == c.id);
                  if (idx != -1) {
                    final old = _items[idx].data as ContractorItem;
                    _items[idx] = _FeedItem(
                      'contracting',
                      _items[idx].date,
                      ContractorItem(
                        id: old.id,
                        name: old.name,
                        logoUrl: old.logoUrl,
                        phone: old.phone,
                        bio: old.bio,
                        referenceNo: old.referenceNo,
                        viewsCount: old.viewsCount + 1,
                      ),
                    );
                  }
                });
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: (c.logoUrl == null || c.logoUrl!.isEmpty)
                        ? Container(height: 150.h, width: double.infinity, color: const Color(0xFFF6F8F8),
                            child: Icon(Icons.handyman_outlined, size: 32.sp, color: ColorManager.primary))
                        : CachedNetworkImage(imageUrl: c.logoUrl!, height: 150.h, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Row(children: [
                      Container(width: 26.w, height: 26.w, decoration: const BoxDecoration(color: Color(0xFFFEE4E2), shape: BoxShape.circle),
                        child: Center(child: FavoriteButton(type: FavoriteType.contracting, itemId: c.id, size: 13.sp))),
                      SizedBox(width: 5.w),
                      Container(width: 26.w, height: 26.w, decoration: const BoxDecoration(color: Color(0xFFD1E9FF), shape: BoxShape.circle),
                        child: Center(child: ShareButton(shareText: c.name, size: 12, color: const Color(0xFF1570CB)))),
                    ]),
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
                        Text('${c.viewsCount}', style: TextStyle(fontSize: 9.sp, color: Colors.white)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مقاول', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: ColorManager.primary)),
                  verticalSpace(4),
                  Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                  verticalSpace(3),
                  Text(c.bio, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.sp, color: const Color(0xFF98A2B3))),
                  verticalSpace(3),
                  Text('#${c.referenceNo}', style: TextStyle(fontSize: 9.sp, color: const Color(0xFFE53935))),
                  if (c.phone.isNotEmpty) ...[
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _callPhone(c.phone),
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
                            onTap: () => _whatsappPhone(c.phone),
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
            ),
          ],
        ),
      );
    }

    // === بطاقة وظيفة: نفس حجم/تصميم بطاقة العقار والمقاول بالضبط
    if (item.type == 'job') {
      final job = item.data as VacancyListItem;
      final salaryLabel = (job.salary == null || job.salary!.isEmpty || job.salary == '0') ? 'عند المقابلة' : '${job.salary} د.ك';
      return Container(
        width: 148.w,
        height: 300.h,
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => JobVacancyDetailsView(vacancy: job)));
                if (!mounted) return;
                setState(() {
                  final idx = _items.indexWhere((it) => it.type == 'job' && (it.data as VacancyListItem).id == job.id);
                  if (idx != -1) {
                    final old = _items[idx].data as VacancyListItem;
                    _items[idx] = _FeedItem(
                      'job',
                      _items[idx].date,
                      VacancyListItem(
                        id: old.id,
                        title: old.title,
                        profession: old.profession,
                        employmentType: old.employmentType,
                        region: old.region,
                        description: old.description,
                        phone: old.phone,
                        email: old.email,
                        salary: old.salary,
                        createdAt: old.createdAt,
                        referenceNo: old.referenceNo,
                        viewsCount: old.viewsCount + 1,
                      ),
                    );
                  }
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Stack(
                  children: [
                    Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF2E6D71), const Color(0xFF5EAAB0)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                      alignment: Alignment.center,
                      child: Text(job.title.trim().isEmpty ? '؟' : job.title.trim().substring(0, job.title.trim().length >= 2 ? 2 : 1),
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Row(children: [
                        Container(width: 26.w, height: 26.w, decoration: const BoxDecoration(color: Color(0xFFFEE4E2), shape: BoxShape.circle),
                          child: Center(child: FavoriteButton(type: FavoriteType.job, itemId: job.id, size: 13.sp))),
                        SizedBox(width: 5.w),
                        Container(width: 26.w, height: 26.w, decoration: const BoxDecoration(color: Color(0xFFD1E9FF), shape: BoxShape.circle),
                          child: Center(child: ShareButton(shareText: job.title, size: 12, color: const Color(0xFF1570CB)))),
                      ]),
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
                          Text('${job.viewsCount}', style: TextStyle(fontSize: 9.sp, color: Colors.white)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('وظيفة شاغرة', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF2E6D71))),
                    verticalSpace(4),
                    Text(job.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                    verticalSpace(3),
                    Text(job.profession, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.sp, color: const Color(0xFF98A2B3))),
                    verticalSpace(3),
                    Text('#${job.referenceNo ?? '0000000'}', style: TextStyle(fontSize: 9.sp, color: const Color(0xFFE53935))),
                    const Spacer(),
                    if (job.phone.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _callPhone(job.phone),
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
                              onTap: () => _whatsappPhone(job.phone),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: const Color(0xFFE7F8EE), borderRadius: BorderRadius.circular(8.r)),
                                child: Icon(Icons.chat, size: 13.sp, color: const Color(0xFF25D366)),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(color: const Color(0xFF2E6D71).withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                        alignment: Alignment.center,
                        child: Text(salaryLabel, style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF2E6D71))),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    String title = '';
    String subtitle = '';
    String? image;
    String badge = '';
    String priceLabel = '';
    List<Color> gradient = [ColorManager.primary, ColorManager.primary.withOpacity(0.75)];
    Color badgeColor = ColorManager.primary;
    VoidCallback? onTap;
    String initials(String s) {
      final t = s.trim();
      if (t.isEmpty) return '؟';
      return t.length >= 2 ? t.substring(0, 2) : t.substring(0, 1);
    }

    switch (item.type) {
      case 'property':
        final ad = item.data as AdsDataResponse;
        title = ad.title ?? ad.type ?? '';
        subtitle = ad.region ?? '';
        image = ad.images;
        badge = 'عقار';
        badgeColor = const Color(0xFFE07A1F);
        priceLabel = '${ad.price ?? '0'} د.ك';
        onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailsView(ad: ad)));
        break;
      case 'job':
        break;
      case 'contracting':
        break;
      case 'hotel':
        final h = item.data as HotelModel;
        title = h.name ?? '';
        subtitle = h.region ?? '';
        image = h.images.isNotEmpty ? h.images.first : null;
        badge = 'فندق';
        badgeColor = const Color(0xFFB54708);
        priceLabel = h.nightPrice > 0 ? '${h.nightPrice} د.ك / ليلة' : '';
        onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => HotelDetailView(hotelId: h.id ?? 0)));
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 148.w,
        height: 300.h,
        margin: EdgeInsets.only(left: 12.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 5)),
        ]),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110.h,
              width: double.infinity,
              child: (item.type == 'hotel' || item.type == 'property')
                  ? ((image == null || image.isEmpty)
                      ? Container(color: const Color(0xFFE4E7EC), child: Icon(Icons.apartment_rounded, size: 30.sp, color: const Color(0xFF98A2B3)))
                      : CachedNetworkImage(imageUrl: image, fit: BoxFit.cover, width: double.infinity))
                  : Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)),
                      alignment: Alignment.center,
                      child: Container(
                        width: 58.w,
                        height: 58.w,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(item.type == 'job' ? 16.r : 100.r)),
                        alignment: Alignment.center,
                        child: (image != null && image.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(item.type == 'job' ? 16.r : 100.r),
                                child: CachedNetworkImage(imageUrl: image, width: 58.w, height: 58.w, fit: BoxFit.cover))
                            : Text(initials(title), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: gradient[0])),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(badge, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: badgeColor)),
                    verticalSpace(3),
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                    verticalSpace(3),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 9.5.sp, color: const Color(0xFF98A2B3))),
                    if (priceLabel.isNotEmpty) ...[
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(color: badgeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                        alignment: Alignment.center,
                        child: Text(priceLabel, style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: badgeColor)),
                      ),
                    ] else
                      const Spacer(),
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
