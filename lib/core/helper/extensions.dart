import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/logic/cubit_cubit.dart';
import '../network/api_error_model.dart';
import '../network/dio_factory.dart';
import '../resources/styles_manager.dart';
import '../routing/routes.dart';
import 'constants.dart';
import 'shared_pref.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this == [];
}

class AuthGuard {
  static Future<void> runAction(
    BuildContext context, {
    required VoidCallback onAuthenticated,
  }) async {
    if (isLoggedInUser) {
      // 1. إذا كان مسجلاً، نفذ المهمة فوراً
      onAuthenticated();
    } else {
      // 2. إذا لم يكن مسجلاً، اذهب لصفحة اللوجن
      await context.pushNamed(Routes.loginRoute);

      // 3. بعد العودة، تحقق من نجاح الدخول
      if (isLoggedInUser) {
        if (context.mounted) {
          onAuthenticated();
        }
      }
    }
  }
}

void performLogout(BuildContext context) async {
  await SharedPrefHelper.clearAllData();

  isLoggedInUser = false;

  DioFactory.setTokenIntoHeaderAfterLogin("");

  try {
    context.read<UserInfoCubit>().resetState();
  } catch (_) {
    // UserInfoCubit قد لا يكون متوفراً بمقياس هذه الصفحة - لا يوقف الخروج
  }

  if (context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.dashboardRoute,
      (route) => false,
    );
  }
}


  String convertArabicToEnglish(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
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