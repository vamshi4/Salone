// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get insightsTitle => 'பார்வைகள்';

  @override
  String get tabEarnings => 'வருமானம்';

  @override
  String get tabRetention => 'வாடிக்கையாளர் தக்கவைப்பு';

  @override
  String get periodToday => 'இன்று';

  @override
  String get periodWeek => 'வாரம்';

  @override
  String get periodMonth => 'மாதம்';

  @override
  String get periodLast7Days => 'கடந்த 7 நாட்கள்';

  @override
  String get periodLast30Days => 'கடந்த 30 நாட்கள்';

  @override
  String get earningsLoadError => 'வருமானத்தை ஏற்ற முடியவில்லை.';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String completedServicesCount(int count) {
    return '$count சேவைகள்';
  }

  @override
  String get completedServicesHeading => 'முடிக்கப்பட்ட சேவைகள்';

  @override
  String get noCompletedServices =>
      'இந்த காலகட்டத்தில் இன்னும் சேவைகள் முடிக்கப்படவில்லை.';

  @override
  String get topServicesHeading => 'முதன்மை சேவைகள்';

  @override
  String get byStaffHeading => 'ஊழியர் வாரியாக';

  @override
  String get vsYesterday => 'நேற்றுடன் ஒப்பிடும்போது';

  @override
  String get vsLastWeek => 'கடந்த வாரத்துடன் ஒப்பிடும்போது';

  @override
  String get vsLastMonth => 'கடந்த மாதத்துடன் ஒப்பிடும்போது';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'திரும்பி வந்த வாடிக்கையாளர்கள்';

  @override
  String reactivatedSummary(int count) {
    return 'இந்த மாதம் $count வாடிக்கையாளர்கள் திரும்பி வந்தனர்';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'தக்கவைப்பு அறிக்கையை ஏற்ற முடியவில்லை.';

  @override
  String get couldNotOpenWhatsapp => 'வாட்ஸ்அப்பைத் திறக்க முடியவில்லை';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'வணக்கம் $name! $salonName இல் உங்களை நினைத்துக்கொள்கிறோம். உங்கள் அடுத்த வருகையை முன்பதிவு செய்து சிறப்பு வரவேற்பு சலுகையை அனுபவியுங்கள். விரைவில் சந்திப்போம்!';
  }

  @override
  String get customerCohortsHeading => 'வாடிக்கையாளர் குழுக்கள்';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count வாடிக்கையாளர்கள்';
  }

  @override
  String noCohortCustomers(String label) {
    return 'இந்த காலகட்டத்தில் $label வாடிக்கையாளர்கள் இல்லை.';
  }

  @override
  String get missedCustomersHeading => 'தவறவிட்ட வாடிக்கையாளர்கள்';

  @override
  String get missedCustomersHint =>
      'வாட்ஸ்அப்பில் அவர்களுக்கு செய்தி அனுப்ப \"நினைவூட்டு\" என்பதைத் தட்டவும்.';

  @override
  String get noMissedCustomers => 'இந்த மாதம் எந்த வாடிக்கையாளரும் தவறவில்லை.';

  @override
  String get cohortRegulars => 'வழக்கமானவர்கள்';

  @override
  String get cohortNew => 'புதியவர்கள்';

  @override
  String get cohortCameBack => 'திரும்பி வந்தனர்';

  @override
  String get cohortStoppedComing => 'வருவதை நிறுத்தினர்';

  @override
  String get customersLabel => 'வாடிக்கையாளர்கள்';

  @override
  String get reachOutNow => 'இப்போது தொடர்பு கொள்ளுங்கள்';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count வழக்கமான வாடிக்கையாளர்கள் குறைந்து வருகின்றனர் · $revenue ஆபத்தில்';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× தாமதம்';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'வழக்கமாக ஒவ்வொரு $cadence நாட்களுக்கும் · $overdue நாட்கள் தாமதம்';
  }

  @override
  String get remind => 'நினைவூட்டு';

  @override
  String get remindOnWhatsappTooltip => 'வாட்ஸ்அப்பில் நினைவூட்டு';

  @override
  String get retentionProTitle => 'தக்கவைப்பு பார்வைகள் ஒரு PRO அம்சம்';

  @override
  String get retentionProBody =>
      'யார் வருவதை நிறுத்தினார்கள் என்பதைப் பார்க்கவும், புதிய மற்றும் திரும்பி வரும் வாடிக்கையாளர் விகிதத்தைக் காணவும், ஒரு-தட்டு நினைவூட்டல்களுடன் இழந்த வாடிக்கையாளர்களை மீண்டும் பெறவும்.';

  @override
  String get upgradeToPro => 'PRO க்கு மேம்படுத்தவும்';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits வருகைகள் · $spend செலவழிக்கப்பட்டது';
  }

  @override
  String get createYourAccount => 'உங்கள் கணக்கை உருவாக்கவும்';

  @override
  String get basics => 'அடிப்படைத் தகவல்';

  @override
  String get country => 'நாடு';

  @override
  String get countryHelperText =>
      'உங்கள் நாணயம், தொலைபேசி வடிவம் மற்றும் இயல்புநிலை மொழியை தீர்மானிக்கிறது.';

  @override
  String get language => 'மொழி';

  @override
  String get phoneNumberLabel => 'தொலைபேசி எண்';

  @override
  String get passwordLabel => 'கடவுச்சொல்';

  @override
  String stepOfTotal(int step, int total) {
    return 'படி $step / $total';
  }

  @override
  String get createAccountButton => 'கணக்கை உருவாக்கு';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get enterPhoneNumber => 'தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get passwordMinLength =>
      'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get fillOwnerSalonAddress =>
      'உரிமையாளர் பெயர், சலூன் பெயர் மற்றும் முகவரியை நிரப்பவும்';

  @override
  String get turnOnLocationPermission =>
      'இதைப் பயன்படுத்த இருப்பிடத்தை இயக்கி அணுகலை அனுமதிக்கவும்';

  @override
  String get couldNotGetLocation => 'உங்கள் இருப்பிடத்தைப் பெற முடியவில்லை';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'இந்த தொலைபேசி ஏற்கனவே பதிவு செய்யப்பட்டுள்ளது. தயவுசெய்து உள்நுழையவும்.';

  @override
  String get signupFailedCheckBackend =>
      'பதிவு தோல்வியடைந்தது. சேவையக இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get signupFailedTryAgain =>
      'பதிவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get yourSalon => 'உங்கள் சலூன்';

  @override
  String get salonDetailsSubtitle => 'படி 2/3 · சலூன் விவரங்கள்';

  @override
  String get ownerNameLabel => 'உரிமையாளர் பெயர்';

  @override
  String get salonNameLabel => 'சலூன் பெயர்';

  @override
  String get salonAddressLabel => 'சலூன் முகவரி';

  @override
  String get locationSet => 'இருப்பிடம் அமைக்கப்பட்டது';

  @override
  String get useMyCurrentLocation =>
      'எனது தற்போதைய இருப்பிடத்தைப் பயன்படுத்தவும்';

  @override
  String get pickYourColor => 'உங்கள் நிறத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get colorPreviewHelp =>
      'இது முழு ஆப்பிலும் உங்கள் சலூனின் அணி நிறம். எப்போது வேண்டுமானாலும் கணக்கில் மாற்றவும்.';

  @override
  String get previewLabel => 'முன்னோட்டம்';

  @override
  String get newBooking => 'புதிய முன்பதிவு';

  @override
  String get colorTeal => 'டீல்';

  @override
  String get colorTerracotta => 'டெரகோட்டா';

  @override
  String get colorBlue => 'நீலம்';

  @override
  String get colorViolet => 'ஊதா';

  @override
  String get colorRose => 'ரோஜா';

  @override
  String get welcomeBack => 'மீண்டும் வரவேற்கிறோம்';

  @override
  String get signInToDashboard => 'உங்கள் சலூன் டாஷ்போர்டில் உள்நுழையவும்';

  @override
  String get enterSalonOwnerPhone => 'சலூன் உரிமையாளரின் தொலைபேசியை உள்ளிடவும்';

  @override
  String get enterYourPassword => 'உங்கள் கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get noSalonOwnerFound =>
      'இந்த தொலைபேசிக்கு சலூன் உரிமையாளர் கணக்கு எதுவும் இல்லை.';

  @override
  String get loginFailedCheckBackend =>
      'உள்நுழைவு தோல்வியடைந்தது. சேவையக இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get loginFailedTryAgain =>
      'உள்நுழைவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get hidePassword => 'கடவுச்சொல்லை மறை';

  @override
  String get showPassword => 'கடவுச்சொல்லைக் காட்டு';

  @override
  String get signIn => 'உள்நுழையவும்';

  @override
  String get newHere => 'இங்கே புதியவரா?';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get resetPasswordTitle => 'கடவுச்சொல்லை மீட்டமை';

  @override
  String get resetPasswordEnterPhone =>
      'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும், வாட்ஸ்அப் வழியாக 6-இலக்க குறியீட்டை அனுப்புவோம்.';

  @override
  String get sendCodeViaWhatsApp => 'வாட்ஸ்அப் வழியாக குறியீட்டை அனுப்பு';

  @override
  String get codeSentViaWhatsApp =>
      'அந்த கணக்கு இருந்தால், வாட்ஸ்அப் வழியாக ஒரு குறியீடு அனுப்பப்பட்டது.';

  @override
  String get resetPasswordEnterCode =>
      'வாட்ஸ்அப்பில் அனுப்பிய குறியீட்டை உள்ளிடவும், பின் புதிய கடவுச்சொல்லைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get otpCodeLabel => '6-இலக்க குறியீடு';

  @override
  String get resetPasswordButton => 'கடவுச்சொல்லை மீட்டமை';

  @override
  String get resendCode => 'குறியீட்டை மீண்டும் அனுப்பு';

  @override
  String get changePhoneNumber => 'தொலைபேசி எண்ணை மாற்று';

  @override
  String get enterSixDigitCode => '6-இலக்க குறியீட்டை உள்ளிடவும்';

  @override
  String get passwordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get passwordResetSuccess =>
      'கடவுச்சொல் மீட்டமைக்கப்பட்டது. புதிய கடவுச்சொல்லுடன் உள்நுழையவும்.';

  @override
  String get waitBeforeRetryingCode =>
      'மற்றொரு குறியீட்டைக் கோருவதற்கு முன் ஒரு நிமிடம் காத்திருக்கவும்';

  @override
  String get invalidOrExpiredCode =>
      'அந்த குறியீடு தவறானது அல்லது காலாவதியானது';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'பல முயற்சிகள் — புதிய குறியீட்டைக் கோரவும்';

  @override
  String get continueWithGoogle => 'Google மூலம் தொடரவும்';

  @override
  String get signedInWithGoogle => 'Google மூலம் உள்நுழைந்துள்ளீர்கள்';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google மூலம் $email ஆக உள்நுழைந்துள்ளீர்கள்';
  }

  @override
  String get usePasswordInstead =>
      'அதற்கு பதிலாக கடவுச்சொல்லைப் பயன்படுத்தவும்';

  @override
  String get googleSignInNotConfigured =>
      'Google உள்நுழைவு இன்னும் அமைக்கப்படவில்லை';

  @override
  String get googleSignInFailed =>
      'Google உள்நுழைவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get googleNoAccountFound =>
      'அந்த Google கணக்கிற்கு எந்த கணக்கும் இல்லை. முதலில் ஒன்றை உருவாக்கவும்.';

  @override
  String get linkGoogleAccount => 'Google கணக்கை இணைக்கவும்';

  @override
  String get googleAccountLinked =>
      'Google கணக்கு இணைக்கப்பட்டது — இப்போது நீங்கள் அதன் மூலம் உள்நுழையலாம்';

  @override
  String get addStaffBeforeBookings =>
      'முன்பதிவுகளை உருவாக்கும் முன் செயலில் உள்ள ஊழியர்களைச் சேர்க்கவும்';

  @override
  String get salonLabel => 'சலூன்';

  @override
  String get statToday => 'இன்று';

  @override
  String get statRepeat => 'மீண்டும் வருபவர்';

  @override
  String get statLoggedHelper => 'பதிவு செய்யப்பட்டது';

  @override
  String get statBackHelper => 'திரும்பி வந்தனர்';

  @override
  String get statWeek => 'வாரம்';

  @override
  String get statMonth => 'மாதம்';

  @override
  String get loggedTodayHeading => 'இன்று பதிவு செய்யப்பட்டவை';

  @override
  String get nothingLoggedToday =>
      'இன்று இதுவரை எதுவும் பதிவு செய்யப்படவில்லை. ஒரு சேவை முடிந்ததும் \"புதிய முன்பதிவு\" என்பதைத் தட்டவும்.';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navBookings => 'முன்பதிவுகள்';

  @override
  String get navStaff => 'ஊழியர்கள்';

  @override
  String get navInsights => 'பார்வைகள்';

  @override
  String get navAccount => 'கணக்கு';

  @override
  String get salonAdminTitle => 'சலூன் நிர்வாகி';

  @override
  String get noSalonLinked =>
      'இந்த உரிமையாளர் கணக்குடன் இன்னும் சலூன் எதுவும் இணைக்கப்படவில்லை.';

  @override
  String get bookingsTitle => 'முன்பதிவுகள்';

  @override
  String get searchCustomerOrService => 'வாடிக்கையாளர் அல்லது சேவையைத் தேடவும்';

  @override
  String get filterThisWeek => 'இந்த வாரம்';

  @override
  String get filterAllTime => 'எல்லா நேரமும்';

  @override
  String get filterAllStaff => 'அனைத்து ஊழியர்கள்';

  @override
  String get staffLabel => 'ஊழியர்கள்';

  @override
  String get needsActionHeading => 'நடவடிக்கை தேவை';

  @override
  String get statTotal => 'மொத்தம்';

  @override
  String get statServices => 'சேவைகள்';

  @override
  String get statAvgTicket => 'சராசரி பில்';

  @override
  String get noBookingsMatchFilter =>
      'இந்த வடிகட்டியுடன் பொருந்தும் முன்பதிவுகள் இல்லை';

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count சேவைகள்';
  }

  @override
  String get couldNotOpenStore => 'ஸ்டோரைத் திறக்க முடியவில்லை';

  @override
  String get updateRequired => 'புதுப்பிப்பு தேவை';

  @override
  String get updateRequiredBody =>
      'ஆப்பின் புதிய பதிப்பு கிடைக்கிறது. உங்கள் சலூன் டாஷ்போர்டைத் தொடர்ந்து பயன்படுத்த புதுப்பிக்கவும்.';

  @override
  String get updateNow => 'இப்போதே புதுப்பிக்கவும்';

  @override
  String get themeColorTitle => 'தீம் நிறம்';

  @override
  String get save => 'சேமி';

  @override
  String get staffTitle => 'ஊழியர்கள்';

  @override
  String get addStaff => 'ஊழியரைச் சேர்';

  @override
  String get statActive => 'செயலில்';

  @override
  String get statTodaysTotal => 'இன்றைய மொத்தம்';

  @override
  String get noActiveStaffYet => 'இன்னும் செயலில் உள்ள ஊழியர் இல்லை';

  @override
  String get addFirstStaff => 'முதல் ஊழியரைச் சேர்';

  @override
  String get noServicesYet => 'இன்னும் சேவைகள் இல்லை';

  @override
  String get notActive => 'செயலில் இல்லை';

  @override
  String get canSetOwnPrice => 'தங்கள் சொந்த விலையை நிர்ணயிக்க முடியும்';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count சேவைகள் · $revenue';
  }

  @override
  String get newLabel => 'புதிய';

  @override
  String get serviceLabel => 'சேவை';

  @override
  String get customerLabel => 'வாடிக்கையாளர்';

  @override
  String get repeatLabel => 'மீண்டும்';

  @override
  String get couldNotUpdateBooking =>
      'முன்பதிவை புதுப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get couldNotAcceptReschedule =>
      'மறு அட்டவணையை ஏற்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get couldNotRejectReschedule =>
      'மறு அட்டவணையை நிராகரிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get rescheduleLabel => 'மறு அட்டவணை';

  @override
  String get pendingLabel => 'நிலுவையில்';

  @override
  String get scheduledLabel => 'திட்டமிடப்பட்டது';

  @override
  String get inProgressLabel => 'நடைபெறுகிறது';

  @override
  String get startBookingButton => 'தொடங்கு';

  @override
  String get doneBookingButton => 'முடிந்தது';

  @override
  String get todayScheduleHeading => 'இன்றைய அட்டவணை';

  @override
  String get paymentMethodLabel => 'பணம் செலுத்துதல்';

  @override
  String get paymentMethodCash => 'பணம்';

  @override
  String get paymentMethodCard => 'கார்டு';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'மீண்டும் முன்பதிவு செய்';

  @override
  String get couldNotLoadCustomerProfile =>
      'வாடிக்கையாளர் சுயவிவரத்தை ஏற்ற முடியவில்லை';

  @override
  String get notesSaved => 'குறிப்புகள் சேமிக்கப்பட்டன';

  @override
  String get couldNotSaveNotes =>
      'குறிப்புகளை சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get statsVisitsLabel => 'வருகைகள்';

  @override
  String get statsTotalSpentLabel => 'மொத்த செலவு';

  @override
  String lastServiceSummary(String service, String date) {
    return 'கடைசி: $service, $date';
  }

  @override
  String get notesLabel => 'குறிப்புகள்';

  @override
  String get notesHint => 'விருப்பங்கள், ஒவ்வாமைகள், நினைவில் கொள்ள வேண்டியவை';

  @override
  String get tagsLabel => 'குறிச்சொற்கள்';

  @override
  String get addTagHint => 'குறிச்சொல் சேர்';

  @override
  String get saveNotesButton => 'குறிப்புகளை சேமி';

  @override
  String get visitHistoryHeading => 'வருகை வரலாறு';

  @override
  String get noVisitsYet => 'இதுவரை வருகைகள் இல்லை';

  @override
  String get viewProfileTooltip => 'சுயவிவரத்தைப் பார்';

  @override
  String get dailyRevenueGoalLabel => 'தினசரி வருவாய் இலக்கு';

  @override
  String get dailyRevenueGoalHint =>
      'விருப்பத்தேர்வு — முகப்பில் முன்னேற்ற பட்டியை மறைக்க காலியாக விடவும்';

  @override
  String get payoutsTooltip => 'பணம் செலுத்துதல்கள்';

  @override
  String get staffActiveLabel => 'செயலில்';

  @override
  String get canCancelBookingLabel => 'முன்பதிவுகளை ரத்து செய்யலாம்';

  @override
  String get couldNotLoadPayouts => 'பணம் செலுத்துதல்களை ஏற்ற முடியவில்லை';

  @override
  String get payoutSettled => 'பணம் செலுத்துதல் பதிவு செய்யப்பட்டது';

  @override
  String get couldNotMarkPaid =>
      'செலுத்தியதாக குறிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get payoutsTitle => 'வருமானம் & பணம் செலுத்துதல்கள்';

  @override
  String get unpaidLabel => 'செலுத்தப்படாதது';

  @override
  String get markAsPaidButton => 'செலுத்தியதாக குறி';

  @override
  String get grossRevenueLabel => 'வருவாய்';

  @override
  String get totalPayoutLabel => 'பணம் செலுத்துதல்';

  @override
  String get payoutHistoryHeading => 'பணம் செலுத்துதல் வரலாறு';

  @override
  String get noPayoutsYet => 'இதுவரை பணம் செலுத்துதல்கள் இல்லை';

  @override
  String get payTypeLabel => 'ஊதிய வகை';

  @override
  String get payTypeCommission => 'கமிஷன்';

  @override
  String get payTypeSalary => 'சம்பளம்';

  @override
  String get payTypeBoth => 'இரண்டும்';

  @override
  String get commissionRateLabel => 'கமிஷன் %';

  @override
  String get monthlySalaryLabel => 'மாத சம்பளம்';

  @override
  String get couldNotSavePayType =>
      'ஊதிய அமைப்புகளை சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get salaryThisMonthLabel => 'இந்த மாத சம்பளம்';

  @override
  String get salaryPaidStatus => 'செலுத்தப்பட்டது';

  @override
  String get paySalaryButton => 'சம்பளம் செலுத்து';

  @override
  String get salaryPaid => 'சம்பளம் செலுத்தப்பட்டது';

  @override
  String get couldNotPaySalary =>
      'சம்பளம் செலுத்த முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get searchStaffHint => 'பணியாளர்களைத் தேடு';

  @override
  String get filterActiveStaff => 'செயலில்';

  @override
  String get filterInactiveStaff => 'செயலிலில்லை';

  @override
  String get switchBranchTitle => 'கிளையை மாற்று';

  @override
  String get switchLabel => 'கிளையை மாற்று';

  @override
  String get allBranchesLabel => 'அனைத்து கிளைகள்';

  @override
  String get allBranchesSubtitle => 'அனைத்து கிளைகளின் ஒருங்கிணைந்த மொத்தம்';

  @override
  String get pickBranchFirst =>
      'முதலில் ஒரு குறிப்பிட்ட கிளையைத் தேர்ந்தெடுக்கவும்';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count பதிவு · $revenue · $staff பணியாளர்கள்';
  }

  @override
  String get dayOffLabel => 'விடுமுறை';

  @override
  String get addBranchButton => 'கிளை சேர்';

  @override
  String get addBranchTitle => 'ஒரு கிளையைச் சேர்';

  @override
  String get branchNameAddressRequired => 'கிளையின் பெயரும் முகவரியும் தேவை';

  @override
  String get couldNotAddBranch =>
      'கிளையைச் சேர்க்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get fillProductFields =>
      'அனைத்து தயாரிப்பு புலங்களையும் சரியாக நிரப்பவும்';

  @override
  String get couldNotSaveProduct =>
      'தயாரிப்பை சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get editProductTitle => 'தயாரிப்பைத் திருத்து';

  @override
  String get addProductTitle => 'தயாரிப்பு சேர்';

  @override
  String get productNameLabel => 'தயாரிப்பு பெயர்';

  @override
  String get skuLabel => 'SKU (விருப்பத்தேர்வு)';

  @override
  String get stockQtyLabel => 'இருப்பு';

  @override
  String get lowStockThresholdLabel => 'குறைந்த இருப்பு வரம்பு';

  @override
  String get deleteProductButton => 'தயாரிப்பை நீக்கு';

  @override
  String get productsTitle => 'தயாரிப்புகள்';

  @override
  String get searchProductsHint => 'தயாரிப்புகளைத் தேடு';

  @override
  String get filterLowStock => 'குறைந்த இருப்பு';

  @override
  String get noLowStockProducts => 'எந்த தயாரிப்பும் குறைந்த இருப்பில் இல்லை';

  @override
  String get noProductsInCatalog => 'இதுவரை தயாரிப்புகள் இல்லை';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count இருப்பில்',
      one: '1 இருப்பில்',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'குறைந்த இருப்பு';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தயாரிப்புகள் குறைந்த இருப்பில் உள்ளன',
      one: '1 தயாரிப்பு குறைந்த இருப்பில் உள்ளது',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'இன்று';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நியமனங்கள் பதிவு செய்யப்பட்டன',
      one: '1 நியமனம் பதிவு செய்யப்பட்டது',
      zero: 'இதுவரை நியமனங்கள் பதிவு செய்யப்படவில்லை',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$goal இலக்கில் $current';
  }

  @override
  String get worthReachingOutHeading => 'இன்று தொடர்பு கொள்ள வேண்டியவர்கள்';

  @override
  String get exportCsvTooltip => 'CSV ஏற்றுமதி செய்';

  @override
  String get couldNotExportEarnings =>
      'வருமானத்தை ஏற்றுமதி செய்ய முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days நாட்கள் தாமதம்',
      one: '1 நாள் தாமதம்',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist உடன்';
  }

  @override
  String customerRequestedTime(String time) {
    return 'வாடிக்கையாளர் $time கோரினார்';
  }

  @override
  String get reject => 'நிராகரி';

  @override
  String get accept => 'ஏற்றுக்கொள்';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + மேலும் $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'கணக்கு விவரங்களை ஏற்ற முடியவில்லை';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'உரிமையாளர், தொலைபேசி, சலூன் பெயர் மற்றும் முகவரியை நிரப்பவும்';

  @override
  String get accountUpdated => 'கணக்கு புதுப்பிக்கப்பட்டது';

  @override
  String get phoneOrEmailUsed =>
      'தொலைபேசி அல்லது மின்னஞ்சல் ஏற்கனவே பயன்பாட்டில் உள்ளது';

  @override
  String get couldNotSaveAccount => 'கணக்கு விவரங்களைச் சேமிக்க முடியவில்லை';

  @override
  String get newPasswordMinLength =>
      'புதிய கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get newPasswordsDontMatch => 'புதிய கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get passwordChanged => 'கடவுச்சொல் மாற்றப்பட்டது';

  @override
  String get currentPasswordIncorrect => 'தற்போதைய கடவுச்சொல் தவறானது';

  @override
  String get couldNotChangePassword => 'கடவுச்சொல்லை மாற்ற முடியவில்லை';

  @override
  String get countryAndCurrency => 'நாடு மற்றும் நாணயம்';

  @override
  String get accountTitle => 'கணக்கு';

  @override
  String ownerSinceDate(String date) {
    return '$date முதல் உரிமையாளர்';
  }

  @override
  String planLabel(String plan) {
    return '$plan திட்டம்';
  }

  @override
  String get retentionFreeFor6Months =>
      '6 மாதங்களுக்கு தக்கவைப்பு பார்வைகள் இலவசம்';

  @override
  String get upgrade => 'மேம்படுத்து';

  @override
  String get appearance => 'தோற்றம்';

  @override
  String get salonProfile => 'சலூன் சுயவிவரம்';

  @override
  String get emailLabel => 'மின்னஞ்சல்';

  @override
  String get locationUpdated => 'இருப்பிடம் புதுப்பிக்கப்பட்டது';

  @override
  String get saveDetailsButton => 'விவரங்களைச் சேமி';

  @override
  String get savingEllipsis => 'சேமிக்கிறது...';

  @override
  String get security => 'பாதுகாப்பு';

  @override
  String get currentPasswordLabel => 'தற்போதைய கடவுச்சொல்';

  @override
  String get newPasswordLabel => 'புதிய கடவுச்சொல்';

  @override
  String get confirmNewPasswordLabel => 'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get changePasswordButton => 'கடவுச்சொல்லை மாற்று';

  @override
  String get changingEllipsis => 'மாற்றுகிறது...';

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get enterServiceNamePrice => 'சேவை பெயர் மற்றும் விலையை உள்ளிடவும்';

  @override
  String get fillStaffNamePhone => 'ஊழியர் பெயர் மற்றும் தொலைபேசியை நிரப்பவும்';

  @override
  String get addAtLeastOneService => 'குறைந்தது ஒரு சேவையைச் சேர்க்கவும்';

  @override
  String get enterValidOpenCloseTimes =>
      'சரியான திறக்கும் மற்றும் மூடும் நேரங்களை உள்ளிடவும் (HH:MM, 24-மணி)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'குறைந்தது ஒரு பணி நாளைத் தேர்ந்தெடுக்கவும்';

  @override
  String get staffPhoneInUse =>
      'அந்த ஊழியர் தொலைபேசி ஏற்கனவே பயன்பாட்டில் உள்ளது';

  @override
  String get couldNotAddStaff =>
      'ஊழியரைச் சேர்க்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get addStaffSubtitle =>
      'அவர்களின் சுயவிவரம், சேவைகள் மற்றும் பணி நாட்களை அமைக்கவும்.';

  @override
  String get staffNameLabel => 'ஊழியர் பெயர்';

  @override
  String get staffPhoneLabel => 'ஊழியர் தொலைபேசி';

  @override
  String get servicesLabel => 'சேவைகள்';

  @override
  String servicesAddedCount(int count) {
    return '$count சேர்க்கப்பட்டன';
  }

  @override
  String get workingHours => 'பணி நேரம்';

  @override
  String get opens => 'திறக்கிறது';

  @override
  String get closes => 'மூடுகிறது';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'பணி நாட்கள்';

  @override
  String get serviceNameHint => 'சேவை பெயர்';

  @override
  String get priceHint => 'விலை';

  @override
  String get dayMon => 'திங்';

  @override
  String get dayTue => 'செவ்';

  @override
  String get dayWed => 'புத';

  @override
  String get dayThu => 'வியா';

  @override
  String get dayFri => 'வெள்';

  @override
  String get daySat => 'சனி';

  @override
  String get daySun => 'ஞாயி';

  @override
  String get enterValidStaffNamePhone =>
      'சரியான ஊழியர் பெயர் மற்றும் தொலைபேசியை உள்ளிடவும்';

  @override
  String get staffDetailsSaved => 'ஊழியர் விவரங்கள் சேமிக்கப்பட்டன';

  @override
  String get phoneAlreadyInUse => 'அந்த தொலைபேசி ஏற்கனவே பயன்பாட்டில் உள்ளது';

  @override
  String get couldNotUpdateStaff => 'ஊழியரை புதுப்பிக்க முடியவில்லை';

  @override
  String get enterServiceNameAndPriceShort =>
      'சேவை பெயர் மற்றும் விலையை உள்ளிடவும்';

  @override
  String get couldNotAddService => 'சேவையைச் சேர்க்க முடியவில்லை';

  @override
  String get editServiceTitle => 'சேவையைத் திருத்தவும்';

  @override
  String get enterValidServiceNamePrice =>
      'சரியான சேவை பெயர் மற்றும் விலையை உள்ளிடவும்';

  @override
  String get couldNotUpdateService => 'சேவையை புதுப்பிக்க முடியவில்லை';

  @override
  String get saveServiceButton => 'சேவையைச் சேமி';

  @override
  String get couldNotRemoveServiceDefault => 'சேவையை அகற்ற முடியவில்லை';

  @override
  String get useHHmmWorkingHours => 'பணி நேரத்திற்கு HH:mm ஐப் பயன்படுத்தவும்';

  @override
  String get hoursAdded => 'நேரம் சேர்க்கப்பட்டது';

  @override
  String get couldNotAddWorkingHours => 'பணி நேரத்தைச் சேர்க்க முடியவில்லை';

  @override
  String get couldNotRemoveTiming => 'நேரத்தை அகற்ற முடியவில்லை';

  @override
  String get manageStaffTitle => 'ஊழியரை நிர்வகி';

  @override
  String get done => 'முடிந்தது';

  @override
  String get manageStaffSubtitle =>
      'சேவைகள் மற்றும் நேரங்களைச் சேர்க்கவும், திருத்தவும் அல்லது அகற்றவும், பின்னர் முடிந்தது என்பதைத் தட்டவும்.';

  @override
  String get saveStaffButton => 'ஊழியரைச் சேமி';

  @override
  String get edit => 'திருத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String get newServiceLabel => 'புதிய சேவை';

  @override
  String get addingEllipsis => 'சேர்க்கிறது...';

  @override
  String get addServiceButton => 'சேவையைச் சேர்';

  @override
  String get noTimingsYet => 'இன்னும் நேரங்கள் இல்லை';

  @override
  String get removeLabel => 'அகற்று';

  @override
  String get startLabel => 'தொடக்கம்';

  @override
  String get endLabel => 'முடிவு';

  @override
  String get addMonSatHoursButton => 'திங்-சனி நேரங்களைச் சேர்';

  @override
  String get saveHoursButton => 'நேரங்களைச் சேமி';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate =>
      'ஊழியர், சேவை மற்றும் தேதியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get noSlotsForDate => 'இந்த தேதிக்கு கிடைக்கும் இடங்கள் இல்லை.';

  @override
  String get couldNotLoadSlots => 'இடங்களை ஏற்ற முடியவில்லை';

  @override
  String get enterCustomerName => 'வாடிக்கையாளர் பெயரை உள்ளிடவும்';

  @override
  String get chooseStaffAndService =>
      'ஊழியர் மற்றும் குறைந்தது ஒரு சேவையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get enterCustomerPhone => 'வாடிக்கையாளர் தொலைபேசியை உள்ளிடவும்';

  @override
  String get chooseAvailableSlot => 'கிடைக்கும் இடத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get couldNotCreateBooking =>
      'முன்பதிவை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get doneServiceOption => 'சேவை முடிந்தது';

  @override
  String get scheduleLaterOption => 'பின்னர் திட்டமிடு';

  @override
  String get customerNameLabel => 'வாடிக்கையாளர் பெயர்';

  @override
  String get customerPhoneLabel => 'வாடிக்கையாளர் தொலைபேசி';

  @override
  String recordedNowDate(String date) {
    return 'இப்போது பதிவு செய்யப்பட்டது — $date';
  }

  @override
  String get dateLabel => 'தேதி';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'கிடைக்கும் இடங்கள்';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get saveBooking => 'முன்பதிவைச் சேமி';

  @override
  String saveBookingWithTotal(String total) {
    return 'முன்பதிவைச் சேமி · $total';
  }

  @override
  String get addServiceTitle => 'சேவையைச் சேர்க்கவும்';

  @override
  String get serviceNameLabel => 'சேவை பெயர்';

  @override
  String get categoryLabel => 'வகை';

  @override
  String get priceLabel => 'விலை';

  @override
  String get durationMinutesLabel => 'கால அளவு (நிமிடங்கள்)';

  @override
  String get deleteServiceButton => 'சேவையை நீக்கவும்';

  @override
  String get fillServiceFields =>
      'பெயர், வகை, விலை, கால அளவு ஆகியவற்றை உள்ளிடவும்';

  @override
  String get couldNotSaveService => 'சேவையைச் சேமிக்க முடியவில்லை';

  @override
  String get noServicesInCatalog =>
      'இன்னும் சேவைகள் இல்லை. முதலாவதைச் சேர்க்கவும்.';

  @override
  String get searchServicesHint => 'சேவைகளைத் தேடவும்';

  @override
  String get filterAllCategories => 'அனைத்தும்';

  @override
  String get assignToStaffLabel => 'பணியாளருக்கு ஒதுக்கவும்';

  @override
  String get anyStaffOption => 'எந்த பணியாளரும்';

  @override
  String get addStarterServicesButton => 'பொதுவான சேவைகளைச் சேர்க்கவும்';

  @override
  String get bookingLinkSectionTitle => 'முன்பதிவு இணைப்பு';

  @override
  String get bookingLinkSectionSubtitle =>
      'வாடிக்கையாளர்கள் ஆன்லைனில் முன்பதிவு செய்ய இந்த இணைப்பு அல்லது QR குறியீட்டைப் பகிரவும்';

  @override
  String get copyLinkButton => 'நகலெடு';

  @override
  String get shareLinkButton => 'பகிர்';

  @override
  String get linkCopied => 'இணைப்பு நகலெடுக்கப்பட்டது';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return '$salonName இல் முன்பதிவு செய்யுங்கள்: $link';
  }
}
