import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import '../../../../../../core/routing/routes.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.registerRoute),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.dontHaveAccount.tr(),
              style: StylesManager.font13Grey,
            ),
            TextSpan(
              text: AppStrings.registerNow.tr(),
              style: StylesManager.font25PrimaryBold.copyWith(fontSize: 17.sp),
            ),
          ],
        ),
      ),
    );
  }
}
