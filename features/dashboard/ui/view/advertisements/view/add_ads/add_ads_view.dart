import 'package:afaq_real_estate/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import '../../../../../../../core/helper/amenity_icons.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../../../core/resources/styles_manager.dart';
import '../../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../../core/widgets/app_text_form_field.dart';
import '../../../../../../../core/widgets/location_picker_view.dart';
import '../../../../../../../core/widgets/region_picker_sheet.dart';
import '../../../../../../../core/widgets/app_loading_indicator.dart';
import '../../../../../../../core/widgets/subscription_gate_button.dart';
import 'ad_preview_view.dart';
import '../../../../../logic/home_cubit.dart';
import '../../../../../logic/home_state.dart';
import '../../widgets/add_ads/add_ads_BlocListener.dart';
import '../../widgets/add_ads/custom_decoration.dart';

/// === صفحة "اعرض عقارك" — نموذج بـ 3 خطوات:
/// 1) نوع العقار والمنطقة والعنوان
/// 2) تفاصيل العقار (وصف، سعر، غرف، حمامات، صالات، مساحة، عنوان تفصيلي)
/// 3) الميزات + الموقع على الخريطة + الصور + النشر
class AddAdsView extends StatefulWidget {
  final String? transactionType;
  final bool isFeatured;
  const AddAdsView({super.key, this.transactionType, this.isFeatured = false});

  @override
  State<AddAdsView> createState() => _AddAdsViewState();
}

class _AddAdsViewState extends State<AddAdsView> {
  LatLng? _pickedLocation;
  int _currentStep = 0;

  final Dio _categoriesDio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
  List<Map<String, dynamic>> _propertyCategories = [];
  bool _categoriesLoading = true;
  Map<String, dynamic>? _selectedAddCategory;
  String? _selectedAddTransaction;

  String? _tempTransaction;
  Map<String, dynamic>? _tempCategory;
  String? _tempType;

  static const List<String> _addTransactionTypes = [
    'عقارات للبيع',
    'عقارات للإيجار',
    'عقار للبدل',
  ];
  static const int _totalSteps = 3;

  @override
  void initState() {
    super.initState();
    _fetchPropertyCategories();

    if (widget.transactionType != null) {
      context
          .read<AddAdvertisementCubit>()
          .updateTransactionType(widget.transactionType!);
      _selectedAddTransaction = widget.transactionType;
    }
    final cubit = context.read<AddAdvertisementCubit>();
    cubit.isFeatured = widget.isFeatured;
    cubit.getPropertyTypes();
    cubit.getRegions();
    cubit.getAmenities();
  }

