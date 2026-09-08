import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/services/favorites_service.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/widgets/share_button.dart';
import 'contractors_list_view.dart';

import '../../core/widgets/app_loading_indicator.dart';
enum _ContactMethod { whatsapp, call }

/// صفحة تفاصيل المقاول الكاملة - نفس فكرة صفحة تفاصيل الفنادق/الشقق:
/// معلومات كاملة + زر "اطلب الخدمة" (يسجل طلب بالنظام) + اتصال + واتساب.
class ContractorDetailsView extends StatefulWidget {
  final ContractorItem contractor;
  final String categoryName;

  const ContractorDetailsView({
    super.key,
    required this.contractor,
    required this.categoryName,
  });

  @override
  State<ContractorDetailsView> createState() => _ContractorDetailsViewState();
}

class _ContractorDetailsViewState extends State<ContractorDetailsView> {
  bool _isRequesting = false;
  late int _viewsCount = widget.contractor.viewsCount;

  @override
  void initState() {
    super.initState();
    _incrementViews();
  }

  Future<void> _incrementViews() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      final res = await dio.post('contracting-listings/${widget.contractor.id}/view');
      final updated = int.tryParse('${res.data['views_count']}');
      if (updated != null && mounted) setState(() => _viewsCount = updated);
    } catch (_) {}
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final String message = Uri.encodeComponent(
        'مرحباً، شفت إعلانك (${widget.contractor.name}) بتطبيق آفاق العقاري وحاب أتواصل معك.');
    final Uri whatsappUri = Uri.parse('https://wa.me/${phone.trim()}?text=$message');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق واتساب')),
      );
    }
  }

  // === اضغط "اطلب الخدمة" يطلع فورًا شيت "واتساب أو اتصال" - الطلب
  // نفسه ما يتسجل إلا بعد ما يختار المستخدم وحدة من الاثنين
  Future<void> _requestService() async {
    if (_isRequesting) return;
    await _showContactMethodSheet();
  }

  // === بعد ما يختار طريقة التواصل: نسجل الطلب بالنظام ونفتح
  // واتساب/الاتصال بنفس اللحظة
  Future<void> _registerRequestAndContact(_ContactMethod method) async {
    setState(() => _isRequesting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));

      await dio.post('service-requests', data: {
        'user_id': userId,
        'contracting_listing_id': widget.contractor.id,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تسجيل طلبك! تقدر تتابعه من "طلباتي" وتقيّمه بعد الإنجاز'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تسجيل الطلب، حاول مرة أخرى')),
      );
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }

    if (!mounted) return;
    if (method == _ContactMethod.whatsapp) {
      await _openWhatsApp(context, widget.contractor.phone);
    } else {
      await _makePhoneCall(widget.contractor.phone);
    }
  }

  // === خيار "واتساب" أو "اتصال" - يطلع كشيت صغير بس وقت الضغط على
  // "اطلب الخدمة"، مو أزرار ثابتة بالشاشة طول الوقت
  Future<void> _showContactMethodSheet() async {
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('كيف تحب تتواصل مع ${widget.contractor.name}؟',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                verticalSpace(16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          minimumSize: Size.fromHeight(48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _registerRequestAndContact(_ContactMethod.whatsapp);
                        },
                        icon: const Icon(Icons.chat, color: Colors.white, size: 18),
                        label: const Text('واتساب',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    horizontalSpace(12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          minimumSize: Size.fromHeight(48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _registerRequestAndContact(_ContactMethod.call);
                        },
                        icon: const Icon(Icons.call, color: Colors.white, size: 18),
                        label: const Text('اتصال',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contractor = widget.contractor;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(contractor.name),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
        actions: [
          FavoriteButton(type: FavoriteType.contracting, itemId: contractor.id, size: 26),
          horizontalSpace(14),
          ShareButton(
            size: 24,
            shareText:
                'شوف ${contractor.name} (${widget.categoryName}) بتطبيق آفاق العقاري - ${contractor.phone}',
          ),
          horizontalSpace(12),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55.r,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: contractor.logoUrl != null
                        ? NetworkImage(contractor.logoUrl!)
                        : null,
                    child: contractor.logoUrl == null
                        ? Icon(Icons.handyman_outlined,
                            color: ColorManager.grey, size: 44.sp)
                        : null,
                  ),
                  verticalSpace(10),
                  Text(contractor.name,
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  verticalSpace(4),
                  Text(widget.categoryName,
                      style: TextStyle(fontSize: 13.sp, color: ColorManager.grey)),
                  verticalSpace(4),
                  Text('#${contractor.referenceNo}',
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFFE53935))),
                  verticalSpace(4),
                  Row(children: [
                    Icon(Icons.visibility, size: 13.sp, color: ColorManager.grey),
                    SizedBox(width: 4.w),
                    Text('$_viewsCount', style: TextStyle(fontSize: 11.5.sp, color: ColorManager.grey)),
                  ]),
                ],
              ),
            ),
            verticalSpace(24),
            Divider(color: ColorManager.lighterGray),
            verticalSpace(16),

            Text('نبذة عن الأعمال السابقة',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            verticalSpace(8),
            Text(contractor.bio,
                style: TextStyle(fontSize: 13.5.sp, color: Colors.black87, height: 1.6)),
            verticalSpace(28),

            // === زر "اطلب الخدمة" - الأساسي
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.black,
                minimumSize: Size.fromHeight(52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: _isRequesting ? null : _requestService,
              icon: const Icon(Icons.work_outline, color: Colors.white),
              label: Text(
                _isRequesting ? 'جاري التسجيل...' : 'اطلب الخدمة',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
