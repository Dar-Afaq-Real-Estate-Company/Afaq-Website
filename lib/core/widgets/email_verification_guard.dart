import 'package:flutter/material.dart';

import '../di/di.dart';
import '../helper/constants.dart';
import '../helper/shared_pref.dart';
import 'app_loading_indicator.dart';
import '../routing/routes.dart';
import '../../features/auth/data/repository/repository.dart';

/// يلف أي صفحة "مهمة" بالتطبيق. عند فتحها:
/// 1. يتحقق أصلاً إن فيه مستخدم مسجل دخول (isLoggedInUser)
/// 2. يجيب بيانات المستخدم الطازجة من السيرفر ويفحص email_verified_at
/// 3. لو غير متحقق -> يحوّل تلقائياً لصفحة التحقق (Routes.verifiyRoute)
///    ولو متحقق -> يعرض الصفحة الأصلية بشكل طبيعي
class EmailVerificationGuard extends StatefulWidget {
  final Widget child;
  const EmailVerificationGuard({super.key, required this.child});

  @override
  State<EmailVerificationGuard> createState() =>
      _EmailVerificationGuardState();
}

class _EmailVerificationGuardState extends State<EmailVerificationGuard> {
  bool _checking = true;
  bool _blocked = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    // ما فيه مستخدم مسجل دخول أصلاً - نسيب الصفحة تتعامل مع هذا بنفسها
    if (!isLoggedInUser) {
      if (mounted) setState(() => _checking = false);
      return;
    }

    // getInt يرجع 0 افتراضياً لو المفتاح غير موجود (مو null)
    final int userId =
        await SharedPrefHelper.getInt(SharedPrefKeys.userId) as int;

    if (userId == 0) {
      if (mounted) setState(() => _checking = false);
      return;
    }

    final repository = di<UserInfoRepository>();
    final result = await repository.userInfo(userId);

    result.when(
      success: (userInfoResponse) {
        // نزامن نوع الحساب من السيرفر مع التخزين المحلي
        final type = userInfoResponse.user?.accountType;
        if (type != null && type.isNotEmpty) {
          SharedPrefHelper.setData(SharedPrefKeys.accountType, type);
        }
        final verified = userInfoResponse.user?.isEmailVerified ?? false;
        if (!verified) {
          _redirectToVerify();
        } else if (mounted) {
          setState(() => _checking = false);
        }
      },
      failure: (_) {
        // فشل الاتصال بالسيرفر: نسمح بالدخول عشان ما نحبس المستخدم بلا نت (fail-open)
        if (mounted) setState(() => _checking = false);
      },
    );
  }

  void _redirectToVerify() {
    if (!mounted) return;
    setState(() => _blocked = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.verifiyRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking || _blocked) {
      // بدون const لأن ColorManager.primary قيمة متغيرة مو ثابتة وقت الترجمة
      return Scaffold(
        body: Center(
          child: AppLoadingIndicator(),
        ),
      );
    }
    return widget.child;
  }
}