  bool _validateCurrentStep(BuildContext context) {
    final cubit = context.read<AddAdvertisementCubit>();
    if (_currentStep == 0) {
      if (cubit.selectedRegion == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.fillAllFieldsError.tr())),
        );
        return false;
      }
    }
    if (_currentStep == 1) {
      final bool isLand = (cubit.selectedPropertyType ?? '').contains('أرض') ||
          (cubit.selectedPropertyType ?? '').contains('ارض');
      if (isLand && cubit.selectedLandType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار نوع الأرض')),
        );
        return false;
      }
      if (!_isExchange && cubit.priceController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.enterPriceError.tr())),
        );
        return false;
      }
    }
    return true;
  }

  bool get _isExchange => (_selectedAddTransaction ?? '').contains('بدل');
  bool get _isRent => (_selectedAddTransaction ?? '').contains('إيجار');

  void _goNext(BuildContext context) {
    if (!_validateCurrentStep(context)) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _handleBackPress() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      setState(() => _selectedAddTransaction = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedAddCategory == null || _selectedAddTransaction == null) {
      final List types = _tempCategory != null
          ? (_tempCategory!['types'] as List).cast<String>()
          : const <String>[];
      final bool canProceed =
          _tempTransaction != null && _tempCategory != null && _tempType != null;
      return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.addAd.tr()),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: _categoriesLoading
            ? const Center(child: AppLoadingIndicator())
            : _propertyCategories.isEmpty
                ? const Center(child: Text('ما فيه تصنيفات عقار مضافة حاليًا'))
                : SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.all(4.w),
                          child: Row(
                            children: _addTransactionTypes.map((t) {
                              final bool selected = _tempTransaction == t;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _tempTransaction = t),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: selected ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: selected
                                          ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)]
                                          : null,
                                    ),
                                    child: Text(
                                      t.replaceAll('عقارات ', '').replaceAll('عقار ', ''),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: selected ? ColorManager.primary : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        verticalSpace(24),
                        if (_tempTransaction != null) ...[
                        Text('ما نوع العقارات التي تريدها؟',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        verticalSpace(16),
                        SizedBox(
                          height: 38.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _propertyCategories.length,
                            separatorBuilder: (_, __) => SizedBox(width: 10.w),
                            itemBuilder: (context, index) {
                              final c = _propertyCategories[index];
                              final bool selected = _tempCategory == c;
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _tempCategory = c;
                                  _tempType = null;
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected ? ColorManager.primary.withOpacity(0.08) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: selected
                                        ? Border.all(color: ColorManager.primary)
                                        : null,
                                  ),
                                  child: Text(
                                    c['name'] as String? ?? '',
                                    style: TextStyle(
                                      fontSize: 13.5.sp,
                                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                      color: selected ? ColorManager.primary : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        verticalSpace(24),
                        if (_tempCategory != null)
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.95,
                            children: types.map((t) {
                              final bool selected = _tempType == t;
                              return GestureDetector(
                                onTap: () => setState(() => _tempType = t),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: selected ? ColorManager.primary : Colors.grey.shade300,
                                      width: selected ? 1.6 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_propertyTypeIconFor(t),
                                          size: 26.sp,
                                          color: selected ? ColorManager.primary : Colors.grey[500]),
                                      verticalSpace(8),
                                      Text(t,
                                          style: TextStyle(
                                            fontSize: 12.5.sp,
                                            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                            color: selected ? ColorManager.primary : Colors.black87,
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        verticalSpace(30),
                      ],
                    ),
                  ),
        bottomNavigationBar: _categoriesLoading || _propertyCategories.isEmpty
            ? null
            : SafeArea(
                top: false,
                child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                        ),
                        child: const Text('رجوع'),
                      ),
                    ),
                    horizontalSpace(12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: canProceed
                            ? () {
                                context.read<AddAdvertisementCubit>().updateTransactionType(_tempTransaction!);
                                context.read<AddAdvertisementCubit>().updatePropertyType(_tempType!);
                                setState(() {
                                  _selectedAddCategory = _tempCategory;
                                  _selectedAddTransaction = _tempTransaction;
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                        ),
                        child: Text('التالي',
                            style: TextStyle(color: Colors.white, fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
              ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.addAd.tr()),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackPress,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0.h),
                children: [
                  if (_currentStep == 0) _buildStep1(context),
                  if (_currentStep == 1) _buildStep2(context),
                  if (_currentStep == 2) _buildStep3(context),
                ],
              ),
            ),
            _buildBottomBar(context),
            const AddAdsBloclistener(),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    const titles = ['المنطقة والموقع', 'التفاصيل والسعر', 'العنوان والصور'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الخطوة ${_currentStep + 1} من $_totalSteps',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              Text(
                titles[_currentStep],
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          verticalSpace(6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              minHeight: 4.h,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(ColorManager.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('السابق'),
              ),
            ),
          if (_currentStep > 0) horizontalSpace(10),
          Expanded(
            flex: 2,
            child: _currentStep < _totalSteps - 1
                ? AppTextButton(
                    buttonText: 'التالي',
                    textStyle: StylesManager.font16White,
                    onPressed: () => _goNext(context),
                  )
                : AppTextButton(
                    buttonText: 'معاينة الإعلان',
                    textStyle: StylesManager.font16White,
                    onPressed: () {
                      final cubit = context.read<AddAdvertisementCubit>();
                      if (cubit.selectedPropertyType != null &&
                          cubit.selectedRegion != null &&
                          cubit.titleController.text.trim().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: AdPreviewView(
                                transactionType: _selectedAddTransaction,
                                categoryName: _selectedAddCategory?['name'],
                                latitude: _pickedLocation?.latitude,
                                longitude: _pickedLocation?.longitude,
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppStrings.fillAllFieldsError.tr()),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(BuildContext context) {
    return BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
      builder: (context, state) {
        var cubit = context.read<AddAdvertisementCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${_selectedAddCategory?['name'] ?? ''} • ${cubit.selectedPropertyType ?? ''}',
                style: TextStyle(fontSize: 13.sp, color: ColorManager.primary, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpace(24),
            Text(
              AppStrings.region.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            verticalSpace(10),
            BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
              buildWhen: (previous, current) =>
                  current is RegionsLoading ||
                  current is RegionsSuccess ||
                  current is RegionsError ||
                  current is RegionChanged,
              builder: (context, state) {
                if (state is RegionsLoading) {
                  return const Center(child: AppLoadingIndicator());
                }
                return GestureDetector(
                  onTap: cubit.regions.isEmpty
                      ? null
                      : () async {
                          final selected = await showRegionPickerSheet(
                            context,
                            regions: cubit.regions,
                            current: cubit.selectedRegion,
                          );
                          if (selected != null) {
                            cubit.updateRegion(selected);
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cubit.selectedRegion ?? AppStrings.chooseRegion.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: cubit.selectedRegion == null ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
            verticalSpace(24),
            Text(
              'ضع موقعك على الخريطة',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            verticalSpace(10),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push<LatLng>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPickerView(initialLocation: _pickedLocation),
                  ),
                );
                if (result != null) {
                  setState(() => _pickedLocation = result);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _pickedLocation == null
                          ? 'اضغط لتحديد الموقع على الخريطة'
                          : 'تم تحديد الموقع ✓',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: _pickedLocation == null ? Colors.grey : ColorManager.primary,
                      ),
                    ),
                    Icon(Icons.map_outlined, color: ColorManager.primary),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFloorsBreakdown(AddAdvertisementCubit cubit) {
    if (cubit.floorsDetails.isEmpty) return [];
    return cubit.floorsDetails.asMap().entries.map((floorEntry) {
      final int floorIndex = floorEntry.key;
      final floor = floorEntry.value;
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorManager.primary.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الدور ${floorIndex + 1}',
                style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.bold, color: ColorManager.primary)),
            verticalSpace(10),
            _PropertyStepper(
              key: ValueKey('floor-$floorIndex-apts'),
              icon: Icons.door_front_door_outlined,
              label: 'عدد الشقق في هذا الدور',
              controller: floor.apartmentsCountController,
              onChanged: (v) => cubit.setApartmentsCountForFloor(floorIndex, v),
            ),
            verticalSpace(10),
            ...floor.apartments.asMap().entries.map((aptEntry) {
              final apt = aptEntry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('شقة ${aptEntry.key + 1}',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600)),
                    verticalSpace(8),
                    _PropertyStepper(key: ValueKey('f$floorIndex-a${aptEntry.key}-rooms'), icon: Icons.bed_outlined, label: 'غرف', controller: apt.roomsController),
                    verticalSpace(8),
                    _PropertyStepper(key: ValueKey('f$floorIndex-a${aptEntry.key}-baths'), icon: Icons.bathtub_outlined, label: 'حمامات', controller: apt.bathroomsController),
                    verticalSpace(8),
                    _PropertyStepper(key: ValueKey('f$floorIndex-a${aptEntry.key}-halls'), icon: Icons.weekend_outlined, label: 'صالات', controller: apt.hallsController),
                    verticalSpace(8),
                    _PropertyStepper(key: ValueKey('f$floorIndex-a${aptEntry.key}-kitchens'), icon: Icons.kitchen_outlined, label: 'مطابخ', controller: apt.kitchensController),
                    verticalSpace(8),
                    Row(
                      children: [
                        Icon(Icons.square_foot_outlined, size: 16.sp, color: ColorManager.primary),
                        horizontalSpace(8),
                        Expanded(child: Text('المساحة', style: TextStyle(fontSize: 12.sp))),
                        SizedBox(
                          width: 90.w,
                          child: TextFormField(
                            controller: apt.areaController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              suffixText: 'م²',
                              suffixStyle: TextStyle(fontSize: 10.sp),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _fetchPropertyCategories() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    setState(() {
      _propertyCategories = [
        {
          'name': 'سكني',
          'icon': 'home_outlined',
          'types': [
            'شقة', 'بيت', 'دور', 'فيلا', 'عمارة', 'دوبلكس',
            'استوديو', 'أرض', 'بيت حكومي', 'سكن عمال', 'سرداب',
          ],
        },
        {
          'name': 'تجاري',
          'icon': 'storefront_outlined',
          'types': [
            'مكتب', 'محل', 'معرض', 'مخزن', 'مستودع', 'أرض تجارية',
            'شقة تجارية', 'دور تجاري', 'مجمع', 'مبنى تجاري', 'سرداب',
          ],
        },
        {
          'name': 'استثماري',
          'icon': 'trending_up_outlined',
          'types': ['شقق استثمارية', 'عمارة استثمارية', 'أرض استثمارية', 'مجمع استثماري'],
        },
        {
          'name': 'صناعي',
          'icon': 'factory_outlined',
          'types': ['مصنع', 'أرض صناعية', 'مستودع صناعي', 'ورشة'],
        },
      ];
      _categoriesLoading = false;
    });
  }

  IconData _propertyTypeIconFor(String type) {
    if (type.contains('بيت حكومي')) return Icons.account_balance_outlined;
    if (type.contains('سكن عمال')) return Icons.groups_outlined;
    if (type.contains('بيت')) return Icons.home_outlined;
    if (type.contains('شقة')) return Icons.apartment_outlined;
    if (type.contains('دور')) return Icons.stairs_outlined;
    if (type.contains('فيلا')) return Icons.villa_outlined;
    if (type.contains('عمارة') || type.contains('مبنى')) return Icons.location_city_outlined;
    if (type.contains('دوبلكس')) return Icons.holiday_village_outlined;
    if (type.contains('استوديو')) return Icons.single_bed_outlined;
    if (type.contains('ارض') || type.contains('أرض')) return Icons.terrain_outlined;
    if (type.contains('سرداب')) return Icons.stairs;
    if (type.contains('مكتب')) return Icons.business_center_outlined;
    if (type.contains('محل')) return Icons.storefront_outlined;
    if (type.contains('معرض')) return Icons.storefront;
    if (type.contains('مخزن') || type.contains('مستودع')) return Icons.warehouse_outlined;
    if (type.contains('مجمع')) return Icons.corporate_fare_outlined;
    return Icons.home_work_outlined;
  }

  Widget _buildPropertyDetailsCard(
      AddAdvertisementCubit cubit, String? type, bool isLand) {
    final bool isFloorOrHouse =
        type == 'دور' || type == 'بيت' || type == 'فيلا' || type == 'عمارة';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorManager.primary.withOpacity(0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_outlined, size: 18.sp, color: ColorManager.primary),
              horizontalSpace(6),
              Text(
                'تفاصيل العقار',
                style: TextStyle(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
            ],
          ),
          verticalSpace(16),
          if (!isLand && isFloorOrHouse) ...[
            if (type != 'دور') ...[
              _PropertyStepper(
                icon: Icons.stairs_outlined,
                label: 'عدد الطوابق',
                controller: cubit.floorsCountController,
                onChanged: (v) => cubit.setFloorsCount(v),
              ),
              verticalSpace(12),
            ],
            _PropertyStepper(
              icon: Icons.bed_outlined,
              label: 'عدد الغرف',
              controller: cubit.roomsController,
            ),
            verticalSpace(12),
            _PropertyStepper(
              icon: Icons.bathtub_outlined,
              label: 'عدد دورات المياه',
              controller: cubit.bathroomsController,
            ),
            verticalSpace(12),
          ],
          if (!isLand && !isFloorOrHouse) ...[
            _PropertyStepper(
              icon: Icons.bed_outlined,
              label: 'عدد الغرف',
              controller: cubit.roomsController,
            ),
            verticalSpace(12),
            _PropertyStepper(
              icon: Icons.bathtub_outlined,
              label: 'عدد دورات المياه',
              controller: cubit.bathroomsController,
            ),
            verticalSpace(12),
          ],
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Icon(Icons.square_foot_outlined,
                    size: 18.sp, color: ColorManager.primary),
              ),
              horizontalSpace(12),
              Expanded(
                child: Text('المساحة',
                    style: TextStyle(fontSize: 13.5.sp, color: Colors.black87)),
              ),
              SizedBox(
                width: 110.w,
                child: TextFormField(
                  controller: cubit.areaController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: 'م²',
                    suffixStyle: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLandTypeSelector(AddAdvertisementCubit cubit) {
    const landTypes = ['زراعية', 'تجارية', 'سكنية', 'صناعية'];
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نوع الأرض',
            style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600),
          ),
          verticalSpace(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: landTypes.map((landType) {
              final bool isSelected = cubit.selectedLandType == landType;
              return GestureDetector(
                onTap: () => cubit.updateLandType(landType),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorManager.primary : Colors.white,
                    border: Border.all(
                      color: isSelected ? ColorManager.primary : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    landType,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
      builder: (context, state) {
        var cubit = context.read<AddAdvertisementCubit>();
        final String? type = cubit.selectedPropertyType;
        final bool isLand = type != null &&
            (type.contains('أرض') || type.contains('ارض'));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل العقار',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            verticalSpace(10),
            _buildPropertyDetailsCard(cubit, type, isLand),
            if (isLand) ...[
              verticalSpace(14),
              _buildLandTypeSelector(cubit),
            ],
            if (!isLand &&
                (type == 'فيلا' || type == 'عمارة' || type == 'مبنى تجاري' ||
                    type == 'مصنع' || type == 'بيت')) ...[
              verticalSpace(20),
              Text('خدمات إضافية',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              verticalSpace(10),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  GestureDetector(
                    onTap: cubit.togglePool,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: cubit.hasPool
                            ? ColorManager.primary.withOpacity(0.1)
                            : Colors.grey[50],
                        border: Border.all(
                          color: cubit.hasPool ? ColorManager.primary : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pool,
                              size: 16.sp,
                              color: cubit.hasPool ? ColorManager.primary : Colors.grey[600]),
                          horizontalSpace(6),
                          Text('مسبح',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: cubit.hasPool ? ColorManager.primary : Colors.black87,
                                fontWeight: cubit.hasPool ? FontWeight.w600 : FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: cubit.toggleGarden,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: cubit.hasGarden
                            ? ColorManager.primary.withOpacity(0.1)
                            : Colors.grey[50],
                        border: Border.all(
                          color: cubit.hasGarden ? ColorManager.primary : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.park,
                              size: 16.sp,
                              color: cubit.hasGarden ? ColorManager.primary : Colors.grey[600]),
                          horizontalSpace(6),
                          Text('حديقة',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: cubit.hasGarden ? ColorManager.primary : Colors.black87,
                                fontWeight: cubit.hasGarden ? FontWeight.w600 : FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: cubit.toggleParking,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: cubit.hasParking
                            ? ColorManager.primary.withOpacity(0.1)
                            : Colors.grey[50],
                        border: Border.all(
                          color: cubit.hasParking ? ColorManager.primary : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_parking,
                              size: 16.sp,
                              color: cubit.hasParking ? ColorManager.primary : Colors.grey[600]),
                          horizontalSpace(6),
                          Text('مواقف',
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: cubit.hasParking ? ColorManager.primary : Colors.black87,
                                fontWeight: cubit.hasParking ? FontWeight.w600 : FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (!_isExchange) ...[
              verticalSpace(24),
              Text(
                _isRent ? 'الإيجار الشهري (د.ك)' : 'السعر الكلي (د.ك)',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              verticalSpace(10),
              AppTextFormField(
                hintText: _isRent ? 'مثال: 350' : AppStrings.priceHint.tr(),
                keyboardType: TextInputType.number,
                controller: cubit.priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.enterPriceError.tr();
                  }
                  return null;
                },
              ),
            ],
            verticalSpace(24),
            Text('العمولة', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            verticalSpace(4),
            Text('يظهر هذا الاختيار بالإعلان كما هو',
                style: TextStyle(fontSize: 11.5.sp, color: Colors.grey[600])),
            verticalSpace(10),
            Row(
              children: [
                Expanded(
                  child: _commissionOption(
                    label: 'عمولة',
                    selected: cubit.commissionChoice == 'with',
                    onTap: () => setState(() => cubit.commissionChoice = 'with'),
                  ),
                ),
                horizontalSpace(8),
                Expanded(
                  child: _commissionOption(
                    label: 'بدون عمولة',
                    selected: cubit.commissionChoice == 'without',
                    onTap: () => setState(() {
                      cubit.commissionChoice = 'without';
                      cubit.commissionController.clear();
                    }),
                  ),
                ),
                horizontalSpace(8),
                Expanded(
                  child: _commissionOption(
                    label: 'عدم ذكر',
                    selected: cubit.commissionChoice == 'unspecified',
                    onTap: () => setState(() {
                      cubit.commissionChoice = 'unspecified';
                      cubit.commissionController.clear();
                    }),
                  ),
                ),
              ],
            ),
            if (cubit.commissionChoice == 'with') ...[
              verticalSpace(10),
              AppTextFormField(
                hintText: 'مثال: 2.5',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: cubit.commissionController,
                validator: (value) {
                  if (cubit.commissionChoice == 'with' && (value == null || value.trim().isEmpty)) {
                    return 'أدخل نسبة العمولة';
                  }
                  return null;
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _commissionOption({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? ColorManager.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(color: selected ? ColorManager.primary : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? ColorManager.primary : Colors.black87,
            )),
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    final cubit = context.read<AddAdvertisementCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'عنوان الإعلان',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        verticalSpace(10),
        TextFormField(
          controller: cubit.titleController,
          maxLength: 80,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            hintText: 'مثال: شقة فاخرة في السالمية',
          ),
          textAlign: TextAlign.right,
        ),
        verticalSpace(16),
        Text(
          AppStrings.adDescription.tr(),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        verticalSpace(6),
        Text(
          'اكتب وصفًا واضحًا وجذابًا يساعد المتصفّح يفهم عقارك بسرعة، مثل الموقع والمميزات وأي تفاصيل تهمّه',
          style: TextStyle(fontSize: 11.5.sp, color: Colors.grey[600], height: 1.5),
        ),
        verticalSpace(10),
        TextFormField(
          controller: cubit.descriptionController,
          maxLines: 5,
          maxLength: 250,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            hintText: 'اكتب وصف تفصيلي للعقار: مثل عدد الغرف، الحالة، المميزات القريبة (مدارس، مسجد)، أو أي معلومة تهم المستفسر',
            hintMaxLines: 3,
          ),
          textAlign: TextAlign.right,
        ),
        verticalSpace(20),
        Text(
          'الميزات',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        verticalSpace(10),
        BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
          builder: (context, state) {
            var cubit = context.read<AddAdvertisementCubit>();
            if (cubit.amenitiesLoading) {
              return const Center(child: AppLoadingIndicator());
            }
            if (cubit.amenities.isEmpty) {
              return const SizedBox.shrink();
            }
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: cubit.amenities.map((amenity) {
                final bool isSelected =
                    cubit.selectedAmenityIds.contains(amenity.id);
                return GestureDetector(
                  onTap: () => cubit.toggleAmenity(amenity.id!),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorManager.primary.withOpacity(0.1)
                          : Colors.grey[50],
                      border: Border.all(
                        color: isSelected
                            ? ColorManager.primary
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          amenityIconFor(amenity.icon),
                          size: 16.sp,
                          color: isSelected
                              ? ColorManager.primary
                              : Colors.grey[600],
                        ),
                        horizontalSpace(6),
                        Text(
                          amenity.name ?? '',
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: isSelected
                                ? ColorManager.primary
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        if (cubit.selectedPropertyType == 'فيلا' || cubit.selectedPropertyType == 'عمارة') ...[
          verticalSpace(10),
          TextFormField(
            controller: cubit.extraFeaturesController,
            maxLines: 2,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              hintText: 'اكتب أي ميزة إضافية غير موجودة بالقائمة (مثال: حديقة، شرفة كبيرة)',
              hintStyle: TextStyle(fontSize: 12.sp),
            ),
            textAlign: TextAlign.right,
          ),
        ],
        verticalSpace(20),
        Text(
          AppStrings.uploadPhotos.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        verticalSpace(10),
        BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
          builder: (context, state) {
            var cubit = context.read<AddAdvertisementCubit>();
            return GestureDetector(
              onTap: () => cubit.showImageSource(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: cubit.selectedImage != null
                    ? Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              cubit.selectedImage!,
                              height: 160.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => cubit.showImageSource(context),
                              child: Container(
                                padding: EdgeInsets.all(6.h),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.cloud_upload_outlined,
                              size: 30.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          verticalSpace(10),
                          Text(
                            AppStrings.clickToUpload.tr(),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
        verticalSpace(20),
      ],
    );
  }
}

class _PropertyStepper extends StatefulWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final ValueChanged<int>? onChanged;

  const _PropertyStepper({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.onChanged,
  });

  @override
  State<_PropertyStepper> createState() => _PropertyStepperState();
}

class _PropertyStepperState extends State<_PropertyStepper> {
  int get _value => int.tryParse(widget.controller.text) ?? 0;

  void _update(int newValue) {
    if (newValue < 0) return;
    setState(() => widget.controller.text = newValue.toString());
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(widget.icon, size: 18.sp, color: ColorManager.primary),
        ),
        horizontalSpace(12),
        Expanded(
          child: Text(widget.label,
              style: TextStyle(fontSize: 13.5.sp, color: Colors.black87)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => _update(_value - 1),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(Icons.remove, size: 16.sp, color: ColorManager.primary),
                ),
              ),
              SizedBox(
                width: 28.w,
                child: Text(
                  '$_value',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => _update(_value + 1),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(Icons.add, size: 16.sp, color: ColorManager.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
