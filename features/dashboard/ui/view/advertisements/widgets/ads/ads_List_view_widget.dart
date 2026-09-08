import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../data/response/response.dart';
import 'ads.dart';

class AdsListViewWidget extends StatelessWidget {
  final List<AdModel?> adsDataResponseList;
  const AdsListViewWidget({
    super.key,
    required this.adsDataResponseList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: adsDataResponseList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 0.9.sw,
          child: AdCard(adsData: adsDataResponseList[index]),
        );
      },
    );
  }
}
