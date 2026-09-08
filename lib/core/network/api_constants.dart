class ApiConstants {
  static const String apiBaseUrl = "https://api.afaq.group/api/";
// Auth
  static const String login = "login";
  static const String register = "register";
  static const String sendCode = 'send-code';
  static const String forgotPassword = 'forgotPassword';
  static const String verifyCode = 'verify-code-forgot';
  static const String resetPassword = 'resetPassword';
  static const String verifyCodeRegister = 'verify-code';
  static const String hotelsApartments = 'hotels-apartments';


  // === جديد: إعادة إرسال رابط تحقق البريد
  // ⚠️ ملاحظة مهمة: هذا الـ route مسجل بدون بادئة /api/ في Laravel (تأكدنا
  // منه عبر `php artisan route:list`)، فلازم رابط كامل يتجاوز apiBaseUrl
  // بدل ما يعتمد على الإضافة التلقائية لـ /api/
  static const String resendEmailVerification = 'email/resend';

  // user Ads
  static const String showUserAdvertisement = 'show_all';


// notification is read or not
  static const String markNotificationsAsRead = 'markNotificationsAsRead';
  static const String clearAllNotifications = 'notifications/clear-all';




  //advertisement
  static const String deleteAdvertisement = 'advertisementdestroy';
  static const String updateAdvertisement = 'advertisementupdate';
  static const String addAdvertisement = 'advertisementstore';
  static const String allAds = 'advertisements';

  // home
  static const String adsAuction = 'adsauction';
  static const String adsVip = 'adsvip';
  static const String searchAds = 'adSsearch';
  static const String filterSection = 'advertisements/filter';
  static const String getPropertyTypes = 'get-property-types';
  static const String getAreas = 'get-areas';
  static const String getAmenities = 'get-amenities';
  static const String news = 'News';
  static const String searchFilter = 'Search';
  static const String calculateMarketValue = 'calculateMarketValue';
  static const String  calculateConstructionCost = 'calculateConstructionCost';

  // User Info
  static const String userInfo = 'userinfo';
  static const String userUpdateInfo = 'profile/update';
  static const String notifications = 'Notifications';
  static const String deleteAccount = 'delete-account';
  static const String getUserMonthlyPoints = 'getUserMonthlyPoints';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
