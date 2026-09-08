import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/services/favorites_service.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/widgets/share_button.dart';
import 'companies_list_view.dart';

/// صفحة تفاصيل الشركة الكاملة - نفس فكرة صفحة تفاصيل المقاول بالضبط.
class CompanyDetailsView extends StatelessWidget {
  final RealEstateCompanyItem company;

  const CompanyDetailsView({super.key, required this.company});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final String message = Uri.encodeComponent(
        'مرحباً، شفت شركتكم (${company.name}) بتطبيق آفاق العقاري وحاب أتواصل معكم.');
    final Uri whatsappUri = Uri.parse('https://wa.me/${phone.trim()}?text=$message');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق واتساب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(company.name),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
        actions: [
          FavoriteButton(type: FavoriteType.company, itemId: company.id, size: 26),
          horizontalSpace(14),
          ShareButton(
            size: 24,
            shareText: 'شوف شركة ${company.name} بتطبيق آفاق العقاري - ${company.phone}',
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
                  Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorManager.lighterGray),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: company.logoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: company.logoUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.apartment,
                                color: ColorManager.primary,
                                size: 44.sp,
                              ),
                            )
                          : Icon(Icons.apartment,
                              color: ColorManager.primary, size: 44.sp),
                    ),
                  ),
                  verticalSpace(10),
                  Text(company.name,
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  if (company.motto != null && company.motto!.isNotEmpty) ...[
                    verticalSpace(4),
                    Text('"${company.motto}"',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          color: ColorManager.primary,
                        )),
                  ],
                  verticalSpace(8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(company.field,
                        style: TextStyle(fontSize: 11.5.sp, color: ColorManager.primary)),
                  ),
                ],
              ),
            ),
            verticalSpace(24),
            Divider(color: ColorManager.lighterGray),
            verticalSpace(16),

            if (company.description != null && company.description!.isNotEmpty) ...[
              Text('عن الشركة',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              verticalSpace(8),
              Text(company.description!,
                  style: TextStyle(fontSize: 13.5.sp, color: Colors.black87, height: 1.6)),
              verticalSpace(28),
            ],

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      minimumSize: Size.fromHeight(48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () => _makePhoneCall(company.phone),
                    icon: const Icon(Icons.call, color: Colors.white, size: 18),
                    label: const Text('اتصال', style: TextStyle(color: Colors.white)),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      minimumSize: Size.fromHeight(48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () => _openWhatsApp(context, company.phone),
                    icon: const Icon(Icons.chat, color: Colors.white, size: 18),
                    label: const Text('واتساب', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
