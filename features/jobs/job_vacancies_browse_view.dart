import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/helper/kuwait_governorates.dart';
import 'job_vacancy_details_view.dart';
import 'widgets/job_form_fields.dart';

/// موديل بطاقة الوظيفة الشاغرة
class VacancyListItem {
  final int id;
  final String title;
  final String profession;
  final String employmentType;
  final String region;
  final String? salary;
  final String description;
  final String phone;
  final String email;
  final String? createdAt;
  final String? referenceNo;
  final int viewsCount;

  const VacancyListItem({
    required this.id,
    required this.title,
    required this.profession,
    required this.employmentType,
    required this.region,
    required this.description,
    required this.phone,
    required this.email,
    this.salary,
    this.createdAt,
    this.referenceNo,
    this.viewsCount = 0,
  });

  factory VacancyListItem.fromJson(Map<String, dynamic> j) => VacancyListItem(
        id: int.tryParse(j['id'].toString()) ?? 0,
        title: (j['title'] ?? j['profession'] ?? '').toString(),
        profession: (j['profession'] ?? '').toString(),
        employmentType: (j['employment_type'] ?? '').toString(),
        region: (j['region'] ?? '').toString(),
        salary: j['salary']?.toString(),
        description: (j['description'] ?? '').toString(),
        phone: (j['phone'] ?? '').toString(),
        email: (j['email'] ?? '').toString(),
        createdAt: j['created_at']?.toString(),
        referenceNo: (j['reference_no'] ?? j['id'])?.toString(),
        viewsCount: int.tryParse('${j['views_count'] ?? 0}') ?? 0,
      );

  /// "قبل 3 أيام" / "اليوم" - تُحسب من created_at
  String get postedAgo {
    if (createdAt == null) return '';
    final date = DateTime.tryParse(createdAt!);
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 30) return 'قبل ${diff.inDays} يوم';
    final months = (diff.inDays / 30).floor();
    return 'قبل $months شهر';
  }

  bool get isRemote => employmentType.contains('بُعد') || employmentType.contains('بعد');

  double get salaryValue => double.tryParse((salary ?? '').replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
}

/// صفحة تصفح الوظائف الشاغرة - بحث + فلترة (منطقة/راتب/دوام) + ترتيب بالأحدث
class JobVacanciesBrowseView extends StatefulWidget {
  const JobVacanciesBrowseView({super.key});

  @override
  State<JobVacanciesBrowseView> createState() => _JobVacanciesBrowseViewState();
}

