// Helper method to build filter dropdowns
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BlocBuilder<FilterCubit, FilterState>(
              buildWhen: (previous, current) => true, // يضمن تحديث الـ Dropdown
              builder: (context, state) {
                var addCubit = context.read<AddAdvertisementCubit>();
                if (addCubit.propertyTypes.isEmpty) {
                  // Call getPropertyTypes if not loaded
                  addCubit.getPropertyTypes();
                }
                return buildFilterDropdown(
                  label: AppStrings.propertyCategory.tr(),
                  value: context.read<FilterCubit>().currentTransactionType,
                  items: addCubit.propertyTypes,
                  onChanged: (value) {
                    context
                        .read<FilterCubit>()
                        .getAdsSearch(transactionType: value);
                  },
                );
              },
            ),
          ),
          horizontalSpace(5),
          Expanded(
            child: BlocBuilder<FilterCubit, FilterState>(
              builder: (context, state) {
                var addCubit = context.read<AddAdvertisementCubit>();
                if (addCubit.regions.isEmpty) {
                  addCubit.getRegions();
                  return buildFilterDropdown(
                    label: AppStrings.region.tr(),
                    value: null,
                    items: [],
                    onChanged: (value) {},
                  );
                }
                return buildFilterDropdown(
                  label: AppStrings.region.tr(),
                  value: context.read<FilterCubit>().currentRegion,
                  items: addCubit.regions,
                  onChanged: (value) {
                    context.read<FilterCubit>().getAdsSearch(region: value);
                  },
                );
              },
            ),
          ),
          horizontalSpace(5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color: ColorManager.primary,
                size: 20.sp,
              ),
              onPressed: () {
                context.read<FilterCubit>().clearFilters();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildFilterDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(label, style: StylesManager.font12GrayRegular),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        isExpanded: true,
        style: TextStyle(color: Colors.black87, fontSize: 13.sp),
        onChanged: onChanged,
        items: items.toSet().map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              //  textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          );
        }).toList(),
      ),
    ),
  );
}
