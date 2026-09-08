import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/spacing.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/resources/styles_manager.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../../../logic/cubit_cubit.dart';
import 'widgets/forgot_password_BlocListener.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    super.key,
  });

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  void validateThenDoaSendCode(BuildContext context) {
    if (context.read<ForgotPasswordCubit>().formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().emitForgotPassword();
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
                  AppStrings.verificationTitle.tr(),
                  style: StylesManager.font25PrimaryBold,
                ),
                verticalSpace(8),
                Text(
                  AppStrings.verificationMessage.tr(),
                  style: StylesManager.font13Grey,
                ),
                verticalSpace(36),
                Form(
                  key: context.read<ForgotPasswordCubit>().formKey,
                  child: Column(
                    children: [
                      verticalSpace(18),
                      AppTextFormField(
                        hintText: AppStrings.email.tr(),
                        validator: (value) {},
                        controller:
                            context.read<ForgotPasswordCubit>().emailController,
                      ),
                      verticalSpace(24),
                      AppTextButton(
                        buttonText: AppStrings.sendButton.tr(),
                        textStyle: StylesManager.font16White,
                        onPressed: () {
                          validateThenDoaSendCode(context);
                        },
                      ),
                      verticalSpace(24),
                      const ForgotPasswordBloclistener(),
                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
