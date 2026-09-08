import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:afaq_real_estate/features/dashboard/data/response/response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/network/api_error_model.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../dashboard/logic/home_cubit.dart';
import '../../dashboard/logic/home_state.dart';

class CalculateMarketValueBlocListener extends StatelessWidget {
  const CalculateMarketValueBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalculateMarketValueCubit, CalculateMarketValueState>(
      listenWhen: (previous, current) =>
          current is CalculateMarketValueLoading ||
          current is CalculateMarketValueSuccess ||
          current is CalculateMarketValueError,
      listener: (context, state) {
        state.whenOrNull(
          calculateMarketValueLoading: () {
            Center(
              child: CircularProgressIndicator(),
            );
          },
          calculateMarketValueSuccess: (calculateMarketValueRsponse) {
            context.pop();
            estimatedValue(context, calculateMarketValueRsponse);
          },
          calculateMarketValueError: (apiErrorModel) {
            setupErrorState(context, apiErrorModel);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  Future<dynamic> estimatedValue(BuildContext context,
      CalculateMarketValueRsponse calculateMarketValueRsponse) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            AppStrings.calculationResult.tr(),
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.estimatedValue.tr(),
                style: StylesManager.font18BlackBold,
              ),
              verticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.currency.tr(),
                    style: StylesManager.font24Black700Weight.copyWith(
                      color: ColorManager.primary,
                    ),
                  ),
                  horizontalSpace(8),
                  Text(
                    calculateMarketValueRsponse.estimatedValue.toString(),
                    style: StylesManager.font24Black700Weight.copyWith(
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                AppStrings.close.tr(),
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
