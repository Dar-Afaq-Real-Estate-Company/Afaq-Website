import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/widgets/favorite_button.dart';
import '../../core/services/favorites_service.dart';
import '../../core/widgets/price_range_slider.dart';
import '../../core/helper/kuwait_governorates.dart';
import '../../core/widgets/region_picker_sheet.dart';
import '../../core/widgets/app_loading_indicator.dart';
import '../../core/widgets/share_button.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/resources/strings_manager.dart';
import '../dashboard/data/response/response.dart';
import '../../core/routing/routes.dart';
import '../dashboard/ui/view/advertisements/view/add_ads/add_ads_view.dart';
import '../../core/widgets/map_search_view.dart';
import 'property_details_view.dart';

/// صفحة "عقار" - استعراض وبحث احترافي: فلترة سيرفر-سايد حسب نوع
/// المعاملة (بيع/إيجار/بدل)، نوع العقار، عدة مناطق (بحث)، ونطاق السعر،
/// + ترتيب النتائج. بطاقات بصورة كبيرة ومواصفات وقلب/مشاركة.
class PropertyListView extends StatefulWidget {
  // === معطاة من شاشة اختيار التصنيف (سكني/تجاري/استثماري/صناعي) قبلها
  // - لو null (دخول مباشر قديم) يشتغل بكل الأنواع زي ما كان
  final String? initialTransactionType;
  final List<String>? allowedPropertyTypes;
  // === true لو الصفحة مضمّنة بصفحة ثانية عندها AppBar/عنوانها الخاص
  // (مثلاً تبويب "الإعلانات") فما نكرر AppBar
  final bool embedded;
  // === يظهر زر "+" أعلى الصفحة لإضافة عقار (يُستخدم بشاشة "اطلب عقارك")
  final bool showAddButton;

  const PropertyListView({
    super.key,
    this.initialTransactionType,
    this.allowedPropertyTypes,
    this.embedded = false,
    this.showAddButton = false,
  });

  @override
  State<PropertyListView> createState() => _PropertyListViewState();
}

enum _SortOption { newest, priceLowToHigh, priceHighToLow, mostViewed, leastViewed }

