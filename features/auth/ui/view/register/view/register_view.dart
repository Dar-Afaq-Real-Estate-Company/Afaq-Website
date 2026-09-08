import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../logic/cubit_cubit.dart';
import '../widgets/already_have_account_text.dart';
import '../widgets/form_register.dart';
import '../widgets/register_bloc_listener.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isObscureText = true;
  bool _acceptedTerms = false;

  void validateThenDoRegister(BuildContext context) {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.mustAcceptTerms.tr())),
      );
      return;
    }
    if (context.read<RegisterCubit>().formKey.currentState!.validate()) {
      context.read<RegisterCubit>().emitRegister();
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
                verticalSpace(30),
                Text(
                  AppStrings.createAccount.tr(),
                  style: StylesManager.font25PrimaryBold,
                ),
                verticalSpace(8),
                Text(
                  AppStrings.registerWelcomeMessage.tr(),
                  style: StylesManager.font13Grey,
                ),
                verticalSpace(20),
                Column(
                  children: [
                    verticalSpace(18),
                    const FormRegister(),
                    verticalSpace(14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: Checkbox(
                            value: _acceptedTerms,
                            onChanged: (v) =>
                                setState(() => _acceptedTerms = v ?? false),
                          ),
                        ),
                        horizontalSpace(6),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                                () => _acceptedTerms = !_acceptedTerms),
                            child: Text.rich(
                              TextSpan(
                                text: AppStrings.byLoggingAgree.tr() + ' ',
                                style: StylesManager.font13Grey,
                                children: [
                                  TextSpan(
                                    text: AppStrings.termsConditions.tr(),
                                    style: StylesManager.font13Grey.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, Routes.privacyRoute),
                                  ),
                                  TextSpan(
                                    text: ' ${AppStrings.and.tr()} ',
                                    style: StylesManager.font13Grey,
                                  ),
                                  TextSpan(
                                    text: AppStrings.privacyPolicy.tr(),
                                    style: StylesManager.font13Grey.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, Routes.privacyRoute),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    AppTextButton(
                      buttonText: AppStrings.registerButton.tr(),
                      textStyle: StylesManager.font16White,
                      onPressed: () {
                        validateThenDoRegister(context);
                      },
                    ),
                    verticalSpace(30),
                    const AlreadyHaveAccountText(),
                    RegisterpBlocListener(),
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
