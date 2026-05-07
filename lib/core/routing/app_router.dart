import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/account_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/partner_auth_gateway_screen.dart';
import '../../features/auth/presentation/screens/partner_register_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/contacts/presentation/screens/contact_detail_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/Community/community_screen.dart';
import '../../features/Community/presentation/screens/notification.dart';
import '../../features/missions/presentation/screens/partner_missions_screen.dart';

import '../../features/partner_ads/presentation/screens/collection_point_detail_screen.dart';
import '../../features/partner_ads/presentation/screens/collection_points_screen.dart';
import '../../features/partner/presentation/screens/partner_access_screen.dart';
import '../../features/partner_ads/presentation/screens/partner_create_collection_point_screen.dart';
import '../../features/partner_ads/presentation/screens/partner_location_picker_screen.dart';
import '../../features/partner_ads/presentation/screens/partner_publish_ad_screen.dart';
import '../../features/partner/presentation/screens/partner_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_settings_screen.dart';
import '../../features/points/presentation/screens/points_screen.dart';
import '../../features/points/presentation/screens/my_redemptions_screen.dart';
import '../../features/profile/presentation/screens/myprofile_myanimals_screen.dart';
import '../../features/profile/presentation/screens/add_animal_screen.dart';
import '../../features/profile/data/models/my_animal_model.dart';
import '../../features/profile/presentation/screens/personal_info_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/seek/presentation/screens/seek_report_detail_screen.dart';
import '../../features/reports/presentation/screens/report_step_1_screen.dart';
import '../../features/reports/presentation/screens/report_step_2_screen.dart';
import '../../features/reports/presentation/screens/report_step_3_screen.dart';
import '../../features/reports/presentation/screens/report_step_4_screen.dart';
import '../../features/reports/presentation/screens/location_picker_screen.dart';
import '../../features/reports/presentation/screens/my_reports_screen.dart';
import '../../features/seek/presentation/screens/seek_reports_screen.dart';
import '../../features/solidarity/presentation/screens/solidarity_hub_screen.dart';
import '../../features/solidarity/presentation/screens/solidarity_shop_screen.dart';
import '../../features/solidarity/presentation/screens/my_donations_screen.dart';
import '../../features/payment/presentation/screens/payment_methods_screen.dart';
import '../../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../../features/profile/presentation/screens/legal_notices_screen.dart';
import '../../features/profile/presentation/screens/contact_support_screen.dart';
import 'route_guards.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStateProvider);
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: RouteNames.account,
    routes: [
      GoRoute(
        path: RouteNames.root,
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: RouteNames.main,
        redirect: (context, state) => RouteNames.root,
      ),
      GoRoute(
        path: RouteNames.account,
        builder: (context, state) => const AuthAccountScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const AuthLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerLogin,
        builder: (context, state) => const AuthLoginScreen(isPartner: true),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const AuthRegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerRegister,
        builder: (context, state) => const PartnerRegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerRegisterLocationPicker,
        builder: (context, state) => const PartnerLocationPickerScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerAuthGateway,
        builder: (context, state) => const PartnerAuthGatewayScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final lockEmail = state.uri.queryParameters['lockEmail'] == '1';
          return ForgotPasswordScreen(
            initialEmail: email,
            lockEmail: lockEmail,
          );
        },
      ),
      GoRoute(
        path: RouteNames.verifyOtp,
        builder: (context, state) {
          final mode =
              state.uri.queryParameters['mode'] ?? VerifyOtpScreen.modeAccount;
          final email = state.uri.queryParameters['email'];
          return VerifyOtpScreen(mode: mode, initialEmail: email);
        },
      ),
      GoRoute(
        path: RouteNames.resetPassword,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          final email = state.uri.queryParameters['email'];
          return ResetPasswordScreen(token: token, email: email);
        },
      ),
      GoRoute(
        path: RouteNames.reports,
        builder: (context, state) => const SeekReportsScreen(),
      ),
      GoRoute(
        path: RouteNames.reportDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SeekReportDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: RouteNames.mainHome,
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: RouteNames.myReports,
        builder: (context, state) => const MyReportsScreen(),
      ),
      GoRoute(
        path: RouteNames.mainReports,
        builder: (context, state) => const MyReportsScreen(),
      ),
      GoRoute(
        path: RouteNames.mainCommunity,
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: RouteNames.mainSolidarity,
        builder: (context, state) => const SolidarityHubScreen(),
      ),
      GoRoute(
        path: RouteNames.mainNotifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: RouteNames.myDonations,
        builder: (context, state) => const MyDonationsScreen(),
      ),
      GoRoute(
        path: RouteNames.solidarityShop,
        builder: (context, state) => const SolidarityShopScreen(),
      ),
      GoRoute(
        path: RouteNames.mainProfile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.myProfile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.reportCreateStep1,
        builder: (context, state) => const ReportStep1Screen(),
      ),
      GoRoute(
        path: RouteNames.reportCreateStep2,
        builder: (context, state) => const ReportStep2Screen(),
      ),
      GoRoute(
        path: RouteNames.reportCreateStep3,
        builder: (context, state) => const ReportStep3Screen(),
      ),
      GoRoute(
        path: RouteNames.reportCreateStep4,
        builder: (context, state) => const ReportStep4Screen(),
      ),
      GoRoute(
        path: RouteNames.reportLocationPicker,
        builder: (context, state) => const LocationPickerScreen(),
      ),

      GoRoute(
        path: '/collection-points/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CollectionPointDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: RouteNames.partnerAccess,
        builder: (context, state) => const PartnerAccessScreen(),
      ),
      GoRoute(
        path: '/partner/location-picker',
        builder: (context, state) => const PartnerLocationPickerScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerProfile,
        builder: (context, state) => const PartnerProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerCollectionPoints,
        builder: (context, state) => const CollectionPointsScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerCreateCollectionPoint,
        builder: (context, state) => const PartnerCreateCollectionPointScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerMissions,
        builder: (context, state) => const PartnerMissionsScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerAds,
        builder: (context, state) => const PartnerPublishAdScreen(),
      ),
      GoRoute(
        path: RouteNames.partnerSettings,
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.profilePersonalInformation,
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.profileSettings,
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: '/contacts/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ContactDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: RouteNames.profileMyAnimals,
        builder: (context, state) => const MyAnimalsScreen(),
      ),
      GoRoute(
        path: RouteNames.profileAddAnimal,
        builder: (context, state) => const AddAnimalScreen(),
      ),
      GoRoute(
        path: RouteNames.profileEditAnimal,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final initialAnimal = state.extra is MyAnimalModel
              ? state.extra as MyAnimalModel
              : null;
          return AddAnimalScreen(animalId: id, initialAnimal: initialAnimal);
        },
      ),
      GoRoute(
        path: RouteNames.profilePoints,
        builder: (context, state) => const PointsScreen(),
      ),
      GoRoute(
        path: RouteNames.profileMyRedemptions,
        builder: (context, state) => const MyRedemptionsScreen(),
      ),
      GoRoute(
        path: RouteNames.profilePaymentMethods,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RouteNames.legalNotices,
        builder: (context, state) => const LegalNoticesScreen(),
      ),
      GoRoute(
        path: RouteNames.contactSupport,
        builder: (context, state) => const ContactSupportScreen(),
      ),
    ],
    redirect: (context, state) =>
        routeGuard(authStatus, state, userRole: currentUser?.role),
  );
});
