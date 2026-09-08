import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import 'contractor_details_view.dart';

import '../../core/widgets/app_loading_indicator.dart';
class ContractorItem {
  final int id;
  final String name;
  final String? logoUrl;
  final String phone;
  final String bio;
  final String referenceNo;
  final int viewsCount;

  const ContractorItem({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.phone,
    required this.bio,
    this.referenceNo = '0000000',
    this.viewsCount = 0,
  });

  factory ContractorItem.fromJson(Map<String, dynamic> json) {
    return ContractorItem(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logo_url'],
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      referenceNo: (json['reference_no'] == null || json['reference_no'].toString().isEmpty)
          ? '0000000'
          : json['reference_no'].toString(),
      viewsCount: int.tryParse('${json['views_count'] ?? 0}') ?? 0,
    );
  }
}

/// صفحة قائمة المقاولين لقسم معين - مرتبة حسب التقييم (الأعلى فوق)،
/// واللي بدون تقييم بعد يطلعون بالآخر. تجيب البيانات فعليًا من
/// GET /contracting-listings?category=
///
/// TODO: نظام تقييم حقيقي (نجوم تُمنح بعد اكتمال طلب خدمة) لسا يحتاج
/// تصميم وبناء بالباك اند بشكل منفصل - حالياً rating يرجع 0 لكل مقاول
/// جديد لين نبني هذا الجزء.
class ContractorsListView extends StatefulWidget {
  final String categoryName;

  const ContractorsListView({super.key, required this.categoryName});

  @override
  State<ContractorsListView> createState() => _ContractorsListViewState();
}

class _ContractorsListViewState extends State<ContractorsListView> {
  bool _isLoading = true;
  String? _error;
  List<ContractorItem> _contractors = [];

  @override
  void initState() {
    super.initState();
    _fetchContractors();
  }

  Future<void> _fetchContractors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      final response = await dio.get(
        'contracting-listings',
        queryParameters: {'category': widget.categoryName},
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final list = data.map((e) => ContractorItem.fromJson(e)).toList();

      if (!mounted) return;
      setState(() {
        _contractors = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل قائمة المقاولين، تأكد من اتصالك بالإنترنت';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchContractors,
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
                  onPressed: _fetchContractors,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ],
      );
    }
    if (_contractors.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text('ما فيه مقاولين منشورين بهذا القسم بعد',
                style: TextStyle(color: ColorManager.grey)),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: _contractors.length,
      separatorBuilder: (_, __) => verticalSpace(10),
      itemBuilder: (context, index) {
        final c = _contractors[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContractorDetailsView(
                  contractor: c,
                  categoryName: widget.categoryName,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.lighterGray),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.grey[100],
                  backgroundImage:
                      c.logoUrl != null ? NetworkImage(c.logoUrl!) : null,
                  child: c.logoUrl == null
                      ? Icon(Icons.handyman_outlined, color: ColorManager.grey)
                      : null,
                ),
                horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      verticalSpace(4),
                      Text(c.bio.isEmpty ? '' : c.bio,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.sp, color: ColorManager.grey)),
                    ],
                  ),
                ),
                Icon(Icons.phone_outlined, color: ColorManager.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
