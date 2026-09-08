import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import '../../../../../../core/routing/routes.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: AppStrings.alreadyHaveAccount.tr(),
            style: StylesManager.font13Grey,
          ),
          TextSpan(
            text: AppStrings.loginNow.tr(),
            style: StylesManager.font25PrimaryBold.copyWith(fontSize: 17.sp),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.pushReplacementNamed(Routes.loginRoute);
              },
          ),
        ],
      ),
    );
  }
}
