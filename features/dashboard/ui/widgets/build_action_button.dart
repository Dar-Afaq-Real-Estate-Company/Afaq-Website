// Helper method to build action buttons (call/chat/share)
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/resources/color_manager.dart';

Widget buildActionButton(IconData icon, Color color) {
  // Only the call and chat buttons have the blue circular border in the image
  // bool isPrimaryAction =
  //     (icon == Icons.phone || icon == Icons.chat_bubble_outline);

  return Container(
    padding: EdgeInsets.all(8.h),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: ColorManager.grey,
        width: 1,
      ),
    ),
    // No specific decoration for the share icon
    child: Icon(
      icon,
      color: ColorManager.primary,
      size: 20.sp,
    ),
  );
}

Future<void> launchWhatsAppAd(
  BuildContext context, {
  required String? phone,
  required String adId,
}) async {
  final String webLink = "https://api.afaq.group/share.php?code=$adId";
  // final String webLink = "https://api.afaq.group/advertisements/$adId";
  final String lang = Localizations.localeOf(context).languageCode;
  String message = lang == "ar"
      ? "مرحبا\nانا مهتم بالإعلان الذي تم نشره علي منصه آفاق\n🔗 $webLink"
      : "Hello, I am interested in the advertisement that was published on the Afaq platform\n🔗 $webLink";

  String cleanPhone = (phone ?? "").replaceAll(RegExp(r'[^\d]'), '');
  if (cleanPhone.length == 8) cleanPhone = '965$cleanPhone';

  final Uri whatsappUri = Uri.parse(
      "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    final Uri fallbackUri = Uri.parse(webLink);
    if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا يمكن فتح الرابط")),
      );
    }
  }
}

// Future<void> launchWhatsAppAd(
//   BuildContext context, {
//   required String? phone,
//   required String adId,
// }) async {
//   // الرابط الجديد الذي سيفتح التطبيق مباشرة بدون سيرفر
//   final String customLink = "https://api.afaq.group/ar/details/$adId";

//   final String lang = Localizations.localeOf(context).languageCode;

//   String message;

//   if (lang == "ar") {
//     message = "مرحبا\n"
//         "انا مهتم بالإعلان الذي تم نشره علي منصه آفاق\n"
//         "🔗 $customLink";
//   } else {
//     message =
//         "Hello, I am interested in the advertisement that was published on the Afaq platform\n"
//         "🔗 $customLink";
//   }

//   // تنظيف الرقم
//   String cleanPhone = (phone ?? "").replaceAll(RegExp(r'[^\d]'), '');
//   if (cleanPhone.length == 8) cleanPhone = '965$cleanPhone';

//   final Uri whatsappUri = Uri.parse(
//       "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");

//   if (await canLaunchUrl(whatsappUri)) {
//     await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
//   }
// }

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $urlString');
  }
}
