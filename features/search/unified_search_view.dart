import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/strings_manager.dart';
import '../dashboard/data/response/response.dart';
import '../real_estate/property_details_view.dart';
import '../contracting/contractors_list_view.dart';
import '../contracting/contractor_details_view.dart';
import '../jobs/job_vacancies_browse_view.dart';
import '../jobs/job_vacancy_details_view.dart';
import '../companies/companies_list_view.dart';
import '../companies/company_details_view.dart';
import '../engineering_offices/engineering_offices_list_view.dart';
import '../engineering_offices/engineering_office_details_view.dart';
import '../hotels_apartments/data/models/response/response.dart';
import '../hotels_apartments/ui/view/hotel_apartment_detail_view.dart';

/// بحث شامل على كل أقسام التطبيق (عقار، مقاولين، وظائف، شركات عقارية،
/// مكاتب هندسية، فنادق وشقق) - يبحث بالاسم/العنوان بغض النظر عن القسم،
/// مع إمكانية تحديد قسم واحد فقط لتضييق النتائج.
class UnifiedSearchView extends StatefulWidget {
  const UnifiedSearchView({super.key});

  @override
  State<UnifiedSearchView> createState() => _UnifiedSearchViewState();
}

enum _Category { all, property, contracting, jobs, companies, engineering, hotels }

class _UnifiedSearchViewState extends State<UnifiedSearchView> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
  final TextEditingController _queryController = TextEditingController();
  _Category _category = _Category.all;
  bool _loading = false;
  List<_SearchResult> _results = [];
  bool _searched = false;
  Timer? _debounce;

  Map<_Category, String> _labels(String lang) => {
    _Category.all: AppStrings.getString('txn_all', lang),
    _Category.property: AppStrings.getString('cat_property_search', lang),
    _Category.contracting: AppStrings.getString('cat_contractors', lang),
    _Category.jobs: AppStrings.getString('jobs', lang),
    _Category.companies: AppStrings.getString('cat_real_estate_companies', lang),
    _Category.engineering: AppStrings.getString('cat_engineering_offices', lang),
    _Category.hotels: AppStrings.getString('cat_hotels_apartments', lang),
  };

  static const Map<_Category, IconData> _icons = {
    _Category.property: Icons.home_work_outlined,
    _Category.contracting: Icons.handyman_outlined,
    _Category.jobs: Icons.work_outline,
    _Category.companies: Icons.apartment_outlined,
    _Category.engineering: Icons.architecture_outlined,
    _Category.hotels: Icons.hotel_outlined,
  };

  @override
  void dispose() {
    _debounce?.cancel();
    _queryController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), _search);
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _searched = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _searched = true;
    });

    final List<_Category> toFetch = _category == _Category.all
        ? _Category.values.where((c) => c != _Category.all).toList()
        : [_category];

    final List<_SearchResult> merged = [];
    await Future.wait(toFetch.map((cat) async {
      try {
        final items = await _fetchCategory(cat, query);
        merged.addAll(items);
      } catch (_) {}
    }));

    if (!mounted) return;
    setState(() {
      _results = merged;
      _loading = false;
    });
  }

  Future<List<_SearchResult>> _fetchCategory(_Category cat, String query) async {
    final String path;
    switch (cat) {
      case _Category.property:
        path = 'advertisements';
        break;
      case _Category.contracting:
        path = 'contracting-listings';
        break;
      case _Category.jobs:
        path = 'job-listings';
        break;
      case _Category.companies:
        path = 'real-estate-companies';
        break;
      case _Category.engineering:
        path = 'engineering-offices';
        break;
      case _Category.hotels:
        path = 'hotels-apartments';
        break;
      case _Category.all:
        return [];
    }

    final response = await _dio.get(path);
    final Map<String, dynamic> body = Map<String, dynamic>.from(response.data);
    final List<dynamic> raw = (body['data'] ?? body['advertisements'] ?? []) as List<dynamic>;

    final String q = query.toLowerCase();
    return raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .where((item) {
          final name = (item['name'] ?? item['title'] ?? item['full_name'] ?? '').toString().toLowerCase();
          final profession = (item['profession'] ?? item['type'] ?? item['category'] ?? '').toString().toLowerCase();
          return name.contains(q) || profession.contains(q);
        })
        .map((item) => _SearchResult.fromJson(cat, item))
        .toList();
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.getString('unified_search_title', context.locale.languageCode)),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _queryController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: _onQueryChanged,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: AppStrings.getString('unified_search_hint', context.locale.languageCode),
                    prefixIcon: Icon(Icons.search, color: ColorManager.primary),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _queryController,
                      builder: (context, value, _) => value.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                _queryController.clear();
                                setState(() {
                                  _results = [];
                                  _searched = false;
                                });
                              },
                            ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF2F4F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
                verticalSpace(12),
                SizedBox(
                  height: 36.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _labels(context.locale.languageCode).entries
                        .map((entry) => Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: ChoiceChip(
                                label: Text(entry.value, style: TextStyle(fontSize: 12.5.sp)),
                                selected: _category == entry.key,
                                selectedColor: ColorManager.primary,
                                backgroundColor: const Color(0xFFF2F4F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  side: BorderSide.none,
                                ),
                                labelStyle: TextStyle(
                                  color: _category == entry.key ? Colors.white : const Color(0xFF344054),
                                  fontWeight: _category == entry.key ? FontWeight.w700 : FontWeight.w400,
                                ),
                                onSelected: (_) {
                                  setState(() => _category = entry.key);
                                  if (_queryController.text.trim().isNotEmpty) _search();
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (!_searched) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.travel_explore, size: 52.sp, color: const Color(0xFFD0D5DD)),
            verticalSpace(12),
            Text(AppStrings.getString('unified_search_empty_hint', context.locale.languageCode),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: ColorManager.grey)),
          ],
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 52.sp, color: const Color(0xFFD0D5DD)),
            verticalSpace(12),
            Text(AppStrings.getString('unified_search_no_results', context.locale.languageCode), style: TextStyle(color: ColorManager.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _results.length,
      itemBuilder: (context, index) => _ResultCard(result: _results[index], onCall: _call),
    );
  }
}

