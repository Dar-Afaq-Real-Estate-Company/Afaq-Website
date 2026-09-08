import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

import '../../../../core/resources/color_manager.dart';

/// قسم "الشركاء الأكثر ثقة" - يجيب البيانات من لوحة الإدارة (API)، نفس
/// تصميم الوكلاء بالضبط.
class TrustedPartnersSection extends StatefulWidget {
  const TrustedPartnersSection({super.key});

  @override
  State<TrustedPartnersSection> createState() => _TrustedPartnersSectionState();
}

class _TrustedPartnersSectionState extends State<TrustedPartnersSection> {
  static const int _itemsPerPage = 4;
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<List<Map<String, dynamic>>> _fetch() async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
    final response = await dio.get('trusted-partners');
    final List<dynamic> data = response.data['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: 120.h);
        }
        final partners = snapshot.data!;
        if (partners.isEmpty) return const SizedBox.shrink();

        final pageCount = (partners.length / _itemsPerPage).ceil();

        return SizedBox(
          height: 104.h,
          child: PageView.builder(
            itemCount: pageCount,
            controller: PageController(viewportFraction: 1),
            itemBuilder: (context, pageIndex) {
              final start = pageIndex * _itemsPerPage;
              final end = (start + _itemsPerPage).clamp(0, partners.length);
              final pagePartners = partners.sublist(start, end);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pagePartners
                    .map((partner) => _PartnerLogo(partner: partner))
                    .toList(),
              );
            },
          ),
        );
      },
    );
  }
}

class _PartnerLogo extends StatelessWidget {
  final Map<String, dynamic> partner;

  const _PartnerLogo({required this.partner});

  @override
  Widget build(BuildContext context) {
    final String? logoUrl = partner['logo_url'] as String?;
    final String name = partner['name'] as String? ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: ColorManager.primary.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: ClipOval(
            child: logoUrl == null
                ? Container(
                    color: ColorManager.primary.withOpacity(0.1),
                    child: Icon(Icons.business, color: ColorManager.primary),
                  )
                : Padding(
                    padding: EdgeInsets.all(10.w),
                    child: CachedNetworkImage(
                      imageUrl: logoUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.business, color: ColorManager.grey, size: 24.sp),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 76.w,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.sp, color: ColorManager.grey),
          ),
        ),
      ],
    );
  }
}