class _PropertyListViewState extends State<PropertyListView> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
  final ScrollController _scrollController = ScrollController();
  bool _showBottomBar = false;
  double _lastOffset = 0;

  bool _isLoading = true;
  String? _error;
  List<AdsDataResponse> _results = [];
  List<String> _allRegions = [];

  late String _transactionType; // بيع / إيجار / بدل / مزاد
  String _propertySection = 'الكل'; // سكني / تجاري / استثماري / صناعي
  String _propertyType = 'الكل'; // شقة / بيت / ارض / دور ...
  List<String> _selectedRegions = [];
  double _minPrice = 0;
  double _maxPrice = 500000;
  double _minArea = 0;
  double _maxArea = 1000;
  String _rooms = 'الكل'; // الكل / 1 / 2 / 3 / 4+
  _SortOption _sort = _SortOption.newest;

  static const List<String> _transactionTypes = [
    'الكل',
    'عقارات للبيع',
    'عقارات للإيجار',
    'عقار للبدل',
  ];

  // === نص العرض المترجم لقيمة نوع المعاملة - القيمة الفعلية المستخدمة
  // بالفلترة/الإرسال للسيرفر تبقى عربي دايمًا (بالأعلى)، بس شكلها بالواجهة
  // يتبدل عربي/إنجليزي حسب لغة التطبيق
  // === نفس منطق ترجمة نوع المعاملة - يترجم اسم العرض فقط، القيمة
  // الفعلية المرسلة للسيرفر/الفلترة تبقى عربي دايمًا
  static const Map<String, String> _propertyTypeKeys = {
    'سكني': 'cat_residential',
    'تجاري': 'cat_commercial',
    'استثماري': 'cat_investment',
    'صناعي': 'cat_industrial',
    'شقة': 'ptype_apartment',
    'بيت': 'ptype_house',
    'دور': 'ptype_floor',
    'فيلا': 'ptype_villa',
    'عمارة': 'ptype_building',
    'دوبلكس': 'ptype_duplex',
    'استوديو': 'ptype_studio',
    'أرض': 'ptype_land',
    'بيت حكومي': 'ptype_gov_house',
    'سكن عمال': 'ptype_workers_housing',
    'سرداب': 'ptype_basement',
    'مكتب': 'ptype_office',
    'محل': 'ptype_shop',
    'معرض': 'ptype_showroom',
    'مخزن': 'ptype_store',
    'مستودع': 'ptype_warehouse',
    'أرض تجارية': 'ptype_commercial_land',
    'شقة تجارية': 'ptype_commercial_apartment',
    'دور تجاري': 'ptype_commercial_floor',
    'مجمع': 'ptype_complex',
    'مبنى تجاري': 'ptype_commercial_building',
    'شقق استثمارية': 'ptype_investment_apartments',
    'عمارة استثمارية': 'ptype_investment_building',
    'أرض استثمارية': 'ptype_investment_land',
    'مجمع استثماري': 'ptype_investment_complex',
    'مصنع': 'ptype_factory',
    'أرض صناعية': 'ptype_industrial_land',
    'مستودع صناعي': 'ptype_industrial_warehouse',
    'ورشة': 'ptype_workshop',
  };

  String _ptypeLabel(String value) {
    if (value == 'الكل') {
      return AppStrings.getString('txn_all', context.locale.languageCode);
    }
    final key = _propertyTypeKeys[value];
    if (key == null) return value;
    return AppStrings.getString(key, context.locale.languageCode);
  }

  String _txnLabel(String value) {
    final lang = context.locale.languageCode;
    switch (value) {
      case 'الكل':
        return AppStrings.getString('txn_all', lang);
      case 'عقارات للبيع':
        return AppStrings.getString('txn_sale', lang);
      case 'عقارات للإيجار':
        return AppStrings.getString('txn_rent', lang);
      case 'عقار للبدل':
        return AppStrings.getString('txn_swap', lang);
      default:
        return value;
    }
  }

  static const List<String> _roomsOptions = ['الكل', '1', '2', '3', '4+'];

  // === تصنيفات العقار وأنواع كل تصنيف - تجي من لوحة الإدارة (نفس المصدر
  // المستخدم بشاشة "اطلب عقارك")
  List<Map<String, dynamic>> _propertyCategories = [];

  List<String> get _propertyTypesForSection {
    if (_propertySection == 'الكل') {
      return ['الكل', ..._propertyCategories.expand((c) => (c['types'] as List).cast<String>())];
    }
    final cat = _propertyCategories.firstWhere(
      (c) => c['name'] == _propertySection,
      orElse: () => {'types': []},
    );
    return ['الكل', ...(cat['types'] as List).cast<String>()];
  }

  @override
  void initState() {
    super.initState();
    _transactionType = widget.initialTransactionType ?? 'الكل';
    _fetchRegions();
    _fetchCategories();
    _fetchProperties();
    _scrollController.addListener(_onScroll);
  }

  void _fetchCategories() {
    // === بيانات ثابتة بالتطبيق نفسه (بدون طلب شبكة) - نفس المصدر
    // المستخدم بشاشة "اطلب عقارك" بالضبط (راوت property-categories غير
    // موجود بالباك اند أصلاً)
    setState(() {
      _propertyCategories = [
        {
          'name': 'سكني',
          'types': [
            'شقة', 'بيت', 'دور', 'فيلا', 'عمارة', 'دوبلكس',
            'استوديو', 'أرض', 'بيت حكومي', 'سكن عمال', 'سرداب',
          ],
        },
        {
          'name': 'تجاري',
          'types': [
            'مكتب', 'محل', 'معرض', 'مخزن', 'مستودع', 'أرض تجارية',
            'شقة تجارية', 'دور تجاري', 'مجمع', 'مبنى تجاري', 'سرداب',
          ],
        },
        {
          'name': 'استثماري',
          'types': ['شقق استثمارية', 'عمارة استثمارية', 'أرض استثمارية', 'مجمع استثماري'],
        },
        {
          'name': 'صناعي',
          'types': ['مصنع', 'أرض صناعية', 'مستودع صناعي', 'ورشة'],
        },
      ];
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // === السحب لتحت يخفي شريط الخريطة/الفلترة، السحب لفوق أو القرب من
  // الأعلى يرجّعه - نفس سلوك الصفحة الرئيسية بالضبط
  void _onScroll() {
    final offset = _scrollController.offset;
    final scrollingDown = offset > _lastOffset;
    _lastOffset = offset;

    if (offset < 80) {
      if (_showBottomBar) setState(() => _showBottomBar = false);
      return;
    }
    if (scrollingDown) {
      if (!_showBottomBar) setState(() => _showBottomBar = true);
    } else {
      if (_showBottomBar) setState(() => _showBottomBar = false);
    }
  }

  Future<void> _fetchRegions() async {
    try {
      final response = await _dio.get('adSregions');
      final List<dynamic> data = response.data['regions'] ?? [];
      if (!mounted) return;
      setState(() => _allRegions = data.map((e) => e.toString()).toList());
    } catch (_) {}
  }

  Future<void> _fetchProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> body = {};
      if (_transactionType != 'الكل') body['transaction_type'] = _transactionType;
      if (_propertySection != 'الكل') body['property_section'] = _propertySection;
      if (_propertyType != 'الكل') body['type'] = _propertyType;
      if (_selectedRegions.isNotEmpty) body['region'] = _selectedRegions;
      if (_minPrice > 0 || _maxPrice < 500000) {
        body['price_range'] = '${_minPrice.toInt()}-${_maxPrice.toInt()}';
      }
      if (_minArea > 0 || _maxArea < 1000) {
        body['area_range'] = '${_minArea.toInt()}-${_maxArea.toInt()}';
      }
      if (_rooms != 'الكل') body['rooms_count'] = _rooms;

      final response = await _dio.get('Search', queryParameters: body);
      final List<dynamic> data = response.data['data'] ?? [];

      List<AdsDataResponse> results =
          data.map((e) => AdsDataResponse.fromJson(e)).toList();

      switch (_sort) {
        case _SortOption.priceLowToHigh:
          results.sort((a, b) =>
              (double.tryParse(a.price ?? '0') ?? 0)
                  .compareTo(double.tryParse(b.price ?? '0') ?? 0));
          break;
        case _SortOption.priceHighToLow:
          results.sort((a, b) =>
              (double.tryParse(b.price ?? '0') ?? 0)
                  .compareTo(double.tryParse(a.price ?? '0') ?? 0));
          break;
        case _SortOption.mostViewed:
          results.sort((a, b) => (b.viewsCount ?? 0).compareTo(a.viewsCount ?? 0));
          break;
        case _SortOption.leastViewed:
          results.sort((a, b) => (a.viewsCount ?? 0).compareTo(b.viewsCount ?? 0));
          break;
        case _SortOption.newest:
          break;
      }

      if (!mounted) return;
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل العقارات، تأكد من اتصالك بالإنترنت';
        _isLoading = false;
      });
    }
  }

  int get _activeFilterCount {
    int count = 0;
    if (_transactionType != 'الكل') count++;
    if (_propertySection != 'الكل') count++;
    if (_propertyType != 'الكل') count++;
    if (_selectedRegions.isNotEmpty) count++;
    if (_minPrice > 0 || _maxPrice < 500000) count++;
    if (_minArea > 0 || _maxArea < 1000) count++;
    if (_rooms != 'الكل') count++;
    return count;
  }

  Future<void> _openFilterSheet() async {
    String tempTransaction = _transactionType;
    String tempSection = _propertySection;
    String tempType = _propertyType;
    String tempRooms = _rooms;
    List<String> tempRegions = List.of(_selectedRegions);
    double tempMin = _minPrice;
    double tempMax = _maxPrice;
    double tempMinArea = _minArea;
    double tempMaxArea = _maxArea;

    List<String> typesForSection(String section) {
      if (section == 'الكل') {
        return ['الكل', ..._propertyCategories.expand((c) => (c['types'] as List).cast<String>())];
      }
      final cat = _propertyCategories.firstWhere(
        (c) => c['name'] == section,
        orElse: () => {'types': []},
      );
      return ['الكل', ...(cat['types'] as List).cast<String>()];
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
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
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('فلترة العقارات',
                              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                tempTransaction = 'الكل';
                                tempSection = 'الكل';
                                tempType = 'الكل';
                                tempRooms = 'الكل';
                                tempRegions = [];
                                tempMin = 0;
                                tempMax = 500000;
                                tempMinArea = 0;
                                tempMaxArea = 1000;
                              });
                            },
                            child: Text(AppStrings.getString('clear_all_filters', context.locale.languageCode)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(AppStrings.getString('transaction_type_title', context.locale.languageCode),
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _transactionTypes.map((t) {
                          final selected = t == tempTransaction;
                          return ChoiceChip(
                            label: Text(_txnLabel(t), style: TextStyle(fontSize: 12.sp)),
                            selected: selected,
                            selectedColor: ColorManager.primary,
                            labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                            onSelected: (_) => setSheetState(() => tempTransaction = t),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.h),
                      Text(AppStrings.getString('property_type_title', context.locale.languageCode),
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _propertyCategories.map((c) => c['name'] as String).map((s) {
                          final selected = s == tempSection;
                          return ChoiceChip(
                            label: Text(_ptypeLabel(s), style: TextStyle(fontSize: 12.sp)),
                            selected: selected,
                            selectedColor: ColorManager.primary,
                            labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                            onSelected: (_) => setSheetState(() {
                              tempSection = selected ? 'الكل' : s;
                              tempType = 'الكل';
                            }),
                          );
                        }).toList(),
                      ),
                      if (tempSection != 'الكل') ...[
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: typesForSection(tempSection).map((t) {
                            final selected = t == tempType;
                            return ChoiceChip(
                              label: Text(_ptypeLabel(t), style: TextStyle(fontSize: 12.sp)),
                              selected: selected,
                              selectedColor: ColorManager.primary,
                              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                              onSelected: (_) => setSheetState(() => tempType = t),
                            );
                          }).toList(),
                        ),
                      ],
                      SizedBox(height: 16.h),
                      Text(AppStrings.getString('rooms_count_title', context.locale.languageCode),
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _roomsOptions.map((r) {
                          final selected = r == tempRooms;
                          return ChoiceChip(
                            label: Text(r, style: TextStyle(fontSize: 12.sp)),
                            selected: selected,
                            selectedColor: ColorManager.primary,
                            labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                            onSelected: (_) => setSheetState(() => tempRooms = r),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.h),
                      Text(AppStrings.getString('region_title', context.locale.languageCode),
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () async {
                          final result = await showRegionsMultiPickerSheet(
                            context,
                            regions: _allRegions,
                            selected: tempRegions,
                          );
                          if (result != null) {
                            setSheetState(() => tempRegions = result);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: ColorManager.lighterGray,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  tempRegions.isEmpty
                                      ? 'كل المناطق'
                                      : tempRegions.map((r) => regionWithGovernorate(r, context.locale.languageCode)).join('، '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: tempRegions.isEmpty ? ColorManager.grey : Colors.black87,
                                  ),
                                ),
                              ),
                              const Icon(Icons.location_on_outlined),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text('نطاق السعر (د.ك)',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      PriceRangeSlider(
                        min: 0,
                        max: 500000,
                        step: 500,
                        initialMin: tempMin,
                        initialMax: tempMax,
                        currencyLabel: 'د.ك',
                        onChanged: (min, max) => setSheetState(() {
                          tempMin = min;
                          tempMax = max;
                        }),
                      ),
                      SizedBox(height: 16.h),
                      Text('المساحة (م²)',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      PriceRangeSlider(
                        min: 0,
                        max: 1000,
                        step: 10,
                        initialMin: tempMinArea,
                        initialMax: tempMaxArea,
                        currencyLabel: 'م²',
                        onChanged: (min, max) => setSheetState(() {
                          tempMinArea = min;
                          tempMaxArea = max;
                        }),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            minimumSize: Size.fromHeight(48.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _transactionType = tempTransaction;
                              _propertySection = tempSection;
                              _propertyType = tempType;
                              _rooms = tempRooms;
                              _selectedRegions = tempRegions;
                              _minPrice = tempMin;
                              _maxPrice = tempMax;
                              _minArea = tempMinArea;
                              _maxArea = tempMaxArea;
                            });
                            Navigator.pop(context);
                            _fetchProperties();
                          },
                          child: const Text('تطبيق الفلترة', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openSortMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        Widget option(String label, _SortOption value) {
          final selected = _sort == value;
          return ListTile(
            title: Text(label, style: TextStyle(fontSize: 14.sp)),
            trailing: selected ? Icon(Icons.check, color: ColorManager.primary) : null,
            onTap: () {
              setState(() => _sort = value);
              Navigator.pop(context);
              _fetchProperties();
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Text('ترتيب حسب', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              option('الأحدث', _SortOption.newest),
              option('الأعلى مشاهدة', _SortOption.mostViewed),
              option('الأقل مشاهدة', _SortOption.leastViewed),
              option('السعر: الأقل أولاً', _SortOption.priceLowToHigh),
              option('السعر: الأعلى أولاً', _SortOption.priceHighToLow),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Column(
          children: [
            _buildQuickFilterBar(),
            if (_activeFilterCount > 0) _buildActiveFilterChips(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchProperties,
                child: _buildBody(),
              ),
            ),
          ],
        ),
        _buildBottomMapFilterBar(),
      ],
    );

    if (widget.embedded) return body;

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('عقار'),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, Routes.addRoute);
              _fetchProperties();
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'أضف عقار',
          ),
          IconButton(
            onPressed: _openSortMenu,
            icon: const Icon(Icons.sort),
            tooltip: 'ترتيب',
          ),
        ],
      ),
      body: body,
    );
  }

  // === شريط "+" بسيط أعلى القائمة لإضافة عقار - يُستخدم بشاشة "اطلب عقارك"
  // === شريط فلترة سريع: زرّين يفتحون قوائم منسدلة (مو خيارات ظاهرة) + زر إضافة
  Widget _buildQuickFilterBar() {
    Widget pickerButton(String label, bool active, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: active ? ColorManager.primary.withOpacity(0.08) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: active ? ColorManager.primary : ColorManager.lighterGray,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? ColorManager.primary : Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    size: 18.sp, color: active ? ColorManager.primary : ColorManager.grey),
              ],
            ),
          ),
        ),
      );
    }

    Color _txnColor(String t) {
      if (t.contains('بدل')) return const Color(0xFF7C3AED);
      if (t.contains('يجار')) return const Color(0xFF2E6D71);
      return const Color(0xFFE07A1F);
    }

    Widget segButton(String txn) {
      final bool active = _transactionType == txn;
      final label = txn == 'الكل' ? AppStrings.getString('txn_all', context.locale.languageCode) : _txnLabel(txn);
      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() => _transactionType = txn);
            _fetchProperties();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(11.r),
              boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))] : null,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                color: active ? _txnColor(txn) : const Color(0xFF667085),
              ),
            ),
          ),
        ),
      );
    }

    Widget categoryChip(String name) {
      final bool active = _propertySection == name;
      final label = name == 'الكل' ? AppStrings.getString('txn_all', context.locale.languageCode) : _ptypeLabel(name);
      return Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _propertySection = name;
              _propertyType = 'الكل';
            });
            _fetchProperties();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: active ? ColorManager.primary : const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                color: active ? Colors.white : const Color(0xFF344054),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: _transactionTypes.where((t) => t != 'الكل').map(segButton).toList(),
            ),
          ),
          verticalSpace(12),
          SizedBox(
            height: 38.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['الكل', ..._propertyCategories.map((c) => c['name'] as String)].map(categoryChip).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // === قائمة منسدلة عامة للفلترة السريعة
  void _openOptionsSheet({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
    String Function(String)? labelBuilder,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),
                Text(title,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.h),
                const Divider(height: 1),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(height: 1.h),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final selected = option == current;
                      return ListTile(
                        title: Text(
                          labelBuilder != null ? labelBuilder(option) : option,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                            color: selected ? ColorManager.primary : Colors.black87,
                          ),
                        ),
                        trailing: selected
                            ? Icon(Icons.check_circle, color: ColorManager.primary)
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddPropertyBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAdsView()),
          );
          _fetchProperties();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorManager.primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: ColorManager.primary, size: 18.sp),
              horizontalSpace(6),
              Text('أضف عقارك',
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5.sp)),
            ],
          ),
        ),
      ),
    );
  }

  // === شريط عائم بالأسفل: الخريطة + الفلترة - يختفي عند السحب لتحت
  Widget _buildBottomMapFilterBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      bottom: _showBottomBar ? 16.h : -70,
      left: 16.w,
      right: 16.w,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                minimumSize: Size.fromHeight(50.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapSearchView(ads: _results)),
                );
              },
              icon: const Icon(Icons.map_outlined, color: Colors.white),
              label: const Text('الخريطة', style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),
          horizontalSpace(10),
          GestureDetector(
            onTap: _openFilterSheet,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune, color: ColorManager.primary, size: 18.sp),
                  horizontalSpace(6),
                  Text(
                    _activeFilterCount == 0 ? 'فلترة' : 'فلترة ($_activeFilterCount)',
                    style: TextStyle(color: ColorManager.primary, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    final List<Widget> chips = [];
    if (_transactionType != 'الكل') {
      chips.add(_filterChip(_transactionType, () {
        setState(() => _transactionType = 'الكل');
        _fetchProperties();
      }));
    }
    if (_propertySection != 'الكل') {
      chips.add(_filterChip(_propertySection, () {
        setState(() => _propertySection = 'الكل');
        _fetchProperties();
      }));
    }
    if (_propertyType != 'الكل') {
      chips.add(_filterChip(_ptypeLabel(_propertyType), () {
        setState(() => _propertyType = 'الكل');
        _fetchProperties();
      }));
    }
    if (_rooms != 'الكل') {
      chips.add(_filterChip('$_rooms ${AppStrings.getString('rooms_count_title', context.locale.languageCode)}', () {
        setState(() => _rooms = 'الكل');
        _fetchProperties();
      }));
    }
    for (final region in _selectedRegions) {
      chips.add(_filterChip(regionWithGovernorate(region, context.locale.languageCode), () {
        setState(() => _selectedRegions.remove(region));
        _fetchProperties();
      }));
    }
    if (_minPrice > 0 || _maxPrice < 500000) {
      chips.add(_filterChip('${_minPrice.toInt()}-${_maxPrice.toInt()} د.ك', () {
        setState(() {
          _minPrice = 0;
          _maxPrice = 500000;
        });
        _fetchProperties();
      }));
    }
    if (_minArea > 0 || _maxArea < 1000) {
      chips.add(_filterChip('${_minArea.toInt()}-${_maxArea.toInt()} م²', () {
        setState(() {
          _minArea = 0;
          _maxArea = 1000;
        });
        _fetchProperties();
      }));
    }

    return SizedBox(
      height: 36.h,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        reverse: true,
        children: chips.map((c) => Padding(padding: EdgeInsets.only(left: 8.w), child: c)).toList(),
      ),
    );
  }

  Widget _filterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label, style: TextStyle(fontSize: 11.sp, color: ColorManager.primary)),
      backgroundColor: ColorManager.primary.withOpacity(0.08),
      deleteIcon: Icon(Icons.close, size: 14.sp, color: ColorManager.primary),
      onDeleted: onRemove,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide.none,
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
                TextButton(onPressed: _fetchProperties, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ],
      );
    }
    if (_results.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 48.sp, color: ColorManager.grey),
                verticalSpace(10),
                Text('ما فيه عقارات مطابقة حاليًا',
                    style: TextStyle(color: ColorManager.grey)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 90.h),
      itemCount: _results.length,
      itemBuilder: (context, index) => PropertyCard(ad: _results[index]),
    );
  }
}

