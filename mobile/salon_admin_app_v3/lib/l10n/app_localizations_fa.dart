// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get insightsTitle => 'بینش‌ها';

  @override
  String get tabEarnings => 'درآمد';

  @override
  String get tabRetention => 'حفظ مشتری';

  @override
  String get periodToday => 'امروز';

  @override
  String get periodWeek => 'هفته';

  @override
  String get periodMonth => 'ماه';

  @override
  String get periodLast7Days => '۷ روز گذشته';

  @override
  String get periodLast30Days => '۳۰ روز گذشته';

  @override
  String get earningsLoadError => 'درآمد بارگذاری نشد.';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String completedServicesCount(int count) {
    return '$count خدمت';
  }

  @override
  String get completedServicesHeading => 'خدمات تکمیل‌شده';

  @override
  String get noCompletedServices => 'هنوز خدمتی در این بازه تکمیل نشده است.';

  @override
  String get topServicesHeading => 'خدمات برتر';

  @override
  String get byStaffHeading => 'بر اساس کارمند';

  @override
  String get vsYesterday => 'نسبت به دیروز';

  @override
  String get vsLastWeek => 'نسبت به هفته گذشته';

  @override
  String get vsLastMonth => 'نسبت به ماه گذشته';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'مشتریانی که بازگرداندید';

  @override
  String reactivatedSummary(int count) {
    return '$count مشتری این ماه بازگشتند';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'گزارش حفظ مشتری بارگذاری نشد.';

  @override
  String get couldNotOpenWhatsapp => 'واتس‌اپ باز نشد';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'سلام $name! دلمان برایتان در $salonName تنگ شده. بازدید بعدی خود را رزرو کنید و از پیشنهاد ویژه بازگشت لذت ببرید. به‌زودی می‌بینیمتان!';
  }

  @override
  String get customerCohortsHeading => 'گروه‌های مشتری';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count مشتری';
  }

  @override
  String noCohortCustomers(String label) {
    return 'در این بازه مشتری $label وجود ندارد.';
  }

  @override
  String get missedCustomersHeading => 'مشتریان از دست رفته';

  @override
  String get missedCustomersHint =>
      'برای ارسال پیام در واتس‌اپ روی «یادآوری» ضربه بزنید.';

  @override
  String get noMissedCustomers => 'این ماه هیچ مشتری از دست نرفته است.';

  @override
  String get cohortRegulars => 'دائمی‌ها';

  @override
  String get cohortNew => 'جدید';

  @override
  String get cohortCameBack => 'بازگشته‌اند';

  @override
  String get cohortStoppedComing => 'دیگر نمی‌آیند';

  @override
  String get customersLabel => 'مشتریان';

  @override
  String get reachOutNow => 'همین حالا تماس بگیرید';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count مشتری دائمی در حال کاهش‌اند · $revenue در معرض خطر';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× تأخیر';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'معمولاً هر $cadence روز · $overdue روز تأخیر';
  }

  @override
  String get remind => 'یادآوری';

  @override
  String get remindOnWhatsappTooltip => 'یادآوری از طریق واتس‌اپ';

  @override
  String get retentionProTitle => 'بینش‌های حفظ مشتری یک ویژگی PRO است';

  @override
  String get retentionProBody =>
      'ببینید چه کسی دیگر نمی‌آید، نسبت مشتریان جدید به بازگشتی خود را بررسی کنید و با یادآوری‌های یک‌ضربه‌ای مشتریان ازدست‌رفته را بازگردانید.';

  @override
  String get upgradeToPro => 'ارتقا به PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits بازدید · $spend هزینه شده';
  }

  @override
  String get createYourAccount => 'حساب خود را بسازید';

  @override
  String get basics => 'اطلاعات پایه';

  @override
  String get country => 'کشور';

  @override
  String get countryHelperText =>
      'ارز، قالب تلفن و زبان پیش‌فرض شما را تعیین می‌کند.';

  @override
  String get language => 'زبان';

  @override
  String get phoneNumberLabel => 'شماره تلفن';

  @override
  String get passwordLabel => 'رمز عبور';

  @override
  String stepOfTotal(int step, int total) {
    return 'مرحله $step از $total';
  }

  @override
  String get createAccountButton => 'ایجاد حساب';

  @override
  String get continueButton => 'ادامه';

  @override
  String get enterPhoneNumber => 'شماره تلفن را وارد کنید';

  @override
  String get passwordMinLength => 'رمز عبور باید حداقل ۶ کاراکتر باشد';

  @override
  String get fillOwnerSalonAddress => 'نام مالک، نام سالن و آدرس را وارد کنید';

  @override
  String get turnOnLocationPermission =>
      'برای استفاده از این ویژگی، موقعیت مکانی را روشن و دسترسی را مجاز کنید';

  @override
  String get couldNotGetLocation => 'موقعیت مکانی شما دریافت نشد';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'این تلفن قبلاً ثبت شده است. لطفاً وارد شوید.';

  @override
  String get signupFailedCheckBackend =>
      'ثبت‌نام ناموفق بود. اتصال سرور را بررسی کنید.';

  @override
  String get signupFailedTryAgain =>
      'ثبت‌نام ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get yourSalon => 'سالن شما';

  @override
  String get salonDetailsSubtitle => 'مرحله ۲ از ۳ · جزئیات سالن';

  @override
  String get ownerNameLabel => 'نام مالک';

  @override
  String get salonNameLabel => 'نام سالن';

  @override
  String get salonAddressLabel => 'آدرس سالن';

  @override
  String get locationSet => 'موقعیت مکانی تنظیم شد';

  @override
  String get useMyCurrentLocation => 'استفاده از موقعیت فعلی من';

  @override
  String get pickYourColor => 'رنگ خود را انتخاب کنید';

  @override
  String get colorPreviewHelp =>
      'این رنگ تأکیدی سالن شما در سراسر برنامه است. هر زمان در حساب کاربری تغییرش دهید.';

  @override
  String get previewLabel => 'پیش‌نمایش';

  @override
  String get newBooking => 'رزرو جدید';

  @override
  String get colorTeal => 'فیروزه‌ای';

  @override
  String get colorTerracotta => 'سفالی';

  @override
  String get colorBlue => 'آبی';

  @override
  String get colorViolet => 'بنفش';

  @override
  String get colorRose => 'صورتی';

  @override
  String get welcomeBack => 'خوش برگشتید';

  @override
  String get signInToDashboard => 'به داشبورد سالن خود وارد شوید';

  @override
  String get enterSalonOwnerPhone => 'تلفن مالک سالن را وارد کنید';

  @override
  String get enterYourPassword => 'رمز عبور خود را وارد کنید';

  @override
  String get noSalonOwnerFound => 'هیچ حساب مالک سالنی برای این تلفن یافت نشد.';

  @override
  String get loginFailedCheckBackend =>
      'ورود ناموفق بود. اتصال سرور را بررسی کنید.';

  @override
  String get loginFailedTryAgain => 'ورود ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get hidePassword => 'پنهان کردن رمز عبور';

  @override
  String get showPassword => 'نمایش رمز عبور';

  @override
  String get signIn => 'ورود';

  @override
  String get newHere => 'تازه اینجا هستید؟';

  @override
  String get createAccount => 'ایجاد حساب';

  @override
  String get forgotPassword => 'رمز عبور را فراموش کرده‌اید؟';

  @override
  String get resetPasswordTitle => 'بازنشانی رمز عبور';

  @override
  String get resetPasswordEnterPhone =>
      'شماره تلفن خود را وارد کنید تا کد ۶ رقمی از طریق واتساپ ارسال شود.';

  @override
  String get sendCodeViaWhatsApp => 'ارسال کد از طریق واتساپ';

  @override
  String get codeSentViaWhatsApp =>
      'اگر این حساب وجود داشته باشد، کدی از طریق واتساپ ارسال شد.';

  @override
  String get resetPasswordEnterCode =>
      'کدی را که از طریق واتساپ ارسال کردیم وارد کنید، سپس رمز عبور جدید را انتخاب کنید.';

  @override
  String get otpCodeLabel => 'کد ۶ رقمی';

  @override
  String get resetPasswordButton => 'بازنشانی رمز عبور';

  @override
  String get resendCode => 'ارسال مجدد کد';

  @override
  String get changePhoneNumber => 'تغییر شماره تلفن';

  @override
  String get enterSixDigitCode => 'کد ۶ رقمی را وارد کنید';

  @override
  String get passwordsDoNotMatch => 'رمزهای عبور مطابقت ندارند';

  @override
  String get passwordResetSuccess =>
      'رمز عبور بازنشانی شد. لطفاً با رمز عبور جدید وارد شوید.';

  @override
  String get waitBeforeRetryingCode =>
      'لطفاً یک دقیقه صبر کنید و سپس کد دیگری درخواست کنید';

  @override
  String get invalidOrExpiredCode => 'این کد نامعتبر است یا منقضی شده است';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'تلاش‌های زیاد — یک کد جدید درخواست کنید';

  @override
  String get continueWithGoogle => 'ادامه با گوگل';

  @override
  String get signedInWithGoogle => 'با گوگل وارد شدید';

  @override
  String signedInWithGoogleAs(String email) {
    return 'با گوگل به عنوان $email وارد شدید';
  }

  @override
  String get usePasswordInstead => 'در عوض از رمز عبور استفاده کنید';

  @override
  String get googleSignInNotConfigured => 'ورود با گوگل هنوز تنظیم نشده است';

  @override
  String get googleSignInFailed =>
      'ورود با گوگل ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get googleNoAccountFound =>
      'هیچ حسابی برای این حساب گوگل یافت نشد. ابتدا یکی ایجاد کنید.';

  @override
  String get linkGoogleAccount => 'اتصال حساب گوگل';

  @override
  String get googleAccountLinked =>
      'حساب گوگل متصل شد — اکنون می‌توانید با آن وارد شوید';

  @override
  String get addStaffBeforeBookings =>
      'قبل از ایجاد رزرو، کارکنان فعال اضافه کنید';

  @override
  String get salonLabel => 'سالن';

  @override
  String get statToday => 'امروز';

  @override
  String get statRepeat => 'تکراری';

  @override
  String get statLoggedHelper => 'ثبت‌شده';

  @override
  String get statBackHelper => 'بازگشته';

  @override
  String get statWeek => 'هفته';

  @override
  String get statMonth => 'ماه';

  @override
  String get loggedTodayHeading => 'ثبت‌شده امروز';

  @override
  String get nothingLoggedToday =>
      'امروز هنوز چیزی ثبت نشده است. پس از اتمام خدمت، روی «رزرو جدید» ضربه بزنید.';

  @override
  String get navHome => 'خانه';

  @override
  String get navBookings => 'رزروها';

  @override
  String get navStaff => 'کارکنان';

  @override
  String get navInsights => 'بینش‌ها';

  @override
  String get navAccount => 'حساب کاربری';

  @override
  String get salonAdminTitle => 'مدیریت سالن';

  @override
  String get noSalonLinked => 'هنوز سالنی به این حساب مالک متصل نشده است.';

  @override
  String get bookingsTitle => 'رزروها';

  @override
  String get searchCustomerOrService => 'جستجوی مشتری یا خدمت';

  @override
  String get filterThisWeek => 'این هفته';

  @override
  String get filterAllTime => 'همه زمان‌ها';

  @override
  String get filterAllStaff => 'همه کارکنان';

  @override
  String get staffLabel => 'کارکنان';

  @override
  String get needsActionHeading => 'نیاز به اقدام';

  @override
  String get statTotal => 'مجموع';

  @override
  String get statServices => 'خدمات';

  @override
  String get statAvgTicket => 'میانگین صورت‌حساب';

  @override
  String get noBookingsMatchFilter => 'هیچ رزروی با این فیلتر مطابقت ندارد';

  @override
  String get today => 'امروز';

  @override
  String get yesterday => 'دیروز';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count خدمت';
  }

  @override
  String get couldNotOpenStore => 'فروشگاه باز نشد';

  @override
  String get updateRequired => 'به‌روزرسانی لازم است';

  @override
  String get updateRequiredBody =>
      'نسخه جدید برنامه در دسترس است. لطفاً برای ادامه استفاده از داشبورد سالن خود به‌روزرسانی کنید.';

  @override
  String get updateNow => 'اکنون به‌روزرسانی کنید';

  @override
  String get themeColorTitle => 'رنگ تم';

  @override
  String get save => 'ذخیره';

  @override
  String get staffTitle => 'کارکنان';

  @override
  String get addStaff => 'افزودن کارمند';

  @override
  String get statActive => 'فعال';

  @override
  String get statTodaysTotal => 'مجموع امروز';

  @override
  String get noActiveStaffYet => 'هنوز کارمند فعالی وجود ندارد';

  @override
  String get addFirstStaff => 'افزودن اولین کارمند';

  @override
  String get noServicesYet => 'هنوز خدمتی وجود ندارد';

  @override
  String get notActive => 'غیرفعال';

  @override
  String get canSetOwnPrice => 'می‌تواند قیمت خود را تعیین کند';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count خدمت · $revenue';
  }

  @override
  String get newLabel => 'جدید';

  @override
  String get serviceLabel => 'خدمت';

  @override
  String get customerLabel => 'مشتری';

  @override
  String get repeatLabel => 'تکراری';

  @override
  String get couldNotUpdateBooking =>
      'رزرو به‌روزرسانی نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get couldNotAcceptReschedule =>
      'تغییر زمان پذیرفته نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get couldNotRejectReschedule =>
      'تغییر زمان رد نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get rescheduleLabel => 'تغییر زمان';

  @override
  String get pendingLabel => 'در انتظار';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer با $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'مشتری $time درخواست کرد';
  }

  @override
  String get reject => 'رد کردن';

  @override
  String get accept => 'پذیرفتن';

  @override
  String get confirm => 'تأیید';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count مورد دیگر';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'جزئیات حساب بارگذاری نشد';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'مالک، تلفن، نام سالن و آدرس را وارد کنید';

  @override
  String get accountUpdated => 'حساب به‌روزرسانی شد';

  @override
  String get phoneOrEmailUsed => 'تلفن یا ایمیل قبلاً استفاده شده است';

  @override
  String get couldNotSaveAccount => 'جزئیات حساب ذخیره نشد';

  @override
  String get newPasswordMinLength => 'رمز عبور جدید باید حداقل ۶ کاراکتر باشد';

  @override
  String get newPasswordsDontMatch => 'رمزهای عبور جدید مطابقت ندارند';

  @override
  String get passwordChanged => 'رمز عبور تغییر کرد';

  @override
  String get currentPasswordIncorrect => 'رمز عبور فعلی نادرست است';

  @override
  String get couldNotChangePassword => 'رمز عبور تغییر نکرد';

  @override
  String get countryAndCurrency => 'کشور و ارز';

  @override
  String get accountTitle => 'حساب کاربری';

  @override
  String ownerSinceDate(String date) {
    return 'مالک از تاریخ $date';
  }

  @override
  String planLabel(String plan) {
    return 'طرح $plan';
  }

  @override
  String get retentionFreeFor6Months => 'بینش‌های حفظ مشتری برای ۶ ماه رایگان';

  @override
  String get upgrade => 'ارتقا';

  @override
  String get appearance => 'ظاهر';

  @override
  String get salonProfile => 'پروفایل سالن';

  @override
  String get emailLabel => 'ایمیل';

  @override
  String get locationUpdated => 'موقعیت مکانی به‌روزرسانی شد';

  @override
  String get saveDetailsButton => 'ذخیره جزئیات';

  @override
  String get savingEllipsis => 'در حال ذخیره...';

  @override
  String get security => 'امنیت';

  @override
  String get currentPasswordLabel => 'رمز عبور فعلی';

  @override
  String get newPasswordLabel => 'رمز عبور جدید';

  @override
  String get confirmNewPasswordLabel => 'تأیید رمز عبور جدید';

  @override
  String get changePasswordButton => 'تغییر رمز عبور';

  @override
  String get changingEllipsis => 'در حال تغییر...';

  @override
  String get signOut => 'خروج';

  @override
  String get enterServiceNamePrice => 'نام و قیمت خدمت را وارد کنید';

  @override
  String get fillStaffNamePhone => 'نام و تلفن کارمند را وارد کنید';

  @override
  String get addAtLeastOneService => 'حداقل یک خدمت اضافه کنید';

  @override
  String get enterValidOpenCloseTimes =>
      'زمان‌های معتبر باز و بسته شدن را وارد کنید (HH:MM، ۲۴ ساعته)';

  @override
  String get selectAtLeastOneWorkingDay => 'حداقل یک روز کاری انتخاب کنید';

  @override
  String get staffPhoneInUse => 'آن تلفن کارمند قبلاً استفاده شده است';

  @override
  String get couldNotAddStaff => 'کارمند اضافه نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get addStaffSubtitle =>
      'پروفایل، خدمات و روزهای کاری او را تنظیم کنید.';

  @override
  String get staffNameLabel => 'نام کارمند';

  @override
  String get staffPhoneLabel => 'تلفن کارمند';

  @override
  String get servicesLabel => 'خدمات';

  @override
  String servicesAddedCount(int count) {
    return '$count اضافه شد';
  }

  @override
  String get workingHours => 'ساعات کاری';

  @override
  String get opens => 'باز می‌شود';

  @override
  String get closes => 'بسته می‌شود';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'روزهای کاری';

  @override
  String get serviceNameHint => 'نام خدمت';

  @override
  String get priceHint => 'قیمت';

  @override
  String get dayMon => 'دوشنبه';

  @override
  String get dayTue => 'سه‌شنبه';

  @override
  String get dayWed => 'چهارشنبه';

  @override
  String get dayThu => 'پنجشنبه';

  @override
  String get dayFri => 'جمعه';

  @override
  String get daySat => 'شنبه';

  @override
  String get daySun => 'یکشنبه';

  @override
  String get enterValidStaffNamePhone => 'نام و تلفن معتبر کارمند را وارد کنید';

  @override
  String get staffDetailsSaved => 'جزئیات کارمند ذخیره شد';

  @override
  String get phoneAlreadyInUse => 'آن تلفن قبلاً استفاده شده است';

  @override
  String get couldNotUpdateStaff => 'کارمند به‌روزرسانی نشد';

  @override
  String get enterServiceNameAndPriceShort => 'نام و قیمت خدمت را وارد کنید';

  @override
  String get couldNotAddService => 'خدمت اضافه نشد';

  @override
  String get editServiceTitle => 'ویرایش خدمت';

  @override
  String get enterValidServiceNamePrice => 'نام و قیمت معتبر خدمت را وارد کنید';

  @override
  String get couldNotUpdateService => 'خدمت به‌روزرسانی نشد';

  @override
  String get saveServiceButton => 'ذخیره خدمت';

  @override
  String get couldNotRemoveServiceDefault => 'خدمت حذف نشد';

  @override
  String get useHHmmWorkingHours => 'برای ساعات کاری از HH:mm استفاده کنید';

  @override
  String get hoursAdded => 'ساعات اضافه شد';

  @override
  String get couldNotAddWorkingHours => 'ساعات کاری اضافه نشد';

  @override
  String get couldNotRemoveTiming => 'زمان‌بندی حذف نشد';

  @override
  String get manageStaffTitle => 'مدیریت کارمند';

  @override
  String get done => 'انجام شد';

  @override
  String get manageStaffSubtitle =>
      'خدمات و ساعات را اضافه، ویرایش یا حذف کنید، سپس روی «انجام شد» ضربه بزنید.';

  @override
  String get saveStaffButton => 'ذخیره کارمند';

  @override
  String get edit => 'ویرایش';

  @override
  String get delete => 'حذف';

  @override
  String get newServiceLabel => 'خدمت جدید';

  @override
  String get addingEllipsis => 'در حال افزودن...';

  @override
  String get addServiceButton => 'افزودن خدمت';

  @override
  String get noTimingsYet => 'هنوز زمان‌بندی وجود ندارد';

  @override
  String get removeLabel => 'حذف';

  @override
  String get startLabel => 'شروع';

  @override
  String get endLabel => 'پایان';

  @override
  String get addMonSatHoursButton => 'افزودن ساعات دوشنبه تا شنبه';

  @override
  String get saveHoursButton => 'ذخیره ساعات';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'کارمند، خدمت و تاریخ را انتخاب کنید';

  @override
  String get noSlotsForDate => 'هیچ زمانی برای این تاریخ در دسترس نیست.';

  @override
  String get couldNotLoadSlots => 'زمان‌ها بارگذاری نشد';

  @override
  String get enterCustomerName => 'نام مشتری را وارد کنید';

  @override
  String get chooseStaffAndService => 'کارمند و حداقل یک خدمت را انتخاب کنید';

  @override
  String get enterCustomerPhone => 'تلفن مشتری را وارد کنید';

  @override
  String get chooseAvailableSlot => 'یک زمان در دسترس را انتخاب کنید';

  @override
  String get couldNotCreateBooking => 'رزرو ایجاد نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get doneServiceOption => 'خدمت انجام شد';

  @override
  String get scheduleLaterOption => 'زمان‌بندی برای بعد';

  @override
  String get customerNameLabel => 'نام مشتری';

  @override
  String get customerPhoneLabel => 'تلفن مشتری';

  @override
  String recordedNowDate(String date) {
    return 'اکنون ثبت شد — $date';
  }

  @override
  String get dateLabel => 'تاریخ';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'زمان‌های در دسترس';

  @override
  String get cancel => 'لغو';

  @override
  String get saveBooking => 'ذخیره رزرو';

  @override
  String saveBookingWithTotal(String total) {
    return 'ذخیره رزرو · $total';
  }
}
