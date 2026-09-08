import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../../../core/widgets/app_loading_indicator.dart';
import '../../../../../data/response/response.dart';
import '../../../../../../real_estate/property_details_view.dart';
import '../../../../../../jobs/job_vacancies_browse_view.dart' show VacancyListItem;
import '../../../../../../jobs/job_vacancy_details_view.dart';
import '../../../../../../contracting/contractors_list_view.dart' show ContractorItem;
import '../../../../../../contracting/contractor_details_view.dart';
import '../../../../../../hotels/ui/hotel_detail_view.dart';

/// عنصر موحّد لأي نوع إعلان (عقار/وظيفة/مقاول/فندق) بفيد واحد.
class _FeedItem {
  final String type; // property | job | contracting | hotel
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final DateTime? date;
  final int views;
  final double price;
  final bool isFeatured;
  final dynamic raw;
  final String? imageUrl;

  _FeedItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.date,
    required this.views,
    required this.price,
    required this.isFeatured,
    required this.raw,
    this.imageUrl,
  });
}

enum _SortOption { newest, mostViewed, highestPrice, lowestPrice }

class AdsView extends StatefulWidget {
  const AdsView({super.key});

  @override
  State<AdsView> createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
  bool _loading = true;
  String? _error;
  List<_FeedItem> _items = [];
  String _typeFilter = 'all';
  _SortOption _sort = _SortOption.newest;