class PropertyCard extends StatefulWidget {
  final AdsDataResponse ad;

  const PropertyCard({super.key, required this.ad});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  AdsDataResponse get ad => widget.ad;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavorited();
  }

  Future<void> _checkFavorited() async {
    if (ad.id == null) return;
    final result = await FavoritesService.isFavorited(FavoriteType.advertisement, ad.id!);
    if (mounted) setState(() => _isFavorited = result);
  }

  bool get _isRent => ad.transactionType?.contains('يجار') ?? false;
  bool get _isSwap => ad.transactionType?.contains('بدل') ?? false;

  String get _priceText {
    if (_isSwap) return AppStrings.getString('for_swap', context.locale.languageCode);
    final price = ad.price ?? '0';
    return _isRent ? '$price د.ك/شهرياً' : '$price د.ك';
  }

  /// "ايجار | شقة" — النوع المختصر
  String get _typeLine {
    final transaction = (ad.transactionType ?? '')
        .replaceAll('عقارات ', '')
        .replaceAll('عقار ', '')
        .replaceAll('لل', '');
    final type = ad.type ?? '';
    return type.isEmpty ? transaction : '$transaction | $type';
  }

  /// ترجمة نوع العقار (نفس خريطة _propertyTypeKeys بصفحة العقار) - نسخة
  /// ثابتة تُستخدم داخل بطاقة الإعلان
  static const Map<String, String> _ptypeKeysStatic = {
    'شقة': 'ptype_apartment', 'بيت': 'ptype_house', 'دور': 'ptype_floor',
    'فيلا': 'ptype_villa', 'عمارة': 'ptype_building', 'دوبلكس': 'ptype_duplex',
    'استوديو': 'ptype_studio', 'أرض': 'ptype_land', 'بيت حكومي': 'ptype_gov_house',
    'سكن عمال': 'ptype_workers_housing', 'سرداب': 'ptype_basement',
    'مكتب': 'ptype_office', 'محل': 'ptype_shop', 'معرض': 'ptype_showroom',
    'مخزن': 'ptype_store', 'مستودع': 'ptype_warehouse',
    'أرض تجارية': 'ptype_commercial_land', 'شقة تجارية': 'ptype_commercial_apartment',
    'دور تجاري': 'ptype_commercial_floor', 'مجمع': 'ptype_complex',
    'مبنى تجاري': 'ptype_commercial_building',
  };
  String _ptypeLabelStatic(String value, String lang) {
    final key = _ptypeKeysStatic[value];
    return key == null ? value : AppStrings.getString(key, lang);
  }

  /// نص نوع المعاملة فقط: بيع / ايجار / بدل
  String _transactionOnlyFor(String lang) {
    final t = ad.transactionType ?? '';
    if (t.contains('بدل')) return AppStrings.getString('short_swap', lang);
    if (t.contains('يجار')) return AppStrings.getString('short_rent', lang);
    if (t.contains('بيع')) return AppStrings.getString('short_sale', lang);
    return t;
  }

  Color get _transactionColor {
    if (_isSwap) return const Color(0xFF7C3AED);
    if (_isRent) return const Color(0xFF2E6D71);
    return const Color(0xFFE07A1F);
  }

  Widget _pill(String text, {Color? bg, Color? fg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
          color: fg ?? const Color(0xFF344054),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PropertyDetailsView(ad: ad)),
        );
        if (mounted) _checkFavorited();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F8),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === الصورة مع زر المفضلة أعلى اليسار
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: (ad.images == null || ad.images!.isEmpty)
                      ? Image.asset(
                          defaultPropertyImage,
                          width: double.infinity,
                          height: 140.h,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                    imageUrl: ad.images ?? '',
                    width: double.infinity,
                    height: 140.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: const Color(0xFFF2F4F7),
                      height: 140.h,
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                      defaultPropertyImage,
                      width: double.infinity,
                      height: 140.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Row(
                    children: [
                      Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: const BoxDecoration(color: Color(0xFFFEE4E2), shape: BoxShape.circle),
                        child: Center(
                          child: FavoriteButton(
                            key: ValueKey(_isFavorited),
                            type: FavoriteType.advertisement,
                            itemId: ad.id ?? 0,
                            initiallyFavorited: _isFavorited,
                            size: 17.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: const BoxDecoration(color: Color(0xFFD1E9FF), shape: BoxShape.circle),
                        child: Center(
                          child: ShareButton(
                            shareText: '${ad.title ?? ad.type ?? ''} - ${ad.shareUrl ?? ''}',
                            size: 16,
                            color: const Color(0xFF1570CB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility, size: 11.sp, color: Colors.white),
                        SizedBox(width: 4.w),
                        Text('${ad.viewsCount ?? 0}',
                            style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              if (ad.isFeatured == true)
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('VIP', style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
              if (ad.hasCommission != null)
                Positioned(
                  bottom: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: (ad.hasCommission == true)
                          ? const Color(0xFFB54708).withOpacity(0.92)
                          : const Color(0xFF12B76A).withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      (ad.hasCommission == true)
                          ? '${AppStrings.getString('commission_with_percent', context.locale.languageCode).replaceFirst('{p}', '${ad.commissionPercent ?? ''}')}'
                          : AppStrings.getString('no_commission', context.locale.languageCode),
                      style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          verticalSpace(10),

          // === بادجات: نوع المعاملة + نوع العقار + التصنيف
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _pill(_transactionOnlyFor(context.locale.languageCode), bg: _transactionColor.withOpacity(0.12), fg: _transactionColor),
              if ((ad.type ?? '').isNotEmpty) _pill(_ptypeLabelStatic(ad.type!, context.locale.languageCode)),
              if ((ad.propertySection ?? '').isNotEmpty)
                _pill(ad.propertySection!, bg: const Color(0xFFEFF3FF), fg: const Color(0xFF3E5FC1)),
              if ((ad.landType ?? '').isNotEmpty)
                _pill(ad.landType!, bg: const Color(0xFFEFF3FF), fg: const Color(0xFF3E5FC1)),
            ],
          ),
          verticalSpace(10),

          // === السعر + المواصفات المختصرة
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _priceText,
                  style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w900, color: ColorManager.primary),
                ),
              ),
              if ((ad.rooms ?? '').isNotEmpty) ...[
                Icon(Icons.bed_outlined, size: 17.sp, color: const Color(0xFF344054)),
                SizedBox(width: 5.w),
                Text('${ad.rooms}', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF344054))),
                SizedBox(width: 16.w),
              ],
              if ((ad.area ?? '').isNotEmpty) ...[
                Icon(Icons.crop_free, size: 17.sp, color: const Color(0xFF344054)),
                SizedBox(width: 5.w),
                Text('${ad.area} م²', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF344054))),
              ],
            ],
          ),
          verticalSpace(7),

          // === المنطقة
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 15.sp, color: const Color(0xFF98A2B3)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  regionWithGovernorate(ad.region ?? '', context.locale.languageCode),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF98A2B3)),
                ),
              ),
            ],
          ),
          verticalSpace(5),

          // === الرقم المرجعي + العمولة + تاريخ النشر (صغير)
          Row(
            children: [
              Text('#${ad.referenceNo ?? '0000000'}',
                  style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFFE53935))),
              SizedBox(width: 10.w),
              const Spacer(),
              if (ad.createdAt != null)
                Text(
                  "${AppStrings.getString('published_on', context.locale.languageCode)}: ${_publishedAt(ad.createdAt!)}",
                  style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB0B7BD)),
                ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  String _publishedAt(String raw) {
    final date = DateTime.tryParse(raw);
    if (date == null) return '';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
