// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get insightsTitle => 'ఇన్‌సైట్స్';

  @override
  String get tabEarnings => 'ఆదాయం';

  @override
  String get tabRetention => 'రిటెన్షన్';

  @override
  String get periodToday => 'ఈరోజు';

  @override
  String get periodWeek => 'వారం';

  @override
  String get periodMonth => 'నెల';

  @override
  String get periodLast7Days => 'గత 7 రోజులు';

  @override
  String get periodLast30Days => 'గత 30 రోజులు';

  @override
  String get earningsLoadError => 'ఆదాయం లోడ్ కాలేదు.';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String completedServicesCount(int count) {
    return '$count సేవలు';
  }

  @override
  String get completedServicesHeading => 'పూర్తయిన సేవలు';

  @override
  String get noCompletedServices => 'ఈ వ్యవధిలో ఇంకా ఏ సేవ పూర్తి కాలేదు.';

  @override
  String get topServicesHeading => 'అగ్రశ్రేణి సేవలు';

  @override
  String get byStaffHeading => 'స్టాఫ్ వారీగా';

  @override
  String get vsYesterday => 'నిన్నటితో పోలిస్తే';

  @override
  String get vsLastWeek => 'గత వారంతో పోలిస్తే';

  @override
  String get vsLastMonth => 'గత నెలతో పోలిస్తే';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'తిరిగి వచ్చిన కస్టమర్లు';

  @override
  String reactivatedSummary(int count) {
    return 'ఈ నెల $count మంది కస్టమర్లు తిరిగి వచ్చారు';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'రిటెన్షన్ నివేదిక లోడ్ కాలేదు.';

  @override
  String get couldNotOpenWhatsapp => 'వాట్సాప్ తెరవలేకపోయాము';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'హాయ్ $name! మేము మిమ్మల్ని $salonNameలో మిస్ అవుతున్నాము. మీ తదుపరి సందర్శనను బుక్ చేసి ప్రత్యేక వెల్‌కమ్-బ్యాక్ ఆఫర్‌ను ఆస్వాదించండి. త్వరలో కలుద్దాం!';
  }

  @override
  String get customerCohortsHeading => 'కస్టమర్ గ్రూప్‌లు';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count కస్టమర్లు';
  }

  @override
  String noCohortCustomers(String label) {
    return 'ఈ వ్యవధిలో $label కస్టమర్లు లేరు.';
  }

  @override
  String get missedCustomersHeading => 'మిస్ అయిన కస్టమర్లు';

  @override
  String get missedCustomersHint =>
      'వాట్సాప్‌లో వారికి సందేశం పంపడానికి \"రిమైండ్\" నొక్కండి.';

  @override
  String get noMissedCustomers => 'ఈ నెల ఏ కస్టమర్ మిస్ కాలేదు.';

  @override
  String get cohortRegulars => 'రెగ్యులర్లు';

  @override
  String get cohortNew => 'కొత్తవారు';

  @override
  String get cohortCameBack => 'తిరిగి వచ్చారు';

  @override
  String get cohortStoppedComing => 'రావడం ఆపేశారు';

  @override
  String get customersLabel => 'కస్టమర్లు';

  @override
  String get reachOutNow => 'ఇప్పుడే సంప్రదించండి';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count రెగ్యులర్ కస్టమర్లు తగ్గుతున్నారు · $revenue ప్రమాదంలో';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× ఆలస్యం';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'సాధారణంగా ప్రతి $cadence రోజులకు · $overdue రోజులు ఆలస్యం';
  }

  @override
  String get remind => 'గుర్తుచేయండి';

  @override
  String get remindOnWhatsappTooltip => 'వాట్సాప్‌లో గుర్తుచేయండి';

  @override
  String get retentionProTitle => 'రిటెన్షన్ ఇన్‌సైట్స్ ఒక PRO ఫీచర్';

  @override
  String get retentionProBody =>
      'ఎవరు రావడం ఆపేశారో చూడండి, కొత్త వర్సెస్ తిరిగి వచ్చే కస్టమర్ నిష్పత్తి, మరియు వన్-టాప్ రిమైండర్‌లతో పోగొట్టుకున్న కస్టమర్లను తిరిగి పొందండి.';

  @override
  String get upgradeToPro => 'PROకి అప్‌గ్రేడ్ చేయండి';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits సందర్శనలు · $spend ఖర్చు';
  }

  @override
  String get createYourAccount => 'మీ ఖాతాను సృష్టించండి';

  @override
  String get basics => 'ప్రాథమిక వివరాలు';

  @override
  String get country => 'దేశం';

  @override
  String get countryHelperText =>
      'మీ కరెన్సీ, ఫోన్ ఫార్మాట్ మరియు డిఫాల్ట్ భాషను నిర్ణయిస్తుంది.';

  @override
  String get language => 'భాష';

  @override
  String get phoneNumberLabel => 'ఫోన్ నంబర్';

  @override
  String get passwordLabel => 'పాస్‌వర్డ్';

  @override
  String stepOfTotal(int step, int total) {
    return 'దశ $step / $total';
  }

  @override
  String get createAccountButton => 'ఖాతా సృష్టించండి';

  @override
  String get continueButton => 'కొనసాగించండి';

  @override
  String get enterPhoneNumber => 'ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get passwordMinLength => 'పాస్‌వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి';

  @override
  String get fillOwnerSalonAddress =>
      'యజమాని పేరు, సెలూన్ పేరు మరియు చిరునామాను నింపండి';

  @override
  String get turnOnLocationPermission =>
      'దీన్ని ఉపయోగించడానికి లొకేషన్‌ను ఆన్ చేసి యాక్సెస్‌ను అనుమతించండి';

  @override
  String get couldNotGetLocation => 'మీ లొకేషన్ పొందలేకపోయాము';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'ఈ ఫోన్ ఇప్పటికే నమోదు చేయబడింది. దయచేసి సైన్ ఇన్ చేయండి.';

  @override
  String get signupFailedCheckBackend =>
      'సైన్అప్ విఫలమైంది. సర్వర్ కనెక్షన్‌ను తనిఖీ చేయండి.';

  @override
  String get signupFailedTryAgain =>
      'సైన్అప్ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get yourSalon => 'మీ సెలూన్';

  @override
  String get salonDetailsSubtitle => 'దశ 2/3 · సెలూన్ వివరాలు';

  @override
  String get ownerNameLabel => 'యజమాని పేరు';

  @override
  String get salonNameLabel => 'సెలూన్ పేరు';

  @override
  String get salonAddressLabel => 'సెలూన్ చిరునామా';

  @override
  String get locationSet => 'లొకేషన్ సెట్ చేయబడింది';

  @override
  String get useMyCurrentLocation => 'నా ప్రస్తుత లొకేషన్‌ను ఉపయోగించండి';

  @override
  String get pickYourColor => 'మీ రంగును ఎంచుకోండి';

  @override
  String get colorPreviewHelp =>
      'ఇది యాప్ మొత్తంలో మీ సెలూన్ యాక్సెంట్ రంగు. ఖాతాలో ఎప్పుడైనా మార్చండి.';

  @override
  String get previewLabel => 'ప్రివ్యూ';

  @override
  String get newBooking => 'కొత్త బుకింగ్';

  @override
  String get colorTeal => 'టీల్';

  @override
  String get colorTerracotta => 'టెర్రకోటా';

  @override
  String get colorBlue => 'నీలం';

  @override
  String get colorViolet => 'వైలెట్';

  @override
  String get colorRose => 'గులాబీ';

  @override
  String get welcomeBack => 'మళ్లీ స్వాగతం';

  @override
  String get signInToDashboard => 'మీ సెలూన్ డాష్‌బోర్డ్‌లో సైన్ ఇన్ చేయండి';

  @override
  String get enterSalonOwnerPhone => 'సెలూన్ యజమాని ఫోన్‌ను నమోదు చేయండి';

  @override
  String get enterYourPassword => 'మీ పాస్‌వర్డ్‌ను నమోదు చేయండి';

  @override
  String get noSalonOwnerFound =>
      'ఈ ఫోన్ కోసం సెలూన్ యజమాని ఖాతా కనుగొనబడలేదు.';

  @override
  String get loginFailedCheckBackend =>
      'లాగిన్ విఫలమైంది. సర్వర్ కనెక్షన్‌ను తనిఖీ చేయండి.';

  @override
  String get loginFailedTryAgain =>
      'లాగిన్ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get hidePassword => 'పాస్‌వర్డ్‌ను దాచండి';

  @override
  String get showPassword => 'పాస్‌వర్డ్‌ను చూపించండి';

  @override
  String get signIn => 'సైన్ ఇన్ చేయండి';

  @override
  String get newHere => 'ఇక్కడ కొత్తా?';

  @override
  String get createAccount => 'ఖాతా సృష్టించండి';

  @override
  String get forgotPassword => 'పాస్‌వర్డ్ మర్చిపోయారా?';

  @override
  String get resetPasswordTitle => 'పాస్‌వర్డ్ రీసెట్ చేయండి';

  @override
  String get resetPasswordEnterPhone =>
      'మీ ఫోన్ నంబర్‌ను నమోదు చేయండి, మేము వాట్సాప్ ద్వారా 6-అంకెల కోడ్‌ను పంపుతాము.';

  @override
  String get sendCodeViaWhatsApp => 'వాట్సాప్ ద్వారా కోడ్ పంపండి';

  @override
  String get codeSentViaWhatsApp =>
      'ఆ ఖాతా ఉంటే, వాట్సాప్ ద్వారా ఒక కోడ్ పంపబడింది.';

  @override
  String get resetPasswordEnterCode =>
      'వాట్సాప్‌లో మేము పంపిన కోడ్‌ను నమోదు చేయండి, తర్వాత కొత్త పాస్‌వర్డ్‌ను ఎంచుకోండి.';

  @override
  String get otpCodeLabel => '6-అంకెల కోడ్';

  @override
  String get resetPasswordButton => 'పాస్‌వర్డ్ రీసెట్ చేయండి';

  @override
  String get resendCode => 'కోడ్‌ను మళ్లీ పంపండి';

  @override
  String get changePhoneNumber => 'ఫోన్ నంబర్‌ను మార్చండి';

  @override
  String get enterSixDigitCode => '6-అంకెల కోడ్‌ను నమోదు చేయండి';

  @override
  String get passwordsDoNotMatch => 'పాస్‌వర్డ్‌లు సరిపోలలేదు';

  @override
  String get passwordResetSuccess =>
      'పాస్‌వర్డ్ రీసెట్ చేయబడింది. దయచేసి కొత్త పాస్‌వర్డ్‌తో సైన్ ఇన్ చేయండి.';

  @override
  String get waitBeforeRetryingCode =>
      'మరొక కోడ్‌ను అభ్యర్థించే ముందు ఒక నిమిషం వేచి ఉండండి';

  @override
  String get invalidOrExpiredCode => 'ఆ కోడ్ చెల్లదు లేదా గడువు ముగిసింది';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'చాలా ప్రయత్నాలు — కొత్త కోడ్‌ను అభ్యర్థించండి';

  @override
  String get continueWithGoogle => 'Google తో కొనసాగించండి';

  @override
  String get signedInWithGoogle => 'Google తో సైన్ ఇన్ చేయబడింది';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google తో $email గా సైన్ ఇన్ చేయబడింది';
  }

  @override
  String get usePasswordInstead => 'బదులుగా పాస్‌వర్డ్‌ను ఉపయోగించండి';

  @override
  String get googleSignInNotConfigured =>
      'Google సైన్-ఇన్ ఇంకా సెటప్ చేయబడలేదు';

  @override
  String get googleSignInFailed =>
      'Google సైన్-ఇన్ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get googleNoAccountFound =>
      'ఆ Google ఖాతా కోసం ఖాతా కనుగొనబడలేదు. ముందుగా ఒకటి సృష్టించండి.';

  @override
  String get linkGoogleAccount => 'Google ఖాతాను లింక్ చేయండి';

  @override
  String get googleAccountLinked =>
      'Google ఖాతా లింక్ చేయబడింది — ఇప్పుడు మీరు దానితో సైన్ ఇన్ చేయవచ్చు';

  @override
  String get addStaffBeforeBookings =>
      'బుకింగ్‌లు సృష్టించే ముందు యాక్టివ్ స్టాఫ్‌ను జోడించండి';

  @override
  String get salonLabel => 'సెలూన్';

  @override
  String get statToday => 'ఈరోజు';

  @override
  String get statRepeat => 'రిపీట్';

  @override
  String get statLoggedHelper => 'నమోదు చేయబడింది';

  @override
  String get statBackHelper => 'తిరిగి వచ్చారు';

  @override
  String get statWeek => 'వారం';

  @override
  String get statMonth => 'నెల';

  @override
  String get loggedTodayHeading => 'ఈరోజు నమోదైనవి';

  @override
  String get nothingLoggedToday =>
      'ఈరోజు ఇంకా ఏమీ నమోదు కాలేదు. సేవ పూర్తయిన తర్వాత \"కొత్త బుకింగ్\" నొక్కండి.';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navBookings => 'బుకింగ్‌లు';

  @override
  String get navStaff => 'స్టాఫ్';

  @override
  String get navInsights => 'ఇన్‌సైట్స్';

  @override
  String get navAccount => 'ఖాతా';

  @override
  String get salonAdminTitle => 'సెలూన్ అడ్మిన్';

  @override
  String get noSalonLinked => 'ఈ యజమాని ఖాతాకు ఇంకా ఏ సెలూన్ లింక్ కాలేదు.';

  @override
  String get bookingsTitle => 'బుకింగ్‌లు';

  @override
  String get searchCustomerOrService => 'కస్టమర్ లేదా సేవను వెతకండి';

  @override
  String get filterThisWeek => 'ఈ వారం';

  @override
  String get filterAllTime => 'అన్ని సమయాలు';

  @override
  String get filterAllStaff => 'అందరు స్టాఫ్';

  @override
  String get staffLabel => 'స్టాఫ్';

  @override
  String get needsActionHeading => 'చర్య అవసరం';

  @override
  String get statTotal => 'మొత్తం';

  @override
  String get statServices => 'సేవలు';

  @override
  String get statAvgTicket => 'సగటు బిల్లు';

  @override
  String get noBookingsMatchFilter => 'ఈ ఫిల్టర్‌తో సరిపోలే బుకింగ్‌లు లేవు';

  @override
  String get today => 'ఈరోజు';

  @override
  String get yesterday => 'నిన్న';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count సేవలు';
  }

  @override
  String get couldNotOpenStore => 'స్టోర్ తెరవలేకపోయాము';

  @override
  String get updateRequired => 'అప్‌డేట్ అవసరం';

  @override
  String get updateRequiredBody =>
      'యాప్ యొక్క కొత్త వెర్షన్ అందుబాటులో ఉంది. మీ సెలూన్ డాష్‌బోర్డ్‌ను ఉపయోగించడం కొనసాగించడానికి దయచేసి అప్‌డేట్ చేయండి.';

  @override
  String get updateNow => 'ఇప్పుడే అప్‌డేట్ చేయండి';

  @override
  String get themeColorTitle => 'థీమ్ రంగు';

  @override
  String get save => 'సేవ్ చేయండి';

  @override
  String get staffTitle => 'స్టాఫ్';

  @override
  String get addStaff => 'స్టాఫ్‌ను జోడించండి';

  @override
  String get statActive => 'యాక్టివ్';

  @override
  String get statTodaysTotal => 'ఈరోజు మొత్తం';

  @override
  String get noActiveStaffYet => 'ఇంకా యాక్టివ్ స్టాఫ్ లేరు';

  @override
  String get addFirstStaff => 'మొదటి స్టాఫ్‌ను జోడించండి';

  @override
  String get noServicesYet => 'ఇంకా సేవలు లేవు';

  @override
  String get notActive => 'యాక్టివ్‌గా లేరు';

  @override
  String get canSetOwnPrice => 'వారి స్వంత ధరను సెట్ చేయగలరు';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count సేవలు · $revenue';
  }

  @override
  String get newLabel => 'కొత్త';

  @override
  String get serviceLabel => 'సేవ';

  @override
  String get customerLabel => 'కస్టమర్';

  @override
  String get repeatLabel => 'రిపీట్';

  @override
  String get couldNotUpdateBooking =>
      'బుకింగ్‌ను అప్‌డేట్ చేయలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get couldNotAcceptReschedule =>
      'రీషెడ్యూల్‌ను అంగీకరించలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get couldNotRejectReschedule =>
      'రీషెడ్యూల్‌ను తిరస్కరించలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get rescheduleLabel => 'రీషెడ్యూల్';

  @override
  String get pendingLabel => 'పెండింగ్';

  @override
  String get scheduledLabel => 'షెడ్యూల్ చేయబడింది';

  @override
  String get inProgressLabel => 'జరుగుతోంది';

  @override
  String get startBookingButton => 'ప్రారంభించు';

  @override
  String get doneBookingButton => 'పూర్తయింది';

  @override
  String get todayScheduleHeading => 'ఈరోజు షెడ్యూల్';

  @override
  String get paymentMethodLabel => 'చెల్లింపు';

  @override
  String get paymentMethodCash => 'నగదు';

  @override
  String get paymentMethodCard => 'కార్డు';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'మళ్లీ బుక్ చేయండి';

  @override
  String get couldNotLoadCustomerProfile => 'కస్టమర్ ప్రొఫైల్ లోడ్ కాలేదు';

  @override
  String get notesSaved => 'నోట్స్ సేవ్ చేయబడ్డాయి';

  @override
  String get couldNotSaveNotes =>
      'నోట్స్ సేవ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get statsVisitsLabel => 'సందర్శనలు';

  @override
  String get statsTotalSpentLabel => 'మొత్తం ఖర్చు';

  @override
  String lastServiceSummary(String service, String date) {
    return 'చివరిది: $service, $date';
  }

  @override
  String get notesLabel => 'నోట్స్';

  @override
  String get notesHint => 'ఇష్టాలు, అలర్జీలు, గుర్తుంచుకోవలసినవి ఏవైనా';

  @override
  String get tagsLabel => 'ట్యాగ్‌లు';

  @override
  String get addTagHint => 'ట్యాగ్ జోడించండి';

  @override
  String get saveNotesButton => 'నోట్స్ సేవ్ చేయండి';

  @override
  String get visitHistoryHeading => 'సందర్శన చరిత్ర';

  @override
  String get noVisitsYet => 'ఇంకా సందర్శనలు లేవు';

  @override
  String get viewProfileTooltip => 'ప్రొఫైల్ చూడండి';

  @override
  String get dailyRevenueGoalLabel => 'రోజువారీ ఆదాయ లక్ష్యం';

  @override
  String get dailyRevenueGoalHint =>
      'ఐచ్ఛికం — హోమ్‌లో ప్రోగ్రెస్ బార్‌ను దాచడానికి ఖాళీగా ఉంచండి';

  @override
  String get payoutsTooltip => 'చెల్లింపులు';

  @override
  String get staffActiveLabel => 'యాక్టివ్';

  @override
  String get canCancelBookingLabel => 'బుకింగ్‌లను రద్దు చేయగలరు';

  @override
  String get couldNotLoadPayouts => 'చెల్లింపులను లోడ్ చేయలేకపోయాము';

  @override
  String get payoutSettled => 'చెల్లింపు నమోదు చేయబడింది';

  @override
  String get couldNotMarkPaid =>
      'చెల్లించినట్లు గుర్తించలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get payoutsTitle => 'ఆదాయాలు & చెల్లింపులు';

  @override
  String get unpaidLabel => 'చెల్లించనిది';

  @override
  String get markAsPaidButton => 'చెల్లించినట్లు గుర్తించండి';

  @override
  String get grossRevenueLabel => 'ఆదాయం';

  @override
  String get totalPayoutLabel => 'చెల్లింపు';

  @override
  String get payoutHistoryHeading => 'చెల్లింపు చరిత్ర';

  @override
  String get noPayoutsYet => 'ఇంకా చెల్లింపులు లేవు';

  @override
  String get payTypeLabel => 'వేతన రకం';

  @override
  String get payTypeCommission => 'కమీషన్';

  @override
  String get payTypeSalary => 'జీతం';

  @override
  String get payTypeBoth => 'రెండూ';

  @override
  String get commissionRateLabel => 'కమీషన్ %';

  @override
  String get monthlySalaryLabel => 'నెలవారీ జీతం';

  @override
  String get couldNotSavePayType =>
      'వేతన సెట్టింగ్‌లను సేవ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get salaryThisMonthLabel => 'ఈ నెల జీతం';

  @override
  String get salaryPaidStatus => 'చెల్లించబడింది';

  @override
  String get paySalaryButton => 'జీతం చెల్లించండి';

  @override
  String get salaryPaid => 'జీతం చెల్లించబడింది';

  @override
  String get couldNotPaySalary =>
      'జీతం చెల్లించలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get searchStaffHint => 'సిబ్బందిని వెతకండి';

  @override
  String get filterActiveStaff => 'యాక్టివ్';

  @override
  String get filterInactiveStaff => 'ఇనాక్టివ్';

  @override
  String get switchBranchTitle => 'బ్రాంచ్ మార్చండి';

  @override
  String get switchLabel => 'బ్రాంచ్ మార్చండి';

  @override
  String get allBranchesLabel => 'అన్ని బ్రాంచ్‌లు';

  @override
  String get allBranchesSubtitle => 'అన్ని బ్రాంచ్‌ల కలిపిన మొత్తాలు';

  @override
  String get pickBranchFirst => 'ముందుగా ఒక నిర్దిష్ట బ్రాంచ్‌ని ఎంచుకోండి';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count నమోదు · $revenue · $staff సిబ్బంది';
  }

  @override
  String get dayOffLabel => 'సెలవు';

  @override
  String get addBranchButton => 'బ్రాంచ్ జోడించండి';

  @override
  String get addBranchTitle => 'ఒక బ్రాంచ్‌ని జోడించండి';

  @override
  String get branchNameAddressRequired => 'బ్రాంచ్ పేరు మరియు చిరునామా అవసరం';

  @override
  String get couldNotAddBranch =>
      'బ్రాంచ్‌ని జోడించలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get fillProductFields =>
      'దయచేసి అన్ని ఉత్పత్తి ఫీల్డ్‌లను సరిగ్గా పూరించండి';

  @override
  String get couldNotSaveProduct =>
      'ఉత్పత్తిని సేవ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get editProductTitle => 'ఉత్పత్తిని సవరించండి';

  @override
  String get addProductTitle => 'ఉత్పత్తిని జోడించండి';

  @override
  String get productNameLabel => 'ఉత్పత్తి పేరు';

  @override
  String get skuLabel => 'SKU (ఐచ్ఛికం)';

  @override
  String get stockQtyLabel => 'స్టాక్';

  @override
  String get lowStockThresholdLabel => 'తక్కువ స్టాక్ పరిమితి';

  @override
  String get deleteProductButton => 'ఉత్పత్తిని తొలగించండి';

  @override
  String get productsTitle => 'ఉత్పత్తులు';

  @override
  String get searchProductsHint => 'ఉత్పత్తులను వెతకండి';

  @override
  String get filterLowStock => 'తక్కువ స్టాక్';

  @override
  String get noLowStockProducts => 'ఏ ఉత్పత్తి తక్కువ స్టాక్‌లో లేదు';

  @override
  String get noProductsInCatalog => 'ఇంకా ఉత్పత్తులు లేవు';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count స్టాక్‌లో ఉన్నాయి',
      one: '1 స్టాక్‌లో ఉంది',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'తక్కువ స్టాక్';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ఉత్పత్తులు తక్కువ స్టాక్‌లో ఉన్నాయి',
      one: '1 ఉత్పత్తి తక్కువ స్టాక్‌లో ఉంది',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'ఈరోజు';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count అపాయింట్‌మెంట్‌లు నమోదయ్యాయి',
      one: '1 అపాయింట్‌మెంట్ నమోదైంది',
      zero: 'ఇంకా అపాయింట్‌మెంట్‌లు నమోదు కాలేదు',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$goal లక్ష్యంలో $current';
  }

  @override
  String get worthReachingOutHeading => 'ఈరోజు సంప్రదించదగినవారు';

  @override
  String get exportCsvTooltip => 'CSV ఎగుమతి చేయండి';

  @override
  String get couldNotExportEarnings =>
      'ఆదాయాలను ఎగుమతి చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days రోజులు ఆలస్యం',
      one: '1 రోజు ఆలస్యం',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylistతో';
  }

  @override
  String customerRequestedTime(String time) {
    return 'కస్టమర్ $time అభ్యర్థించారు';
  }

  @override
  String get reject => 'తిరస్కరించండి';

  @override
  String get accept => 'అంగీకరించండి';

  @override
  String get confirm => 'నిర్ధారించండి';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + మరో $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'ఖాతా వివరాలు లోడ్ కాలేదు';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'యజమాని, ఫోన్, సెలూన్ పేరు మరియు చిరునామాను నింపండి';

  @override
  String get accountUpdated => 'ఖాతా అప్‌డేట్ చేయబడింది';

  @override
  String get phoneOrEmailUsed => 'ఫోన్ లేదా ఇమెయిల్ ఇప్పటికే ఉపయోగంలో ఉంది';

  @override
  String get couldNotSaveAccount => 'ఖాతా వివరాలు సేవ్ కాలేదు';

  @override
  String get newPasswordMinLength => 'కొత్త పాస్‌వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి';

  @override
  String get newPasswordsDontMatch => 'కొత్త పాస్‌వర్డ్‌లు సరిపోలడం లేదు';

  @override
  String get passwordChanged => 'పాస్‌వర్డ్ మార్చబడింది';

  @override
  String get currentPasswordIncorrect => 'ప్రస్తుత పాస్‌వర్డ్ తప్పు';

  @override
  String get couldNotChangePassword => 'పాస్‌వర్డ్ మార్చలేకపోయాము';

  @override
  String get countryAndCurrency => 'దేశం మరియు కరెన్సీ';

  @override
  String get accountTitle => 'ఖాతా';

  @override
  String ownerSinceDate(String date) {
    return '$date నుండి యజమాని';
  }

  @override
  String planLabel(String plan) {
    return '$plan ప్లాన్';
  }

  @override
  String get retentionFreeFor6Months => '6 నెలలు రిటెన్షన్ ఇన్‌సైట్స్ ఉచితం';

  @override
  String get upgrade => 'అప్‌గ్రేడ్ చేయండి';

  @override
  String get appearance => 'రూపం';

  @override
  String get salonProfile => 'సెలూన్ ప్రొఫైల్';

  @override
  String get emailLabel => 'ఇమెయిల్';

  @override
  String get locationUpdated => 'లొకేషన్ అప్‌డేట్ చేయబడింది';

  @override
  String get saveDetailsButton => 'వివరాలను సేవ్ చేయండి';

  @override
  String get savingEllipsis => 'సేవ్ చేస్తోంది...';

  @override
  String get security => 'భద్రత';

  @override
  String get currentPasswordLabel => 'ప్రస్తుత పాస్‌వర్డ్';

  @override
  String get newPasswordLabel => 'కొత్త పాస్‌వర్డ్';

  @override
  String get confirmNewPasswordLabel => 'కొత్త పాస్‌వర్డ్‌ను నిర్ధారించండి';

  @override
  String get changePasswordButton => 'పాస్‌వర్డ్‌ను మార్చండి';

  @override
  String get changingEllipsis => 'మారుస్తోంది...';

  @override
  String get signOut => 'సైన్ అవుట్ చేయండి';

  @override
  String get enterServiceNamePrice => 'సేవ పేరు మరియు ధరను నమోదు చేయండి';

  @override
  String get fillStaffNamePhone => 'స్టాఫ్ పేరు మరియు ఫోన్‌ను నింపండి';

  @override
  String get addAtLeastOneService => 'కనీసం ఒక సేవను జోడించండి';

  @override
  String get enterValidOpenCloseTimes =>
      'సరైన ఓపెన్ మరియు క్లోజ్ సమయాలను నమోదు చేయండి (HH:MM, 24-గంటలు)';

  @override
  String get selectAtLeastOneWorkingDay => 'కనీసం ఒక పని దినాన్ని ఎంచుకోండి';

  @override
  String get staffPhoneInUse => 'ఆ స్టాఫ్ ఫోన్ ఇప్పటికే ఉపయోగంలో ఉంది';

  @override
  String get couldNotAddStaff =>
      'స్టాఫ్‌ను జోడించలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get addStaffSubtitle =>
      'వారి ప్రొఫైల్, సేవలు మరియు పని దినాలను సెటప్ చేయండి.';

  @override
  String get staffNameLabel => 'స్టాఫ్ పేరు';

  @override
  String get staffPhoneLabel => 'స్టాఫ్ ఫోన్';

  @override
  String get servicesLabel => 'సేవలు';

  @override
  String servicesAddedCount(int count) {
    return '$count జోడించబడ్డాయి';
  }

  @override
  String get workingHours => 'పని గంటలు';

  @override
  String get opens => 'తెరుచుకుంటుంది';

  @override
  String get closes => 'మూసుకుంటుంది';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'పని దినాలు';

  @override
  String get serviceNameHint => 'సేవ పేరు';

  @override
  String get priceHint => 'ధర';

  @override
  String get dayMon => 'సోమ';

  @override
  String get dayTue => 'మంగళ';

  @override
  String get dayWed => 'బుధ';

  @override
  String get dayThu => 'గురు';

  @override
  String get dayFri => 'శుక్ర';

  @override
  String get daySat => 'శని';

  @override
  String get daySun => 'ఆది';

  @override
  String get enterValidStaffNamePhone =>
      'సరైన స్టాఫ్ పేరు మరియు ఫోన్‌ను నమోదు చేయండి';

  @override
  String get staffDetailsSaved => 'స్టాఫ్ వివరాలు సేవ్ చేయబడ్డాయి';

  @override
  String get phoneAlreadyInUse => 'ఆ ఫోన్ ఇప్పటికే ఉపయోగంలో ఉంది';

  @override
  String get couldNotUpdateStaff => 'స్టాఫ్‌ను అప్‌డేట్ చేయలేకపోయాము';

  @override
  String get enterServiceNameAndPriceShort =>
      'సేవ పేరు మరియు ధరను నమోదు చేయండి';

  @override
  String get couldNotAddService => 'సేవను జోడించలేకపోయాము';

  @override
  String get editServiceTitle => 'సేవను సవరించండి';

  @override
  String get enterValidServiceNamePrice =>
      'సరైన సేవ పేరు మరియు ధరను నమోదు చేయండి';

  @override
  String get couldNotUpdateService => 'సేవను అప్‌డేట్ చేయలేకపోయాము';

  @override
  String get saveServiceButton => 'సేవను సేవ్ చేయండి';

  @override
  String get couldNotRemoveServiceDefault => 'సేవను తీసివేయలేకపోయాము';

  @override
  String get useHHmmWorkingHours => 'పని గంటల కోసం HH:mm ఉపయోగించండి';

  @override
  String get hoursAdded => 'గంటలు జోడించబడ్డాయి';

  @override
  String get couldNotAddWorkingHours => 'పని గంటలను జోడించలేకపోయాము';

  @override
  String get couldNotRemoveTiming => 'సమయాన్ని తీసివేయలేకపోయాము';

  @override
  String get manageStaffTitle => 'స్టాఫ్‌ను నిర్వహించండి';

  @override
  String get done => 'పూర్తయింది';

  @override
  String get manageStaffSubtitle =>
      'సేవలు మరియు గంటలను జోడించండి, సవరించండి లేదా తీసివేయండి, తర్వాత పూర్తయింది నొక్కండి.';

  @override
  String get saveStaffButton => 'స్టాఫ్‌ను సేవ్ చేయండి';

  @override
  String get edit => 'సవరించండి';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get newServiceLabel => 'కొత్త సేవ';

  @override
  String get addingEllipsis => 'జోడిస్తోంది...';

  @override
  String get addServiceButton => 'సేవను జోడించండి';

  @override
  String get noTimingsYet => 'ఇంకా సమయాలు లేవు';

  @override
  String get removeLabel => 'తీసివేయండి';

  @override
  String get startLabel => 'ప్రారంభం';

  @override
  String get endLabel => 'ముగింపు';

  @override
  String get addMonSatHoursButton => 'సోమ-శని గంటలను జోడించండి';

  @override
  String get saveHoursButton => 'సమయాలను సేవ్ చేయండి';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'స్టాఫ్, సేవ మరియు తేదీని ఎంచుకోండి';

  @override
  String get noSlotsForDate => 'ఈ తేదీకి అందుబాటులో ఉన్న స్లాట్‌లు లేవు.';

  @override
  String get couldNotLoadSlots => 'స్లాట్‌లు లోడ్ కాలేదు';

  @override
  String get enterCustomerName => 'కస్టమర్ పేరును నమోదు చేయండి';

  @override
  String get chooseStaffAndService => 'స్టాఫ్ మరియు కనీసం ఒక సేవను ఎంచుకోండి';

  @override
  String get enterCustomerPhone => 'కస్టమర్ ఫోన్‌ను నమోదు చేయండి';

  @override
  String get chooseAvailableSlot => 'అందుబాటులో ఉన్న స్లాట్‌ను ఎంచుకోండి';

  @override
  String get couldNotCreateBooking =>
      'బుకింగ్‌ను సృష్టించలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get doneServiceOption => 'సేవ పూర్తయింది';

  @override
  String get scheduleLaterOption => 'తర్వాత షెడ్యూల్ చేయండి';

  @override
  String get customerNameLabel => 'కస్టమర్ పేరు';

  @override
  String get customerPhoneLabel => 'కస్టమర్ ఫోన్';

  @override
  String recordedNowDate(String date) {
    return 'ఇప్పుడే నమోదు చేయబడింది — $date';
  }

  @override
  String get dateLabel => 'తేదీ';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'అందుబాటులో ఉన్న స్లాట్‌లు';

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get saveBooking => 'బుకింగ్‌ను సేవ్ చేయండి';

  @override
  String saveBookingWithTotal(String total) {
    return 'బుకింగ్‌ను సేవ్ చేయండి · $total';
  }

  @override
  String get addServiceTitle => 'సేవను జోడించండి';

  @override
  String get serviceNameLabel => 'సేవ పేరు';

  @override
  String get categoryLabel => 'వర్గం';

  @override
  String get priceLabel => 'ధర';

  @override
  String get durationMinutesLabel => 'వ్యవధి (నిమిషాలు)';

  @override
  String get deleteServiceButton => 'సేవను తొలగించండి';

  @override
  String get fillServiceFields => 'పేరు, వర్గం, ధర మరియు వ్యవధిని నమోదు చేయండి';

  @override
  String get couldNotSaveService => 'సేవను సేవ్ చేయలేకపోయాము';

  @override
  String get noServicesInCatalog =>
      'ఇంకా సేవలు లేవు. మీ మొదటిదాన్ని జోడించండి.';

  @override
  String get searchServicesHint => 'సేవలను వెతకండి';

  @override
  String get filterAllCategories => 'అన్నీ';

  @override
  String get assignToStaffLabel => 'సిబ్బందికి కేటాయించండి';

  @override
  String get anyStaffOption => 'ఏ సిబ్బంది అయినా';

  @override
  String get addStarterServicesButton => 'సాధారణ సేవలను జోడించండి';

  @override
  String get bookingLinkSectionTitle => 'బుకింగ్ లింక్';

  @override
  String get bookingLinkSectionSubtitle =>
      'కస్టమర్లు ఆన్‌లైన్‌లో బుక్ చేసుకోవడానికి ఈ లింక్ లేదా QR కోడ్‌ను షేర్ చేయండి';

  @override
  String get copyLinkButton => 'కాపీ చేయండి';

  @override
  String get shareLinkButton => 'షేర్ చేయండి';

  @override
  String get linkCopied => 'లింక్ కాపీ అయ్యింది';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return '$salonName వద్ద బుక్ చేయండి: $link';
  }
}
