import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../dashboard/logic/home_cubit.dart';
import 'my_advertisment_bloc_builder.dart';

class MyAdvertisementsView extends StatefulWidget {
  const MyAdvertisementsView({super.key});

  @override
  State<MyAdvertisementsView> createState() => _MyAdvertisementsViewState();
}

class _MyAdvertisementsViewState extends State<MyAdvertisementsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // use read to avoid listening outside build
      context.read<ShowUserAdCubit>().emitGetUserAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppStrings.myAdvertisements.tr()),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MyAdvertismentBlocBuilder(),
    );
  }
}
