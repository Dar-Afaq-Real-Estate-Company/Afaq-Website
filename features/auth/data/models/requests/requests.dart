import 'package:json_annotation/json_annotation.dart';
part 'requests.g.dart';

// Login
@JsonSerializable()
class LoginRequest {
  final String phone;
  final String password;

  LoginRequest({required this.phone, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// Register

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  final String email;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  // === نوع الحساب: seeker | owner | office | developer | broker
  @JsonKey(name: 'account_type')
  final String accountType;
  // === الجنس: male | female
  @JsonKey(name: 'Gender')
  final String? gender;
  // === الرخصة العقارية (للمكتب العقاري)
  @JsonKey(name: 'license_number')
  final String? licenseNumber;
  @JsonKey(name: 'license_file')
  final String? licenseFile;

  RegisterRequest({
    required this.firstName,
    this.accountType = 'seeker',
    this.gender,
    this.licenseNumber,
    this.licenseFile,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': firstName,
      'last_name': lastName,
      'account_type': accountType,
      if (gender != null) 'Gender': gender,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (licenseFile != null) 'license_file': licenseFile,
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

// ===========   Reset Password Request ==========================================
@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

// forgotPassword
@JsonSerializable()
class ForgotPasswordRequest {
  final String type;
  final String email;

  ForgotPasswordRequest({
    required this.type,
    required this.email,
  });

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

// forgotPassword
@JsonSerializable()
class UpdateUserInfoRequest {
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  final String email;
  final String password;
  @JsonKey(name: 'account_type', includeIfNull: false)
  final String? accountType;
  @JsonKey(name: 'Gender', includeIfNull: false)
  final String? gender;
  @JsonKey(name: 'logo_base64', includeIfNull: false)
  final String? logoBase64;
  @JsonKey(name: 'license_number', includeIfNull: false)
  final String? licenseNumber;
  @JsonKey(name: 'license_file', includeIfNull: false)
  final String? licenseFile;

  UpdateUserInfoRequest({
    required this.userId,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.accountType,
    this.gender,
    this.logoBase64,
    this.licenseNumber,
    this.licenseFile,
  });

  Map<String, dynamic> toJson() => _$UpdateUserInfoRequestToJson(this);
}

// ========= Verify Code  Request =======================================
@JsonSerializable()
class VerifyCodeRequest {
  final int code;

  VerifyCodeRequest({
    required this.code,
  });

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}

@JsonSerializable()
class VerifyCodeRegisterRequest {
  final String code;
  final String phone;

  VerifyCodeRegisterRequest({
    required this.code,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        "code": code.toString(),
        "phone": phone.toString(),
      };
}

// ============= Delete Account Request ========================================
@JsonSerializable()
class DeleteAccountRequest {
  @JsonKey(name: 'user_id')
  final int userId;

  DeleteAccountRequest({
    required this.userId,
  });

  Map<String, dynamic> toJson() => _$DeleteAccountRequestToJson(this);
}
