import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/extensions.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../logic/cubit_cubit.dart';
import '../../../../logic/cubit_state.dart';

class RegisterOtpBlocListener extends StatelessWidget {
  const RegisterOtpBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCodeRegisterCubit, VerifyCodeRegisterState>(
      listenWhen: (previous, current) =>
          current is VerifyCodeRegisterLoading ||
          current is VerifyCodeRegisterSuccess ||
          current is VerifyCodeRegisterError,
      listener: (context, state) {
        state.whenOrNull(
          verifyCodeRegisterLoading: () {
            showDialog(
              context: context,
              builder: (context) => Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                ),
              ),
            );
          },
          verifyCodeRegisterSuccess: (response) {
            context.pop();
            context.pushNamedAndRemoveUntil(
              Routes.loginRoute,
              predicate: (Route<dynamic> route) => false,
            );
          },
          verifyCodeRegisterError: (apiErrorModel) {
            setupErrorState(context, apiErrorModel);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
