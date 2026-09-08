import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../helper/spacing.dart';
import '../resources/color_manager.dart';
import '../services/favorites_service.dart';
import '../../features/contracting/contractors_list_view.dart';
import '../../features/contracting/contractor_details_view.dart';
import '../../features/companies/companies_list_view.dart';
import '../../features/companies/company_details_view.dart';
import '../../features/engineering_offices/engineering_offices_list_view.dart';
import '../../features/engineering_offices/engineering_office_details_view.dart';
import '../../features/jobs/job_vacancies_browse_view.dart';
import '../../features/jobs/job_vacancy_details_view.dart';
import '../resources/assets_manager.dart';

import 'app_loading_indicator.dart';
import '../resources/strings_manager.dart';
/// صفحة "المفضلة" - تجمع كل شي أضافه المستخدم للمفضلة بالتطبيق (عقارات،
/// مقاولين، شركات عقارية، مكاتب هندسية، وظائف) بتصميم واحد موحّد.
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await FavoritesService.fetchAll();
      if (!mounted) return;
      setState(() {
        _favorites = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل المفضلة، تأكد من اتصالك بالإنترنت';
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Map<String, dynamic> favorite) async {
    final type = FavoriteType.values.firstWhere(
      (t) => t.apiValue == favorite['type'],
      orElse: () => FavoriteType.advertisement,
    );
    final int id = int.tryParse(favorite['id'].toString()) ?? 0;

    setState(() => _favorites.remove(favorite));
    final success = await FavoritesService.removeFavorite(type, id);
    if (!success) {
      _fetchFavorites(); // تراجع لو فشل الحذف فعليًا
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'advertisement':
        return 'عقار';
      case 'contracting':
        return 'مقاول';
      case 'company':
        return 'شركة عقارية';
      case 'engineering':
        return 'مكتب هندسي';
      case 'job':
        return 'وظيفة';
      default:
        return '';
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'advertisement':
        return Colors.orange;
      case 'contracting':
        return Colors.blue;
      case 'company':
        return ColorManager.primary;
      case 'engineering':
        return Colors.purple;
      case 'job':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'advertisement':
        return Icons.home_work_outlined;
      case 'contracting':
        return Icons.handyman_outlined;
      case 'company':
        return Icons.apartment;
      case 'engineering':
        return Icons.architecture_outlined;
      case 'job':
        return Icons.work_outline;
      default:
        return Icons.star_border;
    }
  }

  void _openDetails(Map<String, dynamic> favorite) {
    final String type = favorite['type']?.toString() ?? '';
    final Map<String, dynamic> raw = Map<String, dynamic>.from(favorite['raw'] ?? {});

    switch (type) {
      case 'contracting':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContractorDetailsView(
              contractor: ContractorItem.fromJson(raw),
              categoryName: raw['category']?.toString() ?? '',
            ),
          ),
        );
        break;

      case 'company':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CompanyDetailsView(
              company: RealEstateCompanyItem.fromJson(raw),
            ),
          ),
        );
        break;

      case 'engineering':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EngineeringOfficeDetailsView(
              office: EngineeringOfficeItem.fromJson(raw),
            ),
          ),
        );
        break;

      case 'job':
        if (raw['listing_type'] == 'vacancy') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobVacancyDetailsView(
                vacancy: VacancyListItem(
                  id: int.tryParse(raw['id'].toString()) ?? 0,
                  title: raw['title']?.toString() ?? '',
                  profession: raw['profession']?.toString() ?? '',
                  employmentType: raw['employment_type']?.toString() ?? '',
                  region: raw['region']?.toString() ?? '',
                  salary: raw['salary']?.toString(),
                  description: raw['description']?.toString() ?? '',
                  phone: raw['phone']?.toString() ?? '',
                  email: raw['email']?.toString() ?? '',
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('هذا ملف باحث عن عمل، مو وظيفة شاغرة')),
          );
        }
        break;

      case 'advertisement':
        // TODO: اربطها بصفحة تفاصيل الإعلان الحالية عندكم (adDetailsRoute)
        // لما توصلني بيانات الموديل المستخدم هناك
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('صفحة تفاصيل الإعلان لسا ما اترّبطت هنا')),
        );
        break;
    }
  }

  Widget _floatingIconButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(7.w),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.favorites.tr()),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchFavorites,
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
                TextButton(onPressed: _fetchFavorites, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ],
      );
    }
    if (_favorites.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 120.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.favorite_border, size: 48.sp, color: ColorManager.grey),
                verticalSpace(10),
                Text('ما أضفت أي شي للمفضلة بعد',
                    style: TextStyle(color: ColorManager.grey)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: _favorites.length,
      separatorBuilder: (_, __) => verticalSpace(10),
      itemBuilder: (context, index) {
        final favorite = _favorites[index];
        final String type = favorite['type']?.toString() ?? '';
        final String? imageUrl = favorite['image_url']?.toString();

        return Container(
          margin: EdgeInsets.only(bottom: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.lighterGray),
            borderRadius: BorderRadius.circular(16.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === صورة/شعار كبيرة فوق + قلب ومشاركة عائمين
              GestureDetector(
                onTap: () => _openDetails(favorite),
                child: Stack(
                  children: [
                    Container(
                      height: 140.h,
                      width: double.infinity,
                      color: _typeColor(type).withOpacity(0.08),
                      child: (imageUrl != null && imageUrl.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorWidget: (_, __, ___) => type == 'advertisement'
                                  ? Image.asset(defaultPropertyImage, fit: BoxFit.cover, width: double.infinity)
                                  : Center(
                                      child: Icon(_typeIcon(type),
                                          color: _typeColor(type), size: 44.sp),
                                    ),
                            )
                          : type == 'advertisement'
                              ? Image.asset(defaultPropertyImage, fit: BoxFit.cover, width: double.infinity)
                              : Center(
                                  child: Icon(_typeIcon(type), color: _typeColor(type), size: 44.sp),
                                ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Row(
                        children: [
                          _floatingIconButton(
                            child: const Icon(Icons.favorite, color: Colors.red, size: 18),
                            onTap: () => _removeFavorite(favorite),
                          ),
                          horizontalSpace(8),
                          _floatingIconButton(
                            child: Icon(Icons.share, color: Colors.grey[800], size: 18),
                            onTap: () => Share.share(
                              '${favorite['title'] ?? ''} - آفاق العقارية',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          _typeLabel(type),
                          style: TextStyle(fontSize: 11.sp, color: Colors.white),
                        ),
                      ),
                    ),
                    if (favorite['is_featured'] == true)
                      Positioned(
                        bottom: 10.h,
                        right: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text('VIP', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),

              // === النصوص تحت الصورة
              Padding(
                padding: EdgeInsets.all(12.w),
                child: GestureDetector(
                  onTap: () => _openDetails(favorite),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite['title']?.toString() ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      if (favorite['subtitle'] != null) ...[
                        verticalSpace(4),
                        Text(
                          favorite['subtitle'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5.sp, color: ColorManager.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
