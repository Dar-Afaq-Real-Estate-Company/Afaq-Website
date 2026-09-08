import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/constants.dart';
import '../../../../core/helper/shared_pref.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';

final Dio _jobsDio = Dio(BaseOptions(
  baseUrl: 'https://api.afaq.group/api/',
  connectTimeout: const Duration(seconds: 20),
  receiveTimeout: const Duration(seconds: 20),
));

/// يجيب إعلانات وظائف المستخدم (تُدمج مع إعلانات العقار بصفحة إعلاناتي)
Future<List<Map<String, dynamic>>> fetchMyJobListings() async {
  final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
  final response =
      await _jobsDio.get('my-job-listings', queryParameters: {'user_id': userId});
  final List<dynamic> data = response.data['data'] ?? [];
  return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

int _daysLeft(DateTime d) {
  final today = DateTime.now();
  final diff = d.difference(DateTime(today.year, today.month, today.day)).inDays;
  return diff < 0 ? 0 : diff;
}

String _formatDate(DateTime d) =>
    '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

/// بطاقة إعلان وظيفة داخل "إعلاناتي" - حالة النشر + تعديل وحذف
class JobAdCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Future<void> Function() onChanged;

  const JobAdCard({super.key, required this.item, required this.onChanged});

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإعلان'),
        content: const Text('متأكد إنك تبي تحذف هذا الإعلان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _jobsDio.delete('job-listings/${item['id']}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الإعلان')),
        );
      }
      await onChanged();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر حذف الإعلان')),
        );
      }
    }
  }

  Future<void> _openEditSheet(BuildContext context) async {
    final titleController = TextEditingController(
        text: (item['title'] ?? item['full_name'] ?? '').toString());
    final salaryController =
        TextEditingController(text: (item['salary'] ?? '').toString());
    final phoneController = TextEditingController(text: (item['phone'] ?? '').toString());
    final descriptionController =
        TextEditingController(text: (item['description'] ?? '').toString());
    DateTime? expiry = DateTime.tryParse((item['expires_at'] ?? '').toString());

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        bool saving = false;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> submit() async {
              setSheetState(() => saving = true);
              try {
                await _jobsDio.post('job-listings/${item['id']}/update', data: {
                  'title': titleController.text.trim(),
                  'salary': salaryController.text.trim(),
                  'phone': phoneController.text.trim(),
                  'description': descriptionController.text.trim(),
                  'duration_days': expiry == null ? null : _daysLeft(expiry!),
                });
                if (context.mounted) Navigator.pop(context, true);
              } catch (_) {
                setSheetState(() => saving = false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر حفظ التعديل')),
                  );
                }
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 18.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 45.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    verticalSpace(16),
                    Text('تعديل الإعلان',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    verticalSpace(16),
                    _sheetField('المسمى الوظيفي', titleController),
                    _sheetField('الراتب', salaryController,
                        keyboard: TextInputType.number),
                    _sheetField('رقم التواصل', phoneController,
                        keyboard: TextInputType.phone),
                    _sheetField('الوصف', descriptionController, maxLines: 4),
                    verticalSpace(6),
                    Text('تاريخ انتهاء النشر',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    verticalSpace(8),
                    GestureDetector(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: expiry != null && expiry!.isAfter(now)
                              ? expiry!
                              : now.add(const Duration(days: 30)),
                          firstDate: now.add(const Duration(days: 1)),
                          lastDate: now.add(const Duration(days: 365)),
                          helpText: 'آخر يوم لنشر الوظيفة',
                          cancelText: 'إلغاء',
                          confirmText: 'تحديد',
                        );
                        if (picked != null) setSheetState(() => expiry = picked);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE4E7EC)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_outlined,
                                size: 18.sp, color: ColorManager.primary),
                            horizontalSpace(10),
                            Expanded(
                              child: Text(
                                expiry != null
                                    ? 'ينتهي بتاريخ ${_formatDate(expiry!)} — باقي ${_daysLeft(expiry!)} يوم'
                                    : 'اختر آخر يوم لنشر الوظيفة',
                                style: TextStyle(fontSize: 12.5.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(20),
                    GestureDetector(
                      onTap: saving ? null : submit,
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: saving ? const Color(0xFF98A2B3) : ColorManager.primary,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: saving
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.2),
                              )
                            : Text('حفظ التعديل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الإعلان')),
        );
      }
      await onChanged();
    }
  }

  Widget _sheetField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          verticalSpace(6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int status = int.tryParse((item['status'] ?? 0).toString()) ?? 0;
    final expiresAt = DateTime.tryParse((item['expires_at'] ?? '').toString());
    final bool expired = expiresAt != null && expiresAt.isBefore(DateTime.now());
    final bool isSeeker = (item['listing_type'] ?? '') == 'seeker';

    late final String statusLabel;
    late final Color statusColor;
    if (expired) {
      statusLabel = 'انتهت مدة النشر';
      statusColor = const Color(0xFF98A2B3);
    } else if (status == 2) {
      statusLabel = 'مرفوض';
      statusColor = const Color(0xFFD92D20);
    } else if (status == 1) {
      statusLabel = 'منشور';
      statusColor = const Color(0xFF12B76A);
    } else {
      statusLabel = 'بانتظار المراجعة';
      statusColor = const Color(0xFFF79009);
    }
    final String? rejectionReason = item['rejection_reason']?.toString();

    return GestureDetector(
      onTap: (status == 2 && rejectionReason != null && rejectionReason.isNotEmpty)
          ? () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('سبب رفض الإعلان'),
                  content: Text(rejectionReason),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً')),
                  ],
                ),
              )
          : null,
      child: Container(
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
                child: Icon(
                  isSeeker ? Icons.person_search : Icons.work_outline,
                  color: ColorManager.primary,
                  size: 20.sp,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (item['title'] ?? item['full_name'] ?? '').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                    verticalSpace(3),
                    Text(
                      '${item['profession'] ?? ''} • ${item['region'] ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF667085)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (expiresAt != null) ...[
            verticalSpace(10),
            Row(
              children: [
                Icon(Icons.event_outlined, size: 13.sp, color: const Color(0xFF98A2B3)),
                SizedBox(width: 5.w),
                Text(
                  expired
                      ? 'انتهت بتاريخ ${_formatDate(expiresAt)}'
                      : 'ينتهي بتاريخ ${_formatDate(expiresAt)} — باقي ${_daysLeft(expiresAt)} يوم',
                  style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF98A2B3)),
                ),
              ],
            ),
          ],
          verticalSpace(12),
          Divider(height: 1, color: const Color(0xFFF2F4F7)),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.edit_outlined,
                  label: 'تعديل',
                  color: ColorManager.primary,
                  onTap: () => _openEditSheet(context),
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: _actionButton(
                  icon: Icons.delete_outline,
                  label: 'حذف',
                  color: const Color(0xFFF04438),
                  onTap: () => _delete(context),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
