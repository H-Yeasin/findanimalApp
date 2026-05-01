import 'package:flutter/material.dart';
import 'l10n/app_fr.dart';
import 'l10n/app_en.dart';
import 'l10n/app_de.dart';
import 'l10n/app_es.dart';
import 'l10n/app_it.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('fr'),
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('it'),
  ];

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': appFr,
    'en': appEn,
    'de': appDe,
    'es': appEs,
    'it': appIt,
  };

  String _text(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  String text(String key, {Map<String, String> params = const {}}) {
    var value = _text(key);
    params.forEach((placeholder, replacement) {
      value = value.replaceAll('{$placeholder}', replacement);
    });
    return value;
  }

  String fieldRequired(String field) {
    return text('fieldRequired', params: {'field': field});
  }

  String seeAnimalSheet(String animal) {
    return text('seeAnimalSheet', params: {'animal': animal});
  }

  String viewProfile(String name) {
    return text('viewProfile', params: {'name': name});
  }

  String homeReportStatusDate(String status, String date) {
    return text(
      'homeReportStatusDate',
      params: {'status': status, 'date': date},
    );
  }

  String nearbyKm(int radius) {
    return text('nearbyKm', params: {'radius': '$radius'});
  }

  String radiusValue(int radius) {
    return text('radiusValue', params: {'radius': '$radius'});
  }

  String get appName => _text('appName');
  String get settingsTitle => _text('settingsTitle');
  String get changePassword => _text('changePassword');
  String get registeredPaymentMethods => _text('registeredPaymentMethods');
  String get language => _text('language');
  String get darkLightMode => _text('darkLightMode');
  String get locationAuthorization => _text('locationAuthorization');
  String get privacyPolicy => _text('privacyPolicy');
  String get legalNotices => _text('legalNotices');
  String get contactSupport => _text('contactSupport');
  String get deleteMyAccount => _text('deleteMyAccount');
  String get navSeek => _text('navSeek');
  String get navReport => _text('navReport');
  String get navCommunity => _text('navCommunity');
  String get navSolidarity => _text('navSolidarity');
  String get retry => _text('retry');
  String get unknownError => _text('unknownError');
  String get accountTitle => _text('accountTitle');
  String get login => _text('login');
  String get createAccount => _text('createAccount');
  String get partnerAccess => _text('partnerAccess');
  String get loginTitle => _text('loginTitle');
  String get partnerLoginTitle => _text('partnerLoginTitle');
  String get emailLabel => _text('emailLabel');
  String get emailHint => _text('emailHint');
  String get confirmEmailHint => _text('confirmEmailHint');
  String get passwordLabel => _text('passwordLabel');
  String get passwordHint => _text('passwordHint');
  String get confirmPasswordHint => _text('confirmPasswordHint');
  String get forgotPassword => _text('forgotPassword');
  String get continueLabel => _text('continue');
  String get continueWithApple => _text('continueWithApple');
  String get continueWithGoogle => _text('continueWithGoogle');
  String get or => _text('or');
  String get unauthorizedPartnerLogin => _text('unauthorizedPartnerLogin');
  String get registerSuccess => _text('registerSuccess');
  String get registerTitle => _text('registerTitle');
  String get firstNameLabel => _text('firstNameLabel');
  String get lastNameLabel => _text('lastNameLabel');
  String get firstNameHint => _text('firstNameHint');
  String get lastNameHint => _text('lastNameHint');
  String get phoneLabel => _text('phoneLabel');
  String get phoneHint => _text('phoneHint');
  String get addressLabel => _text('addressLabel');
  String get addressHint => _text('addressHint');
  String get companyNameLabel => _text('companyNameLabel');
  String get companyNameHint => _text('companyNameHint');
  String get createMyAccount => _text('createMyAccount');
  String get registerAsPartner => _text('registerAsPartner');
  String get partnerRegisterTitle => _text('partnerRegisterTitle');
  String get partnerRegisterSuccess => _text('partnerRegisterSuccess');
  String get forgotPasswordTitle => _text('forgotPasswordTitle');
  String get sendOtp => _text('sendOtp');
  String get otpSent => _text('otpSent');
  String get resetPasswordTitle => _text('resetPasswordTitle');
  String get newPasswordLabel => _text('newPasswordLabel');
  String get updatePassword => _text('updatePassword');
  String get passwordResetSuccess => _text('passwordResetSuccess');
  String get verifyAccountOtpTitle => _text('verifyAccountOtpTitle');
  String get verifyResetOtpTitle => _text('verifyResetOtpTitle');
  String get otpLabel => _text('otpLabel');
  String get verifyOtp => _text('verifyOtp');
  String get accountVerified => _text('accountVerified');
  String get invalidOtpResponse => _text('invalidOtpResponse');
  String get otpMust6Digits => _text('otpMust6Digits');
  String get emailsDoNotMatch => _text('emailsDoNotMatch');
  String get passwordsDoNotMatch => _text('passwordsDoNotMatch');
  String get emailRequired => _text('emailRequired');
  String get emailInvalid => _text('emailInvalid');
  String get fieldEmail => _text('fieldEmail');
  String get fieldFirstName => _text('fieldFirstName');
  String get fieldLastName => _text('fieldLastName');
  String get fieldPhone => _text('fieldPhone');
  String get fieldAddress => _text('fieldAddress');
  String get fieldCompanyName => _text('fieldCompanyName');
  String get fieldPassword => _text('fieldPassword');
  String get fieldConfirmPassword => _text('fieldConfirmPassword');
  String get fieldOtp => _text('fieldOtp');
  String get memberSince => _text('memberSince');
  String get myProfileMyAnimals => _text('myProfileMyAnimals');
  String get myReportsLabel => _text('myReportsLabel');
  String get donationsMade => _text('donationsMade');
  String get myPoints => _text('myPoints');
  String get settings => _text('settings');
  String get notifications => _text('notifications');
  String get logout => _text('logout');
  String get inviteContacts => _text('inviteContacts');
  String get contactUs => _text('contactUs');
  String get nameAndFirstName => _text('nameAndFirstName');
  String get subject => _text('subject');
  String get message => _text('message');
  String get enterMyFirstAndLastName => _text('enterMyFirstAndLastName');
  String get contactSubjectHint => _text('contactSubjectHint');
  String get tellUsEverything => _text('tellUsEverything');
  String get sendMyMessage => _text('sendMyMessage');
  String get myReportsTitle => _text('myReportsTitle');
  String get pleaseLoginToViewReports => _text('pleaseLoginToViewReports');
  String get goToLogin => _text('goToLogin');
  String get couldNotLoadReports => _text('couldNotLoadReports');
  String get editMyReport => _text('editMyReport');
  String get unknownAnimal => _text('unknownAnimal');
  String get unknownValue => _text('unknownValue');
  String get seeOnMap => _text('seeOnMap');
  String get found => _text('found');
  String get communityTitle => _text('communityTitle');
  String get mindHint => _text('mindHint');
  String get picture => _text('picture');
  String get video => _text('video');
  String get file => _text('file');
  String get pleaseLoginToPostCommunity => _text('pleaseLoginToPostCommunity');
  String get couldNotPost => _text('couldNotPost');
  String get postSharedSuccess => _text('postSharedSuccess');
  String get pleaseLoginToShareStory => _text('pleaseLoginToShareStory');
  String get couldNotShareStory => _text('couldNotShareStory');
  String get storySharedSuccess => _text('storySharedSuccess');
  String get newStory => _text('newStory');
  String get cancel => _text('cancel');
  String get post => _text('post');
  String get couldNotLoadStories => _text('couldNotLoadStories');
  String get findFriend => _text('findFriend');
  String get posting => _text('posting');
  String get localCat => _text('localCat');
  String get pleaseLoginToViewLocalChat => _text('pleaseLoginToViewLocalChat');
  String get couldNotLoadLocalChat => _text('couldNotLoadLocalChat');
  String get seekViewReports => _text('seekViewReports');
  String get locationUpdated => _text('locationUpdated');
  String get couldNotGetLocation => _text('couldNotGetLocation');
  String get filters => _text('filters');
  String get globalSearch => _text('globalSearch');
  String get noReportsFound => _text('noReportsFound');
  String get errorLoadingReports => _text('errorLoadingReports');
  String get viewOnMap => _text('viewOnMap');
  String get adjustFilters => _text('adjustFilters');
  String get searchAnimal => _text('searchAnimal');
  String get status => _text('status');
  String get searchRadius => _text('searchRadius');
  String get sortBy => _text('sortBy');
  String get applyFilters => _text('applyFilters');
  String get searchHintExample => _text('searchHintExample');
  String get date => _text('date');
  String get name => _text('name');
  String get reportOneOfMyAnimals => _text('reportOneOfMyAnimals');
  String get homeInfoBanner => _text('homeInfoBanner');
  String get homeWelcomePrefix => _text('homeWelcomePrefix');
  String get homeExploreFullMap => _text('homeExploreFullMap');
  String get homeReportedRecently => _text('homeReportedRecently');
  String get homeNearYou => _text('homeNearYou');
  String get homeSeeMore => _text('homeSeeMore');
  String get homeCommunityHelped => _text('homeCommunityHelped');
  String get homeAnimalsFound => _text('homeAnimalsFound');
  String get homeReports => _text('homeReports');
  String get homeAnimalsRescued => _text('homeAnimalsRescued');
  String get homeSupportTitle => _text('homeSupportTitle');
  String get homeMakeDonation => _text('homeMakeDonation');
  String get homeSolidarityShop => _text('homeSolidarityShop');
  String get homeSignUpMission => _text('homeSignUpMission');
  String get homeSupportBody => _text('homeSupportBody');
  String get homeSupportPoints => _text('homeSupportPoints');
  String get homeFilterTitle => _text('homeFilterTitle');
  String get homeSearchExample => _text('homeSearchExample');
  String get statusAll => _text('statusAll');
  String get statusMissing => _text('statusMissing');
  String get statusFound => _text('statusFound');
  String get statusRescued => _text('statusRescued');
  String get communityUser => _text('communityUser');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((item) => item.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
