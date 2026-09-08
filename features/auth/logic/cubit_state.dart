import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_error_model.dart';
import '../data/models/response/response.dart';

part 'cubit_state.freezed.dart';

@freezed
class LoginState<T> with _$LoginState<T> {
  const factory LoginState.initial() = _Initial<T>;
  const factory LoginState.loading() = Loading<T>;
  const factory LoginState.success(T data) = Success<T>;
  const factory LoginState.error(ApiErrorModel apiErrorModel) = Error;
}

@freezed
class RegisterState<T> with _$RegisterState<T> {
  const factory RegisterState.registerInitial() = RegisterInitial<T>;
  const factory RegisterState.registerLoading() = RegisterLoading<T>;
  const factory RegisterState.registerSuccess(T data) = RegisterSuccess<T>;
  const factory RegisterState.registerError(ApiErrorModel apiErrorModel) =
      RegisterError<T>;
}

@freezed
class ForgotPasswordState<T> with _$ForgotPasswordState<T> {
  const factory ForgotPasswordState.forgotPasswordInitial() =
      _ForgotPasswordInitial<T>;
  const factory ForgotPasswordState.forgotPasswordLoading() =
      ForgotPasswordLoading<T>;
  const factory ForgotPasswordState.forgotPasswordSuccess(T data) =
      ForgotPasswordSuccess<T>;
  const factory ForgotPasswordState.forgotPasswordError(
      ApiErrorModel apiErrorModel) = ForgotPasswordError<T>;
}

// ====== Verify Code State ====================================================
@freezed
class VerifyCodeState<T> with _$VerifyCodeState<T> {
  const factory VerifyCodeState.verifyCodeInitial() = _VerifyCodeInitial<T>;
  const factory VerifyCodeState.verifyCodeLoading() = VerifyCodeLoading<T>;
  const factory VerifyCodeState.verifyCodeSuccess(T data) =
      VerifyCodeSuccess<T>;
  const factory VerifyCodeState.verifyCodeError(ApiErrorModel apiErrorModel) =
      VerifyCodeError<T>;
}

// =============================================================================
@freezed
class VerifyCodeRegisterState<T> with _$VerifyCodeRegisterState<T> {
  const factory VerifyCodeRegisterState.verifyCodeRegisterInitial() = _VerifyCodeRegisterInitial<T>;
  const factory VerifyCodeRegisterState.verifyCodeRegisterLoading() = VerifyCodeRegisterLoading<T>;
  const factory VerifyCodeRegisterState.verifyCodeRegisterSuccess(T data) =
     VerifyCodeRegisterSuccess<T>;
  const factory VerifyCodeRegisterState.verifyCodeRegisterError(ApiErrorModel apiErrorModel) =
      VerifyCodeRegisterError<T>;
}

@freezed
class UserInfoState<T> with _$UserInfoState<T> {
  const factory UserInfoState.userInfoInitial() = UserInfoInitial<T>;

  // حالة التحميل
  const factory UserInfoState.userInfoLoading() = UserInfoLoading;

  // حالة النجاح واستلام البيانات
  const factory UserInfoState.userInfoSuccess(UserInfoResponse data) =
      UserInfoSuccess<T>;

  // حالة الخطأ
  const factory UserInfoState.userInfoError(ApiErrorModel apiErrorModel) =
      UserInfoError;
}

@freezed
class UpdateUserInfoState<T> with _$UpdateUserInfoState<T> {
  const factory UpdateUserInfoState.updateInitial() = _UpdateUserInfoInitial<T>;

  const factory UpdateUserInfoState.updateLoading() = UpdateLoading;
  const factory UpdateUserInfoState.updateSuccess(UpdateUserInfoResponse data) =
      UpdateSuccess<T>;
  const factory UpdateUserInfoState.updateInfoError(
      ApiErrorModel apiErrorModel) = UpdateInfoError;
}

@freezed
class ResetPasswordState<T> with _$ResetPasswordState<T> {
  const factory ResetPasswordState.resetPasswordInitial() =
      _ResetPasswordInitial<T>;
  const factory ResetPasswordState.resetPasswordLoading() =
      ResetPasswordLoading<T>;
  const factory ResetPasswordState.resetPasswordSuccess(T data) =
      ResetPasswordSuccess<T>;
  const factory ResetPasswordState.resetPasswordError(
      ApiErrorModel apiErrorModel) = ResetPasswordError<T>;
}


@freezed
class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState.deleteAccountInitial() = _DeleteAccountInitial;
  const factory DeleteAccountState.deleteAccountLoading() = DeleteAccountLoading;
  const factory DeleteAccountState.deleteAccountSuccess(dynamic response) = DeleteAccountSuccess;
  const factory DeleteAccountState.deleteAccountError(ApiErrorModel apiErrorModel) = DeleteAccountError;
}