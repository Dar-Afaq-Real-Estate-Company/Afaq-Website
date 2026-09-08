import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// Imports الخاصة بالـ Auth (القديمة)
import '../../features/auth/data/models/requests/requests.dart';
import '../../features/auth/data/models/response/response.dart';

// === الـ Imports الجديدة بالامتداد الصحيح للفنادق والشقق ===
import '../../features/hotels_apartments/data/models/requests/requests.dart';
import '../../features/hotels_apartments/data/models/response/response.dart';

import 'api_constants.dart';
part 'app_api.g.dart';



@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(
    @Body() LoginRequest loginRequest,
  );
  @POST(ApiConstants.register)
  Future<RegisterResponse> register(
    @Body() RegisterRequest registerRequest,
  );
  @POST(ApiConstants.resetPassword)
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest resetPassword,
  );

  @GET("${ApiConstants.userInfo}/{id}")
  Future<UserInfoResponse> getUserInfo(
    @Path("id") int id,
  );

  @POST(ApiConstants.userUpdateInfo)
  Future<UpdateUserInfoResponse> updateInfo(
    @Body() UpdateUserInfoRequest updateUserInfo,
  );

  @POST(ApiConstants.forgotPassword)
  Future<ForgotPasswordResponse> forgotPassword(
    @Body() ForgotPasswordRequest forgotPasswordRequest,
  );

  @POST(ApiConstants.verifyCode)
  Future<VerifyCodeResponse> verifyCode(
    @Body() VerifyCodeRequest verifyCodeRequest,
  );

  @POST(ApiConstants.verifyCodeRegister)
  Future<VerifyCodeRegisterResponse> verifyCodeRegister(
    @Body() VerifyCodeRegisterRequest verifyCodeRegisterRequest,
  );

  @POST(ApiConstants.deleteAccount)
  Future<DeleteAccounResponse> deleteAccount(
    @Body() DeleteAccountRequest deleteAccountRequest,
  );

  // === جديد: إعادة إرسال رابط تحقق البريد. يعتمد على الـ token المرسل تلقائياً
  // بالـ header (نفس آلية باقي الطلبات المحمية)، فما يحتاج Body.
  @POST(ApiConstants.resendEmailVerification)
  Future<ResendVerificationResponse> resendEmailVerification();





  @GET(ApiConstants.hotelsApartments)
  Future<HotelApartmentListResponse> getHotelsApartments({
    @Query("region") String? region,
    @Query("min_price") double? minPrice,
    @Query("max_price") double? maxPrice,
  });

  // تم تعديل المسار هنا لنص مباشر لتجنب مشاكل الـ Generator مع الـ Interpolation
  @GET('/hotels-apartments/{id}')
  Future<HotelApartmentDetailResponse> getHotelApartmentDetails(
      @Path("id") int id,
      );

  @POST(ApiConstants.hotelsApartments)
  Future<HotelApartmentDetailResponse> addHotelApartment(
      @Body() AddHotelApartmentRequest request,
      );



}
