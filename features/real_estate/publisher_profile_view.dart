import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../dashboard/data/response/response.dart';
import 'property_list_view.dart' show PropertyCard;

/// صفحة الناشر — بياناته وكل إعلاناته داخل التطبيق
class PublisherProfileView extends StatefulWidget {
  final int userId;
  final String? name;

  const PublisherProfileView({super.key, required this.userId, this.name});

  @override
  State<PublisherProfileView> createState() => _PublisherProfileViewState();
}

class _PublisherProfileViewState extends State<PublisherProfileView> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.afaq.group/api/',
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Map<String, dynamic>? _publisher;
  List<AdsDataResponse> _ads = [];
  bool _loading = true;
  String _filter = 'all'; // all | sale | rent | swap

  static const Map<String, String> _typeLabels = {
    'seeker': 'باحث عن عقار',
    'owner': 'مالك عقار',
    'office': 'مكتب عقاري',
    'developer': 'مطوّر عقاري',
    'broker': 'وسيط عقاري',
  };

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final response = await _dio.get('publisher/${widget.userId}');
      final data = response.data['data'] ?? {};
      final List<dynamic> ads = data['ads'] ?? [];

      if (!mounted) return;
      setState(() {
        _publisher = Map<String, dynamic>.from(data['publisher'] ?? {});
        _ads = ads
            .map((e) => AdsDataResponse.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildAds()),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    final name = (_publisher?['name'] ?? widget.name ?? 'الناشر').toString();
    final logo = (_publisher?['logo'] ?? '').toString();
    final type = _typeLabels[_publisher?['account_type']] ?? '';
    final verified = (_publisher?['license_status'] ?? 0).toString() == '1';
    final phone = (_publisher?['phone'] ?? '').toString();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 22.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26.r)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
              ),
              const Spacer(),
            ],
          ),
          verticalSpace(6),
          Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            clipBehavior: Clip.antiAlias,
            child: logo.isNotEmpty
                ? Transform.scale(
                    scale: 1.14,
                    child: CachedNetworkImage(
                      imageUrl: logo,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _fallback(name),
                    ),
                  )
                : _fallback(name),
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (verified) ...[
                SizedBox(width: 6.w),
                Icon(Icons.verified, size: 18.sp, color: Colors.white),
              ],
            ],
          ),
          if (type.isNotEmpty) ...[
            verticalSpace(5),
            Text(
              type,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.85), fontSize: 12.5.sp),
            ),
          ],
          verticalSpace(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stat('${_ads.length}', 'إعلان'),
              Container(
                width: 1,
                height: 26.h,
                margin: EdgeInsets.symmetric(horizontal: 22.w),
                color: Colors.white.withOpacity(0.3),
              ),
              _stat('${_totalViews}', 'مشاهدة'),
            ],
          ),
          if (phone.isNotEmpty) ...[
            verticalSpace(16),
            Row(
              children: [
                Expanded(
                  child: _headerButton(
                    icon: Icons.chat,
                    label: 'واتساب',
                    onTap: () => _whatsapp(phone),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _headerButton(
                    icon: Icons.call,
                    label: 'اتصال',
                    onTap: () => _call(phone),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int get _totalViews =>
      _ads.fold<int>(0, (sum, ad) => sum + (ad.viewsCount ?? 0));

  List<AdsDataResponse> get _filteredAds {
    if (_filter == 'all') return _ads;
    return _ads.where((ad) {
      final t = ad.transactionType ?? '';
      if (_filter == 'sale') return t.contains('بيع');
      if (_filter == 'rent') return t.contains('يجار');
      if (_filter == 'swap') return t.contains('بدل');
      return true;
    }).toList();
  }

  Widget _fallback(String name) {
    final initials = name.trim().isEmpty
        ? '؟'
        : name.trim().split(RegExp(r'\s+')).first.characters.take(2).toString();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w900,
          color: ColorManager.primary,
        ),
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
        children: [
          Text(value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.sp,
                fontWeight: FontWeight.w900,
              )),
          verticalSpace(2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8), fontSize: 11.5.sp)),
        ],
      );

  Widget _headerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17.sp, color: Colors.white),
            SizedBox(width: 7.w),
            Text(label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAds() {
    if (_ads.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_outlined, size: 48.sp, color: const Color(0xFFD0D5DD)),
            verticalSpace(12),
            Text('ما فيه إعلانات منشورة',
                style: TextStyle(fontSize: 14.sp, color: ColorManager.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetch,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
        children: [
          Text('إعلانات الناشر',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
          verticalSpace(12),
          _buildFilterBar(),
          verticalSpace(14),
          if (_filteredAds.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: Center(
                child: Text('ما فيه إعلانات مطابقة',
                    style: TextStyle(fontSize: 13.sp, color: ColorManager.grey)),
              ),
            )
          else
            ..._filteredAds.map((ad) => PropertyCard(ad: ad)),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final options = const [
      {'value': 'all', 'label': 'الكل'},
      {'value': 'sale', 'label': 'بيع'},
      {'value': 'rent', 'label': 'إيجار'},
      {'value': 'swap', 'label': 'بدل'},
    ];
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: options.map((opt) {
          final selected = _filter == opt['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filter = opt['value']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: EdgeInsets.symmetric(vertical: 9.h),
                decoration: BoxDecoration(
                  color: selected ? ColorManager.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  opt['label']!,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF667085),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
