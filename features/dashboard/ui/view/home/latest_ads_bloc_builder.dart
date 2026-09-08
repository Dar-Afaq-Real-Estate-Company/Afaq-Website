import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/response/response.dart';
import '../../../logic/home_cubit.dart';
import '../../../logic/home_state.dart';
import '../../widgets/latest_ads_list_view.dart';

/// نفس نمط HomeBlocBuilder بالضبط، بس يستمع لحالات allAds بدل vipAds
/// (يعتمد على HomeCubit.getAllAds() الموجودة أصلاً - ما احتجنا API جديد)
class LatestAdsBlocBuilder extends StatelessWidget {
  /// كلمة مفتاحية لنوع المعاملة (بيع/يجار/بدل)، أو null لعرض الكل
  final String? transactionFilter;

  const LatestAdsBlocBuilder({super.key, this.transactionFilter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is AllAdsSuccess ||
          current is AllAdsError ||
          current is AllAdsLoading,
      builder: (context, state) {
        return state.maybeWhen(
          allAdsSuccess: (adsResponse) {
            return setupSuccess(adsResponse);
          },
          allAdsLoading: () {
            return SizedBox(
              height: 290,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          },
          allAdsError: (apiErrorModel) => setupError(),
          orElse: () {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget setupSuccess(AdsResponse adsResponse) {
    final all = adsResponse.allAds ?? [];
    // === نفلتر محليًا حسب نوع المعاملة المختار بالشريط أعلى الصفحة
    final filtered = transactionFilter == null
        ? all
        : all
            .where((ad) =>
                (ad?.transactionType ?? '').contains(transactionFilter!))
            .toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'ما فيه إعلانات بهذا التصنيف',
            style: TextStyle(fontSize: 13.5.sp, color: Colors.grey),
          ),
        ),
      );
    }

    return LatestAdsListView(adsList: filtered);
  }

  Widget setupError() {
    return const SizedBox.shrink();
  }
}
