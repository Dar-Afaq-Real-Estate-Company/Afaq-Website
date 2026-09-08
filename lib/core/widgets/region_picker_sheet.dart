import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../helper/kuwait_governorates.dart';
import 'app_loading_indicator.dart';

/// شيت اختيار منطقة واحدة من قائمة مناطق الكويت الموجودة بالتطبيق،
/// مع خانة بحث فوق تصفّي القائمة أثناء الكتابة.
/// يرجع اسم المنطقة المختارة، أو null لو المستخدم أغلق الشيت بدون اختيار.
Future<String?> showRegionPickerSheet(
  BuildContext context, {
  required List<String> regions,
  String? current,
  bool governorateOnly = false,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return _RegionPickerContent(regions: regions, current: current, governorateOnly: governorateOnly);
    },
  );
}

/// نفس شيت اختيار المنطقة لكن يسمح باختيار عدة مناطق (تشيك بوكس) -
/// نفس تصميم البحث المستخدم بالفنادق بالضبط.
/// يرجع القائمة الجديدة المختارة بعد الضغط "تم".
Future<List<String>?> showRegionsMultiPickerSheet(
  BuildContext context, {
  required List<String> regions,
  required List<String> selected,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return _RegionsMultiPickerContent(
        regions: regions,
        initialSelected: selected,
      );
    },
  );
}

/// === شريحة (chip) موحّدة تستخدمها كل قوائم المحافظات/المدن هنا
Widget _chip({
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: selected ? ColorManager.primary : ColorManager.lighterGray,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          color: selected ? Colors.white : Colors.black87,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    ),
  );
}

class _RegionPickerContent extends StatefulWidget {
  final List<String> regions;
  final String? current;
  final bool governorateOnly;

  const _RegionPickerContent({required this.regions, required this.current, this.governorateOnly = false});

  @override
  State<_RegionPickerContent> createState() => _RegionPickerContentState();
}

class _RegionPickerContentState extends State<_RegionPickerContent> {
  final TextEditingController _searchController = TextEditingController();
  late Map<String, List<String>> _byGovernorate;
  late List<String> _filtered;
  late String _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    _byGovernorate = widget.governorateOnly
        ? {for (final gov in kuwaitGovernorateAreas.keys) gov: []}
        : groupRegionsByGovernorate(widget.regions);
    _filtered = widget.regions;
    // === يبدأ على محافظة المنطقة المختارة حاليًا (لو فيه)، وإلا أول محافظة
    _selectedGovernorate = _byGovernorate.keys.firstWhere(
      (gov) => widget.current != null && (_byGovernorate[gov] ?? []).contains(widget.current),
      orElse: () => _byGovernorate.keys.isNotEmpty ? _byGovernorate.keys.first : '',
    );
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _filtered = query.isEmpty
          ? widget.regions
          : widget.regions.where((r) => r.contains(query)).toList(growable: false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final governorates = _byGovernorate.keys.toList();
    final citiesOfCurrentGov = _byGovernorate[_selectedGovernorate] ?? [];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85 -
                MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(AppStrings.getString('region_picker_choose_region', context.locale.languageCode), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.getString('region_picker_search_hint', context.locale.languageCode),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _searchController.clear(),
                            ),
                      filled: true,
                      fillColor: ColorManager.lighterGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  );
                },
              ),
              if (!_isSearching)
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                SizedBox(height: 14.h),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(AppStrings.getString('region_picker_governorate', context.locale.languageCode),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: governorates.map((gov) {
                    final selected = gov == _selectedGovernorate;
                    return ChoiceChip(
                      label: Text(governorateLabel(gov, context.locale.languageCode), style: TextStyle(fontSize: 12.sp)),
                      selected: selected,
                      selectedColor: ColorManager.primary,
                      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                      onSelected: (_) {
                        if (widget.governorateOnly) {
                          Navigator.pop(context, gov);
                        } else {
                          setState(() => _selectedGovernorate = gov);
                        }
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                if (!widget.governorateOnly) ...[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(AppStrings.getString('region_picker_city', context.locale.languageCode),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 8.h),
                Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ChoiceChip(
                        label: Text(AppStrings.getString('txn_all', context.locale.languageCode), style: TextStyle(fontSize: 12.sp)),
                        selected: widget.current == null,
                        selectedColor: ColorManager.primary,
                        labelStyle: TextStyle(
                            color: widget.current == null ? Colors.white : Colors.black87),
                        onSelected: (_) => Navigator.pop(context, ''),
                      ),
                      ...citiesOfCurrentGov.map((city) {
                        final selected = city == widget.current;
                        return ChoiceChip(
                          label: Text(areaLabel(city, context.locale.languageCode), style: TextStyle(fontSize: 12.sp)),
                          selected: selected,
                          selectedColor: ColorManager.primary,
                          labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                          onSelected: (_) => Navigator.pop(context, city),
                        );
                      }),
                    ],
                ),
                ],
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(child: Text(AppStrings.getString('region_picker_no_results', context.locale.languageCode)))
                      : _buildRegionList(_filtered),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionList(List<String> regions, {bool showAllOption = false}) {
    final int itemCount = regions.length + (showAllOption ? 1 : 0);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => Divider(height: 1.h),
      itemBuilder: (context, index) {
        if (showAllOption && index == 0) {
          final bool selected = widget.current == null;
          return ListTile(
            leading: Icon(Icons.clear_all, color: ColorManager.grey),
            title: Text(AppStrings.getString('txn_all', context.locale.languageCode),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? ColorManager.primary : Colors.black87,
                )),
            trailing: selected ? Icon(Icons.check_circle, color: ColorManager.primary) : null,
            onTap: () => Navigator.pop(context, ''),
          );
        }
        final region = regions[index - (showAllOption ? 1 : 0)];
        final bool selected = region == widget.current;
        return ListTile(
          title: Text(areaLabel(region, context.locale.languageCode),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? ColorManager.primary : Colors.black87,
              )),
          trailing: selected ? Icon(Icons.check_circle, color: ColorManager.primary) : null,
          onTap: () => Navigator.pop(context, region),
        );
      },
    );
  }
}

