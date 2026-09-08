import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/constants.dart';
import '../../../../core/helper/shared_pref.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../contracting/add_contracting_view.dart';

final Dio _contractingDio = Dio(BaseOptions(
  baseUrl: 'https://api.afaq.group/api/',
  connectTimeout: const Duration(seconds: 20),
  receiveTimeout: const Duration(seconds: 20),
));

/// يجيب إعلانات مقاولة المستخدم (تُدمج مع إعلانات العقار والوظائف
/// بصفحة إعلاناتي)
Future<List<Map<String, dynamic>>> fetchMyContractingListings() async {
  final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
  final response = await _contractingDio.get('contracting-listings/my',
      queryParameters: {'user_id': userId});
  final List<dynamic> data = response.data['data'] ?? [];
  return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

/// بطاقة إعلان مقاولة داخل "إعلاناتي" - حالة النشر/الرفض + حذف
class ContractingAdCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Future<void> Function() onChanged;

  const ContractingAdCard({super.key, required this.item, required this.onChanged});

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإعلان'),
        content: const Text('متأكد إنك تبي تحذف هذا الإعلان؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _contractingDio.delete('contracting-listings/${item['id']}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الإعلان')));
      }
      await onChanged();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر حذف الإعلان')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int status = int.tryParse((item['status'] ?? 0).toString()) ?? 0;
    final String? rejectionReason = item['rejection_reason']?.toString();

    late final String statusLabel;
    late final Color statusColor;
    if (status == 2) {
      statusLabel = 'مرفوض';
      statusColor = const Color(0xFFD92D20);
    } else if (status == 1) {
      statusLabel = 'منشور';
      statusColor = const Color(0xFF12B76A);
    } else {
      statusLabel = 'بانتظار المراجعة';
      statusColor = const Color(0xFFF79009);
    }

    return GestureDetector(
      onTap: (status == 2 && rejectionReason != null && rejectionReason.isNotEmpty)
          ? () => showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('سبب رفض الإعلان'),
                  content: Text(rejectionReason),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('حسناً')),
                  ],
                ),
              )
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: status == 2 ? const Color(0xFFD92D20).withOpacity(0.4) : const Color(0xFFEDEFF3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(Icons.handyman_outlined, color: ColorManager.primary, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item['name'] ?? '').toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        (item['category'] ?? '').toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20.r)),
                  child: Text(statusLabel, style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w600, color: statusColor)),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, color: const Color(0xFFF2F4F7)),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddContractingView(initialData: item)),
                      );
                      onChanged();
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_outlined, size: 16.sp, color: ColorManager.primary),
                          SizedBox(width: 6.w),
                          Text('تعديل', style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: ColorManager.primary)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _delete(context),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(color: const Color(0xFFF04438).withOpacity(0.08), borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, size: 16.sp, color: const Color(0xFFF04438)),
                          SizedBox(width: 6.w),
                          Text('حذف', style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: const Color(0xFFF04438))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
