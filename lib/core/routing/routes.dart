import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/models/response/response.dart';
import '../../features/auth/ui/view/forgot_password/forgot_password_view.dart';
import '../../features/auth/ui/view/login/view/login_view.dart';
import '../../features/auth/ui/view/register/view/register_otp_view.dart';
// === جديد: صفحة تحقق البريد + الكيوبت الخاص فيها
import '../../features/auth/ui/view/verify_email/verify_email_view.dart';
import '../../features/auth/logic/email_verification_cubit.dart';
import '../../features/our_services/view/calculate_construction_cost_view.dart';
import '../../features/our_services/view/calculate_market_value_view.dart';
import '../../features/our_services/view/calculate_rent_view.dart';
import '../../features/dashboard/data/response/response.dart';
import '../../features/dashboard/ui/view/advertisements/view/add_ads/add_ads_view.dart';
import '../../features/dashboard/ui/view/dashboard_view.dart';
import '../../features/dashboard/ui/view/home_details_view.dart';
import '../../features/dashboard/ui/widgets/sections/section_services.dart';
import '../../features/our_services/view/managing_others_properties_view.dart';
import '../../features/property_management/owner_portfolio_view.dart';
import '../../features/property_management/tenant_home_view.dart';
import '../../features/real_estate/property_request_view.dart';
import '../../features/real_estate/real_estate_category_entry_view.dart';
import '../../features/contracting/contracting_categories_view.dart';
import '../../features/jobs/jobs_choice_view.dart';
import '../../features/jobs/job_vacancy_view.dart';
import '../../features/companies/companies_list_view.dart';
import '../widgets/favorites_view.dart';
import '../../features/contracting/my_service_requests_view.dart';
import '../../features/contracting/add_contracting_view.dart';
import '../../features/contracting/contractors_list_view.dart';
import '../../features/jobs/job_vacancies_browse_view.dart';
import '../../features/engineering_offices/engineering_offices_list_view.dart';
import '../../features/hotels_apartments/ui/view/hotel_apartment_search_view.dart';
import '../../features/hotels_apartments/logic/hotel_apartment_search_cubit.dart';
import '../../features/hotels/ui/hotels_list_view.dart';
import '../../features/hotels/ui/add_hotel_view.dart';
import '../../features/our_services/view/real_estate_consultation_view.dart';
import '../../features/our_services/view/request_official_evaluation_view.dart';
import '../../features/settings/view/about_us/about_us_view.dart';
import '../../features/auth/logic/cubit_cubit.dart';
import '../../features/auth/ui/view/otp/otp_view.dart';
import '../../features/auth/ui/view/register/view/register_view.dart';
import '../../features/auth/ui/view/reset_password/reset_password_view.dart';
import '../../features/dashboard/logic/home_cubit.dart';
import '../../features/dashboard/ui/view/advertisements/widgets/ads/ads_details.dart';
import '../../features/onboarding/onboarding_view.dart';
import '../../features/settings/view/my_advertisements/edit_advertisement_view.dart';
import '../../features/settings/view/privacy_policy/privacy_policy_view.dart';
import '../../features/settings/view/profile/edit_profile_view.dart';
import '../../features/settings/view/profile/profile_view.dart';
import '../../features/settings/view/my_advertisements/my_advertisements_view.dart';
// === جديد: الحارس اللي يمنع فتح الصفحات المهمة قبل تحقق البريد
import '../widgets/email_verification_guard.dart';
import '../di/di.dart';

class EditProfileArgs {
  final UserInfoResponse? userData;
  EditProfileArgs({this.userData});
}

class Routes {
  static const String onBoardingRoute = "/onBoarding";
  // Auth
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String verifiyRoute = "/verifiy";
  static const String forgotPasswordRoute = "/forgot-password";
  static const String resetPasswordRoute = "/reset-password";
  static const String otpRoute = "/otp";
  static const String otpRegisterRoute = "/otp-register";

  // User
  static const String myAdvertisementsRoute = '/my-advertisements';
  static const String addRoute = '/AddView';
  static const String editAdRoute = '/edit_Ad';

  // Home
  static const String homeDetailsRoute = '/home-details';
  static const String adsDetailsRoute = '/ads-details';
  static const String servicesGridRoute = '/services_grid';
  static const String profileRoute = "/profile";
  static const String editProfileRoute = "/edit-profile";
  static const String aboutUsRoute = "/about-us";
  static const String dashboardRoute = "/dashboard";
  static const String articlesNewsRoute = "/articles-news";
  static const String auctionDetailsRoute = "/auction-details";

