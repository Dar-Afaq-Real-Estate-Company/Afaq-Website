import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/constants.dart';
import '../../../../../core/helper/shared_pref.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/styles_manager.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/app_text_button.dart';
import '../../../../../core/widgets/onboarding_tour.dart';
import '../../../logic/email_verification_cubit.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  // 0 يعني "غير معروف/غير محمّل بعد" لأن getInt يرجع 0 افتراضياً، مو null
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    // إرسال رابط التحقق تلقائياً أول ما تفتح الصفحة - بدون انتظار ضغطة المستخدم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmailVerificationCubit>().resend();
    });
  }

  Future<void> _loadUserId() async {
    final int id = await SharedPrefHelper.getInt(SharedPrefKeys.userId) as int;
    setState(() => _userId = id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: Icon(Icons.logout, color: ColorManager.primary),
                tooltip: 'تسجيل الخروج',
                onPressed: () async {
                  await SharedPrefHelper.removeData(SharedPrefKeys.userToken);
                  await SharedPrefHelper.removeData(SharedPrefKeys.userId);
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.dashboardRoute, (route) => false);
                  }
                },
              ),
            ),
            BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
          listener: (context, state) {
            if (state is EmailVerificationVerified) {
              // تحقق البريد بنجاح - نعرض جولة الترحيب أولاً، بعدها الداشبورد
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.dashboardRoute, (route) => false)
                  .then((_) {
                if (context.mounted) showOnboardingTour(context);
              });
            }
          },
          builder: (context, state) {
            final cubit = context.read<EmailVerificationCubit>();
            final bool isChecking = state is EmailVerificationChecking;
            final bool isResending = state is EmailVerificationResending;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 80,
                    color: ColorManager.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'يرجى تفعيل بريدك الإلكتروني',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'أرسلنا رابط تفعيل إلى بريدك الإلكتروني. افتح الرابط من بريدك،'
                    ' ثم اضغط "لقد فعّلت بريدي" بالأسفل.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // زر التحقق اليدوي من الحالة
                  SizedBox(
                    width: double.infinity,
                    child: AppTextButton(
                      buttonText:
                          isChecking ? 'جاري التحقق...' : 'لقد فعّلت بريدي',
                      textStyle: StylesManager.font16White,
                      onPressed: (isChecking || _userId == 0)
                          ? null
                          : () => cubit.checkStatus(_userId),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // زر إعادة الإرسال مع عدّاد التبريد
                  TextButton(
                    onPressed: (isResending || cubit.remainingCooldown > 0)
                        ? null
                        : () => cubit.resend(),
                    child: Text(
                      cubit.remainingCooldown > 0
                          ? 'إعادة الإرسال بعد ${cubit.remainingCooldown} ثانية'
                          : (isResending
                              ? 'جاري الإرسال...'
                              : 'لم يصلك الرابط؟ إعادة الإرسال'),
                    ),
                  ),

                  if (state is EmailVerificationUnverified)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'البريد لسا غير مفعّل. تأكد إنك ضغطت الرابط بالبريد.',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (state is EmailVerificationCheckError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        state.apiErrorModel.message ?? 'حدث خطأ، حاول مرة أخرى',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (state is EmailVerificationResendError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        state.apiErrorModel.message ??
                            'تعذّر إرسال الرابط، حاول مرة أخرى',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
          ],
        ),
      ),
    );
  }
}
