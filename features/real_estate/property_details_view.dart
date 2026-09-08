import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/helper/kuwait_governorates.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/services/favorites_service.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/widgets/share_button.dart';
import '../dashboard/data/response/response.dart';
import 'publisher_profile_view.dart';

/// تفاصيل العقار — صورة كاملة، بطاقة بيضاء منزلقة فوقها،
/// وشريط ناشر ثابت بالأسفل فيه الاتصال والواتساب.
class PropertyDetailsView extends StatefulWidget {
  final AdsDataResponse ad;

  const PropertyDetailsView({super.key, required this.ad});

  @override
  State<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<PropertyDetailsView> {
  AdsDataResponse get ad => widget.ad;

  bool get _isRent => ad.transactionType?.contains('يجار') ?? false;
  bool get _isSwap => ad.transactionType?.contains('بدل') ?? false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _incrementViews();
    _checkFavorited();
  }

  Future<void> _checkFavorited() async {
    if (ad.id == null) return;
    final result = await FavoritesService.isFavorited(FavoriteType.advertisement, ad.id!);
    if (mounted) setState(() => _isFavorited = result);
  }

  Future<void> _incrementViews() async {
    if (ad.id == null) return;
    setState(() => ad.viewsCount = (ad.viewsCount ?? 0) + 1);
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.afaq.group/api/',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ));
      final response = await dio.post('advertisement-view', data: {'id': ad.id});
      final int? updated = (response.data['views_count'] as num?)?.toInt();
      if (updated != null && mounted) {
        setState(() => ad.viewsCount = updated);
      }
    } catch (_) {}
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String phone) async {
    final message = Uri.encodeComponent(
      'مرحباً، مهتم بالإعلان رقم #${ad.referenceNo ?? ''} (${ad.type ?? ''} - ${ad.region ?? ''})',
    );
    final uri = Uri.parse('https://wa.me/$phone?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label - قريباً')),
    );
  }

  String get _priceText {
    if (_isSwap) return 'للبدل';
    final price = ad.price ?? '0';
    return _isRent ? '$price د.ك/شهرياً' : '$price د.ك';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // === المحتوى القابل للتمرير
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildImage()),
              SliverToBoxAdapter(child: _buildSheet()),
            ],
          ),

          // === أزرار عائمة أعلى الصورة
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 14.w,
            right: 14.w,
            child: Row(
              children: [
                _circleButton(
                  child: FavoriteButton(
                    key: ValueKey(_isFavorited),
                    type: FavoriteType.advertisement,
                    itemId: ad.id ?? 0,
                    initiallyFavorited: _isFavorited,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                _circleButton(
                  child: ShareButton(
                    size: 20.sp,
                    shareText:
                        '${ad.type ?? ''} - ${ad.region ?? ''}\n${ad.shareUrl ?? ''}',
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: _circleButton(
                    child: Icon(Icons.arrow_forward,
                        size: 21.sp, color: const Color(0xFF344054)),
                  ),
                ),
              ],
            ),
          ),

          // === شريط الناشر الثابت بالأسفل
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPublisherBar(),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required Widget child}) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 280.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          (ad.images == null || ad.images!.isEmpty)
              ? Image.asset(defaultPropertyImage, fit: BoxFit.cover)
              : CachedNetworkImage(
            imageUrl: ad.images ?? '',
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: const Color(0xFFF2F4F7)),
            errorWidget: (_, __, ___) => Image.asset(defaultPropertyImage, fit: BoxFit.cover),
          ),
          // تظليل سفلي خفيف لتحسين وضوح عدد المشاهدات فوق الصورة
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 90.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.28)],
                ),
              ),
            ),
          ),
          // عدد المشاهدات
          Positioned(
            bottom: 46.h,
            left: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.42),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.visibility, size: 14.sp, color: Colors.white),
                  SizedBox(width: 5.w),
                  Text('${ad.viewsCount ?? 0}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white)),
                ],
              ),
            ),
          ),
          if (ad.hasCommission != null)
            Positioned(
              bottom: 46.h,
              right: 14.w,
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
                      ? 'عمولة ${ad.commissionPercent ?? ''}%'
                      : 'بدون عمولة',
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSheet() {
    return Transform.translate(
      offset: Offset(0, -28.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(18.w, 26.h, 18.w, 118.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مقبض صغير أعلى البطاقة لإيحاء "قابل للسحب"
            Center(
              child: Container(
                width: 44.w,
                height: 4.5.h,
                margin: EdgeInsets.only(bottom: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E7EC),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            // === سطر واحد: السعر + نوع المعاملة + تاريخ النشر
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.rotate(
                        angle: -0.035,
                        child: Text(
                          _priceText,
                          style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w900,
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                      verticalSpace(5),
                      Row(
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5A524),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            [
                              (ad.transactionType ?? '')
                                  .replaceAll('عقارات ', '')
                                  .replaceAll('عقار ', '')
                                  .replaceAll('لل', ''),
                              if ((ad.type ?? '').isNotEmpty) ad.type!,
                            ].join(' | '),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Transform.rotate(
                      angle: -0.035,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3F2),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text('#${ad.referenceNo ?? '0000000'}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE53935),
                            )),
                      ),
                    ),
                    if (ad.createdAt != null) ...[
                      verticalSpace(5),
                      Text(_publishedAt(ad.createdAt!),
                          style: TextStyle(
                              fontSize: 10.5.sp,
                              color: const Color(0xFFB0B7BD))),
                    ],
                  ],
                ),
              ],
            ),
            verticalSpace(14),

            // === الموقع + العمولة بسطر واحد
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9F9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16.sp, color: ColorManager.primary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      [
                        regionWithGovernorate(ad.region ?? ''),
                        if ((ad.address ?? '').isNotEmpty) ad.address!,
                      ].join('، '),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 12.5.sp, color: const Color(0xFF475467)),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(16),

            // === المواصفات كحبيبات (pills) بحجمها الطبيعي، تلتف لسطر ثاني لو كثرت
            if (_specs.isNotEmpty) ...[
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _specs.map(_specPill).toList(),
              ),
              verticalSpace(16),
            ],

            // === المرافق
            if (_amenities.isNotEmpty) ...[
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _amenities.map(_chip).toList(),
              ),
              verticalSpace(16),
            ],

            // === الوصف
            if ((ad.description ?? '').isNotEmpty) ...[
              _sectionTitle('الوصف'),
              verticalSpace(7),
              Text(
                ad.description!,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  height: 1.8,
                  color: const Color(0xFF475467),
                ),
              ),
              verticalSpace(18),
            ],

            // === إجراءات إضافية
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(46.h),
                      side: BorderSide(color: ColorManager.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () => _showSoon('طلب معاينة'),
                    icon: Icon(Icons.event_available_outlined,
                        size: 17.sp, color: ColorManager.primary),
                    label: Text('طلب معاينة',
                        style: TextStyle(
                            fontSize: 13.sp, color: ColorManager.primary)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(46.h),
                      side: BorderSide(color: ColorManager.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () => _showSoon('إنشاء عقد'),
                    icon: Icon(Icons.description_outlined,
                        size: 17.sp, color: ColorManager.primary),
                    label: Text('إنشاء عقد',
                        style: TextStyle(
                            fontSize: 13.sp, color: ColorManager.primary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// شريط الناشر الثابت — صورة واسم + اتصال وواتساب
  Widget _buildPublisherBar() {
    final phone = ad.phone ?? '';

    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 16.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // اسم وصورة الناشر — يفتحان صفحته
          Expanded(
            child: GestureDetector(
              onTap: _openPublisher,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEFF3),
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (ad.publisherLogo ?? '').isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: ad.publisherLogo!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _avatarFallback(),
                          )
                        : _avatarFallback(),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((ad.publisherAccountType ?? '').isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.75)]),
                              borderRadius: BorderRadius.circular(9.r),
                              boxShadow: [
                                BoxShadow(color: ColorManager.primary.withOpacity(0.5), blurRadius: 8),
                              ],
                            ),
                            child: Text(
                              _accountTypeLabel(ad.publisherAccountType!),
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                        ],
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            ad.publisherName ?? 'الناشر',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (phone.isNotEmpty) ...[
            SizedBox(width: 10.w),
            _contactCircle(
              icon: Icons.call,
              bg: const Color(0xFFE8F1F8),
              fg: const Color(0xFF2E7CB8),
              onTap: () => _call(phone),
            ),
            SizedBox(width: 10.w),
            _contactCircle(
              icon: Icons.chat,
              bg: const Color(0xFFE7F8EE),
              fg: const Color(0xFF25D366),
              onTap: () => _whatsapp(phone),
            ),
          ],
        ],
      ),
    );
  }

  String _accountTypeLabel(String value) {
    const labels = {
      'seeker': 'فرد',
      'company': 'شركة عقارية',
      'office': 'مكتب عقاري',
      'broker': 'مسوق عقاري',
    };
    return labels[value] ?? value;
  }

  Widget _avatarFallback() {
    final name = (ad.publisherName ?? '').trim();
    final initials = name.isEmpty
        ? '؟'
        : name.split(RegExp(r'\s+')).first.characters.take(2).toString();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF98A2B3),
        ),
      ),
    );
  }

  Widget _contactCircle({
    required IconData icon,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 21.sp, color: fg),
      ),
    );
  }

  void _openPublisher() {
    final id = ad.userId;
    if (id == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PublisherProfileView(
          userId: int.tryParse(id.toString()) ?? 0,
          name: ad.publisherName,
        ),
      ),
    );
  }

  /// بطاقة مواصفة صغيرة (أيقونة + قيمة + وصف)
  Widget _specTile((String, String, IconData) spec) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9F9),
          borderRadius: BorderRadius.circular(13.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(spec.$3, size: 16.sp, color: ColorManager.primary),
            SizedBox(height: 4.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                spec.$2,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF101828),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                spec.$1,
                maxLines: 1,
                style: TextStyle(fontSize: 10.sp, color: const Color(0xFF98A2B3)),
              ),
            ),
          ],
        ),
      );

  /// حبة (pill) مواصفة صغيرة — أيقونة + قيمة + وصف بسطر واحد، بحجمها الطبيعي
  Widget _specPill((String, String, IconData) spec) => Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE4E7EC), width: 1.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(spec.$3, size: 13.5.sp, color: ColorManager.primary),
            SizedBox(width: 5.w),
            Text(
              spec.$2,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101828),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              spec.$1,
              style:
                  TextStyle(fontSize: 11.5.sp, color: const Color(0xFF475467)),
            ),
          ],
        ),
      );

  Widget _sectionTitle(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 14.5.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF101828),
        ),
      );

  Widget _chip(String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF5F4),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorManager.primary,
          ),
        ),
      );

  List<String> get _amenities {
    final list = <String>[];
    if (ad.hasPool ?? false) list.add('مسبح');
    if (ad.hasGarden ?? false) list.add('حديقة');
    if (ad.hasParking ?? false) list.add('مواقف للسيارات');
    for (final a in ad.amenities ?? []) {
      final name = a.name?.toString();
      if (name != null && name.isNotEmpty) list.add(name);
    }
    return list;
  }

  /// (العنوان، القيمة، الأيقونة)
  List<(String, String, IconData)> get _specs {
    final list = <(String, String, IconData)>[];
    void add(String label, dynamic value, IconData icon) {
      if (value == null) return;
      final text = value.toString().trim();
      if (text.isEmpty || text == '0') return;
      list.add((label, text, icon));
    }

    add('الغرف', ad.rooms, Icons.bed_outlined);
    add('الحمامات', ad.bathrooms, Icons.bathtub_outlined);
    add('المساحة', ad.area != null ? '${ad.area} م²' : null, Icons.crop_free);
    add('الطوابق', ad.floorsCount, Icons.layers_outlined);
    add('الفرش', ad.furnishing, Icons.chair_outlined);
    add('عمر البناء', ad.buildingAge, Icons.calendar_today_outlined);
    add('نوع الأرض', ad.landType, Icons.terrain_outlined);
    return list;
  }

  String _publishedAt(String raw) {
    final date = DateTime.tryParse(raw);
    if (date == null) return '';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