class _RegionsMultiPickerContent extends StatefulWidget {
  final List<String> regions;
  final List<String> initialSelected;

  const _RegionsMultiPickerContent({
    required this.regions,
    required this.initialSelected,
  });

  @override
  State<_RegionsMultiPickerContent> createState() =>
      _RegionsMultiPickerContentState();
}

class _RegionsMultiPickerContentState
    extends State<_RegionsMultiPickerContent> {
  final TextEditingController _searchController = TextEditingController();
  late Map<String, List<String>> _byGovernorate;
  late List<String> _filtered;
  late List<String> _selected;
  late String _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    _byGovernorate = groupRegionsByGovernorate(widget.regions);
    _filtered = widget.regions;
    _selected = List.of(widget.initialSelected);
    _selectedGovernorate = _byGovernorate.keys.firstWhere(
      (gov) => (_byGovernorate[gov] ?? []).any((a) => _selected.contains(a)),
      orElse: () => _byGovernorate.keys.isNotEmpty ? _byGovernorate.keys.first : '',
    );
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _filtered = query.isEmpty
          ? widget.regions
          : widget.regions.where((r) => r.contains(query)).toList(growable: false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  void _toggleAllInGovernorate(List<String> cities) {
    final bool allSelected = cities.every((c) => _selected.contains(c));
    setState(() {
      if (allSelected) {
        _selected.removeWhere((c) => cities.contains(c));
      } else {
        for (final c in cities) {
          if (!_selected.contains(c)) _selected.add(c);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final governorates = _byGovernorate.keys.toList();
    final citiesOfCurrentGov = _byGovernorate[_selectedGovernorate] ?? [];
    final bool allOfCurrentSelected =
        citiesOfCurrentGov.isNotEmpty && citiesOfCurrentGov.every((c) => _selected.contains(c));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85 -
                MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.getString('region_picker_choose_regions', context.locale.languageCode), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    child: Text(AppStrings.getString('region_picker_done', context.locale.languageCode)),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.getString('region_picker_search_hint', context.locale.languageCode),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _searchController.clear(),
                            ),
                      filled: true,
                      fillColor: ColorManager.lighterGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  );
                },
              ),
              if (!_isSearching)
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                SizedBox(height: 14.h),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(AppStrings.getString('region_picker_governorate', context.locale.languageCode),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: governorates.map((gov) {
                    final selected = gov == _selectedGovernorate;
                    final int count = (_byGovernorate[gov] ?? []).where((a) => _selected.contains(a)).length;
                    return ChoiceChip(
                      label: Text(count > 0 ? '${governorateLabel(gov, context.locale.languageCode)} ($count)' : governorateLabel(gov, context.locale.languageCode), style: TextStyle(fontSize: 12.sp)),
                      selected: selected,
                      selectedColor: ColorManager.primary,
                      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                      onSelected: (_) => setState(() => _selectedGovernorate = gov),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(AppStrings.getString('region_picker_city', context.locale.languageCode),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ChoiceChip(
                      label: Text(AppStrings.getString('txn_all', context.locale.languageCode), style: TextStyle(fontSize: 12.sp)),
                      selected: allOfCurrentSelected,
                      selectedColor: ColorManager.primary,
                      labelStyle: TextStyle(color: allOfCurrentSelected ? Colors.white : Colors.black87),
                      onSelected: (_) => _toggleAllInGovernorate(citiesOfCurrentGov),
                    ),
                    ...citiesOfCurrentGov.map((city) {
                      final selected = _selected.contains(city);
                      return ChoiceChip(
                        label: Text(areaLabel(city, context.locale.languageCode), style: TextStyle(fontSize: 12.sp)),
                        selected: selected,
                        selectedColor: ColorManager.primary,
                        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                        onSelected: (_) => setState(() {
                          if (selected) {
                            _selected.remove(city);
                          } else {
                            _selected.add(city);
                          }
                        }),
                      );
                    }),
                  ],
                ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(child: Text(AppStrings.getString('region_picker_no_results', context.locale.languageCode)))
                      : _buildRegionCheckboxList(_filtered),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionCheckboxList(
    List<String> regions, {
    bool showAllOption = false,
    bool allSelected = false,
  }) {
    final int itemCount = regions.length + (showAllOption ? 1 : 0);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => Divider(height: 1.h),
      itemBuilder: (context, index) {
        if (showAllOption && index == 0) {
          return CheckboxListTile(
            title: Text(AppStrings.getString('txn_all', context.locale.languageCode),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: allSelected ? FontWeight.w700 : FontWeight.w400,
                )),
            value: allSelected,
            activeColor: ColorManager.primary,
            onChanged: (_) => _toggleAllInGovernorate(regions),
          );
        }
        final region = regions[index - (showAllOption ? 1 : 0)];
        final bool selected = _selected.contains(region);
        return CheckboxListTile(
          title: Text(areaLabel(region, context.locale.languageCode),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              )),
          value: selected,
          activeColor: ColorManager.primary,
          onChanged: (v) {
            setState(() {
              if (v == true) {
                _selected.add(region);
              } else {
                _selected.remove(region);
              }
            });
          },
        );
      },
    );
  }
}
