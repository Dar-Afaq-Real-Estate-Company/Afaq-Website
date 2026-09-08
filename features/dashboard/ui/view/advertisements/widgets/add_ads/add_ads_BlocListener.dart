import 'package:afaq_real_estate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/resources/styles_manager.dart';
import '../../../../../../../../core/routing/routes.dart';
import '../../../../../../../../core/widgets/publish_success_view.dart';
import '../../../../../logic/home_cubit.dart';
import '../../../../../logic/home_state.dart';

class AddAdsBloclistener extends StatelessWidget {
  const AddAdsBloclistener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddAdvertisementCubit, AddAdvertisementState>(
      listenWhen: (previous, current) =>
          current is AddAdvertisementLoading ||
          current is AddAdvertisementSuccess ||
          current is AddAdvertisementError,
      listener: (context, state) {
        state.whenOrNull(
          addAdvertisementLoading: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (ctx) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          addAdvertisementSuccess: (addAdvertisementResponse) {
            Navigator.of(context, rootNavigator: true).pop();
            showPublishSuccessThenGoToMyAds(
              context,
              referenceNo: addAdvertisementResponse.addAdvertisement?.referenceNo
                  ?? addAdvertisementResponse.addAdvertisement?.id,
            );
          },
          addAdvertisementError: (apiErrorModel) {
            setupErrorState(
              context,
            );
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void setupErrorState(
    BuildContext context,
  ) {
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
          'Unknown error',
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
