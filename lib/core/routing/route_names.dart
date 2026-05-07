class RouteNames {
  const RouteNames._();

  static const String root = '/';

  static const String account = '/auth/account';
  static const String login = '/auth/login';
  static const String partnerLogin = '/auth/partner-login';
  static const String register = '/auth/register';
  static const String partnerRegister = '/auth/partner-register';
  static const String partnerRegisterLocationPicker =
      '/auth/partner-location-picker';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String partnerAuthGateway = '/auth/partner-gateway';

  static const String main = '/main';
  static const String mainHome = '/main/home';
  static const String mainReports = '/main/reports';
  static const String mainCommunity = '/main/community';
  static const String mainSolidarity = '/main/solidarity';
  static const String mainNotifications = '/main/notifications';
  static const String solidarityShop = '/solidarity/shop';
  static const String mainProfile = '/main/profile';
  static const String myProfile = '/my-profile';

  static const String reports = '/seek-reports';
  static const String myReports = '/my-reports';
  static const String myDonations = '/my-donations';
  static const String reportDetail = '/reports/:id';
  static const String reportCreateStep1 = '/reports/create/step-1';
  static const String reportCreateStep2 = '/reports/create/step-2';
  static const String reportCreateStep3 = '/reports/create/step-3';
  static const String reportCreateStep4 = '/reports/create/step-4';
  static const String reportLocationPicker = '/reports/create/location-picker';

  static const String missionDetail = '/missions/:id';
  static const String collectionPointDetail = '/collection-points/:id';
  static const String partnerAccess = '/partner/access';
  static const String partnerProfile = '/partner/profile';
  static const String partnerCollectionPoints = '/partner/collection-points';
  static const String partnerCreateCollectionPoint =
      '/partner/collection-points/create';
  static const String partnerMissions = '/partner/missions';
  static const String partnerAds = '/partner/ads';
  static const String partnerSettings = '/partner/settings';
  static const String contactDetail = '/contacts/:id';
  static const String profileMyAnimals = '/profile/my-animals';
  static const String profileAddAnimal = '/profile/my-animals/add';
  static const String profileEditAnimal = '/profile/my-animals/edit/:id';
  static const String profilePersonalInformation =
      '/profile/personal-information';
  static const String profileSettings = '/profile/settings';
  static const String profilePoints = '/profile/points';
  static const String profileMyRedemptions = '/profile/my-redemptions';
  static const String profilePaymentMethods = '/profile/payment-methods';
  static const String privacyPolicy = '/profile/privacy-policy';
  static const String legalNotices = '/profile/legal-notices';
  static const String contactSupport = '/profile/contact-support';
}