  static const Map<String, Map<String, dynamic>> _typeInfo = {
    'property': {'label': 'عقار', 'icon': Icons.home_outlined, 'colors': [Color(0xFF2E6D71), Color(0xFF5EAAB0)], 'chipBg': Color(0xFFEAF1F1), 'chipFg': Color(0xFF2E6D71)},
    'job': {'label': 'وظيفة', 'icon': Icons.work_outline, 'colors': [Color(0xFF1570CD), Color(0xFF53B1FD)], 'chipBg': Color(0xFFEAF1FE), 'chipFg': Color(0xFF1570CD)},
    'contracting': {'label': 'مقاول', 'icon': Icons.handyman_outlined, 'colors': [Color(0xFFB54708), Color(0xFFF79009)], 'chipBg': Color(0xFFFFF4E5), 'chipFg': Color(0xFFB54708)},
    'hotel': {'label': 'فندق', 'icon': Icons.hotel_outlined, 'colors': [Color(0xFF7A5AF8), Color(0xFFB692F6)], 'chipBg': Color(0xFFEEF0FF), 'chipFg': Color(0xFF7A5AF8)},
  };

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _dio.get('advertisements').catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'data': []})),
        _dio.get('job-listings').catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'data': []})),
        _dio.get('contracting-listings').catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'data': []})),
        _dio.get('hotels').catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'data': []})),
        _dio.get('adsvip').catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'vip_ads': []})),
      ]);

      final List<_FeedItem> items = [];

      final List<dynamic> ads = [
        ...(results[0].data['advertisements'] ?? []),
        ...(results[4].data['vip_ads'] ?? []),
      ];
      for (final e in ads) {
        final ad = AdsDataResponse.fromJson(e);
        items.add(_FeedItem(
          type: 'property',
          title: '${ad.type ?? ''} - ${(ad.transactionType ?? '').contains('يجار') ? 'للإيجار' : (ad.transactionType ?? '').contains('بدل') ? 'للبدل' : 'للبيع'}',
          subtitle: '${ad.region ?? ''} — ${(ad.transactionType ?? '').contains('بدل') ? 'للبدل' : '${ad.price ?? '0'} د.ك'}',
          icon: Icons.home_outlined,
          colors: (_typeInfo['property']!['colors'] as List<Color>),
          date: DateTime.tryParse(ad.createdAt ?? ''),
          views: ad.viewsCount ?? 0,
          price: double.tryParse(ad.price ?? '0') ?? 0,
          isFeatured: ad.isFeatured == true,
          raw: ad,
          imageUrl: (ad.images != null && ad.images!.isNotEmpty) ? ad.images : null,
        ));
      }

      final List<dynamic> jobs = results[1].data['data'] ?? [];
      for (final e in jobs) {
        final j = VacancyListItem.fromJson(Map<String, dynamic>.from(e as Map));
        items.add(_FeedItem(
          type: 'job',
          title: j.title,
          subtitle: '${j.region} — ${j.employmentType}${(j.salary != null && j.salary!.isNotEmpty && j.salary != '0') ? ' — ${j.salary} د.ك' : ''}',
          icon: Icons.work_outline,
          colors: (_typeInfo['job']!['colors'] as List<Color>),
          date: DateTime.tryParse(j.createdAt ?? ''),
          views: int.tryParse('${e['views_count'] ?? 0}') ?? 0,
          price: double.tryParse(j.salary ?? '0') ?? 0,
          isFeatured: false,
          raw: j,
        ));
      }

      final List<dynamic> contracting = results[2].data['data'] ?? [];
      for (final e in contracting) {
        final c = ContractorItem.fromJson(e);
        items.add(_FeedItem(
          type: 'contracting',
          title: c.name,
          subtitle: '${e['category'] ?? ''}${(e['region'] != null) ? ' — ${e['region']}' : ''}',
          icon: Icons.handyman_outlined,
          colors: (_typeInfo['contracting']!['colors'] as List<Color>),
          date: DateTime.tryParse('${e['created_at'] ?? ''}'),
          views: int.tryParse('${e['views_count'] ?? 0}') ?? 0,
          price: 0,
          isFeatured: false,
          raw: {'contractor': c, 'category': e['category']?.toString() ?? ''},
        ));
      }

      final List<dynamic> hotels = results[3].data['data'] ?? [];
      for (final e in hotels) {
        final nightPrice = double.tryParse('${e['prices']?['night'] ?? e['price_per_night'] ?? 0}') ?? 0;
        items.add(_FeedItem(
          type: 'hotel',
          title: e['name']?.toString() ?? '',
          subtitle: '${e['region'] ?? ''} — $nightPrice د.ك/الليلة',
          icon: Icons.hotel_outlined,
          colors: (_typeInfo['hotel']!['colors'] as List<Color>),
          date: DateTime.tryParse('${e['created_at'] ?? ''}'),
          views: int.tryParse('${e['views_count'] ?? 0}') ?? 0,
          price: nightPrice,
          isFeatured: false,
          raw: e['id'],
          imageUrl: ((e['images'] as List?)?.isNotEmpty ?? false) ? (e['images'] as List).first.toString() : null,
        ));
      }

      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل الإعلانات، تأكد من اتصالك بالإنترنت';
        _loading = false;
      });
    }
  }

  List<_FeedItem> get _filteredSorted {
    var list = _typeFilter == 'all' ? _items : _items.where((i) => i.type == _typeFilter).toList();
    list = List.of(list);
    switch (_sort) {
      case _SortOption.newest:
        list.sort((a, b) => (b.date ?? DateTime(2000)).compareTo(a.date ?? DateTime(2000)));
        break;
      case _SortOption.mostViewed:
        list.sort((a, b) => b.views.compareTo(a.views));
        break;
      case _SortOption.highestPrice:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortOption.lowestPrice:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
    return list;
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  void _openDetails(_FeedItem item) {
    switch (item.type) {
      case 'property':
        Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailsView(ad: item.raw as AdsDataResponse)));
        break;
      case 'job':
        final j = item.raw as VacancyListItem;
        Navigator.push(context, MaterialPageRoute(builder: (_) => JobVacancyDetailsView(vacancy: j)));
        break;
      case 'contracting':
        final map = item.raw as Map;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ContractorDetailsView(contractor: map['contractor'] as ContractorItem, categoryName: map['category'] as String)),
        );
        break;
      case 'hotel':
        final id = int.tryParse('${item.raw}') ?? 0;
        Navigator.push(context, MaterialPageRoute(builder: (_) => HotelDetailView(hotelId: id)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: AppLoadingIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, style: TextStyle(color: Colors.grey.shade600)),
          SizedBox(height: 10.h),
          TextButton(onPressed: _fetchAll, child: const Text('إعادة المحاولة')),
        ]),
      );
    }

    final items = _filteredSorted;

    return RefreshIndicator(
      onRefresh: _fetchAll,
      child: Column(
        children: [
          SizedBox(height: 8.h),
          SizedBox(
            height: 34.h,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              scrollDirection: Axis.horizontal,
              children: [
                _typeChip('all', 'الكل'),
                SizedBox(width: 6.w),
                ..._typeInfo.entries.expand((e) => [
                      _typeChip(e.key, e.value['label'] as String),
                      SizedBox(width: 6.w),
                    ]),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 30.h,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              scrollDirection: Axis.horizontal,
              children: [
                _sortChip(_SortOption.newest, '🕐 الأحدث'),
                SizedBox(width: 6.w),
                _sortChip(_SortOption.mostViewed, '👁 الأكثر مشاهدة'),
                SizedBox(width: 6.w),
                _sortChip(_SortOption.highestPrice, '💰 الأعلى سعر'),
                SizedBox(width: 6.w),
                _sortChip(_SortOption.lowestPrice, '💲 الأقل سعر'),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('لا توجد إعلانات حالياً', style: TextStyle(color: Colors.grey.shade600)))
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 20.h),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) => _card(items[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _typeChip(String key, String label) {
    final active = _typeFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _typeFilter = key),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF16818A) : const Color(0xFFF2F4F5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label, style: TextStyle(fontSize: 11.5.sp, color: active ? Colors.white : const Color(0xFF344054), fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _sortChip(_SortOption option, String label) {
    final active = _sort == option;
    return GestureDetector(
      onTap: () => setState(() => _sort = option),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: active ? const Color(0xFF16818A) : const Color(0xFFE4E7EC), width: active ? 1.3 : 1),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(label, style: TextStyle(fontSize: 10.5.sp, color: active ? const Color(0xFF16818A) : const Color(0xFF667085), fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
      ),
    );
  }

  Widget _card(_FeedItem item) {
    final info = _typeInfo[item.type]!;
    return GestureDetector(
      onTap: () => _openDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEDEFF3)),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    gradient: item.imageUrl == null ? LinearGradient(colors: item.colors, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            decoration: BoxDecoration(gradient: LinearGradient(colors: item.colors, begin: Alignment.topLeft, end: Alignment.bottomRight)),
                            child: Icon(item.icon, color: Colors.white, size: 26.sp),
                          ),
                        )
                      : Icon(item.icon, color: Colors.white, size: 26.sp),
                ),
                if (item.isFeatured)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(color: const Color(0xFFF5A623), borderRadius: BorderRadius.circular(6.r)),
                      child: Text('VIP', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(color: info['chipBg'] as Color, borderRadius: BorderRadius.circular(10.r)),
                        child: Text(info['label'] as String, style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w700, color: info['chipFg'] as Color)),
                      ),
                      Text(_timeAgo(item.date), style: TextStyle(fontSize: 9.sp, color: const Color(0xFF98A2B3))),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF101828))),
                  SizedBox(height: 2.h),
                  Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF667085))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
