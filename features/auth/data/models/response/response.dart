import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

// helper converter: convert any value to String?
String? _stringFromJson(dynamic value) => value?.toString();

@JsonSerializable()
class LoginResponse {
  @JsonKey(fromJson: _stringFromJson)
  String? message;
  @JsonKey(name: 'user')
  LoginData? loginData;
  @JsonKey(fromJson: _stringFromJson)
  String? token;

  LoginResponse({this.message, this.loginData, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class LoginData {
  int? id;
  @JsonKey(name: 'name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(fromJson: _stringFromJson)
  String? email;
  @JsonKey(fromJson: _stringFromJson)
  String? phone;
  @JsonKey(name: 'user_type', fromJson: _stringFromJson)
  String? userType;
  @JsonKey(name: 'phone_type', fromJson: _stringFromJson)
  String? phoneType;

  LoginData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.userType,
      this.phoneType});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
// Register

@JsonSerializable()
class RegisterResponse {
  @JsonKey(fromJson: _stringFromJson)
  String? message;
  @JsonKey(name: 'user')
  RegisterData? registerData;
  @JsonKey(fromJson: _stringFromJson)
  String? token;

  RegisterResponse({this.message, this.registerData, this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}

@JsonSerializable()
class RegisterData {
  @JsonKey(fromJson: _stringFromJson)
  String? id;
  @JsonKey(name: 'name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(fromJson: _stringFromJson)
  String? email;
  @JsonKey(fromJson: _stringFromJson)
  String? phone;

  RegisterData(
      {this.id, this.firstName, this.lastName, this.email, this.phone});

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}

// Send Code Response
@JsonSerializable()
class ResetPasswordResponse {
  String? message;

  ResetPasswordResponse({
    this.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}

@JsonSerializable()
class UserInfoResponse {
  @JsonKey(name: "status")
  bool? status;
  @JsonKey(name: "user")
  UserResponse? user;

  UserInfoResponse({this.status, this.user});

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
}

@JsonSerializable()
class UserResponse {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? points;
  // === جديد: تاريخ التحقق من البريد. Laravel يرجعها كـ datetime نصي أو null
  @JsonKey(name: 'email_verified_at', fromJson: _stringFromJson)
  String? emailVerifiedAt;
  // === نوع الحساب: يحدّد ترتيب التطبيق للمستخدم
  @JsonKey(name: 'account_type')
  String? accountType;
  String? logo;
  // === الجنس: male / female - لعرض شارة مميزة بالبروفايل
  @JsonKey(name: 'Gender')
  String? gender;
  // === الرخصة العقارية: لشركة/مكتب فقط
  @JsonKey(name: 'license_number')
  String? licenseNumber;
  @JsonKey(name: 'license_file')
  String? licenseFile;

  UserResponse({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.points,
    this.emailVerifiedAt,
    this.accountType,
    this.logo,
    this.gender,
    this.licenseNumber,
    this.licenseFile,
  });

  // true لو فيه تاريخ تحقق فعلي (يعني البريد متحقق منه)
  bool get isEmailVerified =>
      emailVerifiedAt != null && emailVerifiedAt!.isNotEmpty;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

// Forgot Password Response
@JsonSerializable()
class ForgotPasswordResponse {
  String? message;

  ForgotPasswordResponse({
    this.message,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}

// =========== Verify Code Forgot Response =====================================
@JsonSerializable()
class VerifyCodeResponse {
  String? message;

  VerifyCodeResponse({
    this.message,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeResponseFromJson(json);
}

@JsonSerializable()
class VerifyCodeRegisterResponse {
  String? message;

  VerifyCodeRegisterResponse({
    this.message,
  });

  factory VerifyCodeRegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeRegisterResponseFromJson(json);
}

// Update User Info

@JsonSerializable()
class UpdateUserInfoResponse {
  String? message;
  @JsonKey(name: "user")
  UpdateUserDataResponse? updateUserInfo;

  UpdateUserInfoResponse({this.message, this.updateUserInfo});

  factory UpdateUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoResponseFromJson(json);
}

@JsonSerializable()
class UpdateUserDataResponse {
  @JsonKey(name: "id")
  int? userId;
  @JsonKey(name: "name")
  String? firstName;
  @JsonKey(name: "last_name")
  String? lastName;
  String? email;
  String? phone;

  UpdateUserDataResponse({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory UpdateUserDataResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDataResponseFromJson(json);
}

@JsonSerializable()
class DeleteAccounResponse {
  bool? status;
  String? message;

  DeleteAccounResponse({
    this.status,
    this.message,
  });

  factory DeleteAccounResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccounResponseFromJson(json);
}

// === جديد: رد إعادة إرسال رابط تحقق البريد
@JsonSerializable()
class ResendVerificationResponse {
  bool? status;
  String? message;

  ResendVerificationResponse({
    this.status,
    this.message,
  });

  factory ResendVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationResponseFromJson(json);
}
