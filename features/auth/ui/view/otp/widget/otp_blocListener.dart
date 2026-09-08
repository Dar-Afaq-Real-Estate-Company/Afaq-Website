import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../logic/cubit_cubit.dart';
import '../../../../logic/cubit_state.dart';

class OtpBloclistener extends StatelessWidget {
  final String email;
  const OtpBloclistener({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCodeCubit, VerifyCodeState>(
      listenWhen: (previous, current) =>
          current is VerifyCodeLoading ||
          current is VerifyCodeSuccess ||
          current is VerifyCodeError,
      listener: (context, state) {
        state.whenOrNull(
          verifyCodeLoading: () {
            showDialog(
              context: context,
              builder: (context) => Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                ),
              ),
            );
          },
          verifyCodeSuccess: (response) {
            context.pop();
            context.pushNamed(
              Routes.resetPasswordRoute,
              arguments: email,
            );
          },
          verifyCodeError: (apiErrorModel) {
            setupErrorState(context, apiErrorModel);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
