import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'account_type_field.dart';
import 'license_upload_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/app_regex.dart';
import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/widgets/app_text_form_field.dart';
import '../../../../logic/cubit_cubit.dart';
import '../../../../../../core/helper/excluded_countries.dart';
import 'dart:ui' as ui;

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  bool isPasswordObscureText = true;
  bool isPasswordConfirmationObscureText = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<RegisterCubit>().formKey,
      child: Column(
        children: [
          // === نوع الحساب: يحدّد ترتيب التطبيق بعد الدخول
          const AccountTypeField(),
          // === رفع الرخصة: يظهر للمكتب العقاري فقط
          const LicenseUploadField(),
          verticalSpace(18),
          const _GenderField(),
          verticalSpace(18),
          ValueListenableBuilder<String>(
            valueListenable: context.read<RegisterCubit>().accountTypeNotifier,
            builder: (context, type, _) {
              final isOffice = type == 'office' || type == 'engineering_office';
              if (isOffice) {
                // === مكتب/شركة عقارية أو مكتب هندسي: اسم المنشأة فقط، بدون اسم عائلة
                context.read<RegisterCubit>().lastNameController.text = '';
              }
              return Column(
                children: [
                  AppTextFormField(
                    hintText: isOffice
                        ? (type == 'engineering_office'
                            ? AppStrings.getString('engineering_office_name', context.locale.languageCode)
                            : AppStrings.getString('company_name_field', context.locale.languageCode))
                        : AppStrings.firstName.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.validNameError.tr();
                      }
                    },
                    controller:
                        context.read<RegisterCubit>().firstNameController,
                  ),
                  if (!isOffice) ...[
                    verticalSpace(18),
                    AppTextFormField(
                      hintText: AppStrings.lastName.tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.validNameError.tr();
                        }
                      },
                      controller:
                          context.read<RegisterCubit>().lastNameController,
                    ),
                  ],
                ],
              );
            },
          ),
          verticalSpace(18),
          AppTextFormField(
            hintText: AppStrings.email.tr(),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value)) {
                return AppStrings.validEmailError.tr();
              }
            },
            controller: context.read<RegisterCubit>().emailController,
          ),
          verticalSpace(18),
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
                        context.read<RegisterCubit>().countryDialCode =
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
                    // if (!AppRegex.isPhoneNumberValid(value)) {
                    //   return AppStrings.validPhoneError.tr();
                    // }

                    // return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // LengthLimitingTextInputFormatter(10),
                  ],
                  controller: context.read<RegisterCubit>().phoneController,
                ),
              ),
            ],
          ),
          verticalSpace(18),
          AppTextFormField(
            controller: context.read<RegisterCubit>().passwordController,
            hintText: AppStrings.password.tr(),
            isObscureText: isPasswordObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordObscureText = !isPasswordObscureText;
                });
              },
              child: Icon(
                isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.validPasswordError.tr();
              }
            },
          ),
          verticalSpace(18),
          AppTextFormField(
            controller:
                context.read<RegisterCubit>().passwordConfirmationController,
            hintText: AppStrings.passwordConfirmation.tr(),
            isObscureText: isPasswordConfirmationObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordConfirmationObscureText =
                      !isPasswordConfirmationObscureText;
                });
              },
              child: Icon(
                isPasswordConfirmationObscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.validPasswordError.tr();
              }
            },
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}

/// حقل "الجنس" — شارتين تفاعليتين ملوّنتين (أزرق للذكر، وردي للأنثى)
class _GenderField extends StatelessWidget {
  const _GenderField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return ValueListenableBuilder<String?>(
      valueListenable: cubit.genderNotifier,
      builder: (context, selected, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: AppStrings.getString('gender_label', context.locale.languageCode),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF344054),
                ),
                children: [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                ],
              ),
            ),
            verticalSpace(8),
            Row(
              children: [
                Expanded(
                  child: _genderOption(
                    context,
                    value: 'male',
                    label: '👨 ${AppStrings.getString('gender_male', context.locale.languageCode)}',
                    color: const Color(0xFF4F8FE0),
                    selected: selected == 'male',
                    onTap: () => cubit.gender = 'male',
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: _genderOption(
                    context,
                    value: 'female',
                    label: '👩 ${AppStrings.getString('gender_female', context.locale.languageCode)}',
                    color: const Color(0xFFE8639A),
                    selected: selected == 'female',
                    onTap: () => cubit.gender = 'female',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _genderOption(
    BuildContext context, {
    required String value,
    required String label,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? color : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: selected ? color : const Color(0xFFE4E7EC), width: 1.4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF667085),
          ),
        ),
      ),
    );
  }
}
