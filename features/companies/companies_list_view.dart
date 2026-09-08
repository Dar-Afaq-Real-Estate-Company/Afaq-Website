import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../real_estate/publisher_profile_view.dart';

import '../../core/widgets/app_loading_indicator.dart';
class RealEstateCompanyItem {
  final int id;
  final String name;
  final String? logoUrl;
  final String? motto;
  final String field;
  final String? description;
  final String phone;
  final int adsCount;

  const RealEstateCompanyItem({
    required this.id,
    required this.name,
    this.logoUrl,
    this.motto,
    this.field = '',
    this.description,
    required this.phone,
    this.adsCount = 0,
  });

  factory RealEstateCompanyItem.fromJson(Map<String, dynamic> json) {
    return RealEstateCompanyItem(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logo_url'],
      motto: json['motto'],
      field: json['field'] ?? '',
      description: json['description'],
      phone: json['phone'] ?? '',
      adsCount: int.tryParse(json['ads_count'].toString()) ?? 0,
    );
  }
}

/// صفحة "شركات عقارية" - تظهر تلقائيًا كل حساب مسجّل بنوع "مكتب عقاري"،
/// شبكة دوائر (شعار فقط + اسم الشركة تحته)، تضغط على أي وحدة تفتح
/// نفس صفحة بروفايل الناشر (عدد الإعلانات، المشاهدات، وإعلاناته).
class CompaniesListView extends StatefulWidget {
  const CompaniesListView({super.key});

  @override
  State<CompaniesListView> createState() => _CompaniesListViewState();
}

class _CompaniesListViewState extends State<CompaniesListView> {
  bool _isLoading = true;
  String? _error;
  List<RealEstateCompanyItem> _companies = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      final response = await dio.get('real-estate-companies');
      final List<dynamic> data = response.data['data'] ?? [];

      if (!mounted) return;
      setState(() {
        _companies = data.map((e) => RealEstateCompanyItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل الشركات، تأكد من اتصالك بالإنترنت';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('شركات عقارية'),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCompanies,
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
                    onPressed: _fetchCompanies, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ],
      );
    }
    if (_companies.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text('ما فيه شركات منشورة بعد',
                style: TextStyle(color: ColorManager.grey)),
          ),
        ],
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _companies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _CompanyCircle(company: _companies[index]),
    );
  }
}

class _CompanyCircle extends StatelessWidget {
  final RealEstateCompanyItem company;

  const _CompanyCircle({required this.company});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PublisherProfileView(
              userId: company.id,
              name: company.name,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: ColorManager.lighterGray),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
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
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.apartment,
                        color: ColorManager.primary,
                        size: 34.sp,
                      ),
                    )
                  : Icon(Icons.apartment, color: ColorManager.primary, size: 28.sp),
            ),
          ),
          verticalSpace(8),
          Text(
            company.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
