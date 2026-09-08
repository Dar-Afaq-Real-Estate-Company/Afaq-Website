import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constants.dart';
import '../../../core/helper/shared_pref.dart';
import '../../../core/network/dio_factory.dart';
import '../data/models/requests/requests.dart';
import '../data/repository/repository.dart';
import 'cubit_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;
  LoginCubit(this._loginRepository) : super(const LoginState.initial());
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String countryDialCode = "+965";
  // === نوع الحساب المختار بشيت "اختر نوع المستخدم"
  // ValueNotifier عشان الحقول التابعة (رفع الرخصة) تُعاد بناؤها فورًا
  final ValueNotifier<String> accountTypeNotifier = ValueNotifier('seeker');
  String get accountType => accountTypeNotifier.value;
  set accountType(String value) => accountTypeNotifier.value = value;
  // === الرخصة العقارية (للمكتب العقاري)
  TextEditingController licenseNumberController = TextEditingController();
  String? licenseBase64;
  void emitLogin() async {
    emit(const LoginState.loading());

    String enteredPhone = phoneController.text.trim();
    if (enteredPhone.startsWith('0')) {
      enteredPhone = enteredPhone.substring(1);
    }
    final String cleanCountryCode = countryDialCode.replaceAll('+', '');
    final String fullPhoneToSend = "$cleanCountryCode$enteredPhone";
    final response = await _loginRepository.login(
      LoginRequest(
        phone: fullPhoneToSend,
        password: passwordController.text,
      ),
    );

    response.when(success: (loginResponse) async {
      final String token = loginResponse.token ?? '';
      final int userId = loginResponse.loginData?.id ?? 0;
      final String userPhone = loginResponse.loginData?.phone ?? '';

      await saveUserToken(token);
      await SharedPrefHelper.setData(SharedPrefKeys.userId, userId);
      await SharedPrefHelper.setData(SharedPrefKeys.userPhone, userPhone);
      await SharedPrefHelper.setData(SharedPrefKeys.userType, loginResponse.loginData?.userType ?? '');

      emit(LoginState.success(loginResponse));
    }, failure: (apiErrorModel) {
      emit(LoginState.error(apiErrorModel));
    });
  }

  Future<void> saveUserToken(String token) async {
    if (token.isNotEmpty) {
      await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
      isLoggedInUser = true;
      DioFactory.setTokenIntoHeaderAfterLogin(token);
      debugPrint("Token saved and Dio Header updated successfully.");
    } else {
      debugPrint("Warning: Trying to save an empty token!");
    }
  }
}

//==============================================================================
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _registerRepository;

  RegisterCubit(this._registerRepository)
      : super(const RegisterState.registerInitial());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  String countryDialCode = "+965";
  // === نوع الحساب المختار بشيت "اختر نوع المستخدم"
  // ValueNotifier عشان الحقول التابعة (رفع الرخصة) تُعاد بناؤها فورًا
  final ValueNotifier<String> accountTypeNotifier = ValueNotifier('seeker');
  String get accountType => accountTypeNotifier.value;
  set accountType(String value) => accountTypeNotifier.value = value;
  // === الجنس: male | female - يظهر بشارة ملوّنة بالبروفايل بعد التسجيل
  final ValueNotifier<String?> genderNotifier = ValueNotifier(null);
  String? get gender => genderNotifier.value;
  set gender(String? value) => genderNotifier.value = value;
  // === الرخصة العقارية (للمكتب العقاري)
  TextEditingController licenseNumberController = TextEditingController();
  String? licenseBase64;
  void emitRegister() async {
    emit(const RegisterState.registerLoading());
    await SharedPrefHelper.clearAllData();
    String enteredPhone = phoneController.text.trim();
    if (enteredPhone.startsWith('0')) {
      enteredPhone = enteredPhone.substring(1);
    }
// حذف علامة الـ + من كود الدولة قبل الدمج
    final String cleanCountryCode = countryDialCode.replaceAll('+', '');

    // 2. دمج كود الدولة (النظيف) مع الرقم
    final String fullPhoneToSend = "$cleanCountryCode$enteredPhone";
    final response = await _registerRepository.register(
      RegisterRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        accountType: accountType,
        gender: gender,
        licenseNumber: licenseNumberController.text.trim().isEmpty
            ? null
            : licenseNumberController.text.trim(),
        licenseFile: licenseBase64,
        email: emailController.text,
        phone: fullPhoneToSend,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );

    print("الرقم المرسل للـ API هو: $fullPhoneToSend");

    response.when(success: (registerResponse) async {
      await SharedPrefHelper.saveUser(registerResponse);
      if (registerResponse.token != null) {
        DioFactory.setTokenIntoHeaderAfterLogin(registerResponse.token!);
      }
      emit(RegisterState.registerSuccess(registerResponse));
    }, failure: (apiErrorModel) {
      emit(RegisterState.registerError(apiErrorModel));
    });
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}

//==============================================================================
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository _forgotPasswordRepository;

  ForgotPasswordCubit(this._forgotPasswordRepository)
      : super(const ForgotPasswordState.forgotPasswordInitial());

  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void emitForgotPassword() async {
    emit(const ForgotPasswordState.forgotPasswordLoading());
    final response = await _forgotPasswordRepository.forgotPassword(
      ForgotPasswordRequest(
        email: emailController.text,
        type: 'email',
      ),
    );

    response.when(success: (forgotPasswordResponse) async {
      emit(ForgotPasswordState.forgotPasswordSuccess(forgotPasswordResponse));
    }, failure: (apiErrorModel) {
      emit(ForgotPasswordState.forgotPasswordError(apiErrorModel));
    });
  }
}

