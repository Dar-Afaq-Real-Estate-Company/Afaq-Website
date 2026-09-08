import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';

import '../../core/widgets/app_loading_indicator.dart';
class MyServiceRequest {
  final int id;
  final String contractorName;
  final String category;
  final String status; // pending | completed

  const MyServiceRequest({
    required this.id,
    required this.contractorName,
    required this.category,
    required this.status,
  });

  factory MyServiceRequest.fromJson(Map<String, dynamic> json) {
    final listing = json['contracting_listing'] ?? {};
    return MyServiceRequest(
      id: int.tryParse(json['id'].toString()) ?? 0,
      contractorName: listing['name'] ?? '',
      category: listing['category'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}

/// صفحة "طلباتي" - كل طلبات الخدمة اللي سويتها، وتقدر تقيّم اللي خلص
/// منها (نجوم + تعليق) - التقييم يدخل بمتوسط تقييم المقاول تلقائيًا.
class MyServiceRequestsView extends StatefulWidget {
  const MyServiceRequestsView({super.key});

  @override
  State<MyServiceRequestsView> createState() => _MyServiceRequestsViewState();
}

class _MyServiceRequestsViewState extends State<MyServiceRequestsView> {
  bool _isLoading = true;
  String? _error;
  List<MyServiceRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      final response = await dio.get(
        'service-requests',
        queryParameters: {'user_id': userId},
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final list = data.map((e) => MyServiceRequest.fromJson(e)).toList();

      if (!mounted) return;
      setState(() {
        _requests = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل طلباتك، تأكد من اتصالك بالإنترنت';
        _isLoading = false;
      });
    }
  }

  // === خطوة تأكيد قبل التقييم: "هل اكتملت الخدمة؟" - لو "لا" نتراجع
  // بدون أي تغيير، لو "نعم" نفتح نافذة التقييم
  Future<void> _confirmCompletion(MyServiceRequest request) async {
    // === النتيجة: 'yes' (اكتملت), 'no' (لسا)، 'delete' (لم تُطلب أصلاً)
    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('هل اكتملت الخدمة مع ${request.contractorName}؟'),
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

    if (result == 'yes') {
      await _openRatingDialog(request);
    } else if (result == 'delete') {
      await _deleteFakeRequest(request);
    }
    // لو "لا" ما نسوي أي شي - الطلب يضل معلّق زي ما هو، يقدر يرجع يجرب لاحقًا
  }

  // === حذف طلب لم يُطلب فعليًا (يمنع التلاعب بعدد طلبات المقاول)
  Future<void> _deleteFakeRequest(MyServiceRequest request) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      await dio.delete('service-requests/${request.id}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف الطلب')),
      );
      _fetchRequests();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر حذف الطلب، حاول مرة أخرى')),
      );
    }
  }

  Future<void> _openRatingDialog(MyServiceRequest request) async {
    int selectedRating = 0;
    final commentController = TextEditingController();

    final bool? submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Column(
                children: [
                  const Text('قيّم تجربتك مع',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                  Text(request.contractorName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            onTap: () => setDialogState(
                                () => selectedRating = starIndex),
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
                  onPressed: selectedRating == 0
                      ? null
                      : () => Navigator.pop(dialogContext, true),
                  child: const Text('إرسال التقييم',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted == true) {
      await _submitRating(request.id, selectedRating, commentController.text);
    }
  }

  Future<void> _submitRating(int requestId, int rating, String comment) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      await dio.post('service-requests/$requestId/rate', data: {
        'rating': rating,
        'comment': comment.isEmpty ? null : comment,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('شكراً لتقييمك!')),
      );
      _fetchRequests();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر إرسال التقييم، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRequests,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: AppLoadingIndicator());
    }
    if (_error != null) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Column(
              children: [
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorManager.grey)),
                verticalSpace(10),
                TextButton(
                    onPressed: _fetchRequests, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ],
      );
    }
    if (_requests.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text('ما عندك طلبات خدمة بعد',
                style: TextStyle(color: ColorManager.grey)),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: _requests.length,
      separatorBuilder: (_, __) => verticalSpace(10),
      itemBuilder: (context, index) {
        final r = _requests[index];
        final bool isPending = r.status == 'pending';
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.lighterGray),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.contractorName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    verticalSpace(4),
                    Text('قسم: ${r.category}',
                        style: TextStyle(fontSize: 11.5.sp, color: ColorManager.grey)),
                    verticalSpace(6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isPending
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        isPending ? 'قيد التنفيذ' : 'مكتمل',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: isPending
                              ? Colors.orange.shade800
                              : Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isPending)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                  onPressed: () => _confirmCompletion(r),
                  child: const Text('تحديد كمكتمل',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
            ],
          ),
        );
      },
    );
  }
}
