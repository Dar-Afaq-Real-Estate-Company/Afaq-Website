import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/widgets/app_text_form_field.dart';
import '../../../../logic/cubit_cubit.dart';
import '../../../../../../core/helper/excluded_countries.dart';
import 'dart:ui' as ui;

class PhoneAndPassword extends StatefulWidget {
  const PhoneAndPassword({super.key});

  @override
  State<PhoneAndPassword> createState() => _PhoneAndPasswordState();
}

class _PhoneAndPasswordState extends State<PhoneAndPassword> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Container(
                    height: 47.h,
                    decoration: BoxDecoration(
                      color: ColorManager.lighterGray,
                      borderRadius: BorderRadius.circular(16.0.r),
                    ),
                    child: CountryCodePicker(
                      initialSelection: '+965',
                      showFlagMain: true,
                      showFlagDialog: true,
                      hideMainText: false,
                      alignLeft: false,
                      padding: EdgeInsets.zero,
                      countryFilter: excludedCountryCodes,
                      onChanged: ((countryCode) {
                        context.read<LoginCubit>().countryDialCode =
                            countryCode.dialCode ?? "+965";
                        print("Selected code without plus: $countryCode");
                      }),
                    ),
                  ),
                ),
              ),
              horizontalSpace(5),
              Expanded(
                flex: 5,
                child: AppTextFormField(
                  hintText: AppStrings.phoneNumber.tr(),
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.validPhoneError.tr();
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // LengthLimitingTextInputFormatter(10),
                  ],
                  controller: context.read<LoginCubit>().phoneController,
                ),
              ),
            ],
          ),
          // AppTextFormField(
          //   hintText: AppStrings.phoneNumber.tr(),
          //   keyboardType: TextInputType.phone,
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return AppStrings.phoneValidationEmpty.tr();
          //     }
          //     if (!AppRegex.isPhoneNumberValid(value)) {
          //       return AppStrings.validPhoneError.tr();
          //     }

          //     return null;
          //   },
          //   inputFormatters: [
          //     FilteringTextInputFormatter.digitsOnly,
          //     LengthLimitingTextInputFormatter(10),
          //   ],
          //   controller: context.read<LoginCubit>().phoneController,
          // ),
          verticalSpace(18),
          AppTextFormField(
            controller: context.read<LoginCubit>().passwordController,
            hintText: AppStrings.password.tr(),
            isObscureText: isObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.passwordValidationEmpty.tr();
              }
            },
          ),
        ],
      ),
    );
  }
}
