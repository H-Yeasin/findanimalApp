import 'package:flutter/material.dart';
import 'l10n/app_fr.dart';
import 'l10n/app_en.dart';

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

  String updateFailed(String error) =>
      text('updateFailed', params: {'error': error});
  String errorParam(String error) =>
      text('errorParam', params: {'error': error});

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
  String get filterLostAnimals => _text('filterLostAnimals');
  String get filterFoundAnimals => _text('filterFoundAnimals');
  String get filterSightedAnimals => _text('filterSightedAnimals');
  String get filterInjuredAnimals => _text('filterInjuredAnimals');
  String get communityUser => _text('communityUser');
  String get collectionPoints => _text('collectionPoints');
  String get makeDonation => _text('makeDonation');
  String get seeDetails => _text('seeDetails');
  String get seeCollectionPoint => _text('seeCollectionPoint');
  String get listShelters => _text('listShelters');
  String get allShelters => _text('allShelters');
  String get listVeterinarians => _text('listVeterinarians');
  String get allVeterinarians => _text('allVeterinarians');
  String get searchByName => _text('searchByName');
  String get filterBySortBy => _text('filterBySortBy');
  String get ourPartners => _text('ourPartners');
  String get viewWebsite => _text('viewWebsite');
  String get addToCart => _text('addToCart');
  String get seeLocalMissions => _text('seeLocalMissions');
  String get seeFullList => _text('seeFullList');
  String get goToFaq => _text('goToFaq');
  String get shareStory => _text('shareStory');
  String get partnersBody => _text('partnersBody');
  String get sheltersBody => _text('sheltersBody');
  String get veterinariansBody => _text('veterinariansBody');
  String get authoritiesTitle => _text('authoritiesTitle');
  String get authoritiesBody => _text('authoritiesBody');
  String get gendarmeries => _text('gendarmeries');
  String get toCall => _text('toCall');
  String get unknown => _text('unknown');
  String get noPhone => _text('noPhone');
  String get faqTitleLabel => _text('faqTitleLabel');
  String get howCanIHelp => _text('howCanIHelp');
  String get faqSubtitle => _text('faqSubtitle');
  String get faqContactText => _text('faqContactText');
  String get searchTopic => _text('searchTopic');
  String get categoryReport => _text('categoryReport');
  String get categoryMissions => _text('categoryMissions');
  String get categoryAccount => _text('categoryAccount');
  String get categoryMessaging => _text('categoryMessaging');
  String get categoryDonations => _text('categoryDonations');
  String get categorySecurity => _text('categorySecurity');
  String get together => _text('together');
  String get solidarityDescription => _text('solidarityDescription');
  String get collectionPointsAround => _text('collectionPointsAround');
  String get collectionPointsDescription =>
      _text('collectionPointsDescription');
  String get donatingNearYou => _text('donatingNearYou');
  String get thoseWhoAre => _text('thoseWhoAre');
  String get byOurSide => _text('byOurSide');
  String get solidarityShopTitle => _text('solidarityShopTitle');
  String get shopDescription => _text('shopDescription');
  String get viewShop => _text('viewShop');
  String get collectionPointsFullDescription =>
      _text('collectionPointsFullDescription');
  String get sortByName => _text('sortByName');
  String get sortByNewest => _text('sortByNewest');
  String get sortByOldest => _text('sortByOldest');
  String get collectionPointDetailTemplate =>
      _text('collectionPointDetailTemplate');
  String get missionsLocalesDescription => _text('missionsLocalesDescription');
  String get noMissionsFound => _text('noMissionsFound');
  String get seeMission => _text('seeMission');
  String get recently => _text('recently');
  String get daysAgo => _text('daysAgo');
  String get hoursAgo => _text('hoursAgo');
  String get minutesAgo => _text('minutesAgo');
  String get justNow => _text('justNow');
  String get searchMissions => _text('searchMissions');
  String get searchByTitle => _text('searchByTitle');
  String get radiusKm => _text('radiusKm');
  String get dateLabel => _text('dateLabel');
  String get titleLabel => _text('titleLabel');
  String get interestSubmitted => _text('interestSubmitted');
  String get couldNotGetLocationDetailed => _text('couldNotGetLocation');
  String get fillAllFields => _text('fillAllFields');
  String get missionCreated => _text('missionCreated');
  String get couldNotCreateMission => _text('couldNotCreateMission');
  String get myLocalMissions => _text('myLocalMissions');
  String get myCreatedMissions => _text('myCreatedMissions');
  String get couldNotLoadMissions => _text('couldNotLoadMissions');
  String get noMissionsCreated => _text('noMissionsCreated');
  String get missionTitle => _text('missionTitle');
  String get missionTitleHint => _text('missionTitleHint');
  String get missionDescriptionHint => _text('missionDescriptionHint');
  String get missionAddressHint => _text('missionAddressHint');
  String get missionDurationHint => _text('missionDurationHint');
  String get missionImageOptional => _text('missionImageOptional');
  String get uploadMissionImage => _text('uploadMissionImage');
  String get imageSelected => _text('imageSelected');
  String get createLocalMission => _text('createLocalMission');
  String get durationPoints => _text('durationPoints');
  String get missionDuration => _text('missionDuration');
  String get organization => _text('organization');
  String get error => _text('error');
  String get myCollectionPoints => _text('myCollectionPoints');
  String get addPoint => _text('addPoint');
  String get couldNotLoadCollectionPoints =>
      _text('couldNotLoadCollectionPoints');
  String get noCollectionPointsYet => _text('noCollectionPointsYet');
  String get fillAllFieldsAndLocation => _text('fillAllFieldsAndLocation');
  String get collectionPointCreated => _text('collectionPointCreated');
  String get createCollectionPointTitle => _text('createCollectionPointTitle');
  String get postAdCollectionPoint => _text('postAdCollectionPoint');
  String get collectionPointName => _text('collectionPointName');
  String get collectionPointNameHint => _text('collectionPointNameHint');
  String get collectionPointDescription => _text('collectionPointDescription');
  String get collectionPointDescriptionHint =>
      _text('collectionPointDescriptionHint');
  String get collectionPointAddress => _text('collectionPointAddress');
  String get pickLocationOnMap => _text('pickLocationOnMap');
  String get photoOfCollectionPoint => _text('photoOfCollectionPoint');
  String get uploadPhoto => _text('uploadPhoto');
  String get createCollectionPointButton =>
      _text('createCollectionPointButton');
  String get publishAdTitle => _text('publishAdTitle');
  String get placeAdLocalMission => _text('placeAdLocalMission');
  String get titleOfLocalMission => _text('titleOfLocalMission');
  String get addressOfLocalMission => _text('addressOfLocalMission');
  String get durationOfLocalMission => _text('durationOfLocalMission');
  String get photoOfLocalMission => _text('photoOfLocalMission');
  String get publishMyAd => _text('publishMyAd');
  String get donateTodayTitle => _text('donateTodayTitle');
  String get helpingTomorrowSubtitle => _text('helpingTomorrowSubtitle');
  String get myDonationsTitle => _text('myDonationsTitle');
  String get noDonationsMade => _text('noDonationsMade');
  String donationAmount(String amount) =>
      text('donationAmount', params: {'amount': amount});
  String donationMethodStatus(String method, String status) => text(
    'donationMethodStatus',
    params: {'method': method, 'status': status},
  );
  String get thanksCommunityText => _text('thanksCommunityText');
  String get myAdsTitle => _text('myAdsTitle');
  String get myAds => _text('myAds');
  String get myProfile => _text('myProfile');
  String get partnerLabel => _text('partnerLabel');
  String welcomeName(String name) =>
      text('welcomeName', params: {'name': name});

  String get shopHeroTitle => _text('shopHeroTitle');
  String get shopHeroSubtitle => _text('shopHeroSubtitle');
  String get shopHeroDescription => _text('shopHeroDescription');
  String get shopHeroCommitment => _text('shopHeroCommitment');
  String get shopBestSellersLabel => _text('shopBestSellersLabel');
  String get shopBestSellersTitle => _text('shopBestSellersTitle');
  String get shopBestSellersDescription => _text('shopBestSellersDescription');
  String get shopEntireCollectionLabel => _text('shopEntireCollectionLabel');
  String get shopEntireCollectionTitle => _text('shopEntireCollectionTitle');
  String get shopEntireCollectionDescription =>
      _text('shopEntireCollectionDescription');
  String get shopSeeAll => _text('shopSeeAll');
  String get shopClothing => _text('shopClothing');
  String get shopAccessories => _text('shopAccessories');
  String get shopNoProducts => _text('shopNoProducts');
  String get shopCommitmentsLabel => _text('shopCommitmentsLabel');
  String get shopCommitmentsTitle => _text('shopCommitmentsTitle');
  String get shopCommitment1Title => _text('shopCommitment1Title');
  String get shopCommitment1Description => _text('shopCommitment1Description');
  String get shopCommitment2Title => _text('shopCommitment2Title');
  String get shopCommitment2Description => _text('shopCommitment2Description');
  String get shopCommitment3Title => _text('shopCommitment3Title');
  String get shopCommitment3Description => _text('shopCommitment3Description');

  String get mySupport => _text('mySupport');
  String get oneTimeSupport => _text('oneTimeSupport');
  String get monthlySupport => _text('monthlySupport');
  String get enterAmount => _text('enterAmount');
  String get myDetails => _text('myDetails');
  String get orEnterDetails => _text('orEnterDetails');
  String get payment => _text('payment');
  String get cardNumber => _text('cardNumber');
  String get expiryDate => _text('expiryDate');
  String get validateMySupport => _text('validateMySupport');
  String get onBehalfOfCompany => _text('onBehalfOfCompany');

  String get profileUpdated => _text('profileUpdated');
  String get editMyInformation => _text('editMyInformation');
  String get myInformation => _text('myInformation');
  String get firstName => _text('firstName');
  String get lastName => _text('lastName');
  String get email => _text('email');
  String get phone => _text('phone');
  String get address => _text('address');
  String get city => _text('city');
  String get country => _text('country');
  String get company => _text('company');
  String get profession => _text('profession');
  String get selfIntro => _text('selfIntro');
  String get locationAddress => _text('locationAddress');
  String get saveChanges => _text('saveChanges');
  String get save => _text('save');
  String get edit => _text('edit');
  String get personalInformation => _text('personalInformation');
  String get changeCover => _text('changeCover');
  String get required => _text('required');
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
