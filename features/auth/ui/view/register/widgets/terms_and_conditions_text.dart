import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: AppStrings.byLoggingAgree.tr(),
            style: StylesManager.font13Grey,
          ),
          TextSpan(
            text: AppStrings.termsConditions.tr(),
            style: StylesManager.font14Grey,
          ),
          TextSpan(
            text: AppStrings.and.tr(),
            style: StylesManager.font13Grey.copyWith(height: 1.5),
          ),
          TextSpan(
            text: AppStrings.privacyPolicy.tr(),
            style: StylesManager.font14Grey,
          ),
        ],
      ),
    );
  }
}
