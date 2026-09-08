import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/routing/routes.dart';
import '../real_estate/publisher_profile_view.dart';

import '../../core/widgets/app_loading_indicator.dart';
class EngineeringOfficeItem {
  final int id;
  final String name;
  final String? logoUrl;
  final String? motto;
  final String specialty;
  final String? description;
  final String phone;
  final int adsCount;

  const EngineeringOfficeItem({
    required this.id,
    required this.name,
    this.logoUrl,
    this.motto,
    this.specialty = '',
    this.description,
    required this.phone,
    this.adsCount = 0,
  });

  factory EngineeringOfficeItem.fromJson(Map<String, dynamic> json) {
    return EngineeringOfficeItem(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logo_url'],
      motto: json['motto'],
      specialty: json['specialty'] ?? '',
      description: json['description'],
      phone: json['phone'] ?? '',
      adsCount: int.tryParse(json['ads_count'].toString()) ?? 0,
    );
  }
}

/// صفحة "شركات عقارية" - شبكة دوائر (شعار فقط + اسم الشركة تحته)،
/// تضغط على أي وحدة تفتح صفحة تفاصيلها الكاملة.
class EngineeringOfficesListView extends StatefulWidget {
  const EngineeringOfficesListView({super.key});

  @override
  State<EngineeringOfficesListView> createState() => _EngineeringOfficesListViewState();
}

class _EngineeringOfficesListViewState extends State<EngineeringOfficesListView> {
  bool _isLoading = true;
  String? _error;
  List<EngineeringOfficeItem> _offices = [];

  @override
  void initState() {
    super.initState();
    _fetchOffices();
  }

  Future<void> _fetchOffices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
      final response = await dio.get('engineering-offices');
      final List<dynamic> data = response.data['data'] ?? [];

      if (!mounted) return;
      setState(() {
        _offices = data.map((e) => EngineeringOfficeItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل المكاتب، تأكد من اتصالك بالإنترنت';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('مكاتب هندسية'),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchOffices,
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
                    onPressed: _fetchOffices, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ],
      );
    }
    if (_offices.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text('ما فيه مكاتب منشورة بعد',
                style: TextStyle(color: ColorManager.grey)),
          ),
        ],
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _offices.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _OfficeCircle(office: _offices[index]),
    );
  }
}

class _OfficeCircle extends StatelessWidget {
  final EngineeringOfficeItem office;

  const _OfficeCircle({required this.office});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PublisherProfileView(userId: office.id, name: office.name),
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
              child: office.logoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: office.logoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.architecture_outlined,
                        color: ColorManager.primary,
                        size: 34.sp,
                      ),
                    )
                  : Icon(Icons.architecture_outlined,
                      color: ColorManager.primary, size: 28.sp),
            ),
          ),
          verticalSpace(6),
          Text(
            office.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
