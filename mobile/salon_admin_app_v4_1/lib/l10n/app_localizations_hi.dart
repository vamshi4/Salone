// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get insightsTitle => 'इनसाइट्स';

  @override
  String get tabEarnings => 'कमाई';

  @override
  String get tabRetention => 'रिटेंशन';

  @override
  String get periodToday => 'आज';

  @override
  String get periodWeek => 'सप्ताह';

  @override
  String get periodMonth => 'महीना';

  @override
  String get periodLast7Days => 'पिछले 7 दिन';

  @override
  String get periodLast30Days => 'पिछले 30 दिन';

  @override
  String get earningsLoadError => 'कमाई लोड नहीं हो सकी।';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेवाएं',
      one: '$count सेवा',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'पूरी की गई सेवाएं';

  @override
  String get noCompletedServices =>
      'इस अवधि में अभी तक कोई सेवा पूरी नहीं हुई।';

  @override
  String get topServicesHeading => 'शीर्ष सेवाएं';

  @override
  String get byStaffHeading => 'स्टाफ अनुसार';

  @override
  String get vsYesterday => 'कल की तुलना में';

  @override
  String get vsLastWeek => 'पिछले सप्ताह की तुलना में';

  @override
  String get vsLastMonth => 'पिछले महीने की तुलना में';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'वापस आए ग्राहक';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस महीने $count ग्राहक वापस आए',
      one: 'इस महीने $count ग्राहक वापस आया',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'रिटेंशन रिपोर्ट लोड नहीं हो सकी।';

  @override
  String get couldNotOpenWhatsapp => 'व्हाट्सएप नहीं खुल सका';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'नमस्ते $name! हमें आपकी याद आ रही है $salonName में। अपनी अगली विज़िट बुक करें और खास वेलकम-बैक ऑफर पाएं। जल्द मिलते हैं!';
  }

  @override
  String get customerCohortsHeading => 'ग्राहक समूह';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count ग्राहक';
  }

  @override
  String noCohortCustomers(String label) {
    return 'इस अवधि में कोई $label ग्राहक नहीं है।';
  }

  @override
  String get missedCustomersHeading => 'छूटे हुए ग्राहक';

  @override
  String get missedCustomersHint =>
      'व्हाट्सएप पर संदेश भेजने के लिए \"रिमाइंड\" पर टैप करें।';

  @override
  String get noMissedCustomers => 'इस महीने कोई ग्राहक नहीं छूटा।';

  @override
  String get cohortRegulars => 'नियमित';

  @override
  String get cohortNew => 'नए';

  @override
  String get cohortCameBack => 'वापस आए';

  @override
  String get cohortStoppedComing => 'आना बंद किया';

  @override
  String get customersLabel => 'ग्राहक';

  @override
  String get reachOutNow => 'अभी संपर्क करें';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count नियमित ग्राहक फिसल रहे हैं · $revenue जोखिम में';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× ओवरड्यू';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'आमतौर पर हर $cadenceदिन · $overdueदिन ओवरड्यू';
  }

  @override
  String get remind => 'रिमाइंड करें';

  @override
  String get remindOnWhatsappTooltip => 'व्हाट्सएप पर रिमाइंड करें';

  @override
  String get retentionProTitle => 'रिटेंशन इनसाइट्स एक PRO फीचर है';

  @override
  String get retentionProBody =>
      'देखें किसने आना बंद किया, आपका नया-बनाम-वापसी अनुपात, और एक-टैप रिमाइंडर से खोए ग्राहकों को वापस लाएं।';

  @override
  String get upgradeToPro => 'PRO में अपग्रेड करें';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits विज़िट · $spend खर्च';
  }

  @override
  String get createYourAccount => 'अपना अकाउंट बनाएं';

  @override
  String get basics => 'बुनियादी जानकारी';

  @override
  String get country => 'देश';

  @override
  String get countryHelperText =>
      'आपकी करेंसी, फोन फॉर्मेट और डिफ़ॉल्ट भाषा तय करता है।';

  @override
  String get language => 'भाषा';

  @override
  String get phoneNumberLabel => 'फोन नंबर';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String stepOfTotal(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get createAccountButton => 'अकाउंट बनाएं';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get enterPhoneNumber => 'फोन नंबर दर्ज करें';

  @override
  String get passwordMinLength => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get fillOwnerSalonAddress => 'मालिक का नाम, सैलून नाम और पता भरें';

  @override
  String get turnOnLocationPermission =>
      'इसका उपयोग करने के लिए लोकेशन चालू करें और अनुमति दें';

  @override
  String get couldNotGetLocation => 'आपकी लोकेशन नहीं मिल सकी';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'यह फोन पहले से रजिस्टर्ड है। कृपया साइन इन करें।';

  @override
  String get signupFailedCheckBackend => 'साइनअप विफल। बैकएंड कनेक्शन जांचें।';

  @override
  String get signupFailedTryAgain => 'साइनअप विफल। कृपया फिर से प्रयास करें।';

  @override
  String get yourSalon => 'आपका सैलून';

  @override
  String get salonDetailsSubtitle => 'चरण 2/3 · सैलून विवरण';

  @override
  String get ownerNameLabel => 'मालिक का नाम';

  @override
  String get salonNameLabel => 'सैलून का नाम';

  @override
  String get salonAddressLabel => 'सैलून का पता';

  @override
  String get locationSet => 'लोकेशन सेट हो गई';

  @override
  String get useMyCurrentLocation => 'मेरी वर्तमान लोकेशन का उपयोग करें';

  @override
  String get pickYourColor => 'अपना रंग चुनें';

  @override
  String get colorPreviewHelp =>
      'यह पूरे ऐप में आपके सैलून का एक्सेंट रंग है। इसे कभी भी अकाउंट में बदलें।';

  @override
  String get previewLabel => 'पूर्वावलोकन';

  @override
  String get newBooking => 'नई बुकिंग';

  @override
  String get colorTeal => 'टील';

  @override
  String get colorTerracotta => 'टेराकोटा';

  @override
  String get colorBlue => 'नीला';

  @override
  String get colorViolet => 'बैंगनी';

  @override
  String get colorRose => 'गुलाबी';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get signInToDashboard => 'अपने सैलून डैशबोर्ड में साइन इन करें';

  @override
  String get enterSalonOwnerPhone => 'सैलून मालिक का फोन नंबर दर्ज करें';

  @override
  String get enterYourPassword => 'अपना पासवर्ड दर्ज करें';

  @override
  String get noSalonOwnerFound =>
      'इस फोन के लिए कोई सैलून मालिक अकाउंट नहीं मिला।';

  @override
  String get loginFailedCheckBackend => 'लॉगिन विफल। बैकएंड कनेक्शन जांचें।';

  @override
  String get loginFailedTryAgain => 'लॉगिन विफल। कृपया फिर से प्रयास करें।';

  @override
  String get hidePassword => 'पासवर्ड छुपाएं';

  @override
  String get showPassword => 'पासवर्ड दिखाएं';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get newHere => 'नए हैं?';

  @override
  String get createAccount => 'अकाउंट बनाएं';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get resetPasswordTitle => 'पासवर्ड रीसेट करें';

  @override
  String get resetPasswordEnterPhone =>
      'अपना फोन नंबर डालें, हम व्हाट्सएप पर 6 अंकों का कोड भेजेंगे।';

  @override
  String get sendCodeViaWhatsApp => 'व्हाट्सएप पर कोड भेजें';

  @override
  String get codeSentViaWhatsApp =>
      'अगर वह अकाउंट मौजूद है, तो व्हाट्सएप पर एक कोड भेजा गया है।';

  @override
  String get resetPasswordEnterCode =>
      'हमने व्हाट्सएप पर भेजा कोड डालें, फिर नया पासवर्ड चुनें।';

  @override
  String get otpCodeLabel => '6 अंकों का कोड';

  @override
  String get resetPasswordButton => 'पासवर्ड रीसेट करें';

  @override
  String get resendCode => 'कोड फिर से भेजें';

  @override
  String get changePhoneNumber => 'फोन नंबर बदलें';

  @override
  String get enterSixDigitCode => '6 अंकों का कोड डालें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get passwordResetSuccess =>
      'पासवर्ड रीसेट हो गया। कृपया नए पासवर्ड से साइन इन करें।';

  @override
  String get waitBeforeRetryingCode => 'दूसरा कोड मांगने से पहले एक मिनट रुकें';

  @override
  String get invalidOrExpiredCode => 'यह कोड अमान्य है या समाप्त हो गया है';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'बहुत अधिक प्रयास — नया कोड मांगें';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get signedInWithGoogle => 'Google से साइन इन किया गया';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google से $email के रूप में साइन इन किया गया';
  }

  @override
  String get usePasswordInstead => 'इसके बजाय पासवर्ड का उपयोग करें';

  @override
  String get googleSignInNotConfigured =>
      'Google साइन-इन अभी सेट अप नहीं हुआ है';

  @override
  String get googleSignInFailed =>
      'Google साइन-इन विफल। कृपया फिर से प्रयास करें।';

  @override
  String get googleNoAccountFound =>
      'उस Google खाते के लिए कोई खाता नहीं मिला। पहले एक बनाएं।';

  @override
  String get linkGoogleAccount => 'Google खाता लिंक करें';

  @override
  String get googleAccountLinked =>
      'Google खाता लिंक हो गया — अब आप इससे साइन इन कर सकते हैं';

  @override
  String get addStaffBeforeBookings =>
      'बुकिंग बनाने से पहले सक्रिय स्टाफ जोड़ें';

  @override
  String get salonLabel => 'सैलून';

  @override
  String get statToday => 'आज';

  @override
  String get statRepeat => 'दोहराव';

  @override
  String get statLoggedHelper => 'दर्ज';

  @override
  String get statBackHelper => 'वापसी';

  @override
  String get statWeek => 'सप्ताह';

  @override
  String get statMonth => 'महीना';

  @override
  String get loggedTodayHeading => 'आज दर्ज किया गया';

  @override
  String get nothingLoggedToday =>
      'आज अभी तक कुछ दर्ज नहीं हुआ। सेवा पूरी होने पर \"नई बुकिंग\" टैप करें।';

  @override
  String get navHome => 'होम';

  @override
  String get navBookings => 'बुकिंग';

  @override
  String get navStaff => 'स्टाफ';

  @override
  String get navInsights => 'इनसाइट्स';

  @override
  String get navAccount => 'अकाउंट';

  @override
  String get salonAdminTitle => 'सैलून एडमिन';

  @override
  String get noSalonLinked => 'इस मालिक अकाउंट से अभी कोई सैलून जुड़ा नहीं है।';

  @override
  String get bookingsTitle => 'बुकिंग';

  @override
  String get searchCustomerOrService => 'ग्राहक या सेवा खोजें';

  @override
  String get filterThisWeek => 'इस सप्ताह';

  @override
  String get filterAllTime => 'सभी समय';

  @override
  String get filterAllStaff => 'सभी स्टाफ';

  @override
  String get staffLabel => 'स्टाफ';

  @override
  String get needsActionHeading => 'कार्रवाई ज़रूरी';

  @override
  String get statTotal => 'कुल';

  @override
  String get statServices => 'सेवाएं';

  @override
  String get statAvgTicket => 'औसत टिकट';

  @override
  String get noBookingsMatchFilter => 'इस फ़िल्टर से कोई बुकिंग मेल नहीं खाती';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेवाएं',
      one: '$count सेवा',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'स्टोर नहीं खुल सका';

  @override
  String get updateRequired => 'अपडेट आवश्यक है';

  @override
  String get updateRequiredBody =>
      'ऐप का नया वर्ज़न उपलब्ध है। अपना सैलून डैशबोर्ड उपयोग करना जारी रखने के लिए कृपया अपडेट करें।';

  @override
  String get updateNow => 'अभी अपडेट करें';

  @override
  String get themeColorTitle => 'थीम रंग';

  @override
  String get save => 'सेव करें';

  @override
  String get staffTitle => 'स्टाफ';

  @override
  String get addStaff => 'स्टाफ जोड़ें';

  @override
  String get statActive => 'सक्रिय';

  @override
  String get statTodaysTotal => 'आज की कुल कमाई';

  @override
  String get noActiveStaffYet => 'अभी तक कोई सक्रिय स्टाफ नहीं';

  @override
  String get addFirstStaff => 'पहला स्टाफ जोड़ें';

  @override
  String get noServicesYet => 'अभी तक कोई सेवा नहीं';

  @override
  String get notActive => 'सक्रिय नहीं';

  @override
  String get canSetOwnPrice => 'अपनी कीमत खुद तय कर सकते हैं';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेवाएं',
      one: '$count सेवा',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'नई';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get customerLabel => 'ग्राहक';

  @override
  String get repeatLabel => 'दोहराव';

  @override
  String get couldNotUpdateBooking =>
      'बुकिंग अपडेट नहीं हो सकी। कृपया फिर से प्रयास करें।';

  @override
  String get couldNotAcceptReschedule =>
      'रीशेड्यूल स्वीकार नहीं हो सका। कृपया फिर से प्रयास करें।';

  @override
  String get couldNotRejectReschedule =>
      'रीशेड्यूल अस्वीकार नहीं हो सका। कृपया फिर से प्रयास करें।';

  @override
  String get rescheduleLabel => 'रीशेड्यूल';

  @override
  String get pendingLabel => 'लंबित';

  @override
  String get scheduledLabel => 'निर्धारित';

  @override
  String get inProgressLabel => 'जारी है';

  @override
  String get startBookingButton => 'शुरू करें';

  @override
  String get doneBookingButton => 'पूर्ण';

  @override
  String get todayScheduleHeading => 'आज का शेड्यूल';

  @override
  String get paymentMethodLabel => 'भुगतान';

  @override
  String get paymentMethodCash => 'नकद';

  @override
  String get paymentMethodCard => 'कार्ड';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'फिर से बुक करें';

  @override
  String get couldNotLoadCustomerProfile => 'ग्राहक प्रोफ़ाइल लोड नहीं हो सकी';

  @override
  String get notesSaved => 'नोट्स सेव हो गए';

  @override
  String get couldNotSaveNotes =>
      'नोट्स सेव नहीं हो सके। कृपया फिर से कोशिश करें।';

  @override
  String get statsVisitsLabel => 'विज़िट';

  @override
  String get statsTotalSpentLabel => 'कुल खर्च';

  @override
  String lastServiceSummary(String service, String date) {
    return 'आखिरी: $service, $date';
  }

  @override
  String get notesLabel => 'नोट्स';

  @override
  String get notesHint => 'पसंद, एलर्जी, याद रखने लायक कुछ भी';

  @override
  String get tagsLabel => 'टैग';

  @override
  String get addTagHint => 'टैग जोड़ें';

  @override
  String get saveNotesButton => 'नोट्स सेव करें';

  @override
  String get visitHistoryHeading => 'विज़िट इतिहास';

  @override
  String get noVisitsYet => 'अभी तक कोई विज़िट नहीं';

  @override
  String get viewProfileTooltip => 'प्रोफ़ाइल देखें';

  @override
  String get dailyRevenueGoalLabel => 'दैनिक कमाई लक्ष्य';

  @override
  String get dailyRevenueGoalHint =>
      'वैकल्पिक — होम पर प्रगति बार छिपाने के लिए खाली छोड़ें';

  @override
  String get payoutsTooltip => 'भुगतान';

  @override
  String get staffActiveLabel => 'सक्रिय';

  @override
  String get canCancelBookingLabel => 'बुकिंग रद्द कर सकते हैं';

  @override
  String get couldNotLoadPayouts => 'भुगतान लोड नहीं हो सके';

  @override
  String get payoutSettled => 'भुगतान दर्ज हुआ';

  @override
  String get couldNotMarkPaid =>
      'भुगतान के रूप में चिह्नित नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get payoutsTitle => 'कमाई और भुगतान';

  @override
  String get unpaidLabel => 'बकाया';

  @override
  String get markAsPaidButton => 'भुगतान हो गया चिह्नित करें';

  @override
  String get grossRevenueLabel => 'कमाई';

  @override
  String get totalPayoutLabel => 'भुगतान';

  @override
  String get payoutHistoryHeading => 'भुगतान इतिहास';

  @override
  String get noPayoutsYet => 'अभी तक कोई भुगतान नहीं';

  @override
  String get payTypeLabel => 'भुगतान प्रकार';

  @override
  String get payTypeCommission => 'कमीशन';

  @override
  String get payTypeSalary => 'वेतन';

  @override
  String get payTypeBoth => 'दोनों';

  @override
  String get commissionRateLabel => 'कमीशन %';

  @override
  String get monthlySalaryLabel => 'मासिक वेतन';

  @override
  String get couldNotSavePayType =>
      'भुगतान सेटिंग सेव नहीं हो सकी। कृपया फिर से कोशिश करें।';

  @override
  String get salaryThisMonthLabel => 'इस महीने का वेतन';

  @override
  String get salaryPaidStatus => 'भुगतान हो गया';

  @override
  String get paySalaryButton => 'वेतन दें';

  @override
  String get salaryPaid => 'वेतन दिया गया';

  @override
  String get couldNotPaySalary =>
      'वेतन नहीं दिया जा सका। कृपया फिर से कोशिश करें।';

  @override
  String get searchStaffHint => 'स्टाफ खोजें';

  @override
  String get filterActiveStaff => 'सक्रिय';

  @override
  String get filterInactiveStaff => 'निष्क्रिय';

  @override
  String get switchBranchTitle => 'शाखा बदलें';

  @override
  String get switchLabel => 'शाखा बदलें';

  @override
  String get allBranchesLabel => 'सभी शाखाएं';

  @override
  String get allBranchesSubtitle => 'सभी शाखाओं का कुल योग';

  @override
  String get pickBranchFirst => 'पहले एक विशेष शाखा चुनें';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count दर्ज · $revenue · $staff स्टाफ';
  }

  @override
  String get dayOffLabel => 'छुट्टी';

  @override
  String get addBranchButton => 'शाखा जोड़ें';

  @override
  String get addBranchTitle => 'एक शाखा जोड़ें';

  @override
  String get branchNameAddressRequired => 'शाखा का नाम और पता आवश्यक है';

  @override
  String get couldNotAddBranch =>
      'शाखा नहीं जोड़ी जा सकी। कृपया फिर से कोशिश करें।';

  @override
  String get fillProductFields => 'कृपया सभी प्रोडक्ट फ़ील्ड सही से भरें';

  @override
  String get couldNotSaveProduct =>
      'प्रोडक्ट सेव नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get editProductTitle => 'प्रोडक्ट संपादित करें';

  @override
  String get addProductTitle => 'प्रोडक्ट जोड़ें';

  @override
  String get productNameLabel => 'प्रोडक्ट का नाम';

  @override
  String get skuLabel => 'SKU (वैकल्पिक)';

  @override
  String get stockQtyLabel => 'स्टॉक';

  @override
  String get lowStockThresholdLabel => 'कम स्टॉक सीमा';

  @override
  String get deleteProductButton => 'प्रोडक्ट हटाएं';

  @override
  String get productsTitle => 'प्रोडक्ट्स';

  @override
  String get searchProductsHint => 'प्रोडक्ट खोजें';

  @override
  String get filterLowStock => 'कम स्टॉक';

  @override
  String get noLowStockProducts => 'कोई भी प्रोडक्ट कम स्टॉक में नहीं है';

  @override
  String get noProductsInCatalog => 'अभी तक कोई प्रोडक्ट नहीं';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्टॉक में',
      one: '1 स्टॉक में',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'कम स्टॉक';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रोडक्ट कम स्टॉक में हैं',
      one: '1 प्रोडक्ट कम स्टॉक में है',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'आज';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अपॉइंटमेंट दर्ज',
      one: '1 अपॉइंटमेंट दर्ज',
      zero: 'अभी तक कोई अपॉइंटमेंट दर्ज नहीं',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$goal लक्ष्य में से $current';
  }

  @override
  String get worthReachingOutHeading => 'आज संपर्क करने लायक';

  @override
  String get exportCsvTooltip => 'CSV निर्यात करें';

  @override
  String get couldNotExportEarnings =>
      'कमाई निर्यात नहीं हो सकी। कृपया फिर से कोशिश करें।';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन देरी',
      one: '1 दिन देरी',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist के साथ';
  }

  @override
  String customerRequestedTime(String time) {
    return 'ग्राहक ने $time अनुरोध किया';
  }

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count और';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'अकाउंट विवरण लोड नहीं हो सके';

  @override
  String get fillOwnerPhoneSalonAddress => 'मालिक, फोन, सैलून नाम और पता भरें';

  @override
  String get accountUpdated => 'अकाउंट अपडेट हो गया';

  @override
  String get phoneOrEmailUsed => 'फोन या ईमेल पहले से उपयोग में है';

  @override
  String get couldNotSaveAccount => 'अकाउंट विवरण सेव नहीं हो सके';

  @override
  String get newPasswordMinLength =>
      'नया पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get newPasswordsDontMatch => 'नए पासवर्ड मेल नहीं खाते';

  @override
  String get passwordChanged => 'पासवर्ड बदल दिया गया';

  @override
  String get currentPasswordIncorrect => 'मौजूदा पासवर्ड गलत है';

  @override
  String get couldNotChangePassword => 'पासवर्ड नहीं बदला जा सका';

  @override
  String get countryAndCurrency => 'देश और मुद्रा';

  @override
  String get accountTitle => 'अकाउंट';

  @override
  String ownerSinceDate(String date) {
    return '$date से मालिक';
  }

  @override
  String planLabel(String plan) {
    return '$plan प्लान';
  }

  @override
  String get retentionFreeFor6Months => '6 महीने के लिए रिटेंशन इनसाइट्स मुफ्त';

  @override
  String get upgrade => 'अपग्रेड करें';

  @override
  String get appearance => 'दिखावट';

  @override
  String get salonProfile => 'सैलून प्रोफाइल';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get locationUpdated => 'लोकेशन अपडेट हो गई';

  @override
  String get saveDetailsButton => 'विवरण सेव करें';

  @override
  String get savingEllipsis => 'सेव हो रहा है...';

  @override
  String get security => 'सुरक्षा';

  @override
  String get currentPasswordLabel => 'मौजूदा पासवर्ड';

  @override
  String get newPasswordLabel => 'नया पासवर्ड';

  @override
  String get confirmNewPasswordLabel => 'नया पासवर्ड फिर से दर्ज करें';

  @override
  String get changePasswordButton => 'पासवर्ड बदलें';

  @override
  String get changingEllipsis => 'बदल रहा है...';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get enterServiceNamePrice => 'सेवा का नाम और कीमत दर्ज करें';

  @override
  String get fillStaffNamePhone => 'स्टाफ का नाम और फोन भरें';

  @override
  String get addAtLeastOneService => 'कम से कम एक सेवा जोड़ें';

  @override
  String get enterValidOpenCloseTimes =>
      'मान्य खुलने और बंद होने का समय दर्ज करें (HH:MM, 24-घंटे)';

  @override
  String get selectAtLeastOneWorkingDay => 'कम से कम एक कार्य दिवस चुनें';

  @override
  String get staffPhoneInUse => 'यह स्टाफ फोन पहले से उपयोग में है';

  @override
  String get couldNotAddStaff =>
      'स्टाफ नहीं जोड़ा जा सका। कृपया फिर से प्रयास करें।';

  @override
  String get addStaffSubtitle =>
      'उनकी प्रोफाइल, सेवाएं और कार्य दिवस सेट करें।';

  @override
  String get staffNameLabel => 'स्टाफ का नाम';

  @override
  String get staffPhoneLabel => 'स्टाफ का फोन';

  @override
  String get servicesLabel => 'सेवाएं';

  @override
  String servicesAddedCount(int count) {
    return '$count जोड़ी गईं';
  }

  @override
  String get workingHours => 'काम के घंटे';

  @override
  String get opens => 'खुलता है';

  @override
  String get closes => 'बंद होता है';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'कार्य दिवस';

  @override
  String get serviceNameHint => 'सेवा का नाम';

  @override
  String get priceHint => 'कीमत';

  @override
  String get dayMon => 'सोम';

  @override
  String get dayTue => 'मंगल';

  @override
  String get dayWed => 'बुध';

  @override
  String get dayThu => 'गुरु';

  @override
  String get dayFri => 'शुक्र';

  @override
  String get daySat => 'शनि';

  @override
  String get daySun => 'रवि';

  @override
  String get enterValidStaffNamePhone => 'मान्य स्टाफ नाम और फोन दर्ज करें';

  @override
  String get staffDetailsSaved => 'स्टाफ विवरण सेव हो गया';

  @override
  String get phoneAlreadyInUse => 'यह फोन पहले से उपयोग में है';

  @override
  String get couldNotUpdateStaff => 'स्टाफ अपडेट नहीं हो सका';

  @override
  String get enterServiceNameAndPriceShort => 'सेवा का नाम और कीमत दर्ज करें';

  @override
  String get couldNotAddService => 'सेवा नहीं जोड़ी जा सकी';

  @override
  String get editServiceTitle => 'सेवा संपादित करें';

  @override
  String get enterValidServiceNamePrice => 'मान्य सेवा नाम और कीमत दर्ज करें';

  @override
  String get couldNotUpdateService => 'सेवा अपडेट नहीं हो सकी';

  @override
  String get saveServiceButton => 'सेवा सेव करें';

  @override
  String get couldNotRemoveServiceDefault => 'सेवा हटाई नहीं जा सकी';

  @override
  String get useHHmmWorkingHours => 'काम के घंटों के लिए HH:mm उपयोग करें';

  @override
  String get hoursAdded => 'घंटे जोड़े गए';

  @override
  String get couldNotAddWorkingHours => 'काम के घंटे नहीं जोड़े जा सके';

  @override
  String get couldNotRemoveTiming => 'समय नहीं हटाया जा सका';

  @override
  String get manageStaffTitle => 'स्टाफ प्रबंधित करें';

  @override
  String get done => 'पूर्ण';

  @override
  String get manageStaffSubtitle =>
      'सेवाएं और घंटे जोड़ें, संपादित करें या हटाएं, फिर \'पूर्ण\' पर टैप करें।';

  @override
  String get saveStaffButton => 'स्टाफ सेव करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get newServiceLabel => 'नई सेवा';

  @override
  String get addingEllipsis => 'जोड़ रहा है...';

  @override
  String get addServiceButton => 'सेवा जोड़ें';

  @override
  String get noTimingsYet => 'अभी तक कोई समय नहीं';

  @override
  String get removeLabel => 'हटाएं';

  @override
  String get startLabel => 'शुरू';

  @override
  String get endLabel => 'समाप्त';

  @override
  String get addMonSatHoursButton => 'सोम-शनि घंटे जोड़ें';

  @override
  String get saveHoursButton => 'घंटे सेव करें';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'स्टाफ, सेवा और तारीख चुनें';

  @override
  String get noSlotsForDate => 'इस तारीख के लिए कोई उपलब्ध स्लॉट नहीं।';

  @override
  String get couldNotLoadSlots => 'स्लॉट लोड नहीं हो सके';

  @override
  String get enterCustomerName => 'ग्राहक का नाम दर्ज करें';

  @override
  String get chooseStaffAndService => 'स्टाफ और कम से कम एक सेवा चुनें';

  @override
  String get enterCustomerPhone => 'ग्राहक का फोन दर्ज करें';

  @override
  String get chooseAvailableSlot => 'उपलब्ध स्लॉट चुनें';

  @override
  String get couldNotCreateBooking =>
      'बुकिंग नहीं बन सकी। कृपया फिर से प्रयास करें।';

  @override
  String get doneServiceOption => 'सेवा पूरी हुई';

  @override
  String get scheduleLaterOption => 'बाद में शेड्यूल करें';

  @override
  String get customerNameLabel => 'ग्राहक का नाम';

  @override
  String get customerPhoneLabel => 'ग्राहक का फोन';

  @override
  String recordedNowDate(String date) {
    return 'अभी दर्ज किया गया — $date';
  }

  @override
  String get dateLabel => 'तारीख';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'उपलब्ध स्लॉट';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get saveBooking => 'बुकिंग सेव करें';

  @override
  String saveBookingWithTotal(String total) {
    return 'बुकिंग सेव करें · $total';
  }

  @override
  String get addServiceTitle => 'सेवा जोड़ें';

  @override
  String get serviceNameLabel => 'सेवा का नाम';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get priceLabel => 'कीमत';

  @override
  String get durationMinutesLabel => 'अवधि (मिनट)';

  @override
  String get deleteServiceButton => 'सेवा हटाएं';

  @override
  String get fillServiceFields => 'नाम, श्रेणी, कीमत और अवधि दर्ज करें';

  @override
  String get couldNotSaveService => 'सेवा सहेजी नहीं जा सकी';

  @override
  String get noServicesInCatalog => 'अभी कोई सेवा नहीं है। पहली सेवा जोड़ें।';

  @override
  String get searchServicesHint => 'सेवाएं खोजें';

  @override
  String get filterAllCategories => 'सभी';

  @override
  String get assignToStaffLabel => 'स्टाफ को असाइन करें';

  @override
  String get anyStaffOption => 'कोई भी स्टाफ';

  @override
  String get addStarterServicesButton => 'सामान्य सेवाएं जोड़ें';

  @override
  String get bookingLinkSectionTitle => 'बुकिंग लिंक';

  @override
  String get bookingLinkSectionSubtitle =>
      'यह लिंक या QR कोड शेयर करें ताकि ग्राहक ऑनलाइन बुक कर सकें';

  @override
  String get copyLinkButton => 'कॉपी करें';

  @override
  String get shareLinkButton => 'शेयर करें';

  @override
  String get linkCopied => 'लिंक कॉपी हो गया';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return '$salonName पर बुक करें: $link';
  }
}