class _SearchResult {
  final _Category category;
  final String name;
  final String subtitle;
  final String? phone;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic> raw;

  _SearchResult({
    required this.category,
    required this.name,
    required this.subtitle,
    required this.raw,
    this.phone,
    this.description,
    this.imageUrl,
  });

  factory _SearchResult.fromJson(_Category cat, Map<String, dynamic> j) {
    switch (cat) {
      case _Category.property:
        return _SearchResult(
          category: cat,
          raw: j,
          name: (j['title'] as String?)?.isNotEmpty == true ? j['title'] : (j['type'] ?? ''),
          subtitle: '${j['region'] ?? ''} • ${j['transaction_type'] ?? ''}',
          phone: j['phone'] as String?,
          description: j['description'] as String?,
          imageUrl: j['images'] as String?,
        );
      case _Category.contracting:
        return _SearchResult(
          category: cat,
          raw: j,
          name: j['name'] ?? '',
          subtitle: j['category'] ?? 'مقاول',
          phone: j['phone'] as String?,
          description: j['bio'] as String?,
          imageUrl: j['logo_url'] as String?,
        );
      case _Category.jobs:
        return _SearchResult(
          category: cat,
          raw: j,
          name: (j['title'] as String?)?.isNotEmpty == true ? j['title'] : (j['full_name'] ?? j['profession'] ?? ''),
          subtitle: j['profession'] ?? '',
          phone: j['phone'] as String?,
          description: j['description'] as String?,
        );
      case _Category.companies:
        return _SearchResult(
          category: cat,
          raw: j,
          name: j['name'] ?? '',
          subtitle: j['field'] ?? 'شركة عقارية',
          phone: j['phone'] as String?,
          description: j['description'] as String?,
          imageUrl: j['logo_url'] as String?,
        );
      case _Category.engineering:
        return _SearchResult(
          category: cat,
          raw: j,
          name: j['name'] ?? '',
          subtitle: j['specialty'] ?? 'مكتب هندسي',
          phone: j['phone'] as String?,
          description: j['description'] as String?,
          imageUrl: j['logo_url'] as String?,
        );
      case _Category.hotels:
        return _SearchResult(
          category: cat,
          raw: j,
          name: j['name'] ?? '',
          subtitle: '${j['region'] ?? ''} • ${j['type'] ?? ''}',
          phone: j['phone'] as String?,
          description: j['description'] as String?,
          imageUrl: (j['images'] is List && (j['images'] as List).isNotEmpty) ? (j['images'] as List).first : null,
        );
      case _Category.all:
        return _SearchResult(category: cat, name: '', subtitle: '', raw: j);
    }
  }

