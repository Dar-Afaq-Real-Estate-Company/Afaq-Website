import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/constants.dart';
import '../../../core/helper/shared_pref.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';

/// === تنبيه "هل اكتملت الخدمة؟" - يتفحص أول ما يفتح التطبيق. لو فيه
/// طلب معلّق مرّ عليه 24 ساعة بدون تحديد حالته، تطلع نافذة تسأل
/// المستخدم. هذا ضروري عشان نقدر نبني تقييمات حقيقية للمقاولين ونرتبهم
/// حسب الأعلى تقييمًا.
///
/// الباك اند نفسه يتحكم بعدم التكرار أكثر من مرة كل 24 ساعة
/// (عمود last_reminded_at بجدول service_requests).
Future<void> checkPendingServiceCompletion(BuildContext context) async {
  try {
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    if (userId == 0) return; // زائر غير مسجل دخول

    final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
    final response = await dio.get(
      'service-requests/pending-reminder',
      queryParameters: {'user_id': userId},
    );

    final Map<String, dynamic>? due = response.data['data'];
    if (due == null) return; // ما فيه شي يستاهل تذكير الحين

    final int requestId = int.tryParse(due['id'].toString()) ?? 0;
    final String contractorName =
        due['contracting_listing']?['name']?.toString() ?? 'المقاول';

    if (!context.mounted || requestId == 0) return;
    await _confirmCompletion(context, requestId, contractorName);
  } catch (e) {
    // فشل صامت - ما نزعج المستخدم بخطأ لأجل تنبيه ثانوي
  }
}

Future<void> _confirmCompletion(
    BuildContext context, int requestId, String contractorName) async {
  final String? result = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('هل اكتملت الخدمة مع $contractorName؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'delete'),
            child: Text('الخدمة لم يتم طلبها',
                style: TextStyle(color: Colors.red.shade400, fontSize: 12.sp)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'no'),
            child: const Text('لا'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
            onPressed: () => Navigator.pop(dialogContext, 'yes'),
            child: const Text('نعم', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  if (result == 'yes' && context.mounted) {
    await _openRatingDialog(context, requestId, contractorName);
  } else if (result == 'delete') {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      await dio.delete('service-requests/$requestId');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الطلب')),
        );
      }
    } catch (e) {
      // فشل صامت - تنبيه ثانوي، ما نزعج المستخدم أكثر
    }
  }
  // لو "لا" - ما نسوي أي شي، الباك اند أصلاً ما بيذكّره إلا بعد 24 ساعة ثانية
}

Future<void> _openRatingDialog(
    BuildContext context, int requestId, String contractorName) async {
  int selectedRating = 0;
  final commentController = TextEditingController();

  final bool? submitted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            title: Column(
              children: [
                const Text('قيّم تجربتك مع',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                Text(contractorName, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        final starIndex = i + 1;
                        return InkWell(
                          borderRadius: BorderRadius.circular(20.r),
                          onTap: () =>
                              setDialogState(() => selectedRating = starIndex),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Icon(
                              starIndex <= selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 26.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  verticalSpace(8),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                    hintText: 'اكتب تعليقك (اختياري)...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
                onPressed:
                    selectedRating == 0 ? null : () => Navigator.pop(dialogContext, true),
                child: const Text('إرسال التقييم', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );

  if (submitted == true) {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      await dio.post('service-requests/$requestId/rate', data: {
        'rating': selectedRating,
        'comment': commentController.text.isEmpty ? null : commentController.text,
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('شكراً لتقييمك!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر إرسال التقييم، حاول لاحقًا من "طلباتي"')),
        );
      }
    }
  }
}
