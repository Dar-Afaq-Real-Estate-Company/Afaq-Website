import 'dart:async';

import 'package:afaq_real_estate/core/di/di.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/resources/styles_manager.dart';
import '../../core/widgets/app_text_button.dart';
import '../../core/widgets/app_text_form_field.dart';
// TODO: عدّل هذا المسار حسب مكان الملف اللي أرسلته لك سابقاً (price_range_slider.dart)
import '../../core/widgets/price_range_slider.dart';
import '../../core/widgets/region_picker_sheet.dart';
import '../dashboard/logic/home_cubit.dart';
import '../dashboard/logic/home_state.dart';
import 'widget/search_blocBuilder.dart';

import '../../core/widgets/app_loading_indicator.dart';
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // مؤقت الـ debounce المستخدم لكل حقول البحث (نصي + سعر)
  Timer? _debounce;

  // قيم السعر الحالية لعرضها بالشريط - عدّل الحد الأقصى المناسب لسوقك
  static const double _priceMin = 0;
  static const double _priceMax = 5000;
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 5000;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// ينفذ البحث فوراً - نفس المنطق اللي كان بزر "بحث"
  void _runSearch(BuildContext context) {
    final addCubit = context.read<AddAdvertisementCubit>();
    final searchCubit = context.read<SearchFilterCubit>();

    searchCubit.getSearchFilter(
      addCubit.selectedPropertyTypes.isEmpty
          ? null
          : addCubit.selectedPropertyTypes,
      addCubit.selectedRegions.isEmpty ? null : addCubit.selectedRegions,
      searchCubit.transactionType.text.isEmpty
          ? null
          : searchCubit.transactionType.text,
      searchCubit.priceRange.text.isEmpty ? null : searchCubit.priceRange.text,
    );
  }

  /// يأخّر تنفيذ البحث 350ms بعد آخر تغيير - هذا اللي يخلي البحث يحس "سريع"
  /// بدون ما يبحث مع كل حرف/حركة (يقلل عدد النداءات على السيرفر)
  void _debouncedSearch(BuildContext context) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di<SearchFilterCubit>(),
        ),
        BlocProvider(
          create: (context) => di<AddAdvertisementCubit>()
            ..getPropertyTypes()
            ..getRegions(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // العملة تتغيّر تلقائياً حسب لغة التطبيق الحالية (عربي/إنجليزي)
          final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
          final String currency = isAr ? 'د.ك' : 'KWD';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Transaction Type / خانة البحث السريع
                    Text(
                      'transaction_type'.tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    verticalSpace(10),
                    AppTextFormField(
                      hintText: "",
                      controller:
                      context.read<SearchFilterCubit>().transactionType,
                      validator: (String) {},
                      // فوري: كل حرف يكتبه المستخدم يشغّل مؤقت البحث المؤجل
                      onChanged: (_) => _debouncedSearch(context),
                    ),
                    verticalSpace(10),

                    /// ================= Property Types =================
                    Text(
                      AppStrings.propertyType.tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    verticalSpace(10),
                    BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
                      builder: (context, state) {
                        final cubit = context.read<AddAdvertisementCubit>();

                        if (state is PropertyTypesLoading) {
                          return const Center(
                              child: AppLoadingIndicator());
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () =>
                                  _showPropertyTypesDialog(context, cubit),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: ColorManager.lightGrey),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cubit.selectedPropertyTypes.isEmpty
                                            ? AppStrings.none.tr()
                                            : cubit.selectedPropertyTypes
                                            .join(', '),
                                        style: StylesManager.font14Grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        color: ColorManager.primary),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    /// ================= Regions =================
                    verticalSpace(10),
                    Text(
                      AppStrings.region.tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    verticalSpace(10),
                    BlocBuilder<AddAdvertisementCubit, AddAdvertisementState>(
                      builder: (context, state) {
                        final cubit = context.read<AddAdvertisementCubit>();

                        if (state is RegionsLoading) {
                          return const Center(
                              child: AppLoadingIndicator());
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpace(8),
                            InkWell(
                              onTap: () async {
                                final result = await showRegionsMultiPickerSheet(
                                  context,
                                  regions: cubit.regions,
                                  selected: cubit.selectedRegions,
                                );
                                if (result != null) {
                                  cubit.setSelectedRegions(result);
                                  setState(() {});
                                  _debouncedSearch(context);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border:
                                  Border.all(color: ColorManager.lightGrey),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cubit.selectedRegions.isEmpty
                                            ? AppStrings.none.tr()
                                            : cubit.selectedRegions.join(', '),
                                        style: StylesManager.font14Grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.location_on_outlined,
                                        color: Colors.green),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    /// ================= Price (الآن شريط نطاق بدل الحقل النصي) =================
                    verticalSpace(16),
                    Text(
                      AppStrings.price.tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    verticalSpace(8),
                    PriceRangeSlider(
                      min: _priceMin,
                      max: _priceMax,
                      step: 50,
                      initialMin: _selectedMinPrice,
                      initialMax: _selectedMaxPrice,
                      currencyLabel: currency,
                      onChanged: (minVal, maxVal) {
                        _selectedMinPrice = minVal;
                        _selectedMaxPrice = maxVal;

                        // إذا وصل الحد الأعلى لأقصى قيمة بالشريط (5000)،
                        // معناها "بدون سقف" - نرسل بدون رقم أعلى بدل ما نحصر النتائج بـ 5000 بالضبط
                        final bool isUncapped = maxVal.round() >= _priceMax.round();
                        final String priceFilterText = isUncapped
                            ? '${minVal.round()}+' // مثال: "5000+" = 5000 فأكثر
                            : '${minVal.round()}-${maxVal.round()}';

                        // نحدّث نفس الـ controller اللي يستخدمه الـ Cubit حالياً
                        // عدّل الصيغة حسب ما يتوقعه السيرفر عندك بالضبط
                        context.read<SearchFilterCubit>().priceRange.text =
                            priceFilterText;
                        // البحث يصير تلقائي بعد ما يفلت المستخدم المقبض ويرتد
                        _debouncedSearch(context);
                      },
                    ),

                    verticalSpace(20),

                    /// ================= Button (اختياري - تقدر تحذفه بما إن البحث صار تلقائي) =================
                    BlocBuilder<SearchFilterCubit, SearchFilterState>(
                      builder: (context, state) {
                        final isLoading = state is SearchFilterLoading;

                        return SizedBox(
                          width: double.infinity,
                          child: AppTextButton(
                            buttonText: isLoading ? "جاري البحث..." : "بحث",
                            textStyle: StylesManager.font16White,
                            onPressed:
                            isLoading ? null : () => _runSearch(context),
                          ),
                        );
                      },
                    ),

                    /// ================= Results =================
                    SingleChildScrollView(child: SearchBlocbuilder()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPropertyTypesDialog(
      BuildContext context, AddAdvertisementCubit cubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(AppStrings.propertyType.tr(),
                  textAlign: TextAlign.right),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cubit.propertyTypes.length,
                  itemBuilder: (context, index) {
                    final type = cubit.propertyTypes[index];
                    final isSelected =
                    cubit.selectedPropertyTypes.contains(type);

                    return CheckboxListTile(
                      title: Text(type),
                      value: isSelected,
                      activeColor: ColorManager.primary,
                      onChanged: (bool? value) {
                        cubit.togglePropertyType(type);
                        setDialogState(() {});
                        setState(() {});
                        // نبحث تلقائي كمان لما يغيّر نوع العقار
                        _debouncedSearch(context);
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("تم"),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
