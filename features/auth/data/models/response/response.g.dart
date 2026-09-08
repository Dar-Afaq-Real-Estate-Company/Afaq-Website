// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      message: _stringFromJson(json['message']),
      loginData: json['user'] == null
          ? null
          : LoginData.fromJson(json['user'] as Map<String, dynamic>),
      token: _stringFromJson(json['token']),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.loginData,
      'token': instance.token,
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['name'] as String?,
      lastName: json['last_name'] as String?,
      email: _stringFromJson(json['email']),
      phone: _stringFromJson(json['phone']),
      userType: _stringFromJson(json['user_type']),
      phoneType: _stringFromJson(json['phone_type']),
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'user_type': instance.userType,
      'phone_type': instance.phoneType,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      message: _stringFromJson(json['message']),
      registerData: json['user'] == null
          ? null
          : RegisterData.fromJson(json['user'] as Map<String, dynamic>),
      token: _stringFromJson(json['token']),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.registerData,
      'token': instance.token,
    };

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) => RegisterData(
      id: _stringFromJson(json['id']),
      firstName: json['name'] as String?,
      lastName: json['last_name'] as String?,
      email: _stringFromJson(json['email']),
      phone: _stringFromJson(json['phone']),
    );

Map<String, dynamic> _$RegisterDataToJson(RegisterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
    };

ResetPasswordResponse _$ResetPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordResponse(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResetPasswordResponseToJson(
        ResetPasswordResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

UserInfoResponse _$UserInfoResponseFromJson(Map<String, dynamic> json) =>
    UserInfoResponse(
      status: json['status'] as bool?,
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserInfoResponseToJson(UserInfoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user': instance.user,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      points: (json['points'] as num?)?.toInt(),
      emailVerifiedAt: _stringFromJson(json['email_verified_at']),
      accountType: json['account_type'] as String?,
      logo: json['logo'] as String?,
      gender: json['Gender'] as String?,
      licenseNumber: json['license_number'] as String?,
      licenseFile: json['license_file'] as String?,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'points': instance.points,
      'email_verified_at': instance.emailVerifiedAt,
      'account_type': instance.accountType,
      'logo': instance.logo,
      'Gender': instance.gender,
      'license_number': instance.licenseNumber,
      'license_file': instance.licenseFile,
    };

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordResponse(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ForgotPasswordResponseToJson(
        ForgotPasswordResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

VerifyCodeResponse _$VerifyCodeResponseFromJson(Map<String, dynamic> json) =>
    VerifyCodeResponse(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$VerifyCodeResponseToJson(VerifyCodeResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

VerifyCodeRegisterResponse _$VerifyCodeRegisterResponseFromJson(
        Map<String, dynamic> json) =>
    VerifyCodeRegisterResponse(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$VerifyCodeRegisterResponseToJson(
        VerifyCodeRegisterResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

UpdateUserInfoResponse _$UpdateUserInfoResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateUserInfoResponse(
      message: json['message'] as String?,
      updateUserInfo: json['user'] == null
          ? null
          : UpdateUserDataResponse.fromJson(
              json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserInfoResponseToJson(
        UpdateUserInfoResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.updateUserInfo,
    };

UpdateUserDataResponse _$UpdateUserDataResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateUserDataResponse(
      userId: (json['id'] as num?)?.toInt(),
      firstName: json['name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UpdateUserDataResponseToJson(
        UpdateUserDataResponse instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
    };

DeleteAccounResponse _$DeleteAccounResponseFromJson(
        Map<String, dynamic> json) =>
    DeleteAccounResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DeleteAccounResponseToJson(
        DeleteAccounResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

ResendVerificationResponse _$ResendVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    ResendVerificationResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResendVerificationResponseToJson(
        ResendVerificationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