  static const String calculateMarketValueRoute = "/calculate-marketValue";
  static const String calculateRentRoute = "/calculate-rent";
  static const String propertyRequestRoute = "/property-request";
  static const String ownerPortfolioRoute = "/owner-portfolio";
  static const String tenantHomeRoute = "/tenant-home";

  static const String calculateConstructionCostRoute = "/calculate-constructionCost";

  static const String officialRequestRoute = "/officiar-Request";

  static const String managingOthersPropertiesRoute = "/managing-others";
  static const String realEstateConsultationRoute = "/real-estate-consultation";
  static const String privacyRoute = "/privacy";
  static const String adDetailsRoute = "/ad_details";
  static const String realEstateSectionRoute = "/section-real-estate";
  static const String contractingSectionRoute = "/section-contracting";
  static const String jobsSectionRoute = "/section-jobs";
  static const String jobVacancyRoute = "/job-vacancy";
  static const String realEstateCompaniesSectionRoute = "/section-real-estate-companies";
  static const String favoritesRoute = "/favorites";
  static const String myServiceRequestsRoute = "/my-service-requests";
  static const String addContractingRoute = "/add-contracting";
  static const String contractorsListRoute = "/contractors-list";
  static const String jobVacanciesBrowseRoute = "/job-vacancies-browse";
  static const String engineeringOfficesSectionRoute = "/section-engineering-offices";
  static const String hotelsSectionRoute = "/section-hotels";
  static const String addHotelRoute = "/add-hotel";
}

