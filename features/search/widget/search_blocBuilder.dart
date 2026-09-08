import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../dashboard/data/response/response.dart';
import '../../dashboard/logic/home_cubit.dart';
import '../../dashboard/logic/home_state.dart';
import 'search_List_view_widget.dart';




import '../../../core/widgets/app_loading_indicator.dart';
class SearchBlocbuilder extends StatelessWidget {
  const SearchBlocbuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchFilterCubit, SearchFilterState>(
      buildWhen: (previous, current) =>
          current is SearchFilterSuccess ||
          current is SearchFilterError ||
          current is SearchFilterLoading,
      builder: (context, state) {
        return state.maybeWhen(
          searchFilterSuccess: (searchFilterResponse) {
            return setupSuccess(searchFilterResponse);
          },
          searchFilterLoading: () {
            return const Center(
              child: AppLoadingIndicator(),
            );
          },
          searchFilterError: (apiErrorModel) => setupError(),
          orElse: () {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget setupSuccess(SearchFilterResponse  searchFilterResponse ) {
    if (searchFilterResponse.data!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60.sp, color: ColorManager.primary),
            SizedBox(height: 10.h),
            Text(
              AppStrings.noResultsMatchYourSearchCurrently.tr(),
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
            ),
          ],
        ),
      );
    }
    return SearchListViewWidget(
      searchFilterData: searchFilterResponse.data ?? [],
    );
  }

  Widget setupError() {
    return const SizedBox.shrink();
  }
}

















// class SearchFilterBlocbuilder extends StatelessWidget {
//   const SearchFilterBlocbuilder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       buildWhen: (previous, current) =>
//           current is SearchFilterSuccess||
//           current is SearchFilterError ||
//           current is SearchFilterLoading,
//       builder: (context, state) {
//         return state.maybeWhen(
//           : (searchFilterList) {
//             return setupSuccess(searchFilterList);
//           },
//           searchFilterLoading: () {
//             return const Center(
//               child: AppLoadingIndicator(),
//             );
//           },
//           searchFilterError: (apiErrorModel) => setupError(),
//           orElse: () {
//             return const Center(child: AppLoadingIndicator());
//           },
//         );
//       },
//     );
//   }

//   Widget setupSuccess(SearchFilterResponse searchFilterList) {
//     return AutionWidget(
//       auctionDataList: searchFilterList.data ?? [],
//     );
//   }

//   Widget setupError() {
//     return const SizedBox.shrink();
//   }
// }
