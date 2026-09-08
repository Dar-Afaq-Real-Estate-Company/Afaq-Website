import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helper/constants.dart';
import '../../../../../../core/helper/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../logic/cubit_cubit.dart';
import '../../../../logic/cubit_state.dart';

class RegisterpBlocListener extends StatelessWidget {
  const RegisterpBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) =>
          current is RegisterLoading ||
          current is RegisterSuccess ||
          current is RegisterError,
      listener: (context, state) {
        state.whenOrNull(
          registerLoading: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                ),
              ),
            );
          },
          registerSuccess: (registerResponse) {
            SharedPrefHelper.setData(
              SharedPrefKeys.accountType,
              context.read<RegisterCubit>().accountType,
            );

            context.pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء الحساب بنجاح'),
              ),
            );

            context.pushReplacementNamed(
              Routes.loginRoute,
            );
          },

          registerError: (apiErrorModel) {
            context.pop();
            setupErrorState(context, apiErrorModel.message ?? "");
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void setupErrorState(BuildContext context, String error) {
    String userFriendlyMessage = error;
    final lower = error.toLowerCase();

    if (error.contains("users_phone_unique") ||
        error.contains("Duplicate entry") ||
        (lower.contains("phone") && (lower.contains("taken") || lower.contains("duplicate") || lower.contains("unique")))) {
      userFriendlyMessage = "رقم الهاتف هذا مسجل مسبقاً، يرجى استخدام رقم آخر.";
    } else if (error.contains("users_email_unique") ||
        (lower.contains("email") && (lower.contains("taken") || lower.contains("duplicate") || lower.contains("unique")))) {
      userFriendlyMessage = "البريد الإلكتروني مستخدم بالفعل.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          userFriendlyMessage,
          style: StylesManager.font13Grey.copyWith(color: ColorManager.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
