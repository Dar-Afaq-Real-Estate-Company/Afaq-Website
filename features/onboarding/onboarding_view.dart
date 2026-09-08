import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helper/spacing.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/resources/styles_manager.dart';
import '../../core/routing/routes.dart';
import '../../core/widgets/app_text_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  verticalSpace(10),
                  Image.asset(
                    'assets/images/splash_image.png',
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                  verticalSpace(30),
                  Text(
                    AppStrings.onboardingTitle.tr(),
                    textAlign: TextAlign.center,
                    style: StylesManager.font12GrayRegular,
                  ),
                  verticalSpace(15),
                  Text(
                    AppStrings.onboardingSubTitle.tr(),
                    textAlign: TextAlign.center,
                    style: StylesManager.font13Grey.copyWith(fontSize: 16.sp),
                  ),
                  verticalSpace(50),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20.0.h),
              child: AppTextButton(
                buttonText: AppStrings.getStarted.tr(),
                textStyle: StylesManager.font16White,
                onPressed: () {
                  context.pushNamed(Routes.loginRoute);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
