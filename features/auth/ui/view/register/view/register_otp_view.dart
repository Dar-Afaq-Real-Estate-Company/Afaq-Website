import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/extensions.dart';
import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import 'dart:ui' as ui;

import '../../../../logic/cubit_cubit.dart';
import '../widgets/register_otp_bloc_listener.dart';

class RegisterOtpView extends StatefulWidget {
  final String phone;
  final String email;
  const RegisterOtpView({super.key, required this.phone, required this.email});

  @override
  State<RegisterOtpView> createState() => _RegisterOtpViewState();
}

class _RegisterOtpViewState extends State<RegisterOtpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(70),
                Text(
                  AppStrings.verificationCodeTitle.tr(),
                  style: StylesManager.font25PrimaryBold,
                ),
                verticalSpace(8),
                Text(
                  "${AppStrings.verificationCodeSentTo.tr()}  ${widget.email}",
                  style: StylesManager.font13Grey,
                ),
                verticalSpace(36),
                Builder(builder: (newContext) {
                  return Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: OtpTextField(
                      numberOfFields: 6,
                      fieldWidth: 45.0.w,
                      borderRadius: BorderRadius.circular(12.r),
                      borderColor: ColorManager.primary,
                      showFieldAsBox: true,
                      autoFocus: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        String englishCode =
                            convertArabicToEnglish(verificationCode).trim();
                        String? parsedCode = (englishCode);
                        newContext
                            .read<VerifyCodeRegisterCubit>()
                            .emitVerifyCodeRegister(
                              code: parsedCode,
                              phone: widget.phone,
                            );
                      },
                    ),
                  );
                }),
                verticalSpace(30),
                RegisterOtpBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
