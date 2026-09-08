import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../logic/cubit_cubit.dart';
import '../widgets/dont_have_account_text.dart';
import '../widgets/email_and_password.dart';
import '../widgets/login_bloc_listener.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isObscureText = true;
  void validateThenDoLogin(BuildContext context) {
    if (context.read<LoginCubit>().formKey.currentState!.validate()) {
      context.read<LoginCubit>().emitLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(70),
                Text(
                  AppStrings.welcomeBack.tr(),
                  style: StylesManager.font25PrimaryBold,
                ),
                verticalSpace(8),
                Text(
                  AppStrings.loginWelcomeMessage.tr(),
                  style: StylesManager.font13Grey,
                ),
                verticalSpace(36),
                Column(
                  children: [
                    verticalSpace(18),
                    const PhoneAndPassword(),
                    verticalSpace(24),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          Routes.forgotPasswordRoute,
                        );
                      },
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          AppStrings.forgotPassword.tr(),
                          style: StylesManager.font13Grey.copyWith(
                            decoration: TextDecoration.underline,
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(24),
                    AppTextButton(
                      buttonText: AppStrings.loginNow.tr(),
                      textStyle: StylesManager.font16White,
                      onPressed: () {
                        validateThenDoLogin(context);
                      },
                    ),
                    verticalSpace(24),
                    const DontHaveAccountText(),
                    const LoginBlocListener(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