class AppRoute {
  static Route<dynamic> onGeneratorRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<LoginCubit>(),
            child: const LoginView(),
          ),
        );
      case Routes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<RegisterCubit>(),
            child: const RegisterView(),
          ),
        );

      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => di<ForgotPasswordCubit>()),
              BlocProvider(
                create: (context) => di<VerifyCodeCubit>(),
              ),
            ],
            child: const ForgotPasswordView(),
          ),
        );
      case Routes.otpRoute:
        final email = settings.arguments as String? ?? "";
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<VerifyCodeCubit>(),
            child: OtpView(
              email: email,
            ),
          ),
        );
      case Routes.otpRegisterRoute:
        final arguments = settings.arguments as Map<String, dynamic>;
        final phone = arguments['phone'] as String;
        final email = arguments['email'] as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<VerifyCodeRegisterCubit>(),
            child: RegisterOtpView(
              phone: phone,
              email: email,
            ),
          ),
        );
      case Routes.resetPasswordRoute:
        final email = settings.arguments as String? ?? "No Email Found";
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<ResetPasswordCubit>(),
            child: ResetPasswordView(email: email),
          ),
        );

      // === جديد: صفحة تحقق البريد - ما تُحرس بنفسها (وإلا صار Loop لا نهائي)
      case Routes.verifiyRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di<EmailVerificationCubit>(),
            child: const VerifyEmailView(),
          ),
        );

      case Routes.addRoute:
        final sectionItem = settings.arguments as SectionServices;
        return MaterialPageRoute(
          builder: (_) => EmailVerificationGuard(
            child: BlocProvider(
              create: (context) => di<AddAdvertisementCubit>(),
              child: AddAdsView(transactionType: sectionItem.dbValue),
            ),
          ),
        );
      case Routes.calculateMarketValueRoute:
        return MaterialPageRoute(
          builder: (_) => const CalculateMarketValueView(),
        );
      case Routes.calculateRentRoute:
        return MaterialPageRoute(
          builder: (_) => const CalculateRentView(),
        );
      case Routes.propertyRequestRoute:
        return MaterialPageRoute(
          builder: (_) => const PropertyRequestView(),
        );
      case Routes.ownerPortfolioRoute:
        return MaterialPageRoute(
          builder: (_) => const OwnerPortfolioView(),
        );
      case Routes.tenantHomeRoute:
        return MaterialPageRoute(
          builder: (_) => const TenantHomeView(),
        );
      case Routes.officialRequestRoute:
        return MaterialPageRoute(
          builder: (_) => const RequestOfficialEvaluationView(),
        );
      case Routes.managingOthersPropertiesRoute:
        return MaterialPageRoute(
          builder: (_) => const ManagingOthersPropertiesView(),
        );
      case Routes.realEstateConsultationRoute:
        return MaterialPageRoute(
          builder: (_) => const RealEstateConsultationView(),
        );
      case Routes.calculateConstructionCostRoute:
        return MaterialPageRoute(builder: (_) => const CalculateConstructionCostView());
      case Routes.homeDetailsRoute:
        return MaterialPageRoute(builder: (_) => const HomeDetailsView());
      case Routes.privacyRoute:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyView());
      case Routes.adsDetailsRoute:
        return MaterialPageRoute(builder: (_) => AdsDetailsScreen());
      case Routes.editProfileRoute:
        final args = settings.arguments as EditProfileArgs?;
        return MaterialPageRoute(
          builder: (_) => EmailVerificationGuard(
            child: BlocProvider(
              create: (context) => di<UpdateUserInfoCubit>(),
              child: EditProfileView(userData: args?.userData),
            ),
          ),
        );

      case Routes.profileRoute:
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationGuard(
            child: ProfileView(),
          ),
        );
      case Routes.aboutUsRoute:
        return MaterialPageRoute(builder: (_) => const AboutUsView());
      case Routes.dashboardRoute:
        return MaterialPageRoute(
          builder: (_) => EmailVerificationGuard(
            child: BlocProvider(
              create: (context) => HomeCubit(di())
                ..getAllAds()
                ..getVipAds(),
              child: const DashboardView(),
            ),
          ),
        );
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case Routes.myAdvertisementsRoute:
        return MaterialPageRoute(
          builder: (_) => EmailVerificationGuard(
            child: BlocProvider(
              create: (context) => di<ShowUserAdCubit>()..emitGetUserAds(),
              child: const MyAdvertisementsView(),
            ),
          ),
        );

      case Routes.editAdRoute:
        final args = settings.arguments as Map<String, dynamic>;
        final adData = args['adData'] as ShowUserAdvertisementData;
        final showUserAdCubit = args['showUserAdCubit'] as ShowUserAdCubit;
        return MaterialPageRoute(
          builder: (_) => EmailVerificationGuard(
            child: MultiBlocProvider(
              providers: [
                // نستخدم .value لأن الكيوبت موجود بالفعل ولا نريد إنشاء واحد جديد
                BlocProvider.value(value: showUserAdCubit),
                // إنشاء كيوبيت التعديل كالمعتاد
                BlocProvider(
                  create: (context) => di<UpdateAdCubit>(),
                ),
                // إضافة كيوبيت الإعلانات للحصول على المناطق
                BlocProvider(
                  create: (context) => di<AddAdvertisementCubit>()
                    ..getRegions()
                    ..getPropertyTypes(),
                ),
              ],
              child: EditAdvertisementView(adData: adData),
            ),
          ),
        );
      case Routes.adDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => const ManagingOthersPropertiesView(),
        );
      case Routes.realEstateSectionRoute:
        return MaterialPageRoute(builder: (_) => const RealEstateCategoryEntryView());
      case Routes.contractingSectionRoute:
        return MaterialPageRoute(builder: (_) => const ContractingCategoriesView());
      case Routes.jobsSectionRoute:
        return MaterialPageRoute(builder: (_) => const JobsChoiceView());
      case Routes.jobVacancyRoute:
        return MaterialPageRoute(builder: (_) => const JobVacancyView());
      case Routes.realEstateCompaniesSectionRoute:
        return MaterialPageRoute(builder: (_) => const CompaniesListView());
      case Routes.favoritesRoute:
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationGuard(child: FavoritesView()),
        );
      case Routes.myServiceRequestsRoute:
        return MaterialPageRoute(builder: (_) => const MyServiceRequestsView());
      case Routes.addContractingRoute:
        return MaterialPageRoute(builder: (_) => const AddContractingView());
      case Routes.contractorsListRoute:
        final categoryName = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => ContractorsListView(categoryName: categoryName));
      case Routes.jobVacanciesBrowseRoute:
        return MaterialPageRoute(builder: (_) => const JobVacanciesBrowseView());
      case Routes.engineeringOfficesSectionRoute:
        return MaterialPageRoute(builder: (_) => const EngineeringOfficesListView());
      case Routes.hotelsSectionRoute:
        return MaterialPageRoute(builder: (_) => const HotelsListView());
      case Routes.addHotelRoute:
        return MaterialPageRoute(builder: (_) => const AddHotelView());
      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardView(),
        );
    }
  }
}
