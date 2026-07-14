// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get insightsTitle => 'इनसाइट्स';

  @override
  String get tabEarnings => 'कमाई';

  @override
  String get tabRetention => 'रिटेंशन';

  @override
  String get periodToday => 'आज';

  @override
  String get periodWeek => 'आठवडा';

  @override
  String get periodMonth => 'महिना';

  @override
  String get periodLast7Days => 'मागील 7 दिवस';

  @override
  String get periodLast30Days => 'मागील 30 दिवस';

  @override
  String get earningsLoadError => 'कमाई लोड होऊ शकली नाही.';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String completedServicesCount(int count) {
    return '$count सेवा';
  }

  @override
  String get completedServicesHeading => 'पूर्ण झालेल्या सेवा';

  @override
  String get noCompletedServices =>
      'या कालावधीत अद्याप कोणतीही सेवा पूर्ण झालेली नाही.';

  @override
  String get topServicesHeading => 'शीर्ष सेवा';

  @override
  String get byStaffHeading => 'स्टाफनुसार';

  @override
  String get vsYesterday => 'कालच्या तुलनेत';

  @override
  String get vsLastWeek => 'मागील आठवड्याच्या तुलनेत';

  @override
  String get vsLastMonth => 'मागील महिन्याच्या तुलनेत';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'परत आलेले ग्राहक';

  @override
  String reactivatedSummary(int count) {
    return 'या महिन्यात $count ग्राहक परत आले';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'रिटेंशन अहवाल लोड होऊ शकला नाही.';

  @override
  String get couldNotOpenWhatsapp => 'व्हॉट्सअ‍ॅप उघडता आले नाही';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'नमस्कार $name! आम्हाला $salonName मध्ये तुमची आठवण येत आहे. तुमची पुढील भेट बुक करा आणि खास वेलकम-बॅक ऑफरचा आनंद घ्या. लवकरच भेटूया!';
  }

  @override
  String get customerCohortsHeading => 'ग्राहक गट';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count ग्राहक';
  }

  @override
  String noCohortCustomers(String label) {
    return 'या कालावधीत कोणतेही $label ग्राहक नाहीत.';
  }

  @override
  String get missedCustomersHeading => 'चुकलेले ग्राहक';

  @override
  String get missedCustomersHint =>
      'त्यांना व्हॉट्सअ‍ॅपवर संदेश पाठवण्यासाठी \"रिमाइंड\" वर टॅप करा.';

  @override
  String get noMissedCustomers => 'या महिन्यात कोणताही ग्राहक चुकला नाही.';

  @override
  String get cohortRegulars => 'नियमित';

  @override
  String get cohortNew => 'नवीन';

  @override
  String get cohortCameBack => 'परत आले';

  @override
  String get cohortStoppedComing => 'येणे बंद केले';

  @override
  String get customersLabel => 'ग्राहक';

  @override
  String get reachOutNow => 'आता संपर्क करा';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count नियमित ग्राहक कमी होत आहेत · $revenue धोक्यात';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× उशीर';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'साधारणपणे दर $cadenceदिवसांनी · $overdueदिवस उशीर';
  }

  @override
  String get remind => 'रिमाइंड करा';

  @override
  String get remindOnWhatsappTooltip => 'व्हॉट्सअ‍ॅपवर रिमाइंड करा';

  @override
  String get retentionProTitle => 'रिटेंशन इनसाइट्स हे PRO फीचर आहे';

  @override
  String get retentionProBody =>
      'कोणी येणे बंद केले ते पहा, तुमचे नवीन-विरुद्ध-परतणारे प्रमाण, आणि एक-टॅप रिमाइंडरने गमावलेले ग्राहक परत मिळवा.';

  @override
  String get upgradeToPro => 'PRO मध्ये अपग्रेड करा';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits भेटी · $spend खर्च';
  }

  @override
  String get createYourAccount => 'तुमचे खाते तयार करा';

  @override
  String get basics => 'मूलभूत माहिती';

  @override
  String get country => 'देश';

  @override
  String get countryHelperText =>
      'तुमचे चलन, फोन स्वरूप आणि डीफॉल्ट भाषा निश्चित करते.';

  @override
  String get language => 'भाषा';

  @override
  String get phoneNumberLabel => 'फोन नंबर';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String stepOfTotal(int step, int total) {
    return 'पायरी $step / $total';
  }

  @override
  String get createAccountButton => 'खाते तयार करा';

  @override
  String get continueButton => 'पुढे सुरू ठेवा';

  @override
  String get enterPhoneNumber => 'फोन नंबर टाका';

  @override
  String get passwordMinLength => 'पासवर्ड किमान 6 अक्षरांचा असावा';

  @override
  String get fillOwnerSalonAddress => 'मालकाचे नाव, सलूनचे नाव आणि पत्ता भरा';

  @override
  String get turnOnLocationPermission =>
      'हे वापरण्यासाठी लोकेशन चालू करा आणि परवानगी द्या';

  @override
  String get couldNotGetLocation => 'तुमचे लोकेशन मिळू शकले नाही';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'हा फोन आधीच नोंदणीकृत आहे. कृपया साइन इन करा.';

  @override
  String get signupFailedCheckBackend =>
      'साइनअप अयशस्वी. बॅकएंड कनेक्शन तपासा.';

  @override
  String get signupFailedTryAgain =>
      'साइनअप अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get yourSalon => 'तुमचे सलून';

  @override
  String get salonDetailsSubtitle => 'पायरी 2/3 · सलूनचा तपशील';

  @override
  String get ownerNameLabel => 'मालकाचे नाव';

  @override
  String get salonNameLabel => 'सलूनचे नाव';

  @override
  String get salonAddressLabel => 'सलूनचा पत्ता';

  @override
  String get locationSet => 'लोकेशन सेट झाले';

  @override
  String get useMyCurrentLocation => 'माझे सध्याचे लोकेशन वापरा';

  @override
  String get pickYourColor => 'तुमचा रंग निवडा';

  @override
  String get colorPreviewHelp =>
      'हा संपूर्ण अ‍ॅपमधील तुमच्या सलूनचा अ‍ॅक्सेंट रंग आहे. खात्यात कधीही बदला.';

  @override
  String get previewLabel => 'पूर्वावलोकन';

  @override
  String get newBooking => 'नवीन बुकिंग';

  @override
  String get colorTeal => 'टील';

  @override
  String get colorTerracotta => 'टेराकोटा';

  @override
  String get colorBlue => 'निळा';

  @override
  String get colorViolet => 'जांभळा';

  @override
  String get colorRose => 'गुलाबी';

  @override
  String get welcomeBack => 'पुन्हा स्वागत आहे';

  @override
  String get signInToDashboard => 'तुमच्या सलून डॅशबोर्डमध्ये साइन इन करा';

  @override
  String get enterSalonOwnerPhone => 'सलून मालकाचा फोन नंबर टाका';

  @override
  String get enterYourPassword => 'तुमचा पासवर्ड टाका';

  @override
  String get noSalonOwnerFound =>
      'या फोनसाठी कोणतेही सलून मालक खाते सापडले नाही.';

  @override
  String get loginFailedCheckBackend => 'लॉगिन अयशस्वी. बॅकएंड कनेक्शन तपासा.';

  @override
  String get loginFailedTryAgain => 'लॉगिन अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get hidePassword => 'पासवर्ड लपवा';

  @override
  String get showPassword => 'पासवर्ड दाखवा';

  @override
  String get signIn => 'साइन इन करा';

  @override
  String get newHere => 'नवीन आहात?';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get forgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get resetPasswordTitle => 'पासवर्ड रीसेट करा';

  @override
  String get resetPasswordEnterPhone =>
      'तुमचा फोन नंबर टाका, आम्ही व्हॉट्सअॅपवर 6-अंकी कोड पाठवू.';

  @override
  String get sendCodeViaWhatsApp => 'व्हॉट्सअॅपवर कोड पाठवा';

  @override
  String get codeSentViaWhatsApp =>
      'ते खाते अस्तित्वात असल्यास, व्हॉट्सअॅपवर कोड पाठवला गेला आहे.';

  @override
  String get resetPasswordEnterCode =>
      'आम्ही व्हॉट्सअॅपवर पाठवलेला कोड टाका, नंतर नवीन पासवर्ड निवडा.';

  @override
  String get otpCodeLabel => '6-अंकी कोड';

  @override
  String get resetPasswordButton => 'पासवर्ड रीसेट करा';

  @override
  String get resendCode => 'कोड पुन्हा पाठवा';

  @override
  String get changePhoneNumber => 'फोन नंबर बदला';

  @override
  String get enterSixDigitCode => '6-अंकी कोड टाका';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get passwordResetSuccess =>
      'पासवर्ड रीसेट झाला. कृपया नवीन पासवर्डने साइन इन करा.';

  @override
  String get waitBeforeRetryingCode => 'दुसरा कोड मागण्यापूर्वी एक मिनिट थांबा';

  @override
  String get invalidOrExpiredCode => 'तो कोड अवैध आहे किंवा कालबाह्य झाला आहे';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'खूप प्रयत्न झाले — नवीन कोड मागा';

  @override
  String get continueWithGoogle => 'Google सह सुरू ठेवा';

  @override
  String get signedInWithGoogle => 'Google सह साइन इन केले';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google सह $email म्हणून साइन इन केले';
  }

  @override
  String get usePasswordInstead => 'त्याऐवजी पासवर्ड वापरा';

  @override
  String get googleSignInNotConfigured =>
      'Google साइन-इन अद्याप सेट अप केलेले नाही';

  @override
  String get googleSignInFailed =>
      'Google साइन-इन अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get googleNoAccountFound =>
      'त्या Google खात्यासाठी कोणतेही खाते सापडले नाही. आधी एक तयार करा.';

  @override
  String get linkGoogleAccount => 'Google खाते लिंक करा';

  @override
  String get googleAccountLinked =>
      'Google खाते लिंक झाले — आता तुम्ही त्यासह साइन इन करू शकता';

  @override
  String get addStaffBeforeBookings =>
      'बुकिंग तयार करण्यापूर्वी सक्रिय स्टाफ जोडा';

  @override
  String get salonLabel => 'सलून';

  @override
  String get statToday => 'आज';

  @override
  String get statRepeat => 'पुनरावृत्ती';

  @override
  String get statLoggedHelper => 'नोंदवले';

  @override
  String get statBackHelper => 'परतले';

  @override
  String get statWeek => 'आठवडा';

  @override
  String get statMonth => 'महिना';

  @override
  String get loggedTodayHeading => 'आज नोंदवले';

  @override
  String get nothingLoggedToday =>
      'आज अद्याप काहीही नोंदवले नाही. सेवा पूर्ण झाल्यावर \"नवीन बुकिंग\" वर टॅप करा.';

  @override
  String get navHome => 'होम';

  @override
  String get navBookings => 'बुकिंग्ज';

  @override
  String get navStaff => 'स्टाफ';

  @override
  String get navInsights => 'इनसाइट्स';

  @override
  String get navAccount => 'खाते';

  @override
  String get salonAdminTitle => 'सलून अ‍ॅडमिन';

  @override
  String get noSalonLinked =>
      'या मालक खात्याशी अद्याप कोणतेही सलून जोडलेले नाही.';

  @override
  String get bookingsTitle => 'बुकिंग्ज';

  @override
  String get searchCustomerOrService => 'ग्राहक किंवा सेवा शोधा';

  @override
  String get filterThisWeek => 'या आठवड्यात';

  @override
  String get filterAllTime => 'सर्व वेळ';

  @override
  String get filterAllStaff => 'सर्व स्टाफ';

  @override
  String get staffLabel => 'स्टाफ';

  @override
  String get needsActionHeading => 'कारवाई आवश्यक';

  @override
  String get statTotal => 'एकूण';

  @override
  String get statServices => 'सेवा';

  @override
  String get statAvgTicket => 'सरासरी बिल';

  @override
  String get noBookingsMatchFilter => 'या फिल्टरशी जुळणारी कोणतीही बुकिंग नाही';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'काल';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count सेवा';
  }

  @override
  String get couldNotOpenStore => 'स्टोअर उघडता आले नाही';

  @override
  String get updateRequired => 'अपडेट आवश्यक आहे';

  @override
  String get updateRequiredBody =>
      'अ‍ॅपची नवीन आवृत्ती उपलब्ध आहे. तुमचा सलून डॅशबोर्ड वापरणे सुरू ठेवण्यासाठी कृपया अपडेट करा.';

  @override
  String get updateNow => 'आता अपडेट करा';

  @override
  String get themeColorTitle => 'थीम रंग';

  @override
  String get save => 'सेव्ह करा';

  @override
  String get staffTitle => 'स्टाफ';

  @override
  String get addStaff => 'स्टाफ जोडा';

  @override
  String get statActive => 'सक्रिय';

  @override
  String get statTodaysTotal => 'आजची एकूण';

  @override
  String get noActiveStaffYet => 'अद्याप कोणताही सक्रिय स्टाफ नाही';

  @override
  String get addFirstStaff => 'पहिला स्टाफ जोडा';

  @override
  String get noServicesYet => 'अद्याप कोणतीही सेवा नाही';

  @override
  String get notActive => 'सक्रिय नाही';

  @override
  String get canSetOwnPrice => 'स्वतःची किंमत ठरवू शकतात';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count सेवा · $revenue';
  }

  @override
  String get newLabel => 'नवीन';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get customerLabel => 'ग्राहक';

  @override
  String get repeatLabel => 'पुनरावृत्ती';

  @override
  String get couldNotUpdateBooking =>
      'बुकिंग अपडेट होऊ शकली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get couldNotAcceptReschedule =>
      'रीशेड्यूल स्वीकारता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get couldNotRejectReschedule =>
      'रीशेड्यूल नाकारता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get rescheduleLabel => 'रीशेड्यूल';

  @override
  String get pendingLabel => 'प्रलंबित';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist सोबत';
  }

  @override
  String customerRequestedTime(String time) {
    return 'ग्राहकाने $time विनंती केली';
  }

  @override
  String get reject => 'नाकारा';

  @override
  String get accept => 'स्वीकारा';

  @override
  String get confirm => 'पुष्टी करा';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + आणखी $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'खात्याचा तपशील लोड होऊ शकला नाही';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'मालक, फोन, सलूनचे नाव आणि पत्ता भरा';

  @override
  String get accountUpdated => 'खाते अपडेट झाले';

  @override
  String get phoneOrEmailUsed => 'फोन किंवा ईमेल आधीच वापरात आहे';

  @override
  String get couldNotSaveAccount => 'खात्याचा तपशील सेव्ह होऊ शकला नाही';

  @override
  String get newPasswordMinLength => 'नवीन पासवर्ड किमान 6 अक्षरांचा असावा';

  @override
  String get newPasswordsDontMatch => 'नवीन पासवर्ड जुळत नाहीत';

  @override
  String get passwordChanged => 'पासवर्ड बदलला';

  @override
  String get currentPasswordIncorrect => 'सध्याचा पासवर्ड चुकीचा आहे';

  @override
  String get couldNotChangePassword => 'पासवर्ड बदलता आला नाही';

  @override
  String get countryAndCurrency => 'देश आणि चलन';

  @override
  String get accountTitle => 'खाते';

  @override
  String ownerSinceDate(String date) {
    return '$date पासून मालक';
  }

  @override
  String planLabel(String plan) {
    return '$plan प्लॅन';
  }

  @override
  String get retentionFreeFor6Months => '6 महिन्यांसाठी रिटेंशन इनसाइट्स मोफत';

  @override
  String get upgrade => 'अपग्रेड करा';

  @override
  String get appearance => 'देखावा';

  @override
  String get salonProfile => 'सलून प्रोफाइल';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get locationUpdated => 'लोकेशन अपडेट झाले';

  @override
  String get saveDetailsButton => 'तपशील सेव्ह करा';

  @override
  String get savingEllipsis => 'सेव्ह होत आहे...';

  @override
  String get security => 'सुरक्षा';

  @override
  String get currentPasswordLabel => 'सध्याचा पासवर्ड';

  @override
  String get newPasswordLabel => 'नवीन पासवर्ड';

  @override
  String get confirmNewPasswordLabel => 'नवीन पासवर्डची पुष्टी करा';

  @override
  String get changePasswordButton => 'पासवर्ड बदला';

  @override
  String get changingEllipsis => 'बदलत आहे...';

  @override
  String get signOut => 'साइन आउट करा';

  @override
  String get enterServiceNamePrice => 'सेवेचे नाव आणि किंमत टाका';

  @override
  String get fillStaffNamePhone => 'स्टाफचे नाव आणि फोन भरा';

  @override
  String get addAtLeastOneService => 'किमान एक सेवा जोडा';

  @override
  String get enterValidOpenCloseTimes =>
      'वैध उघडण्याची आणि बंद होण्याची वेळ टाका (HH:MM, 24-तास)';

  @override
  String get selectAtLeastOneWorkingDay => 'किमान एक कामाचा दिवस निवडा';

  @override
  String get staffPhoneInUse => 'तो स्टाफ फोन आधीच वापरात आहे';

  @override
  String get couldNotAddStaff =>
      'स्टाफ जोडता आला नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get addStaffSubtitle =>
      'त्यांचे प्रोफाइल, सेवा आणि कामाचे दिवस सेट करा.';

  @override
  String get staffNameLabel => 'स्टाफचे नाव';

  @override
  String get staffPhoneLabel => 'स्टाफचा फोन';

  @override
  String get servicesLabel => 'सेवा';

  @override
  String servicesAddedCount(int count) {
    return '$count जोडल्या';
  }

  @override
  String get workingHours => 'कामाचे तास';

  @override
  String get opens => 'उघडते';

  @override
  String get closes => 'बंद होते';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'कामाचे दिवस';

  @override
  String get serviceNameHint => 'सेवेचे नाव';

  @override
  String get priceHint => 'किंमत';

  @override
  String get dayMon => 'सोम';

  @override
  String get dayTue => 'मंगळ';

  @override
  String get dayWed => 'बुध';

  @override
  String get dayThu => 'गुरू';

  @override
  String get dayFri => 'शुक्र';

  @override
  String get daySat => 'शनि';

  @override
  String get daySun => 'रवि';

  @override
  String get enterValidStaffNamePhone => 'वैध स्टाफ नाव आणि फोन टाका';

  @override
  String get staffDetailsSaved => 'स्टाफ तपशील सेव्ह झाला';

  @override
  String get phoneAlreadyInUse => 'तो फोन आधीच वापरात आहे';

  @override
  String get couldNotUpdateStaff => 'स्टाफ अपडेट होऊ शकला नाही';

  @override
  String get enterServiceNameAndPriceShort => 'सेवेचे नाव आणि किंमत टाका';

  @override
  String get couldNotAddService => 'सेवा जोडता आली नाही';

  @override
  String get editServiceTitle => 'सेवा संपादित करा';

  @override
  String get enterValidServiceNamePrice => 'वैध सेवेचे नाव आणि किंमत टाका';

  @override
  String get couldNotUpdateService => 'सेवा अपडेट होऊ शकली नाही';

  @override
  String get saveServiceButton => 'सेवा सेव्ह करा';

  @override
  String get couldNotRemoveServiceDefault => 'सेवा काढता आली नाही';

  @override
  String get useHHmmWorkingHours => 'कामाच्या तासांसाठी HH:mm वापरा';

  @override
  String get hoursAdded => 'तास जोडले';

  @override
  String get couldNotAddWorkingHours => 'कामाचे तास जोडता आले नाहीत';

  @override
  String get couldNotRemoveTiming => 'वेळ काढता आली नाही';

  @override
  String get manageStaffTitle => 'स्टाफ व्यवस्थापित करा';

  @override
  String get done => 'पूर्ण';

  @override
  String get manageStaffSubtitle =>
      'सेवा आणि तास जोडा, संपादित करा किंवा काढा, नंतर पूर्ण वर टॅप करा.';

  @override
  String get saveStaffButton => 'स्टाफ सेव्ह करा';

  @override
  String get edit => 'संपादित करा';

  @override
  String get delete => 'हटवा';

  @override
  String get newServiceLabel => 'नवीन सेवा';

  @override
  String get addingEllipsis => 'जोडत आहे...';

  @override
  String get addServiceButton => 'सेवा जोडा';

  @override
  String get noTimingsYet => 'अद्याप कोणतीही वेळ नाही';

  @override
  String get removeLabel => 'काढा';

  @override
  String get startLabel => 'सुरुवात';

  @override
  String get endLabel => 'शेवट';

  @override
  String get addMonSatHoursButton => 'सोम-शनि तास जोडा';

  @override
  String get saveHoursButton => 'वेळ सेव्ह करा';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'स्टाफ, सेवा आणि तारीख निवडा';

  @override
  String get noSlotsForDate => 'या तारखेसाठी कोणतेही स्लॉट उपलब्ध नाहीत.';

  @override
  String get couldNotLoadSlots => 'स्लॉट लोड होऊ शकले नाहीत';

  @override
  String get enterCustomerName => 'ग्राहकाचे नाव टाका';

  @override
  String get chooseStaffAndService => 'स्टाफ आणि किमान एक सेवा निवडा';

  @override
  String get enterCustomerPhone => 'ग्राहकाचा फोन टाका';

  @override
  String get chooseAvailableSlot => 'उपलब्ध स्लॉट निवडा';

  @override
  String get couldNotCreateBooking =>
      'बुकिंग तयार होऊ शकली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get doneServiceOption => 'सेवा पूर्ण झाली';

  @override
  String get scheduleLaterOption => 'नंतर शेड्यूल करा';

  @override
  String get customerNameLabel => 'ग्राहकाचे नाव';

  @override
  String get customerPhoneLabel => 'ग्राहकाचा फोन';

  @override
  String recordedNowDate(String date) {
    return 'आत्ता नोंदवले — $date';
  }

  @override
  String get dateLabel => 'तारीख';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'उपलब्ध स्लॉट';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get saveBooking => 'बुकिंग सेव्ह करा';

  @override
  String saveBookingWithTotal(String total) {
    return 'बुकिंग सेव्ह करा · $total';
  }
}