// =============================================================================
class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCodeRepository _verifyCodeRepository;

  VerifyCodeCubit(this._verifyCodeRepository)
      : super(const VerifyCodeState.verifyCodeInitial());

  void emitVerifyCode({required int code}) async {
    emit(const VerifyCodeState.verifyCodeLoading());
    final response = await _verifyCodeRepository.verifyCode(
      VerifyCodeRequest(
        code: code,
      ),
    );

    response.when(success: (verifyCodeResponse) async {
      emit(VerifyCodeState.verifyCodeSuccess(verifyCodeResponse));
    }, failure: (apiErrorModel) {
      emit(VerifyCodeState.verifyCodeError(apiErrorModel));
    });
  }
}

//==============================================================================

class VerifyCodeRegisterCubit extends Cubit<VerifyCodeRegisterState> {
  final VerifyCodeRegistrRepository _verifyCodeRegistrRepository;

  VerifyCodeRegisterCubit(this._verifyCodeRegistrRepository)
      : super(VerifyCodeRegisterState.verifyCodeRegisterInitial());

  void emitVerifyCodeRegister(
      {required String code, required String phone}) async {
    emit(const VerifyCodeRegisterState.verifyCodeRegisterLoading());
    final response = await _verifyCodeRegistrRepository.verifyCodeRegister(
      VerifyCodeRegisterRequest(
        code: code,
        phone: phone,
      ),
    );
    response.when(success: (verifyCodeResponse) async {
      emit(VerifyCodeRegisterState.verifyCodeRegisterSuccess(
          verifyCodeResponse));
    }, failure: (apiErrorModel) {
      emit(VerifyCodeRegisterState.verifyCodeRegisterError(apiErrorModel));
    });
  }
}

//==============================================================================
class UserInfoCubit extends Cubit<UserInfoState> {
  final UserInfoRepository _userInfoRepository;

  UserInfoCubit(this._userInfoRepository)
      : super(const UserInfoState.userInfoInitial());

  void emitGetUserInfo(int userId) async {
    emit(const UserInfoState.userInfoLoading());

    final response = await _userInfoRepository.userInfo(userId);

    response.when(
      success: (userInfoResponse) async {
        if (userInfoResponse.user != null) {
          // await SharedPrefHelper.saveUserInfo(userInfoResponse.user);
         
        }

        emit(UserInfoState.userInfoSuccess(userInfoResponse));
      },
      failure: (apiErrorModel) {
        emit(UserInfoState.userInfoError(apiErrorModel));
      },
    );
  }

  void resetState() {
    emit(const UserInfoState.userInfoInitial());
  }
}

/// تحديث بيانات المستخدم

class UpdateUserInfoCubit extends Cubit<UpdateUserInfoState> {
  final UpdateUserInfoRepository _updateUserInfoRepository;

  UpdateUserInfoCubit(this._updateUserInfoRepository)
      : super(const UpdateUserInfoState.updateInitial());

  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();

  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  void emitUpdateUserInfo({
    required String fullName,
    required String email,
    String? phone,
    String? accountType,
    String? gender,
    String? logoBase64,
    String? licenseNumber,
    String? licenseFile,
  }) async {
    emit(const UpdateUserInfoState.updateLoading());

    final userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    final userPhone =
        phone?.trim().isNotEmpty == true ? phone!.trim() : await SharedPrefHelper.getString(SharedPrefKeys.userPhone);

    if (userId != null) {
      final response = await _updateUserInfoRepository.updateInfo(
        UpdateUserInfoRequest(
          userId: userId,
          email: email,
          firstName: fullName,
          lastName: fullName,
          logoBase64: logoBase64,
          phone: userPhone,
          accountType: accountType,
          gender: gender,
          licenseNumber: licenseNumber,
          licenseFile: licenseFile,
          password: '',
        ),
      );
      response.when(
        success: (updateResponse) {
          emit(UpdateUserInfoState.updateSuccess(updateResponse));
        },
        failure: (apiErrorModel) {
          emit(UpdateUserInfoState.updateInfoError(apiErrorModel));
        },
      );
    }
  }
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository resetPasswordRepository;
  ResetPasswordCubit(this.resetPasswordRepository)
      : super(const ResetPasswordState.resetPasswordInitial());
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  void emitResetPassword({required String email}) async {
    emit(const ResetPasswordState.resetPasswordLoading());
    final response = await resetPasswordRepository.resetPassword(
      ResetPasswordRequest(
        email: email,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );
    print("Final Email being sent to API: $email");

    response.when(success: (resetPasswordResponse) async {
      emit(ResetPasswordState.resetPasswordSuccess(resetPasswordResponse));
    }, failure: (apiErrorModel) {
      emit(ResetPasswordState.resetPasswordError(apiErrorModel));
    });
  }
}

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountRepository _deleteAccountRepository;

  DeleteAccountCubit(this._deleteAccountRepository)
      : super(const DeleteAccountState.deleteAccountInitial());

  void emitDeleteAccount() async {
    emit(const DeleteAccountState.deleteAccountLoading());
    final userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);

    final response = await _deleteAccountRepository
        .deleteAccount(DeleteAccountRequest(userId: userId));

    response.when(
      success: (deleteResponse) {
        emit(DeleteAccountState.deleteAccountSuccess(deleteResponse));
      },
      failure: (apiErrorModel) {
        emit(DeleteAccountState.deleteAccountError(apiErrorModel));
      },
    );
  }
}
