import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repository/repository.dart';
import '../../features/auth/logic/cubit_cubit.dart';
import '../../features/dashboard/data/network/home_api.dart';
import '../../features/dashboard/data/repository/home_repository.dart';
import '../../features/dashboard/logic/home_cubit.dart';
import '../network/app_api.dart';
import '../network/dio_factory.dart';
import '../../features/auth/logic/email_verification_cubit.dart';
import 'package:afaq_real_estate/features/hotels_apartments/data/repository.dart';
import 'package:afaq_real_estate/features/hotels_apartments/logic/hotel_apartment_add_cubit.dart';
import 'package:afaq_real_estate/features/hotels_apartments/logic/hotel_apartment_search_cubit.dart';




final di = GetIt.instance;

Future<void> init() async {
  di.allowReassignment = true;
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  di.registerLazySingleton<ApiService>(() => ApiService(dio));

  // login
  di.registerLazySingleton<LoginRepository>(() => LoginRepository(di()));
  di.registerFactory<LoginCubit>(() => LoginCubit(di()));

  // signup
  di.registerLazySingleton<RegisterRepository>(() => RegisterRepository(di()));
  di.registerFactory<RegisterCubit>(() => RegisterCubit(di()));

  // ForgotPassword
  di.registerLazySingleton<ForgotPasswordRepository>(
      () => ForgotPasswordRepository(di()));
  di.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(di()));

  // VerifyCode
  di.registerLazySingleton<VerifyCodeRepository>(
      () => VerifyCodeRepository(di()));
  di.registerFactory<VerifyCodeCubit>(() => VerifyCodeCubit(di()));

  di.registerLazySingleton<VerifyCodeRegistrRepository>(
      () => VerifyCodeRegistrRepository(di()));
  di.registerFactory<VerifyCodeRegisterCubit>(
      () => VerifyCodeRegisterCubit(di()));

  // ResetPassword
  di.registerLazySingleton<ResetPasswordRepository>(
      () => ResetPasswordRepository(di()));
  di.registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(di()));

  // home
  di.registerLazySingleton<HomeRepository>(() => HomeRepository(di()));
  di.registerLazySingleton<HomeApi>(() => HomeApi(dio));

  // Add Advertisement
  di.registerLazySingleton<AddAdvertisementRepository>(
      () => AddAdvertisementRepository(di()));
  di.registerFactory<AddAdvertisementCubit>(
      () => AddAdvertisementCubit(di(), di()));

  // Show user ads
  di.registerLazySingleton<ShowUserAdRepository>(
      () => ShowUserAdRepository(di()));
  di.registerFactory<ShowUserAdCubit>(() => ShowUserAdCubit(di()));

  // Search
  di.registerLazySingleton<AdsSearchRepository>(
      () => AdsSearchRepository(di()));
  di.registerFactory<FilterCubit>(() => FilterCubit(di()));

  // filter Section
  di.registerLazySingleton<FilterSectionRepository>(
      () => FilterSectionRepository(di()));
  di.registerFactory<FilterSctionCubit>(() => FilterSctionCubit(di()));
  // ===========
  di.registerLazySingleton<SearchFilterRepository>(
      () => SearchFilterRepository(di()));
  di.registerFactory<SearchFilterCubit>(() => SearchFilterCubit(di()));
  // User Info
  di.registerLazySingleton<UserInfoRepository>(() => UserInfoRepository(di()));
  di.registerFactory<UserInfoCubit>(() => UserInfoCubit(di()));
// =================
  di.registerLazySingleton<UserMonthlyPointsRepository>(
      () => UserMonthlyPointsRepository(di()));
  di.registerFactory<UserMonthlyPointsCubit>(
      () => UserMonthlyPointsCubit(di()));
  // Update User Info
  di.registerLazySingleton<UpdateUserInfoRepository>(
      () => UpdateUserInfoRepository(di()));
  di.registerFactory<UpdateUserInfoCubit>(() => UpdateUserInfoCubit(di()));

  // Update Ad
  di.registerLazySingleton<UpdateAdRepository>(() => UpdateAdRepository(di()));
  di.registerFactory<UpdateAdCubit>(() => UpdateAdCubit(di()));

  // Delete Ad
  di.registerLazySingleton<DeleteAdRepository>(() => DeleteAdRepository(di()));
  di.registerFactory<DeleteAdCubit>(() => DeleteAdCubit(di()));
  // Delete Account
  di.registerLazySingleton<DeleteAccountRepository>(
      () => DeleteAccountRepository(di()));
  di.registerFactory<DeleteAccountCubit>(() => DeleteAccountCubit(di()));

  // Notifications
  // تأكد من وجود الـ Repository وتسجيله أولاً
  di.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository(di()));
  // تسجيل الـ Cubit
  di.registerFactory<NotificationsCubit>(() => NotificationsCubit(di()));

  // News
  // Notifications
  // تأكد من وجود الـ Repository وتسجيله أولاً
  di.registerLazySingleton<NewsRepository>(() => NewsRepository(di()));
  // تسجيل الـ Cubit
  di.registerFactory<NewsCubit>(() => NewsCubit(di()));

  di.registerLazySingleton<CalculateMarketValueRepository>(
      () => CalculateMarketValueRepository(di()));
  di.registerFactory<CalculateMarketValueCubit>(
      () => CalculateMarketValueCubit(di()));

//==============================================================================
  di.registerLazySingleton<CalculateConstructionCostRepository>(
      () => CalculateConstructionCostRepository(di()));
  di.registerFactory<CalculateConstructionCostCubit>(
      () => CalculateConstructionCostCubit(di()));

  //==============================================================================

  di.registerFactory(() => ResendVerificationRepository(di()));
  di.registerFactory(() => EmailVerificationCubit(di(), di()));


  di.registerLazySingleton<HotelApartmentRepository>(() => HotelApartmentRepository(di()));
  di.registerFactory<HotelApartmentAddCubit>(() => HotelApartmentAddCubit(di(), di()));
  di.registerFactory<HotelApartmentSearchCubit>(() => HotelApartmentSearchCubit(di(), di()));

}
