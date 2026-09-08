import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/extensions.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/resources/styles_manager.dart';
import '../../../logic/cubit_cubit.dart';
import 'widget/otp_BlocListener.dart';

class OtpView extends StatefulWidget {
  final String email;

  const OtpView({super.key, required this.email});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController _otpController = TextEditingController();
  static const int _cooldownSeconds = 60;
  int _remainingCooldown = _cooldownSeconds;
  Timer? _cooldownTimer;
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  void _trySubmit(BuildContext ctx) {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 4) {
      String englishCode = convertArabicToEnglish(code);
      ctx.read<VerifyCodeCubit>().emitVerifyCode(
            code: int.parse(englishCode),
          );
    }
  }

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    _remainingCooldown = _cooldownSeconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _remainingCooldown -= 1);
      if (_remainingCooldown <= 0) timer.cancel();
    });
  }

  void _resend() {
    context.read<ForgotPasswordCubit>().emitForgotPassword();
    _startCooldown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _cooldownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(70),
                Text(
                  AppStrings.verificationCodeTitle.tr(),
                  style: StylesManager.font25PrimaryBold,
                ),
                verticalSpace(8),
                Text(
                  "${AppStrings.verificationCodeSentTo.tr()} ${widget.email}",
                  style: StylesManager.font13Grey,
                ),
                verticalSpace(36),
                Builder(builder: (newContext) {
                  return Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: SizedBox(
                            width: 50.w,
                            height: 55.h,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              autofocus: index == 0,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: StylesManager.font25PrimaryBold,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide:
                                      BorderSide(color: ColorManager.primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                      color: ColorManager.primary, width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                                _trySubmit(newContext);
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
                verticalSpace(30),
                OtpBloclistener(email: widget.email),
                verticalSpace(20),
                Center(
                  child: TextButton(
                    onPressed: _remainingCooldown > 0 ? null : _resend,
                    child: Text(
                      _remainingCooldown > 0
                          ? 'إعادة الإرسال بعد $_remainingCooldown ثانية'
                          : 'لم يصلك الرمز؟ إعادة الإرسال',
                      style: StylesManager.font13Grey.copyWith(
                        color: _remainingCooldown > 0
                            ? ColorManager.grey
                            : ColorManager.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