class _JobVacanciesBrowseViewState extends State<JobVacanciesBrowseView> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.afaq.group/api/',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  final TextEditingController _searchController = TextEditingController();

  List<VacancyListItem> _vacancies = [];
  bool _loading = true;
  String? _error;

  // === الفلاتر
  String _region = 'الكل';
  String _employmentType = 'الكل';
  double _minSalary = 0;
  double _maxSalary = 2000;
  static const List<String> _employmentTypes = ['الكل', 'دوام كامل', 'دوام جزئي', 'عن بُعد'];

  @override
  void initState() {
    super.initState();
    _fetchVacancies();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchVacancies() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _dio.get('job-listings', queryParameters: {
        'listing_type': 'vacancy',
      });
      final List<dynamic> data = response.data['data'] ?? [];
      final items = data
          .map((e) => VacancyListItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      items.sort((a, b) {
        final da = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
        final db = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
        return db.compareTo(da);
      });
      if (!mounted) return;
      setState(() {
        _vacancies = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر تحميل الوظائف، تحقق من اتصالك وحاول مرة أخرى';
        _loading = false;
      });
    }
  }

  int get _activeFilterCount {
    int c = 0;
    if (_region != 'الكل') c++;
    if (_employmentType != 'الكل') c++;
    if (_minSalary > 0 || _maxSalary < 2000) c++;
    return c;
  }

  List<VacancyListItem> get _filtered {
    final query = _searchController.text.trim();
    return _vacancies.where((v) {
      final matchesRegion = _region == 'الكل' || v.region == _region;
      final matchesEmployment = _employmentType == 'الكل' || v.employmentType == _employmentType;
      final matchesSalary = v.salaryValue == 0 || (v.salaryValue >= _minSalary && v.salaryValue <= _maxSalary);
      final matchesQuery = query.isEmpty ||
          v.title.contains(query) ||
          v.profession.contains(query) ||
          v.region.contains(query);
      return matchesRegion && matchesEmployment && matchesSalary && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterBar(),
            if (_activeFilterCount > 0) _buildActiveChips(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
              ),
              horizontalSpace(12),
              Text('الوظائف الشاغرة',
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (!_loading)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20.r)),
                  child: Text('${_filtered.length} وظيفة', style: TextStyle(color: Colors.white, fontSize: 11.5.sp)),
                ),
            ],
          ),
          verticalSpace(16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن وظيفة أو تخصص...',
                hintStyle: TextStyle(fontSize: 13.sp, color: ColorManager.grey),
                prefixIcon: Icon(Icons.search, color: ColorManager.grey, size: 20.sp),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(icon: Icon(Icons.close, size: 18.sp), onPressed: () => _searchController.clear()),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 13.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === شريط الفلاتر: تصفية / المنطقة / الراتب / الدوام
  Widget _buildFilterBar() {
    Widget chip(String label, bool active, VoidCallback onTap, {bool primary = false}) {
      return Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: (primary || active) ? ColorManager.primary : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: (primary || active) ? ColorManager.primary : const Color(0xFFE4E7EC)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(label,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: (primary || active) ? FontWeight.w700 : FontWeight.w400,
                    color: (primary || active) ? Colors.white : const Color(0xFF344054),
                  )),
              SizedBox(width: 4.w),
              Icon(Icons.keyboard_arrow_down, size: 14.sp, color: (primary || active) ? Colors.white : const Color(0xFF98A2B3)),
            ]),
          ),
        ),
      );
    }

    return Container(
      height: 44.h,
      margin: EdgeInsets.only(top: 12.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          chip(_activeFilterCount == 0 ? 'تصفية' : 'تصفية (${_activeFilterCount})', false, _openFilterSheet, primary: true),
          chip(_region == 'الكل' ? 'المنطقة' : _region, _region != 'الكل', _openRegionSheet),
          chip(_employmentType == 'الكل' ? 'الدوام' : _employmentType, _employmentType != 'الكل', _openEmploymentSheet),
        ],
      ),
    );
  }

  Widget _buildActiveChips() {
    final List<Widget> chips = [];
    if (_region != 'الكل') {
      chips.add(_removableChip(_region, () => setState(() => _region = 'الكل')));
    }
    if (_employmentType != 'الكل') {
      chips.add(_removableChip(_employmentType, () => setState(() => _employmentType = 'الكل')));
    }
    if (_minSalary > 0 || _maxSalary < 2000) {
      chips.add(_removableChip('${_minSalary.toInt()}-${_maxSalary.toInt()} د.ك', () => setState(() {
            _minSalary = 0;
            _maxSalary = 2000;
          })));
    }
    return SizedBox(
      height: 34.h,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        children: chips.map((c) => Padding(padding: EdgeInsets.only(left: 8.w), child: c)).toList(),
      ),
    );
  }

  Widget _removableChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label, style: TextStyle(fontSize: 10.5.sp, color: ColorManager.primary)),
      backgroundColor: ColorManager.primary.withOpacity(0.08),
      deleteIcon: Icon(Icons.close, size: 13.sp, color: ColorManager.primary),
      onDeleted: onRemove,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r), side: BorderSide.none),
    );
  }

  void _openEmploymentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _employmentTypes.map((t) {
            final selected = t == _employmentType;
            return ListTile(
              title: Text(t, style: TextStyle(fontSize: 14.sp, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
              trailing: selected ? Icon(Icons.check, color: ColorManager.primary) : null,
              onTap: () {
                setState(() => _employmentType = t);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _openRegionSheet() async {
    final regions = ['الكل', ...kuwaitGovernorateAreas.values.expand((v) => v)];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: regions.length,
            itemBuilder: (context, index) {
              final r = regions[index];
              final selected = r == _region;
              return ListTile(
                title: Text(r, style: TextStyle(fontSize: 14.sp, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
                trailing: selected ? Icon(Icons.check, color: ColorManager.primary) : null,
                onTap: () {
                  setState(() => _region = r);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openFilterSheet() {
    String tempRegion = _region;
    String tempEmployment = _employmentType;
    double tempMin = _minSalary;
    double tempMax = _maxSalary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
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
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
                    ),
                  ),
                  verticalSpace(16),
                  Text('تصفية النتائج', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  verticalSpace(14),
                  Text('نوع الدوام', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  verticalSpace(8),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _employmentTypes.map((t) {
                      final selected = t == tempEmployment;
                      return ChoiceChip(
                        label: Text(t, style: TextStyle(fontSize: 12.sp)),
                        selected: selected,
                        selectedColor: ColorManager.primary,
                        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                        onSelected: (_) => setSheetState(() => tempEmployment = t),
                      );
                    }).toList(),
                  ),
                  verticalSpace(16),
                  Text('نطاق الراتب (د.ك)', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  RangeSlider(
                    min: 0,
                    max: 2000,
                    divisions: 40,
                    activeColor: ColorManager.primary,
                    values: RangeValues(tempMin, tempMax),
                    labels: RangeLabels('${tempMin.toInt()}', '${tempMax.toInt()}'),
                    onChanged: (v) => setSheetState(() {
                      tempMin = v.start;
                      tempMax = v.end;
                    }),
                  ),
                  verticalSpace(10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        minimumSize: Size.fromHeight(48.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      onPressed: () {
                        setState(() {
                          _region = tempRegion;
                          _employmentType = tempEmployment;
                          _minSalary = tempMin;
                          _maxSalary = tempMax;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('تطبيق الفلترة', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 44.sp, color: ColorManager.grey),
              verticalSpace(12),
              Text(_error!, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, color: ColorManager.grey)),
              verticalSpace(16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
                onPressed: _fetchVacancies,
                child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.work_off_outlined, size: 48.sp, color: const Color(0xFFD0D5DD)),
            verticalSpace(12),
            Text('ما فيه وظائف مطابقة حالياً', style: TextStyle(fontSize: 14.sp, color: ColorManager.grey)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchVacancies,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 100.h),
        itemCount: _filtered.length,
        separatorBuilder: (_, __) => verticalSpace(12),
        itemBuilder: (context, index) {
          final v = _filtered[index];
          return _VacancyCard(
            item: v,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobVacancyDetailsView(vacancy: v))),
          );
        },
      ),
    );
  }
}

class _VacancyCard extends StatelessWidget {
  final VacancyListItem item;
  final VoidCallback onTap;

  const _VacancyCard({required this.item, required this.onTap});

  String get _initials {
    final words = item.title.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '؟';
    if (words.length == 1) return words.first.characters.take(2).toString();
    return '${words[0].characters.first}${words[1].characters.first}';
  }

  @override
  Widget build(BuildContext context) {
    final Color initialsColor1 = _colorFor(item.profession).$1;
    final Color initialsColor2 = _colorFor(item.profession).$2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFEAF1F1)),
          boxShadow: [
            BoxShadow(color: ColorManager.primary.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [initialsColor1, initialsColor2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(_initials, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: const Color(0xFF101828))),
                      verticalSpace(3),
                      Text(item.profession, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                if (item.postedAgo.isNotEmpty)
                  Text(item.postedAgo, style: TextStyle(fontSize: 10.5.sp, color: const Color(0xFF98A2B3))),
              ],
            ),
            if (item.referenceNo != null && item.referenceNo!.isNotEmpty) ...[
              verticalSpace(10),
              Text('#${item.referenceNo}', style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB0B7BD), fontWeight: FontWeight.w700)),
            ],
            verticalSpace(11),
            Divider(height: 1, color: const Color(0xFFF0F2F1)),
            verticalSpace(11),
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                _pill(Icons.location_on_outlined, item.region, bg: const Color(0xFFEAF1F1), fg: ColorManager.primary),
                if (item.employmentType.isNotEmpty)
                  _pill(
                    item.isRemote ? Icons.laptop_mac : Icons.schedule,
                    item.employmentType,
                    bg: item.isRemote ? const Color(0xFFEAF1FE) : const Color(0xFFFFF4E5),
                    fg: item.isRemote ? const Color(0xFF1570CD) : const Color(0xFFB54708),
                  ),
                _pill(
                  Icons.payments_outlined,
                  (item.salary == null || item.salary!.isEmpty)
                      ? 'الراتب غير محدد'
                      : (item.salary == '0' ? 'الراتب عند المقابلة' : item.salary!),
                  bg: (item.salary != null && item.salary!.isNotEmpty && item.salary != '0') ? const Color(0xFFEAF7EF) : const Color(0xFFF4F4F5),
                  fg: (item.salary != null && item.salary!.isNotEmpty && item.salary != '0') ? const Color(0xFF12B76A) : const Color(0xFF667085),
                  bold: item.salary != null && item.salary!.isNotEmpty && item.salary != '0',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _colorFor(String profession) {
    const palettes = [
      (Color(0xFF2E6D71), Color(0xFF5EAAB0)),
      (Color(0xFFB54708), Color(0xFFF79009)),
      (Color(0xFF1570CD), Color(0xFF53B1FD)),
      (Color(0xFF7A5AF8), Color(0xFFB692F6)),
      (Color(0xFFD92D20), Color(0xFFF97066)),
    ];
    final index = profession.isEmpty ? 0 : profession.codeUnits.fold<int>(0, (a, b) => a + b) % palettes.length;
    return palettes[index];
  }

  Widget _pill(IconData icon, String label, {required Color bg, required Color fg, bool bold = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: fg),
          SizedBox(width: 5.w),
          Text(label, style: TextStyle(fontSize: 11.sp, color: fg, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
        ],
      ),
    );
  }
}
