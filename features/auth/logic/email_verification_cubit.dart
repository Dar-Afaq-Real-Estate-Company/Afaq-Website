import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_error_model.dart';
import '../data/repository/repository.dart';

/// حالات التحقق من البريد - كتبناها يدوياً (بدون freezed) عشان ما تحتاج
/// تشغّل build_runner لملف جديد؛ فقط الحقول اللي عدّلناها فعلياً (response.dart)
/// تحتاج build_runner.
abstract class EmailVerificationState {
  const EmailVerificationState();
}

class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial();
}

class EmailVerificationChecking extends EmailVerificationState {
  const EmailVerificationChecking();
}

class EmailVerificationVerified extends EmailVerificationState {
  const EmailVerificationVerified();
}

class EmailVerificationUnverified extends EmailVerificationState {
  const EmailVerificationUnverified();
}

class EmailVerificationCheckError extends EmailVerificationState {
  final ApiErrorModel apiErrorModel;
  const EmailVerificationCheckError(this.apiErrorModel);
}

class EmailVerificationResending extends EmailVerificationState {
  const EmailVerificationResending();
}

class EmailVerificationResendSuccess extends EmailVerificationState {
  final String? message;
  const EmailVerificationResendSuccess(this.message);
}

class EmailVerificationResendError extends EmailVerificationState {
  final ApiErrorModel apiErrorModel;
  const EmailVerificationResendError(this.apiErrorModel);
}

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final UserInfoRepository _userInfoRepository;
  final ResendVerificationRepository _resendVerificationRepository;

  EmailVerificationCubit(
    this._userInfoRepository,
    this._resendVerificationRepository,
  ) : super(const EmailVerificationInitial());

  // ثانية العد التنازلي لمنع الضغط المتكرر على "إعادة إرسال"
  static const int resendCooldownSeconds = 60;
  int remainingCooldown = 0;
  Timer? _cooldownTimer;

  /// يتحقق من حالة البريد عن طريق جلب بيانات المستخدم من السيرفر
  /// (نفس مصدر الحقيقة اللي يعتمد عليه الموقع - email_verified_at)
  Future<void> checkStatus(int userId) async {
    emit(const EmailVerificationChecking());
    final response = await _userInfoRepository.userInfo(userId);
    response.when(
      success: (userInfoResponse) {
        final bool verified = userInfoResponse.user?.isEmailVerified ?? false;
        if (verified) {
          emit(const EmailVerificationVerified());
        } else {
          emit(const EmailVerificationUnverified());
        }
      },
      failure: (apiErrorModel) {
        emit(EmailVerificationCheckError(apiErrorModel));
      },
    );
  }

  /// يرسل رابط تحقق جديد للبريد، مع عدّاد تبريد 60 ثانية يمنع الإرسال المتكرر
  Future<void> resend() async {
    if (remainingCooldown > 0) return; // العدّاد لسا شغال، تجاهل الضغطة

    emit(const EmailVerificationResending());
    final response = await _resendVerificationRepository.resend();
    response.when(
      success: (resendResponse) {
        emit(EmailVerificationResendSuccess(resendResponse.message));
        _startCooldown();
      },
      failure: (apiErrorModel) {
        emit(EmailVerificationResendError(apiErrorModel));
      },
    );
  }

  void _startCooldown() {
    remainingCooldown = resendCooldownSeconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingCooldown -= 1;
      if (remainingCooldown <= 0) {
        timer.cancel();
      }
      // نعيد نفس حالة النجاح الحالية بس نحدّث العدّاد المرئي بواسطة نفس الكيوبت
      // (الواجهة تقرأ remainingCooldown مباشرة من الكيوبت، مو من الـ state)
      emit(EmailVerificationResendSuccess(
        state is EmailVerificationResendSuccess
            ? (state as EmailVerificationResendSuccess).message
            : null,
      ));
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
