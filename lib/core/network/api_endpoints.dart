import '../config/env.dart';

class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = Env.apiBaseUrl;

  // Auth
  static const String login = '/auth/login';
  static const String registerUser = '/auth/register-user';
  static const String registerPartner = '/auth/register-partner';
  static const String verifyAccount = '/auth/verify-account';
  static const String forgetPassword = '/auth/forget-password';
  static const String verifyOtp = '/auth/verify-otp';
  static String resetPassword(String token) => '/auth/reset-password/$token';
  static const String generateAccessToken = '/auth/generate-access-token';
  static const String logout = '/auth/logout';
  static const String googleLogin = '/auth/google-login';
  static const String appleLogin = '/auth/apple-login';

  // Profile
  static const String myProfile = '/user/get-my-profile';
  static const String updateUser = '/user/update-user';
  static const String updateFcmToken = '/user/update-fcm-token';
  static const String createMyAnimal = '/myanimal/create';
  static const String getAllMyAnimals = '/myanimal/get-all';
  static String updateMyAnimal(String id) => '/myanimal/$id';

  // Reports
  static const String getAllReports = '/reports/get-all-reports';
  static const String getMyReports = '/reports/get-my-reports';
  static const String createReport = '/reports/create-report';
  static String updateReport(String id) => '/reports/update-report/$id';

  // Donations
  static const String stripeInitiate = '/donations/stripe/initiate';
  static const String paypalInitiate = '/donations/paypal/initiate';
  static const String paypalCapture = '/donations/paypal/capture';
  static const String myDonations = '/donations/my-donations';

  // Payments
  static const String paymentMethods = '/payments';
  static const String stripeCreateSetupIntent =
      '/payments/stripe/create-setup-intent';
  static String deletePaymentMethod(String id) => '/payments/$id';
  static String setDefaultPaymentMethod(String id) => '/payments/$id/default';

  // Partner Ads / Collection Points
  static const String getAllPartnerAds = '/partner-ads/get-all-partner-ads';
  static const String getMyPartnerAds = '/partner-ads/get-my-partner-ads';
  static const String createCollectionPoint =
      '/partner-ads/create-collection-point';

  // Missions
  static const String getAllLocalMissions =
      '/local-missions/get-all-local-missions';
  static const String getMyLocalMissions =
      '/local-missions/get-my-local-missions';
  static const String createLocalMission =
      '/local-missions/create-local-mission';
  static String submitMissionInterest(String id) =>
      '/local-missions/submit-interest/$id';
  static String getMissionParticipants(String id) =>
      '/local-missions/get-participants/$id';

  // Solidarity
  static const String shopifyCollections = '/solidarity/shopify-collections';
  static const String shopifyProducts = '/solidarity/shopify-products';

  // Notifications
  static const String getMyNotifications =
      '/notifications/get-my-notifications';
  static const String getAllAdminNotifications =
      '/notifications/get-all-admin-notifications';
  static String markNotificationAsRead(String id) =>
      '/notifications/mark-as-read/$id';
  static String deleteNotification(String id) =>
      '/notifications/delete-notification/$id';

  // Contacts
  static const String getAllContacts = '/contacts/get-all-contacts';
  static const String createContact = '/contacts/create-contact';
  static String getSingleContact(String id) => '/contacts/get-single-contact/$id';
  static String updateContact(String id) => '/contacts/update-contact/$id';
  static String deleteContact(String id) => '/contacts/delete-contact/$id';
  static String getContactsByType(String type) => '/contacts/get-by-type/$type';
}
