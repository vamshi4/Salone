// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get insightsTitle => 'بصیرت';

  @override
  String get tabEarnings => 'آمدنی';

  @override
  String get tabRetention => 'بحالی';

  @override
  String get periodToday => 'آج';

  @override
  String get periodWeek => 'ہفتہ';

  @override
  String get periodMonth => 'مہینہ';

  @override
  String get periodLast7Days => 'پچھلے 7 دن';

  @override
  String get periodLast30Days => 'پچھلے 30 دن';

  @override
  String get earningsLoadError => 'آمدنی لوڈ نہیں ہو سکی۔';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String completedServicesCount(int count) {
    return '$count سروسز';
  }

  @override
  String get completedServicesHeading => 'مکمل شدہ سروسز';

  @override
  String get noCompletedServices =>
      'اس مدت میں ابھی تک کوئی سروس مکمل نہیں ہوئی۔';

  @override
  String get topServicesHeading => 'بہترین سروسز';

  @override
  String get byStaffHeading => 'عملے کے مطابق';

  @override
  String get vsYesterday => 'کل کے مقابلے میں';

  @override
  String get vsLastWeek => 'پچھلے ہفتے کے مقابلے میں';

  @override
  String get vsLastMonth => 'پچھلے مہینے کے مقابلے میں';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'واپس آنے والے کسٹمرز';

  @override
  String reactivatedSummary(int count) {
    return 'اس مہینے $count کسٹمرز واپس آئے';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'بحالی رپورٹ لوڈ نہیں ہو سکی۔';

  @override
  String get couldNotOpenWhatsapp => 'واٹس ایپ نہیں کھل سکا';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'ہیلو $name! ہمیں $salonName میں آپ کی کمی محسوس ہو رہی ہے۔ اپنا اگلا وزٹ بک کریں اور خصوصی خوش آمدید آفر سے لطف اٹھائیں۔ جلد ملیں گے!';
  }

  @override
  String get customerCohortsHeading => 'کسٹمر گروپس';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count کسٹمرز';
  }

  @override
  String noCohortCustomers(String label) {
    return 'اس مدت میں کوئی $label کسٹمر نہیں۔';
  }

  @override
  String get missedCustomersHeading => 'چھوٹے ہوئے کسٹمرز';

  @override
  String get missedCustomersHint =>
      'واٹس ایپ پر پیغام بھیجنے کے لیے \"یاد دلائیں\" پر ٹیپ کریں۔';

  @override
  String get noMissedCustomers => 'اس مہینے کوئی کسٹمر نہیں چھوٹا۔';

  @override
  String get cohortRegulars => 'باقاعدہ';

  @override
  String get cohortNew => 'نئے';

  @override
  String get cohortCameBack => 'واپس آئے';

  @override
  String get cohortStoppedComing => 'آنا بند کر دیا';

  @override
  String get customersLabel => 'کسٹمرز';

  @override
  String get reachOutNow => 'ابھی رابطہ کریں';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count باقاعدہ کسٹمرز کم ہو رہے ہیں · $revenue خطرے میں';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× تاخیر';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'عام طور پر ہر $cadence دن · $overdue دن تاخیر';
  }

  @override
  String get remind => 'یاد دلائیں';

  @override
  String get remindOnWhatsappTooltip => 'واٹس ایپ پر یاد دلائیں';

  @override
  String get retentionProTitle => 'بحالی بصیرت ایک PRO خصوصیت ہے';

  @override
  String get retentionProBody =>
      'دیکھیں کون آنا بند کر چکا ہے، نئے بمقابلہ واپس آنے والے کسٹمرز کا تناسب، اور ایک ٹیپ یاد دہانی کے ساتھ کھوئے ہوئے کسٹمرز واپس لائیں۔';

  @override
  String get upgradeToPro => 'PRO میں اپ گریڈ کریں';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits وزٹس · $spend خرچ';
  }

  @override
  String get createYourAccount => 'اپنا اکاؤنٹ بنائیں';

  @override
  String get basics => 'بنیادی معلومات';

  @override
  String get country => 'ملک';

  @override
  String get countryHelperText =>
      'آپ کی کرنسی، فون فارمیٹ اور ڈیفالٹ زبان طے کرتا ہے۔';

  @override
  String get language => 'زبان';

  @override
  String get phoneNumberLabel => 'فون نمبر';

  @override
  String get passwordLabel => 'پاس ورڈ';

  @override
  String stepOfTotal(int step, int total) {
    return 'مرحلہ $step از $total';
  }

  @override
  String get createAccountButton => 'اکاؤنٹ بنائیں';

  @override
  String get continueButton => 'جاری رکھیں';

  @override
  String get enterPhoneNumber => 'فون نمبر درج کریں';

  @override
  String get passwordMinLength => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get fillOwnerSalonAddress => 'مالک کا نام، سیلون کا نام اور پتہ بھریں';

  @override
  String get turnOnLocationPermission =>
      'اسے استعمال کرنے کے لیے لوکیشن آن کریں اور اجازت دیں';

  @override
  String get couldNotGetLocation => 'آپ کی لوکیشن حاصل نہیں ہو سکی';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'یہ فون پہلے سے رجسٹرڈ ہے۔ براہ کرم سائن ان کریں۔';

  @override
  String get signupFailedCheckBackend => 'سائن اپ ناکام۔ سرور کنکشن چیک کریں۔';

  @override
  String get signupFailedTryAgain => 'سائن اپ ناکام۔ دوبارہ کوشش کریں۔';

  @override
  String get yourSalon => 'آپ کا سیلون';

  @override
  String get salonDetailsSubtitle => 'مرحلہ 2 از 3 · سیلون کی تفصیلات';

  @override
  String get ownerNameLabel => 'مالک کا نام';

  @override
  String get salonNameLabel => 'سیلون کا نام';

  @override
  String get salonAddressLabel => 'سیلون کا پتہ';

  @override
  String get locationSet => 'لوکیشن سیٹ ہو گئی';

  @override
  String get useMyCurrentLocation => 'میری موجودہ لوکیشن استعمال کریں';

  @override
  String get pickYourColor => 'اپنا رنگ منتخب کریں';

  @override
  String get colorPreviewHelp =>
      'یہ پورے ایپ میں آپ کے سیلون کا اہم رنگ ہے۔ اسے کبھی بھی اکاؤنٹ میں تبدیل کریں۔';

  @override
  String get previewLabel => 'پیش منظر';

  @override
  String get newBooking => 'نئی بکنگ';

  @override
  String get colorTeal => 'فیروزی';

  @override
  String get colorTerracotta => 'ٹیراکوٹا';

  @override
  String get colorBlue => 'نیلا';

  @override
  String get colorViolet => 'بنفشی';

  @override
  String get colorRose => 'گلابی';

  @override
  String get welcomeBack => 'خوش آمدید';

  @override
  String get signInToDashboard => 'اپنے سیلون ڈیش بورڈ میں سائن ان کریں';

  @override
  String get enterSalonOwnerPhone => 'سیلون مالک کا فون نمبر درج کریں';

  @override
  String get enterYourPassword => 'اپنا پاس ورڈ درج کریں';

  @override
  String get noSalonOwnerFound =>
      'اس فون کے لیے کوئی سیلون مالک اکاؤنٹ نہیں ملا۔';

  @override
  String get loginFailedCheckBackend => 'لاگ ان ناکام۔ سرور کنکشن چیک کریں۔';

  @override
  String get loginFailedTryAgain => 'لاگ ان ناکام۔ دوبارہ کوشش کریں۔';

  @override
  String get hidePassword => 'پاس ورڈ چھپائیں';

  @override
  String get showPassword => 'پاس ورڈ دکھائیں';

  @override
  String get signIn => 'سائن ان کریں';

  @override
  String get newHere => 'یہاں نئے ہیں؟';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get resetPasswordTitle => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get resetPasswordEnterPhone =>
      'اپنا فون نمبر درج کریں، ہم واٹس ایپ کے ذریعے 6 ہندسوں کا کوڈ بھیجیں گے۔';

  @override
  String get sendCodeViaWhatsApp => 'واٹس ایپ کے ذریعے کوڈ بھیجیں';

  @override
  String get codeSentViaWhatsApp =>
      'اگر وہ اکاؤنٹ موجود ہے، تو واٹس ایپ کے ذریعے ایک کوڈ بھیجا گیا ہے۔';

  @override
  String get resetPasswordEnterCode =>
      'واٹس ایپ پر بھیجا گیا کوڈ درج کریں، پھر نیا پاس ورڈ منتخب کریں۔';

  @override
  String get otpCodeLabel => '6 ہندسوں کا کوڈ';

  @override
  String get resetPasswordButton => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String get changePhoneNumber => 'فون نمبر تبدیل کریں';

  @override
  String get enterSixDigitCode => '6 ہندسوں کا کوڈ درج کریں';

  @override
  String get passwordsDoNotMatch => 'پاس ورڈ مماثل نہیں ہیں';

  @override
  String get passwordResetSuccess =>
      'پاس ورڈ ری سیٹ ہو گیا۔ براہ کرم نئے پاس ورڈ سے سائن ان کریں۔';

  @override
  String get waitBeforeRetryingCode =>
      'دوسرا کوڈ مانگنے سے پہلے ایک منٹ انتظار کریں';

  @override
  String get invalidOrExpiredCode => 'یہ کوڈ غلط ہے یا میعاد ختم ہو چکی ہے';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'بہت زیادہ کوششیں — نیا کوڈ طلب کریں';

  @override
  String get continueWithGoogle => 'Google کے ساتھ جاری رکھیں';

  @override
  String get signedInWithGoogle => 'Google کے ساتھ سائن ان کیا گیا';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google کے ساتھ $email کے طور پر سائن ان کیا گیا';
  }

  @override
  String get usePasswordInstead => 'اس کے بجائے پاس ورڈ استعمال کریں';

  @override
  String get googleSignInNotConfigured => 'Google سائن ان ابھی سیٹ اپ نہیں ہوا';

  @override
  String get googleSignInFailed => 'Google سائن ان ناکام۔ دوبارہ کوشش کریں۔';

  @override
  String get googleNoAccountFound =>
      'اس Google اکاؤنٹ کے لیے کوئی اکاؤنٹ نہیں ملا۔ پہلے ایک بنائیں۔';

  @override
  String get linkGoogleAccount => 'Google اکاؤنٹ لنک کریں';

  @override
  String get googleAccountLinked =>
      'Google اکاؤنٹ لنک ہو گیا — اب آپ اس سے سائن ان کر سکتے ہیں';

  @override
  String get addStaffBeforeBookings => 'بکنگ بنانے سے پہلے فعال عملہ شامل کریں';

  @override
  String get salonLabel => 'سیلون';

  @override
  String get statToday => 'آج';

  @override
  String get statRepeat => 'بار بار آنے والے';

  @override
  String get statLoggedHelper => 'درج شدہ';

  @override
  String get statBackHelper => 'واپس آئے';

  @override
  String get statWeek => 'ہفتہ';

  @override
  String get statMonth => 'مہینہ';

  @override
  String get loggedTodayHeading => 'آج درج شدہ';

  @override
  String get nothingLoggedToday =>
      'آج ابھی تک کچھ درج نہیں ہوا۔ سروس مکمل ہونے پر \"نئی بکنگ\" ٹیپ کریں۔';

  @override
  String get navHome => 'ہوم';

  @override
  String get navBookings => 'بکنگز';

  @override
  String get navStaff => 'عملہ';

  @override
  String get navInsights => 'بصیرت';

  @override
  String get navAccount => 'اکاؤنٹ';

  @override
  String get salonAdminTitle => 'سیلون ایڈمن';

  @override
  String get noSalonLinked =>
      'اس مالک اکاؤنٹ سے ابھی تک کوئی سیلون منسلک نہیں۔';

  @override
  String get bookingsTitle => 'بکنگز';

  @override
  String get searchCustomerOrService => 'کسٹمر یا سروس تلاش کریں';

  @override
  String get filterThisWeek => 'اس ہفتے';

  @override
  String get filterAllTime => 'تمام وقت';

  @override
  String get filterAllStaff => 'تمام عملہ';

  @override
  String get staffLabel => 'عملہ';

  @override
  String get needsActionHeading => 'کارروائی درکار';

  @override
  String get statTotal => 'کل';

  @override
  String get statServices => 'سروسز';

  @override
  String get statAvgTicket => 'اوسط بل';

  @override
  String get noBookingsMatchFilter => 'اس فلٹر سے کوئی بکنگ میل نہیں کھاتی';

  @override
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count سروسز';
  }

  @override
  String get couldNotOpenStore => 'اسٹور نہیں کھل سکا';

  @override
  String get updateRequired => 'اپ ڈیٹ درکار ہے';

  @override
  String get updateRequiredBody =>
      'ایپ کا نیا ورژن دستیاب ہے۔ اپنے سیلون ڈیش بورڈ کا استعمال جاری رکھنے کے لیے براہ کرم اپ ڈیٹ کریں۔';

  @override
  String get updateNow => 'ابھی اپ ڈیٹ کریں';

  @override
  String get themeColorTitle => 'تھیم کا رنگ';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get staffTitle => 'عملہ';

  @override
  String get addStaff => 'عملہ شامل کریں';

  @override
  String get statActive => 'فعال';

  @override
  String get statTodaysTotal => 'آج کی کل آمدنی';

  @override
  String get noActiveStaffYet => 'ابھی تک کوئی فعال عملہ نہیں';

  @override
  String get addFirstStaff => 'پہلا عملہ شامل کریں';

  @override
  String get noServicesYet => 'ابھی تک کوئی سروس نہیں';

  @override
  String get notActive => 'فعال نہیں';

  @override
  String get canSetOwnPrice => 'اپنی قیمت خود مقرر کر سکتے ہیں';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count سروسز · $revenue';
  }

  @override
  String get newLabel => 'نئی';

  @override
  String get serviceLabel => 'سروس';

  @override
  String get customerLabel => 'کسٹمر';

  @override
  String get repeatLabel => 'دوبارہ';

  @override
  String get couldNotUpdateBooking =>
      'بکنگ اپ ڈیٹ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get couldNotAcceptReschedule =>
      'دوبارہ شیڈول قبول نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get couldNotRejectReschedule =>
      'دوبارہ شیڈول مسترد نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get rescheduleLabel => 'دوبارہ شیڈول';

  @override
  String get pendingLabel => 'زیر التوا';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist کے ساتھ';
  }

  @override
  String customerRequestedTime(String time) {
    return 'کسٹمر نے $time کی درخواست کی';
  }

  @override
  String get reject => 'مسترد کریں';

  @override
  String get accept => 'قبول کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count مزید';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'اکاؤنٹ کی تفصیلات لوڈ نہیں ہو سکیں';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'مالک، فون، سیلون کا نام اور پتہ بھریں';

  @override
  String get accountUpdated => 'اکاؤنٹ اپ ڈیٹ ہو گیا';

  @override
  String get phoneOrEmailUsed => 'فون یا ای میل پہلے سے استعمال میں ہے';

  @override
  String get couldNotSaveAccount => 'اکاؤنٹ کی تفصیلات محفوظ نہیں ہو سکیں';

  @override
  String get newPasswordMinLength =>
      'نیا پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get newPasswordsDontMatch => 'نئے پاس ورڈز میل نہیں کھاتے';

  @override
  String get passwordChanged => 'پاس ورڈ تبدیل ہو گیا';

  @override
  String get currentPasswordIncorrect => 'موجودہ پاس ورڈ غلط ہے';

  @override
  String get couldNotChangePassword => 'پاس ورڈ تبدیل نہیں ہو سکا';

  @override
  String get countryAndCurrency => 'ملک اور کرنسی';

  @override
  String get accountTitle => 'اکاؤنٹ';

  @override
  String ownerSinceDate(String date) {
    return '$date سے مالک';
  }

  @override
  String planLabel(String plan) {
    return '$plan پلان';
  }

  @override
  String get retentionFreeFor6Months => '6 مہینوں کے لیے بحالی بصیرت مفت';

  @override
  String get upgrade => 'اپ گریڈ کریں';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get salonProfile => 'سیلون پروفائل';

  @override
  String get emailLabel => 'ای میل';

  @override
  String get locationUpdated => 'لوکیشن اپ ڈیٹ ہو گئی';

  @override
  String get saveDetailsButton => 'تفصیلات محفوظ کریں';

  @override
  String get savingEllipsis => 'محفوظ ہو رہا ہے...';

  @override
  String get security => 'سیکیورٹی';

  @override
  String get currentPasswordLabel => 'موجودہ پاس ورڈ';

  @override
  String get newPasswordLabel => 'نیا پاس ورڈ';

  @override
  String get confirmNewPasswordLabel => 'نئے پاس ورڈ کی تصدیق کریں';

  @override
  String get changePasswordButton => 'پاس ورڈ تبدیل کریں';

  @override
  String get changingEllipsis => 'تبدیل ہو رہا ہے...';

  @override
  String get signOut => 'سائن آؤٹ کریں';

  @override
  String get enterServiceNamePrice => 'سروس کا نام اور قیمت درج کریں';

  @override
  String get fillStaffNamePhone => 'عملے کا نام اور فون بھریں';

  @override
  String get addAtLeastOneService => 'کم از کم ایک سروس شامل کریں';

  @override
  String get enterValidOpenCloseTimes =>
      'درست کھلنے اور بند ہونے کا وقت درج کریں (HH:MM، 24 گھنٹے)';

  @override
  String get selectAtLeastOneWorkingDay => 'کم از کم ایک کام کا دن منتخب کریں';

  @override
  String get staffPhoneInUse => 'وہ عملے کا فون پہلے سے استعمال میں ہے';

  @override
  String get couldNotAddStaff => 'عملہ شامل نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get addStaffSubtitle =>
      'ان کا پروفائل، سروسز اور کام کے دن ترتیب دیں۔';

  @override
  String get staffNameLabel => 'عملے کا نام';

  @override
  String get staffPhoneLabel => 'عملے کا فون';

  @override
  String get servicesLabel => 'سروسز';

  @override
  String servicesAddedCount(int count) {
    return '$count شامل کی گئیں';
  }

  @override
  String get workingHours => 'کام کے اوقات';

  @override
  String get opens => 'کھلتا ہے';

  @override
  String get closes => 'بند ہوتا ہے';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'کام کے دن';

  @override
  String get serviceNameHint => 'سروس کا نام';

  @override
  String get priceHint => 'قیمت';

  @override
  String get dayMon => 'پیر';

  @override
  String get dayTue => 'منگل';

  @override
  String get dayWed => 'بدھ';

  @override
  String get dayThu => 'جمعرات';

  @override
  String get dayFri => 'جمعہ';

  @override
  String get daySat => 'ہفتہ';

  @override
  String get daySun => 'اتوار';

  @override
  String get enterValidStaffNamePhone => 'درست عملے کا نام اور فون درج کریں';

  @override
  String get staffDetailsSaved => 'عملے کی تفصیلات محفوظ ہو گئیں';

  @override
  String get phoneAlreadyInUse => 'وہ فون پہلے سے استعمال میں ہے';

  @override
  String get couldNotUpdateStaff => 'عملہ اپ ڈیٹ نہیں ہو سکا';

  @override
  String get enterServiceNameAndPriceShort => 'سروس کا نام اور قیمت درج کریں';

  @override
  String get couldNotAddService => 'سروس شامل نہیں ہو سکی';

  @override
  String get editServiceTitle => 'سروس میں ترمیم کریں';

  @override
  String get enterValidServiceNamePrice => 'درست سروس کا نام اور قیمت درج کریں';

  @override
  String get couldNotUpdateService => 'سروس اپ ڈیٹ نہیں ہو سکی';

  @override
  String get saveServiceButton => 'سروس محفوظ کریں';

  @override
  String get couldNotRemoveServiceDefault => 'سروس ہٹائی نہیں جا سکی';

  @override
  String get useHHmmWorkingHours => 'کام کے اوقات کے لیے HH:mm استعمال کریں';

  @override
  String get hoursAdded => 'اوقات شامل ہو گئے';

  @override
  String get couldNotAddWorkingHours => 'کام کے اوقات شامل نہیں ہو سکے';

  @override
  String get couldNotRemoveTiming => 'وقت ہٹایا نہیں جا سکا';

  @override
  String get manageStaffTitle => 'عملہ منظم کریں';

  @override
  String get done => 'مکمل';

  @override
  String get manageStaffSubtitle =>
      'سروسز اور اوقات شامل، ترمیم یا ہٹائیں، پھر مکمل پر ٹیپ کریں۔';

  @override
  String get saveStaffButton => 'عملہ محفوظ کریں';

  @override
  String get edit => 'ترمیم کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get newServiceLabel => 'نئی سروس';

  @override
  String get addingEllipsis => 'شامل ہو رہا ہے...';

  @override
  String get addServiceButton => 'سروس شامل کریں';

  @override
  String get noTimingsYet => 'ابھی تک کوئی وقت نہیں';

  @override
  String get removeLabel => 'ہٹائیں';

  @override
  String get startLabel => 'شروع';

  @override
  String get endLabel => 'ختم';

  @override
  String get addMonSatHoursButton => 'پیر تا ہفتہ اوقات شامل کریں';

  @override
  String get saveHoursButton => 'اوقات محفوظ کریں';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'عملہ، سروس اور تاریخ منتخب کریں';

  @override
  String get noSlotsForDate => 'اس تاریخ کے لیے کوئی سلاٹ دستیاب نہیں۔';

  @override
  String get couldNotLoadSlots => 'سلاٹس لوڈ نہیں ہو سکے';

  @override
  String get enterCustomerName => 'کسٹمر کا نام درج کریں';

  @override
  String get chooseStaffAndService => 'عملہ اور کم از کم ایک سروس منتخب کریں';

  @override
  String get enterCustomerPhone => 'کسٹمر کا فون درج کریں';

  @override
  String get chooseAvailableSlot => 'ایک دستیاب سلاٹ منتخب کریں';

  @override
  String get couldNotCreateBooking => 'بکنگ نہیں بن سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get doneServiceOption => 'سروس مکمل';

  @override
  String get scheduleLaterOption => 'بعد میں شیڈول کریں';

  @override
  String get customerNameLabel => 'کسٹمر کا نام';

  @override
  String get customerPhoneLabel => 'کسٹمر کا فون';

  @override
  String recordedNowDate(String date) {
    return 'ابھی درج کیا گیا — $date';
  }

  @override
  String get dateLabel => 'تاریخ';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'دستیاب سلاٹس';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get saveBooking => 'بکنگ محفوظ کریں';

  @override
  String saveBookingWithTotal(String total) {
    return 'بکنگ محفوظ کریں · $total';
  }
}
