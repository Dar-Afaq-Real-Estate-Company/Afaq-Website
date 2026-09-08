import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/network/api_error_model.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/styles_manager.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/app_loading_indicator.dart';
import '../../../../logic/cubit_cubit.dart';
import '../../../../logic/cubit_state.dart';

class ForgotPasswordBloclistener extends StatelessWidget {
  const ForgotPasswordBloclistener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) =>
          current is ForgotPasswordLoading ||
          current is ForgotPasswordSuccess ||
          current is ForgotPasswordError,
      listener: (context, state) {
        state.whenOrNull(
          forgotPasswordLoading: () {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: AppLoadingIndicator(),
              ),
            );
          },
          forgotPasswordSuccess: (forgotPassworfResponse) {
            context.pop();

            context.pushNamed(
              Routes.otpRoute,
              arguments:
                  context.read<ForgotPasswordCubit>().emailController.text,
            );
          },
          forgotPasswordError: (apiErrorModel) {
            setupErrorState(context, apiErrorModel);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void setupErrorState(BuildContext context, ApiErrorModel apiErrorModel) {
    context.pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 32,
        ),
        content: Text(
          apiErrorModel.message ?? 'Unknown error',
          style: StylesManager.font24Black700Weight,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              'Got it',
              style: StylesManager.font14Grey,
            ),
          ),
        ],
      ),
    );
  }
}
