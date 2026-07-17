// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get insightsTitle => 'ইনসাইটস';

  @override
  String get tabEarnings => 'আয়';

  @override
  String get tabRetention => 'রিটেনশন';

  @override
  String get periodToday => 'আজ';

  @override
  String get periodWeek => 'সপ্তাহ';

  @override
  String get periodMonth => 'মাস';

  @override
  String get periodLast7Days => 'গত ৭ দিন';

  @override
  String get periodLast30Days => 'গত ৩০ দিন';

  @override
  String get earningsLoadError => 'আয় লোড করা যায়নি।';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সেবা',
      one: '$countটি সেবা',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'সম্পন্ন সেবা';

  @override
  String get noCompletedServices => 'এই সময়ে এখনও কোনো সেবা সম্পন্ন হয়নি।';

  @override
  String get topServicesHeading => 'শীর্ষ সেবা';

  @override
  String get byStaffHeading => 'স্টাফ অনুযায়ী';

  @override
  String get vsYesterday => 'গতকালের তুলনায়';

  @override
  String get vsLastWeek => 'গত সপ্তাহের তুলনায়';

  @override
  String get vsLastMonth => 'গত মাসের তুলনায়';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'ফিরে আসা গ্রাহক';

  @override
  String reactivatedSummary(int count) {
    return 'এই মাসে $count জন গ্রাহক ফিরে এসেছেন';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'রিটেনশন রিপোর্ট লোড করা যায়নি।';

  @override
  String get couldNotOpenWhatsapp => 'হোয়াটসঅ্যাপ খোলা যায়নি';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'হ্যালো $name! আমরা $salonName-এ আপনাকে মিস করছি। আপনার পরবর্তী ভিজিট বুক করুন এবং বিশেষ ওয়েলকাম-ব্যাক অফার উপভোগ করুন। শীঘ্রই দেখা হবে!';
  }

  @override
  String get customerCohortsHeading => 'গ্রাহক গোষ্ঠী';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count জন গ্রাহক';
  }

  @override
  String noCohortCustomers(String label) {
    return 'এই সময়ে কোনো $label গ্রাহক নেই।';
  }

  @override
  String get missedCustomersHeading => 'মিস করা গ্রাহক';

  @override
  String get missedCustomersHint =>
      'হোয়াটসঅ্যাপে বার্তা পাঠাতে \"রিমাইন্ড\" ট্যাপ করুন।';

  @override
  String get noMissedCustomers => 'এই মাসে কোনো গ্রাহক মিস হয়নি।';

  @override
  String get cohortRegulars => 'নিয়মিত';

  @override
  String get cohortNew => 'নতুন';

  @override
  String get cohortCameBack => 'ফিরে এসেছেন';

  @override
  String get cohortStoppedComing => 'আসা বন্ধ করেছেন';

  @override
  String get customersLabel => 'গ্রাহক';

  @override
  String get reachOutNow => 'এখনই যোগাযোগ করুন';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count জন নিয়মিত গ্রাহক কমে যাচ্ছেন · $revenue ঝুঁকিতে';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× বিলম্বিত';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'সাধারণত প্রতি $cadenceদিন · $overdueদিন বিলম্বিত';
  }

  @override
  String get remind => 'রিমাইন্ড করুন';

  @override
  String get remindOnWhatsappTooltip => 'হোয়াটসঅ্যাপে রিমাইন্ড করুন';

  @override
  String get retentionProTitle => 'রিটেনশন ইনসাইটস একটি PRO ফিচার';

  @override
  String get retentionProBody =>
      'কারা আসা বন্ধ করেছেন, নতুন বনাম ফিরে আসা গ্রাহকের অনুপাত দেখুন, এবং এক-ট্যাপ রিমাইন্ডার দিয়ে হারানো গ্রাহকদের ফিরিয়ে আনুন।';

  @override
  String get upgradeToPro => 'PRO-তে আপগ্রেড করুন';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visitsটি ভিজিট · $spend খরচ';
  }

  @override
  String get createYourAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get basics => 'মৌলিক তথ্য';

  @override
  String get country => 'দেশ';

  @override
  String get countryHelperText =>
      'আপনার মুদ্রা, ফোন ফরম্যাট এবং ডিফল্ট ভাষা নির্ধারণ করে।';

  @override
  String get language => 'ভাষা';

  @override
  String get phoneNumberLabel => 'ফোন নম্বর';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String stepOfTotal(int step, int total) {
    return 'ধাপ $step/$total';
  }

  @override
  String get createAccountButton => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get continueButton => 'চালিয়ে যান';

  @override
  String get enterPhoneNumber => 'একটি ফোন নম্বর লিখুন';

  @override
  String get passwordMinLength => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';

  @override
  String get fillOwnerSalonAddress =>
      'মালিকের নাম, সেলুনের নাম এবং ঠিকানা পূরণ করুন';

  @override
  String get turnOnLocationPermission =>
      'এটি ব্যবহার করতে লোকেশন চালু করুন এবং অনুমতি দিন';

  @override
  String get couldNotGetLocation => 'আপনার লোকেশন পাওয়া যায়নি';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'এই ফোন নম্বরটি ইতিমধ্যে নিবন্ধিত। অনুগ্রহ করে সাইন ইন করুন।';

  @override
  String get signupFailedCheckBackend =>
      'সাইনআপ ব্যর্থ হয়েছে। ব্যাকএন্ড সংযোগ পরীক্ষা করুন।';

  @override
  String get signupFailedTryAgain => 'সাইনআপ ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get yourSalon => 'আপনার সেলুন';

  @override
  String get salonDetailsSubtitle => 'ধাপ ২/৩ · সেলুনের বিবরণ';

  @override
  String get ownerNameLabel => 'মালিকের নাম';

  @override
  String get salonNameLabel => 'সেলুনের নাম';

  @override
  String get salonAddressLabel => 'সেলুনের ঠিকানা';

  @override
  String get locationSet => 'লোকেশন সেট হয়েছে';

  @override
  String get useMyCurrentLocation => 'আমার বর্তমান লোকেশন ব্যবহার করুন';

  @override
  String get pickYourColor => 'আপনার রঙ বেছে নিন';

  @override
  String get colorPreviewHelp =>
      'এটি পুরো অ্যাপ জুড়ে আপনার সেলুনের অ্যাকসেন্ট রঙ। যেকোনো সময় অ্যাকাউন্টে পরিবর্তন করুন।';

  @override
  String get previewLabel => 'প্রিভিউ';

  @override
  String get newBooking => 'নতুন বুকিং';

  @override
  String get colorTeal => 'টিল';

  @override
  String get colorTerracotta => 'টেরাকোটা';

  @override
  String get colorBlue => 'নীল';

  @override
  String get colorViolet => 'বেগুনি';

  @override
  String get colorRose => 'গোলাপি';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get signInToDashboard => 'আপনার সেলুন ড্যাশবোর্ডে সাইন ইন করুন';

  @override
  String get enterSalonOwnerPhone => 'সেলুন মালিকের ফোন নম্বর লিখুন';

  @override
  String get enterYourPassword => 'আপনার পাসওয়ার্ড লিখুন';

  @override
  String get noSalonOwnerFound =>
      'এই ফোনের জন্য কোনো সেলুন মালিকের অ্যাকাউন্ট পাওয়া যায়নি।';

  @override
  String get loginFailedCheckBackend =>
      'লগইন ব্যর্থ হয়েছে। ব্যাকএন্ড সংযোগ পরীক্ষা করুন।';

  @override
  String get loginFailedTryAgain => 'লগইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get hidePassword => 'পাসওয়ার্ড লুকান';

  @override
  String get showPassword => 'পাসওয়ার্ড দেখান';

  @override
  String get signIn => 'সাইন ইন করুন';

  @override
  String get newHere => 'নতুন এখানে?';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get resetPasswordTitle => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get resetPasswordEnterPhone =>
      'আপনার ফোন নম্বর দিন, আমরা হোয়াটসঅ্যাপে ৬-সংখ্যার কোড পাঠাব।';

  @override
  String get sendCodeViaWhatsApp => 'হোয়াটসঅ্যাপে কোড পাঠান';

  @override
  String get codeSentViaWhatsApp =>
      'সেই অ্যাকাউন্ট থাকলে, হোয়াটসঅ্যাপে একটি কোড পাঠানো হয়েছে।';

  @override
  String get resetPasswordEnterCode =>
      'হোয়াটসঅ্যাপে পাঠানো কোডটি দিন, তারপর নতুন পাসওয়ার্ড দিন।';

  @override
  String get otpCodeLabel => '৬-সংখ্যার কোড';

  @override
  String get resetPasswordButton => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get resendCode => 'কোড আবার পাঠান';

  @override
  String get changePhoneNumber => 'ফোন নম্বর পরিবর্তন করুন';

  @override
  String get enterSixDigitCode => '৬-সংখ্যার কোড দিন';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get passwordResetSuccess =>
      'পাসওয়ার্ড রিসেট হয়েছে। নতুন পাসওয়ার্ড দিয়ে সাইন ইন করুন।';

  @override
  String get waitBeforeRetryingCode =>
      'আরেকটি কোডের জন্য অনুরোধ করার আগে এক মিনিট অপেক্ষা করুন';

  @override
  String get invalidOrExpiredCode => 'কোডটি ভুল বা মেয়াদ শেষ হয়ে গেছে';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'অনেকবার চেষ্টা করা হয়েছে — নতুন কোডের অনুরোধ করুন';

  @override
  String get continueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get signedInWithGoogle => 'Google দিয়ে সাইন ইন করা হয়েছে';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google দিয়ে $email হিসেবে সাইন ইন করা হয়েছে';
  }

  @override
  String get usePasswordInstead => 'পরিবর্তে পাসওয়ার্ড ব্যবহার করুন';

  @override
  String get googleSignInNotConfigured =>
      'Google সাইন-ইন এখনও সেট আপ করা হয়নি';

  @override
  String get googleSignInFailed =>
      'Google সাইন-ইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get googleNoAccountFound =>
      'সেই Google অ্যাকাউন্টের জন্য কোনো অ্যাকাউন্ট পাওয়া যায়নি। প্রথমে একটি তৈরি করুন।';

  @override
  String get linkGoogleAccount => 'Google অ্যাকাউন্ট লিঙ্ক করুন';

  @override
  String get googleAccountLinked =>
      'Google অ্যাকাউন্ট লিঙ্ক করা হয়েছে — এখন আপনি এটি দিয়ে সাইন ইন করতে পারবেন';

  @override
  String get addStaffBeforeBookings =>
      'বুকিং তৈরি করার আগে সক্রিয় স্টাফ যোগ করুন';

  @override
  String get salonLabel => 'সেলুন';

  @override
  String get statToday => 'আজ';

  @override
  String get statRepeat => 'পুনরাবৃত্তি';

  @override
  String get statLoggedHelper => 'লগ করা হয়েছে';

  @override
  String get statBackHelper => 'ফিরে এসেছেন';

  @override
  String get statWeek => 'সপ্তাহ';

  @override
  String get statMonth => 'মাস';

  @override
  String get loggedTodayHeading => 'আজ লগ করা হয়েছে';

  @override
  String get nothingLoggedToday =>
      'আজ এখনও কিছু লগ করা হয়নি। সেবা সম্পন্ন হলে \"নতুন বুকিং\" ট্যাপ করুন।';

  @override
  String get navHome => 'হোম';

  @override
  String get navBookings => 'বুকিং';

  @override
  String get navStaff => 'স্টাফ';

  @override
  String get navInsights => 'ইনসাইটস';

  @override
  String get navAccount => 'অ্যাকাউন্ট';

  @override
  String get salonAdminTitle => 'সেলুন অ্যাডমিন';

  @override
  String get noSalonLinked =>
      'এই মালিকের অ্যাকাউন্টে এখনও কোনো সেলুন যুক্ত নেই।';

  @override
  String get bookingsTitle => 'বুকিং';

  @override
  String get searchCustomerOrService => 'গ্রাহক বা সেবা খুঁজুন';

  @override
  String get filterThisWeek => 'এই সপ্তাহ';

  @override
  String get filterAllTime => 'সব সময়';

  @override
  String get filterAllStaff => 'সব স্টাফ';

  @override
  String get staffLabel => 'স্টাফ';

  @override
  String get needsActionHeading => 'পদক্ষেপ প্রয়োজন';

  @override
  String get statTotal => 'মোট';

  @override
  String get statServices => 'সেবা';

  @override
  String get statAvgTicket => 'গড় বিল';

  @override
  String get noBookingsMatchFilter => 'এই ফিল্টারের সাথে কোনো বুকিং মেলে না';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সেবা',
      one: '$countটি সেবা',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'স্টোর খোলা যায়নি';

  @override
  String get updateRequired => 'আপডেট প্রয়োজন';

  @override
  String get updateRequiredBody =>
      'অ্যাপের একটি নতুন সংস্করণ উপলব্ধ। আপনার সেলুন ড্যাশবোর্ড ব্যবহার চালিয়ে যেতে অনুগ্রহ করে আপডেট করুন।';

  @override
  String get updateNow => 'এখনই আপডেট করুন';

  @override
  String get themeColorTitle => 'থিমের রঙ';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get staffTitle => 'স্টাফ';

  @override
  String get addStaff => 'স্টাফ যোগ করুন';

  @override
  String get statActive => 'সক্রিয়';

  @override
  String get statTodaysTotal => 'আজকের মোট';

  @override
  String get noActiveStaffYet => 'এখনও কোনো সক্রিয় স্টাফ নেই';

  @override
  String get addFirstStaff => 'প্রথম স্টাফ যোগ করুন';

  @override
  String get noServicesYet => 'এখনও কোনো সেবা নেই';

  @override
  String get notActive => 'সক্রিয় নয়';

  @override
  String get canSetOwnPrice => 'নিজের দাম নির্ধারণ করতে পারেন';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সেবা',
      one: '$countটি সেবা',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'নতুন';

  @override
  String get serviceLabel => 'সেবা';

  @override
  String get customerLabel => 'গ্রাহক';

  @override
  String get repeatLabel => 'পুনরাবৃত্তি';

  @override
  String get couldNotUpdateBooking =>
      'বুকিং আপডেট করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get couldNotAcceptReschedule =>
      'পুনঃনির্ধারণ গ্রহণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get couldNotRejectReschedule =>
      'পুনঃনির্ধারণ প্রত্যাখ্যান করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get rescheduleLabel => 'পুনঃনির্ধারণ';

  @override
  String get pendingLabel => 'মুলতুবি';

  @override
  String get scheduledLabel => 'নির্ধারিত';

  @override
  String get inProgressLabel => 'চলছে';

  @override
  String get startBookingButton => 'শুরু করুন';

  @override
  String get doneBookingButton => 'সম্পন্ন';

  @override
  String get todayScheduleHeading => 'আজকের সময়সূচি';

  @override
  String get paymentMethodLabel => 'পেমেন্ট';

  @override
  String get paymentMethodCash => 'নগদ';

  @override
  String get paymentMethodCard => 'কার্ড';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'আবার বুক করুন';

  @override
  String get couldNotLoadCustomerProfile => 'গ্রাহক প্রোফাইল লোড করা যায়নি';

  @override
  String get notesSaved => 'নোট সংরক্ষিত হয়েছে';

  @override
  String get couldNotSaveNotes => 'নোট সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get statsVisitsLabel => 'ভিজিট';

  @override
  String get statsTotalSpentLabel => 'মোট খরচ';

  @override
  String lastServiceSummary(String service, String date) {
    return 'সর্বশেষ: $service, $date';
  }

  @override
  String get notesLabel => 'নোট';

  @override
  String get notesHint => 'পছন্দ, অ্যালার্জি, মনে রাখার মতো যেকোনো কিছু';

  @override
  String get tagsLabel => 'ট্যাগ';

  @override
  String get addTagHint => 'ট্যাগ যোগ করুন';

  @override
  String get saveNotesButton => 'নোট সংরক্ষণ করুন';

  @override
  String get visitHistoryHeading => 'ভিজিট ইতিহাস';

  @override
  String get noVisitsYet => 'এখনও কোনো ভিজিট নেই';

  @override
  String get viewProfileTooltip => 'প্রোফাইল দেখুন';

  @override
  String get dailyRevenueGoalLabel => 'দৈনিক আয়ের লক্ষ্য';

  @override
  String get dailyRevenueGoalHint =>
      'ঐচ্ছিক — হোমে অগ্রগতি বার লুকাতে খালি রাখুন';

  @override
  String get payoutsTooltip => 'পেআউট';

  @override
  String get staffActiveLabel => 'সক্রিয়';

  @override
  String get canCancelBookingLabel => 'বুকিং বাতিল করতে পারবেন';

  @override
  String get couldNotLoadPayouts => 'পেআউট লোড করা যায়নি';

  @override
  String get payoutSettled => 'পেআউট রেকর্ড করা হয়েছে';

  @override
  String get couldNotMarkPaid =>
      'পরিশোধিত হিসেবে চিহ্নিত করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get payoutsTitle => 'আয় ও পেআউট';

  @override
  String get unpaidLabel => 'অপরিশোধিত';

  @override
  String get markAsPaidButton => 'পরিশোধিত হিসেবে চিহ্নিত করুন';

  @override
  String get grossRevenueLabel => 'আয়';

  @override
  String get totalPayoutLabel => 'পেআউট';

  @override
  String get payoutHistoryHeading => 'পেআউট ইতিহাস';

  @override
  String get noPayoutsYet => 'এখনও কোনো পেআউট নেই';

  @override
  String get payTypeLabel => 'বেতনের ধরন';

  @override
  String get payTypeCommission => 'কমিশন';

  @override
  String get payTypeSalary => 'বেতন';

  @override
  String get payTypeBoth => 'উভয়';

  @override
  String get commissionRateLabel => 'কমিশন %';

  @override
  String get monthlySalaryLabel => 'মাসিক বেতন';

  @override
  String get couldNotSavePayType =>
      'বেতন সেটিংস সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get salaryThisMonthLabel => 'এই মাসের বেতন';

  @override
  String get salaryPaidStatus => 'পরিশোধিত';

  @override
  String get paySalaryButton => 'বেতন দিন';

  @override
  String get salaryPaid => 'বেতন পরিশোধিত হয়েছে';

  @override
  String get couldNotPaySalary => 'বেতন দেওয়া যায়নি। আবার চেষ্টা করুন।';

  @override
  String get searchStaffHint => 'স্টাফ খুঁজুন';

  @override
  String get filterActiveStaff => 'সক্রিয়';

  @override
  String get filterInactiveStaff => 'নিষ্ক্রিয়';

  @override
  String get switchBranchTitle => 'শাখা পরিবর্তন করুন';

  @override
  String get switchLabel => 'শাখা পরিবর্তন করুন';

  @override
  String get allBranchesLabel => 'সব শাখা';

  @override
  String get allBranchesSubtitle => 'সব শাখার সম্মিলিত মোট';

  @override
  String get pickBranchFirst => 'প্রথমে একটি নির্দিষ্ট শাখা নির্বাচন করুন';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count লগ করা হয়েছে · $revenue · $staff স্টাফ';
  }

  @override
  String get dayOffLabel => 'ছুটি';

  @override
  String get addBranchButton => 'শাখা যোগ করুন';

  @override
  String get addBranchTitle => 'একটি শাখা যোগ করুন';

  @override
  String get branchNameAddressRequired => 'শাখার নাম ও ঠিকানা আবশ্যক';

  @override
  String get couldNotAddBranch => 'শাখা যোগ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get fillProductFields =>
      'অনুগ্রহ করে সব প্রোডাক্ট ফিল্ড সঠিকভাবে পূরণ করুন';

  @override
  String get couldNotSaveProduct =>
      'প্রোডাক্ট সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get editProductTitle => 'প্রোডাক্ট সম্পাদনা করুন';

  @override
  String get addProductTitle => 'প্রোডাক্ট যোগ করুন';

  @override
  String get productNameLabel => 'প্রোডাক্টের নাম';

  @override
  String get skuLabel => 'SKU (ঐচ্ছিক)';

  @override
  String get stockQtyLabel => 'স্টক';

  @override
  String get lowStockThresholdLabel => 'কম স্টক সীমা';

  @override
  String get deleteProductButton => 'প্রোডাক্ট মুছুন';

  @override
  String get productsTitle => 'প্রোডাক্টস';

  @override
  String get searchProductsHint => 'প্রোডাক্ট খুঁজুন';

  @override
  String get filterLowStock => 'কম স্টক';

  @override
  String get noLowStockProducts => 'কোনো প্রোডাক্ট কম স্টকে নেই';

  @override
  String get noProductsInCatalog => 'এখনও কোনো প্রোডাক্ট নেই';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি স্টকে আছে',
      one: '1টি স্টকে আছে',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'কম স্টক';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি প্রোডাক্ট কম স্টকে আছে',
      one: '1টি প্রোডাক্ট কম স্টকে আছে',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'আজ';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অ্যাপয়েন্টমেন্ট লগ করা হয়েছে',
      one: '1টি অ্যাপয়েন্টমেন্ট লগ করা হয়েছে',
      zero: 'এখনও কোনো অ্যাপয়েন্টমেন্ট লগ করা হয়নি',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$goal লক্ষ্যের মধ্যে $current';
  }

  @override
  String get worthReachingOutHeading => 'আজ যোগাযোগ করার মতো';

  @override
  String get exportCsvTooltip => 'CSV এক্সপোর্ট করুন';

  @override
  String get couldNotExportEarnings =>
      'আয় এক্সপোর্ট করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিন বিলম্বিত',
      one: '1 দিন বিলম্বিত',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist-এর সাথে';
  }

  @override
  String customerRequestedTime(String time) {
    return 'গ্রাহক $time অনুরোধ করেছেন';
  }

  @override
  String get reject => 'প্রত্যাখ্যান করুন';

  @override
  String get accept => 'গ্রহণ করুন';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + আরও $countটি';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'অ্যাকাউন্টের বিবরণ লোড করা যায়নি';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'মালিক, ফোন, সেলুনের নাম এবং ঠিকানা পূরণ করুন';

  @override
  String get accountUpdated => 'অ্যাকাউন্ট আপডেট হয়েছে';

  @override
  String get phoneOrEmailUsed => 'ফোন বা ইমেল ইতিমধ্যে ব্যবহৃত';

  @override
  String get couldNotSaveAccount => 'অ্যাকাউন্টের বিবরণ সংরক্ষণ করা যায়নি';

  @override
  String get newPasswordMinLength =>
      'নতুন পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';

  @override
  String get newPasswordsDontMatch => 'নতুন পাসওয়ার্ড মিলছে না';

  @override
  String get passwordChanged => 'পাসওয়ার্ড পরিবর্তিত হয়েছে';

  @override
  String get currentPasswordIncorrect => 'বর্তমান পাসওয়ার্ড ভুল';

  @override
  String get couldNotChangePassword => 'পাসওয়ার্ড পরিবর্তন করা যায়নি';

  @override
  String get countryAndCurrency => 'দেশ ও মুদ্রা';

  @override
  String get accountTitle => 'অ্যাকাউন্ট';

  @override
  String ownerSinceDate(String date) {
    return '$date থেকে মালিক';
  }

  @override
  String planLabel(String plan) {
    return '$plan প্ল্যান';
  }

  @override
  String get retentionFreeFor6Months =>
      '৬ মাসের জন্য রিটেনশন ইনসাইটস বিনামূল্যে';

  @override
  String get upgrade => 'আপগ্রেড করুন';

  @override
  String get appearance => 'চেহারা';

  @override
  String get salonProfile => 'সেলুন প্রোফাইল';

  @override
  String get emailLabel => 'ইমেল';

  @override
  String get locationUpdated => 'লোকেশন আপডেট হয়েছে';

  @override
  String get saveDetailsButton => 'বিবরণ সংরক্ষণ করুন';

  @override
  String get savingEllipsis => 'সংরক্ষণ হচ্ছে...';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get currentPasswordLabel => 'বর্তমান পাসওয়ার্ড';

  @override
  String get newPasswordLabel => 'নতুন পাসওয়ার্ড';

  @override
  String get confirmNewPasswordLabel => 'নতুন পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get changePasswordButton => 'পাসওয়ার্ড পরিবর্তন করুন';

  @override
  String get changingEllipsis => 'পরিবর্তন হচ্ছে...';

  @override
  String get signOut => 'সাইন আউট করুন';

  @override
  String get enterServiceNamePrice => 'সেবার নাম এবং দাম লিখুন';

  @override
  String get fillStaffNamePhone => 'স্টাফের নাম এবং ফোন পূরণ করুন';

  @override
  String get addAtLeastOneService => 'কমপক্ষে একটি সেবা যোগ করুন';

  @override
  String get enterValidOpenCloseTimes =>
      'বৈধ খোলা ও বন্ধের সময় লিখুন (HH:MM, ২৪-ঘণ্টা)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'কমপক্ষে একটি কর্মদিবস নির্বাচন করুন';

  @override
  String get staffPhoneInUse => 'সেই স্টাফের ফোন ইতিমধ্যে ব্যবহৃত';

  @override
  String get couldNotAddStaff => 'স্টাফ যোগ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get addStaffSubtitle => 'তাদের প্রোফাইল, সেবা এবং কর্মদিবস সেট করুন।';

  @override
  String get staffNameLabel => 'স্টাফের নাম';

  @override
  String get staffPhoneLabel => 'স্টাফের ফোন';

  @override
  String get servicesLabel => 'সেবা';

  @override
  String servicesAddedCount(int count) {
    return '$countটি যোগ হয়েছে';
  }

  @override
  String get workingHours => 'কাজের সময়';

  @override
  String get opens => 'খোলে';

  @override
  String get closes => 'বন্ধ হয়';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'কর্মদিবস';

  @override
  String get serviceNameHint => 'সেবার নাম';

  @override
  String get priceHint => 'দাম';

  @override
  String get dayMon => 'সোম';

  @override
  String get dayTue => 'মঙ্গল';

  @override
  String get dayWed => 'বুধ';

  @override
  String get dayThu => 'বৃহঃ';

  @override
  String get dayFri => 'শুক্র';

  @override
  String get daySat => 'শনি';

  @override
  String get daySun => 'রবি';

  @override
  String get enterValidStaffNamePhone => 'বৈধ স্টাফের নাম এবং ফোন লিখুন';

  @override
  String get staffDetailsSaved => 'স্টাফের বিবরণ সংরক্ষিত হয়েছে';

  @override
  String get phoneAlreadyInUse => 'সেই ফোন ইতিমধ্যে ব্যবহৃত';

  @override
  String get couldNotUpdateStaff => 'স্টাফ আপডেট করা যায়নি';

  @override
  String get enterServiceNameAndPriceShort => 'সেবার নাম এবং দাম লিখুন';

  @override
  String get couldNotAddService => 'সেবা যোগ করা যায়নি';

  @override
  String get editServiceTitle => 'সেবা সম্পাদনা করুন';

  @override
  String get enterValidServiceNamePrice => 'বৈধ সেবার নাম ও দাম লিখুন';

  @override
  String get couldNotUpdateService => 'সেবা আপডেট করা যায়নি';

  @override
  String get saveServiceButton => 'সেবা সংরক্ষণ করুন';

  @override
  String get couldNotRemoveServiceDefault => 'সেবা সরানো যায়নি';

  @override
  String get useHHmmWorkingHours => 'কাজের সময়ের জন্য HH:mm ব্যবহার করুন';

  @override
  String get hoursAdded => 'সময় যোগ হয়েছে';

  @override
  String get couldNotAddWorkingHours => 'কাজের সময় যোগ করা যায়নি';

  @override
  String get couldNotRemoveTiming => 'সময় সরানো যায়নি';

  @override
  String get manageStaffTitle => 'স্টাফ পরিচালনা করুন';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get manageStaffSubtitle =>
      'সেবা ও সময় যোগ, সম্পাদনা বা সরান, তারপর সম্পন্ন-এ ট্যাপ করুন।';

  @override
  String get saveStaffButton => 'স্টাফ সংরক্ষণ করুন';

  @override
  String get edit => 'সম্পাদনা করুন';

  @override
  String get delete => 'মুছুন';

  @override
  String get newServiceLabel => 'নতুন সেবা';

  @override
  String get addingEllipsis => 'যোগ করা হচ্ছে...';

  @override
  String get addServiceButton => 'সেবা যোগ করুন';

  @override
  String get noTimingsYet => 'এখনও কোনো সময় নেই';

  @override
  String get removeLabel => 'সরান';

  @override
  String get startLabel => 'শুরু';

  @override
  String get endLabel => 'শেষ';

  @override
  String get addMonSatHoursButton => 'সোম-শনি সময় যোগ করুন';

  @override
  String get saveHoursButton => 'সময় সংরক্ষণ করুন';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'স্টাফ, সেবা এবং তারিখ নির্বাচন করুন';

  @override
  String get noSlotsForDate => 'এই তারিখের জন্য কোনো স্লট উপলব্ধ নেই।';

  @override
  String get couldNotLoadSlots => 'স্লট লোড করা যায়নি';

  @override
  String get enterCustomerName => 'গ্রাহকের নাম লিখুন';

  @override
  String get chooseStaffAndService =>
      'স্টাফ এবং কমপক্ষে একটি সেবা নির্বাচন করুন';

  @override
  String get enterCustomerPhone => 'গ্রাহকের ফোন লিখুন';

  @override
  String get chooseAvailableSlot => 'একটি উপলব্ধ স্লট নির্বাচন করুন';

  @override
  String get couldNotCreateBooking =>
      'বুকিং তৈরি করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get doneServiceOption => 'সেবা সম্পন্ন';

  @override
  String get scheduleLaterOption => 'পরে সময়সূচী করুন';

  @override
  String get customerNameLabel => 'গ্রাহকের নাম';

  @override
  String get customerPhoneLabel => 'গ্রাহকের ফোন';

  @override
  String recordedNowDate(String date) {
    return 'এখন রেকর্ড করা হয়েছে — $date';
  }

  @override
  String get dateLabel => 'তারিখ';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'উপলব্ধ স্লট';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get saveBooking => 'বুকিং সংরক্ষণ করুন';

  @override
  String saveBookingWithTotal(String total) {
    return 'বুকিং সংরক্ষণ করুন · $total';
  }

  @override
  String get addServiceTitle => 'সেবা যোগ করুন';

  @override
  String get serviceNameLabel => 'সেবার নাম';

  @override
  String get categoryLabel => 'বিভাগ';

  @override
  String get priceLabel => 'মূল্য';

  @override
  String get durationMinutesLabel => 'সময়কাল (মিনিট)';

  @override
  String get deleteServiceButton => 'সেবা মুছুন';

  @override
  String get fillServiceFields => 'নাম, বিভাগ, মূল্য এবং সময়কাল লিখুন';

  @override
  String get couldNotSaveService => 'সেবা সংরক্ষণ করা যায়নি';

  @override
  String get noServicesInCatalog => 'এখনো কোনো সেবা নেই। প্রথমটি যোগ করুন।';

  @override
  String get searchServicesHint => 'সেবা অনুসন্ধান করুন';

  @override
  String get filterAllCategories => 'সব';

  @override
  String get assignToStaffLabel => 'স্টাফকে বরাদ্দ করুন';

  @override
  String get anyStaffOption => 'যেকোনো স্টাফ';

  @override
  String get addStarterServicesButton => 'সাধারণ সেবা যোগ করুন';

  @override
  String get bookingLinkSectionTitle => 'বুকিং লিঙ্ক';

  @override
  String get bookingLinkSectionSubtitle =>
      'গ্রাহকরা যেন অনলাইনে বুক করতে পারেন, তাই এই লিঙ্ক বা QR কোড শেয়ার করুন';

  @override
  String get copyLinkButton => 'কপি করুন';

  @override
  String get shareLinkButton => 'শেয়ার করুন';

  @override
  String get linkCopied => 'লিঙ্ক কপি হয়েছে';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return '$salonName-এ বুক করুন: $link';
  }
}
