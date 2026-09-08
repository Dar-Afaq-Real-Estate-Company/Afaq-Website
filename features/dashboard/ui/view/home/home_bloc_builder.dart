import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/app_loading_indicator.dart';
import '../../../data/response/response.dart';
import '../../../logic/home_cubit.dart';
import '../../../logic/home_state.dart';
import '../../widgets/home_list_view.dart';

class HomeBlocBuilder extends StatelessWidget {
  const HomeBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is VipAdsSuccess ||
          current is VipAdsError ||
          current is VipAdsLoading,
      builder: (context, state) {
        return state.maybeWhen(
          vipAdsSuccess: (homeList) {
            return setupSuccess(homeList);
          },
          vipAdsLoading: () {
            return const Center(
              child: AppLoadingIndicator(),
            );
          },
          vipAdsError: (apiErrorModel) => setupError(apiErrorModel),
          orElse: () {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget setupSuccess(HomeResponse homeList) {
    return HomeListView(
      vipAdsDataResponseList: homeList.vipAds ?? [],
    );
  }

  Widget setupError(dynamic apiErrorModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'خطأ في تحميل المشاريع المميزة: ${apiErrorModel?.message ?? apiErrorModel}',
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