  Map<_Category, String> _categoryLabel(String lang) => {
    _Category.property: AppStrings.getString('cat_property_single', lang),
    _Category.contracting: AppStrings.getString('cat_contractor_single', lang),
    _Category.jobs: AppStrings.getString('cat_job_single', lang),
    _Category.companies: AppStrings.getString('cat_real_estate_company_single', lang),
    _Category.engineering: AppStrings.getString('cat_engineering_office_single', lang),
    _Category.hotels: AppStrings.getString('cat_hotel_apartment_single', lang),
  };

  static const Map<_Category, IconData> _categoryIcons = {
    _Category.property: Icons.home_work_outlined,
    _Category.contracting: Icons.handyman_outlined,
    _Category.jobs: Icons.work_outline,
    _Category.companies: Icons.apartment_outlined,
    _Category.engineering: Icons.architecture_outlined,
    _Category.hotels: Icons.hotel_outlined,
  };

  String categoryLabelFor(String lang) => _categoryLabel(lang)[category] ?? '';
}

class _ResultCard extends StatelessWidget {
  final _SearchResult result;
  final void Function(String) onCall;

  const _ResultCard({required this.result, required this.onCall});

  void _openDetails(BuildContext context) {
    final Widget? page = switch (result.category) {
      _Category.property => PropertyDetailsView(ad: AdsDataResponse.fromJson(result.raw)),
      _Category.contracting => ContractorDetailsView(
          contractor: ContractorItem.fromJson(result.raw),
          categoryName: result.subtitle,
        ),
      _Category.jobs => JobVacancyDetailsView(
          vacancy: VacancyListItem(
            id: int.tryParse(result.raw['id'].toString()) ?? 0,
            title: result.name,
            profession: (result.raw['profession'] ?? '').toString(),
            employmentType: (result.raw['employment_type'] ?? '').toString(),
            region: (result.raw['region'] ?? '').toString(),
            salary: result.raw['salary']?.toString(),
            description: result.description ?? '',
            phone: result.phone ?? '',
            email: (result.raw['email'] ?? '').toString(),
          ),
        ),
      _Category.companies => CompanyDetailsView(company: RealEstateCompanyItem.fromJson(result.raw)),
      _Category.engineering => EngineeringOfficeDetailsView(office: EngineeringOfficeItem.fromJson(result.raw)),
      _Category.hotels => HotelApartmentDetailView(item: HotelApartmentData.fromJson(result.raw)),
      _Category.all => null,
    };
    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.lighterGray),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: (result.imageUrl ?? '').isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: result.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Icon(
                        _SearchResult._categoryIcons[result.category] ?? Icons.search,
                        color: ColorManager.primary),
                  )
                : Icon(_SearchResult._categoryIcons[result.category] ?? Icons.search,
                    color: ColorManager.primary),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(result.name,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(result.categoryLabelFor(context.locale.languageCode),
                          style: TextStyle(fontSize: 10.sp, color: ColorManager.primary)),
                    ),
                  ],
                ),
                verticalSpace(4),
                Text(result.subtitle,
                    style: TextStyle(fontSize: 12.sp, color: ColorManager.grey),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                if (result.phone != null) ...[
                  verticalSpace(8),
                  GestureDetector(
                    onTap: () => onCall(result.phone!),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, size: 14.sp, color: ColorManager.primary),
                        horizontalSpace(4),
                        Text(AppStrings.call.tr(), style: TextStyle(fontSize: 12.sp, color: ColorManager.primary)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
