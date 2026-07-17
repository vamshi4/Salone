// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get insightsTitle => 'الإحصاءات';

  @override
  String get tabEarnings => 'الأرباح';

  @override
  String get tabRetention => 'الاحتفاظ بالعملاء';

  @override
  String get periodToday => 'اليوم';

  @override
  String get periodWeek => 'الأسبوع';

  @override
  String get periodMonth => 'الشهر';

  @override
  String get periodLast7Days => 'آخر 7 أيام';

  @override
  String get periodLast30Days => 'آخر 30 يومًا';

  @override
  String get earningsLoadError => 'تعذر تحميل الأرباح.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خدمة',
      one: 'خدمة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'الخدمات المكتملة';

  @override
  String get noCompletedServices => 'لا توجد خدمات مكتملة بعد في هذه الفترة.';

  @override
  String get topServicesHeading => 'أفضل الخدمات';

  @override
  String get byStaffHeading => 'حسب الموظف';

  @override
  String get vsYesterday => 'مقارنة بالأمس';

  @override
  String get vsLastWeek => 'مقارنة بالأسبوع الماضي';

  @override
  String get vsLastMonth => 'مقارنة بالشهر الماضي';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'عملاء استعدتهم';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عاد $count عملاء هذا الشهر',
      one: 'عاد عميل واحد هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'تعذر تحميل تقرير الاحتفاظ بالعملاء.';

  @override
  String get couldNotOpenWhatsapp => 'تعذر فتح واتساب';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'مرحبًا $name! لقد اشتقنا إليك في $salonName. احجز زيارتك القادمة واستمتع بعرض ترحيبي خاص. نراك قريبًا!';
  }

  @override
  String get customerCohortsHeading => 'فئات العملاء';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count عميل';
  }

  @override
  String noCohortCustomers(String label) {
    return 'لا يوجد عملاء $label في هذه الفترة.';
  }

  @override
  String get missedCustomersHeading => 'العملاء الغائبون';

  @override
  String get missedCustomersHint =>
      'اضغط على \"تذكير\" لإرسال رسالة لهم عبر واتساب.';

  @override
  String get noMissedCustomers => 'لا يوجد عملاء غائبون هذا الشهر.';

  @override
  String get cohortRegulars => 'الدائمون';

  @override
  String get cohortNew => 'جدد';

  @override
  String get cohortCameBack => 'عادوا';

  @override
  String get cohortStoppedComing => 'توقفوا عن الحضور';

  @override
  String get customersLabel => 'عملاء';

  @override
  String get reachOutNow => 'تواصل الآن';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count من العملاء الدائمين آخذون في التراجع · $revenue معرضة للخطر';
  }

  @override
  String overdueBadge(String ratio) {
    return 'متأخر $ratio×';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'عادة كل $cadence يوم · متأخر $overdue يوم';
  }

  @override
  String get remind => 'تذكير';

  @override
  String get remindOnWhatsappTooltip => 'تذكير عبر واتساب';

  @override
  String get retentionProTitle => 'إحصاءات الاحتفاظ بالعملاء ميزة PRO';

  @override
  String get retentionProBody =>
      'تعرّف على من توقف عن الحضور، ونسبة العملاء الجدد مقابل العائدين، واسترجع العملاء المفقودين بتذكيرات بلمسة واحدة.';

  @override
  String get upgradeToPro => 'الترقية إلى PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits زيارة · تم إنفاق $spend';
  }

  @override
  String get createYourAccount => 'أنشئ حسابك';

  @override
  String get basics => 'الأساسيات';

  @override
  String get country => 'الدولة';

  @override
  String get countryHelperText => 'تحدد عملتك وتنسيق الهاتف واللغة الافتراضية.';

  @override
  String get language => 'اللغة';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String stepOfTotal(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get createAccountButton => 'إنشاء حساب';

  @override
  String get continueButton => 'متابعة';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتف';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get fillOwnerSalonAddress => 'أدخل اسم المالك واسم الصالون والعنوان';

  @override
  String get turnOnLocationPermission =>
      'فعّل الموقع واسمح بالوصول لاستخدام هذا';

  @override
  String get couldNotGetLocation => 'تعذر الحصول على موقعك';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'هذا الهاتف مسجل بالفعل. يرجى تسجيل الدخول بدلاً من ذلك.';

  @override
  String get signupFailedCheckBackend => 'فشل التسجيل. تحقق من اتصال الخادم.';

  @override
  String get signupFailedTryAgain => 'فشل التسجيل. حاول مرة أخرى.';

  @override
  String get yourSalon => 'صالونك';

  @override
  String get salonDetailsSubtitle => 'الخطوة 2 من 3 · تفاصيل الصالون';

  @override
  String get ownerNameLabel => 'اسم المالك';

  @override
  String get salonNameLabel => 'اسم الصالون';

  @override
  String get salonAddressLabel => 'عنوان الصالون';

  @override
  String get locationSet => 'تم تحديد الموقع';

  @override
  String get useMyCurrentLocation => 'استخدام موقعي الحالي';

  @override
  String get pickYourColor => 'اختر لونك';

  @override
  String get colorPreviewHelp =>
      'هذا هو لون التمييز لصالونك في جميع أنحاء التطبيق. غيّره في أي وقت من الحساب.';

  @override
  String get previewLabel => 'معاينة';

  @override
  String get newBooking => 'حجز جديد';

  @override
  String get colorTeal => 'أزرق مخضر';

  @override
  String get colorTerracotta => 'طيني';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorViolet => 'بنفسجي';

  @override
  String get colorRose => 'وردي';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInToDashboard => 'سجّل الدخول إلى لوحة تحكم صالونك';

  @override
  String get enterSalonOwnerPhone => 'أدخل هاتف مالك الصالون';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get noSalonOwnerFound =>
      'لم يتم العثور على حساب مالك صالون لهذا الهاتف.';

  @override
  String get loginFailedCheckBackend =>
      'فشل تسجيل الدخول. تحقق من اتصال الخادم.';

  @override
  String get loginFailedTryAgain => 'فشل تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get newHere => 'جديد هنا؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordEnterPhone =>
      'أدخل رقم هاتفك وسنرسل لك رمزًا مكونًا من 6 أرقام عبر واتساب.';

  @override
  String get sendCodeViaWhatsApp => 'إرسال الرمز عبر واتساب';

  @override
  String get codeSentViaWhatsApp =>
      'إذا كان هذا الحساب موجودًا، فقد تم إرسال رمز عبر واتساب.';

  @override
  String get resetPasswordEnterCode =>
      'أدخل الرمز الذي أرسلناه إليك عبر واتساب، ثم اختر كلمة مرور جديدة.';

  @override
  String get otpCodeLabel => 'رمز مكوّن من 6 أرقام';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get changePhoneNumber => 'تغيير رقم الهاتف';

  @override
  String get enterSixDigitCode => 'أدخل الرمز المكوّن من 6 أرقام';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordResetSuccess =>
      'تمت إعادة تعيين كلمة المرور. يرجى تسجيل الدخول بكلمة المرور الجديدة.';

  @override
  String get waitBeforeRetryingCode => 'يرجى الانتظار دقيقة قبل طلب رمز آخر';

  @override
  String get invalidOrExpiredCode => 'هذا الرمز غير صالح أو منتهي الصلاحية';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'محاولات كثيرة جدًا — اطلب رمزًا جديدًا';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get signedInWithGoogle => 'تم تسجيل الدخول باستخدام Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'تم تسجيل الدخول باستخدام Google كـ $email';
  }

  @override
  String get usePasswordInstead => 'استخدام كلمة المرور بدلاً من ذلك';

  @override
  String get googleSignInNotConfigured =>
      'تسجيل الدخول عبر Google غير مُفعّل بعد';

  @override
  String get googleSignInFailed =>
      'فشل تسجيل الدخول عبر Google. حاول مرة أخرى.';

  @override
  String get googleNoAccountFound =>
      'لم يتم العثور على حساب لهذا الحساب في Google. أنشئ حسابًا أولاً.';

  @override
  String get linkGoogleAccount => 'ربط حساب Google';

  @override
  String get googleAccountLinked =>
      'تم ربط حساب Google — يمكنك الآن تسجيل الدخول به';

  @override
  String get addStaffBeforeBookings => 'أضف موظفين نشطين قبل إنشاء الحجوزات';

  @override
  String get salonLabel => 'الصالون';

  @override
  String get statToday => 'اليوم';

  @override
  String get statRepeat => 'متكرر';

  @override
  String get statLoggedHelper => 'مسجل';

  @override
  String get statBackHelper => 'عائد';

  @override
  String get statWeek => 'الأسبوع';

  @override
  String get statMonth => 'الشهر';

  @override
  String get loggedTodayHeading => 'المسجل اليوم';

  @override
  String get nothingLoggedToday =>
      'لم يتم تسجيل أي شيء اليوم بعد. اضغط على \"حجز جديد\" عند اكتمال الخدمة.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navBookings => 'الحجوزات';

  @override
  String get navStaff => 'الموظفون';

  @override
  String get navInsights => 'الإحصاءات';

  @override
  String get navAccount => 'الحساب';

  @override
  String get salonAdminTitle => 'إدارة الصالون';

  @override
  String get noSalonLinked => 'لا يوجد صالون مرتبط بحساب المالك هذا بعد.';

  @override
  String get bookingsTitle => 'الحجوزات';

  @override
  String get searchCustomerOrService => 'ابحث عن عميل أو خدمة';

  @override
  String get filterThisWeek => 'هذا الأسبوع';

  @override
  String get filterAllTime => 'كل الأوقات';

  @override
  String get filterAllStaff => 'جميع الموظفين';

  @override
  String get staffLabel => 'الموظفون';

  @override
  String get needsActionHeading => 'يحتاج إجراء';

  @override
  String get statTotal => 'الإجمالي';

  @override
  String get statServices => 'الخدمات';

  @override
  String get statAvgTicket => 'متوسط الفاتورة';

  @override
  String get noBookingsMatchFilter => 'لا توجد حجوزات تطابق هذا الفلتر';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خدمة',
      one: 'خدمة واحدة',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'تعذر فتح المتجر';

  @override
  String get updateRequired => 'التحديث مطلوب';

  @override
  String get updateRequiredBody =>
      'يتوفر إصدار جديد من التطبيق. يرجى التحديث لمواصلة استخدام لوحة تحكم صالونك.';

  @override
  String get updateNow => 'التحديث الآن';

  @override
  String get themeColorTitle => 'لون السمة';

  @override
  String get save => 'حفظ';

  @override
  String get staffTitle => 'الموظفون';

  @override
  String get addStaff => 'إضافة موظف';

  @override
  String get statActive => 'نشط';

  @override
  String get statTodaysTotal => 'إجمالي اليوم';

  @override
  String get noActiveStaffYet => 'لا يوجد موظفون نشطون بعد';

  @override
  String get addFirstStaff => 'إضافة أول موظف';

  @override
  String get noServicesYet => 'لا توجد خدمات بعد';

  @override
  String get notActive => 'غير نشط';

  @override
  String get canSetOwnPrice => 'يمكنه تحديد سعره الخاص';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خدمة',
      one: 'خدمة واحدة',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'جديد';

  @override
  String get serviceLabel => 'خدمة';

  @override
  String get customerLabel => 'عميل';

  @override
  String get repeatLabel => 'متكرر';

  @override
  String get couldNotUpdateBooking => 'تعذر تحديث الحجز. حاول مرة أخرى.';

  @override
  String get couldNotAcceptReschedule =>
      'تعذر قبول إعادة الجدولة. حاول مرة أخرى.';

  @override
  String get couldNotRejectReschedule =>
      'تعذر رفض إعادة الجدولة. حاول مرة أخرى.';

  @override
  String get rescheduleLabel => 'إعادة الجدولة';

  @override
  String get pendingLabel => 'قيد الانتظار';

  @override
  String get scheduledLabel => 'مجدول';

  @override
  String get inProgressLabel => 'جارٍ';

  @override
  String get startBookingButton => 'ابدأ';

  @override
  String get doneBookingButton => 'تم';

  @override
  String get todayScheduleHeading => 'جدول اليوم';

  @override
  String get paymentMethodLabel => 'الدفع';

  @override
  String get paymentMethodCash => 'نقدًا';

  @override
  String get paymentMethodCard => 'بطاقة';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'احجز مرة أخرى';

  @override
  String get couldNotLoadCustomerProfile => 'تعذّر تحميل ملف العميل';

  @override
  String get notesSaved => 'تم حفظ الملاحظات';

  @override
  String get couldNotSaveNotes => 'تعذّر حفظ الملاحظات. حاول مرة أخرى.';

  @override
  String get statsVisitsLabel => 'الزيارات';

  @override
  String get statsTotalSpentLabel => 'إجمالي الإنفاق';

  @override
  String lastServiceSummary(String service, String date) {
    return 'الأخيرة: $service في $date';
  }

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get notesHint => 'التفضيلات، الحساسية، أي شيء يستحق التذكر';

  @override
  String get tagsLabel => 'الوسوم';

  @override
  String get addTagHint => 'أضف وسمًا';

  @override
  String get saveNotesButton => 'حفظ الملاحظات';

  @override
  String get visitHistoryHeading => 'سجل الزيارات';

  @override
  String get noVisitsYet => 'لا توجد زيارات بعد';

  @override
  String get viewProfileTooltip => 'عرض الملف الشخصي';

  @override
  String get dailyRevenueGoalLabel => 'هدف الإيراد اليومي';

  @override
  String get dailyRevenueGoalHint =>
      'اختياري — اتركه فارغًا لإخفاء شريط التقدم في الرئيسية';

  @override
  String get payoutsTooltip => 'المدفوعات';

  @override
  String get staffActiveLabel => 'نشط';

  @override
  String get canCancelBookingLabel => 'يمكنه إلغاء الحجوزات';

  @override
  String get couldNotLoadPayouts => 'تعذّر تحميل المدفوعات';

  @override
  String get payoutSettled => 'تم تسجيل الدفعة';

  @override
  String get couldNotMarkPaid => 'تعذّر التحديد كمدفوع. حاول مرة أخرى.';

  @override
  String get payoutsTitle => 'الأرباح والمدفوعات';

  @override
  String get unpaidLabel => 'غير مدفوع';

  @override
  String get markAsPaidButton => 'تحديد كمدفوع';

  @override
  String get grossRevenueLabel => 'الإيراد';

  @override
  String get totalPayoutLabel => 'الدفعة';

  @override
  String get payoutHistoryHeading => 'سجل المدفوعات';

  @override
  String get noPayoutsYet => 'لا توجد مدفوعات بعد';

  @override
  String get payTypeLabel => 'نوع الأجر';

  @override
  String get payTypeCommission => 'عمولة';

  @override
  String get payTypeSalary => 'راتب';

  @override
  String get payTypeBoth => 'كلاهما';

  @override
  String get commissionRateLabel => 'العمولة %';

  @override
  String get monthlySalaryLabel => 'الراتب الشهري';

  @override
  String get couldNotSavePayType => 'تعذّر حفظ إعدادات الأجر. حاول مرة أخرى.';

  @override
  String get salaryThisMonthLabel => 'راتب هذا الشهر';

  @override
  String get salaryPaidStatus => 'مدفوع';

  @override
  String get paySalaryButton => 'دفع الراتب';

  @override
  String get salaryPaid => 'تم دفع الراتب';

  @override
  String get couldNotPaySalary => 'تعذّر دفع الراتب. حاول مرة أخرى.';

  @override
  String get searchStaffHint => 'البحث عن الموظفين';

  @override
  String get filterActiveStaff => 'نشط';

  @override
  String get filterInactiveStaff => 'غير نشط';

  @override
  String get switchBranchTitle => 'تبديل الفرع';

  @override
  String get switchLabel => 'تبديل الفرع';

  @override
  String get allBranchesLabel => 'جميع الفروع';

  @override
  String get allBranchesSubtitle => 'الإجماليات المجمعة من كل فرع';

  @override
  String get pickBranchFirst => 'اختر فرعًا محددًا أولًا';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count مسجل · $revenue · $staff موظف';
  }

  @override
  String get dayOffLabel => 'إجازة';

  @override
  String get addBranchButton => 'إضافة فرع';

  @override
  String get addBranchTitle => 'إضافة فرع';

  @override
  String get branchNameAddressRequired => 'اسم الفرع وعنوانه مطلوبان';

  @override
  String get couldNotAddBranch => 'تعذّر إضافة الفرع. حاول مرة أخرى.';

  @override
  String get fillProductFields => 'يرجى ملء جميع حقول المنتج بشكل صحيح';

  @override
  String get couldNotSaveProduct => 'تعذّر حفظ المنتج. حاول مرة أخرى.';

  @override
  String get editProductTitle => 'تعديل المنتج';

  @override
  String get addProductTitle => 'إضافة منتج';

  @override
  String get productNameLabel => 'اسم المنتج';

  @override
  String get skuLabel => 'رمز المنتج (اختياري)';

  @override
  String get stockQtyLabel => 'المخزون';

  @override
  String get lowStockThresholdLabel => 'حد المخزون المنخفض';

  @override
  String get deleteProductButton => 'حذف المنتج';

  @override
  String get productsTitle => 'المنتجات';

  @override
  String get searchProductsHint => 'البحث عن المنتجات';

  @override
  String get filterLowStock => 'مخزون منخفض';

  @override
  String get noLowStockProducts => 'لا توجد منتجات بمخزون منخفض';

  @override
  String get noProductsInCatalog => 'لا توجد منتجات بعد';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count في المخزون',
      one: '1 في المخزون',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'مخزون منخفض';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج منخفض المخزون',
      one: 'منتج واحد منخفض المخزون',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'اليوم';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تسجيل $count مواعيد',
      one: 'تم تسجيل موعد واحد',
      zero: 'لم يتم تسجيل أي مواعيد بعد',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$current من هدف $goal';
  }

  @override
  String get worthReachingOutHeading => 'يستحق التواصل اليوم';

  @override
  String get exportCsvTooltip => 'تصدير CSV';

  @override
  String get couldNotExportEarnings => 'تعذّر تصدير الأرباح. حاول مرة أخرى.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days أيام متأخرة',
      one: 'يوم واحد متأخر',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer مع $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'طلب العميل $time';
  }

  @override
  String get reject => 'رفض';

  @override
  String get accept => 'قبول';

  @override
  String get confirm => 'تأكيد';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count أخرى';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'تعذر تحميل تفاصيل الحساب';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'أدخل المالك والهاتف واسم الصالون والعنوان';

  @override
  String get accountUpdated => 'تم تحديث الحساب';

  @override
  String get phoneOrEmailUsed => 'الهاتف أو البريد الإلكتروني مستخدم بالفعل';

  @override
  String get couldNotSaveAccount => 'تعذر حفظ تفاصيل الحساب';

  @override
  String get newPasswordMinLength =>
      'يجب أن تتكون كلمة المرور الجديدة من 6 أحرف على الأقل';

  @override
  String get newPasswordsDontMatch => 'كلمتا المرور الجديدتان غير متطابقتين';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور';

  @override
  String get currentPasswordIncorrect => 'كلمة المرور الحالية غير صحيحة';

  @override
  String get couldNotChangePassword => 'تعذر تغيير كلمة المرور';

  @override
  String get countryAndCurrency => 'الدولة والعملة';

  @override
  String get accountTitle => 'الحساب';

  @override
  String ownerSinceDate(String date) {
    return 'مالك منذ $date';
  }

  @override
  String planLabel(String plan) {
    return 'خطة $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'إحصاءات الاحتفاظ بالعملاء مجانية لمدة 6 أشهر';

  @override
  String get upgrade => 'ترقية';

  @override
  String get appearance => 'المظهر';

  @override
  String get salonProfile => 'ملف الصالون';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get locationUpdated => 'تم تحديث الموقع';

  @override
  String get saveDetailsButton => 'حفظ التفاصيل';

  @override
  String get savingEllipsis => 'جارٍ الحفظ...';

  @override
  String get security => 'الأمان';

  @override
  String get currentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordButton => 'تغيير كلمة المرور';

  @override
  String get changingEllipsis => 'جارٍ التغيير...';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get enterServiceNamePrice => 'أدخل اسم الخدمة وسعرها';

  @override
  String get fillStaffNamePhone => 'أدخل اسم الموظف وهاتفه';

  @override
  String get addAtLeastOneService => 'أضف خدمة واحدة على الأقل';

  @override
  String get enterValidOpenCloseTimes =>
      'أدخل أوقات فتح وإغلاق صحيحة (HH:MM، 24 ساعة)';

  @override
  String get selectAtLeastOneWorkingDay => 'اختر يوم عمل واحدًا على الأقل';

  @override
  String get staffPhoneInUse => 'رقم هاتف الموظف هذا مستخدم بالفعل';

  @override
  String get couldNotAddStaff => 'تعذر إضافة الموظف. حاول مرة أخرى.';

  @override
  String get addStaffSubtitle => 'أعدّ ملفه الشخصي وخدماته وأيام عمله.';

  @override
  String get staffNameLabel => 'اسم الموظف';

  @override
  String get staffPhoneLabel => 'هاتف الموظف';

  @override
  String get servicesLabel => 'الخدمات';

  @override
  String servicesAddedCount(int count) {
    return 'تمت إضافة $count';
  }

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get opens => 'يفتح';

  @override
  String get closes => 'يغلق';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'أيام العمل';

  @override
  String get serviceNameHint => 'اسم الخدمة';

  @override
  String get priceHint => 'السعر';

  @override
  String get dayMon => 'اثنين';

  @override
  String get dayTue => 'ثلاثاء';

  @override
  String get dayWed => 'أربعاء';

  @override
  String get dayThu => 'خميس';

  @override
  String get dayFri => 'جمعة';

  @override
  String get daySat => 'سبت';

  @override
  String get daySun => 'أحد';

  @override
  String get enterValidStaffNamePhone => 'أدخل اسم وهاتف موظف صحيحين';

  @override
  String get staffDetailsSaved => 'تم حفظ تفاصيل الموظف';

  @override
  String get phoneAlreadyInUse => 'هذا الهاتف مستخدم بالفعل';

  @override
  String get couldNotUpdateStaff => 'تعذر تحديث الموظف';

  @override
  String get enterServiceNameAndPriceShort => 'أدخل اسم الخدمة وسعرها';

  @override
  String get couldNotAddService => 'تعذر إضافة الخدمة';

  @override
  String get editServiceTitle => 'تعديل الخدمة';

  @override
  String get enterValidServiceNamePrice => 'أدخل اسم وسعر خدمة صحيحين';

  @override
  String get couldNotUpdateService => 'تعذر تحديث الخدمة';

  @override
  String get saveServiceButton => 'حفظ الخدمة';

  @override
  String get couldNotRemoveServiceDefault => 'تعذر إزالة الخدمة';

  @override
  String get useHHmmWorkingHours => 'استخدم HH:mm لساعات العمل';

  @override
  String get hoursAdded => 'تمت إضافة الساعات';

  @override
  String get couldNotAddWorkingHours => 'تعذر إضافة ساعات العمل';

  @override
  String get couldNotRemoveTiming => 'تعذر إزالة التوقيت';

  @override
  String get manageStaffTitle => 'إدارة الموظف';

  @override
  String get done => 'تم';

  @override
  String get manageStaffSubtitle =>
      'أضف أو عدّل أو احذف الخدمات والساعات، ثم اضغط تم.';

  @override
  String get saveStaffButton => 'حفظ الموظف';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get newServiceLabel => 'خدمة جديدة';

  @override
  String get addingEllipsis => 'جارٍ الإضافة...';

  @override
  String get addServiceButton => 'إضافة خدمة';

  @override
  String get noTimingsYet => 'لا توجد أوقات بعد';

  @override
  String get removeLabel => 'إزالة';

  @override
  String get startLabel => 'البداية';

  @override
  String get endLabel => 'النهاية';

  @override
  String get addMonSatHoursButton => 'إضافة ساعات الاثنين-السبت';

  @override
  String get saveHoursButton => 'حفظ الساعات';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'اختر الموظف والخدمة والتاريخ';

  @override
  String get noSlotsForDate => 'لا توجد مواعيد متاحة لهذا التاريخ.';

  @override
  String get couldNotLoadSlots => 'تعذر تحميل المواعيد';

  @override
  String get enterCustomerName => 'أدخل اسم العميل';

  @override
  String get chooseStaffAndService => 'اختر الموظف وخدمة واحدة على الأقل';

  @override
  String get enterCustomerPhone => 'أدخل هاتف العميل';

  @override
  String get chooseAvailableSlot => 'اختر موعدًا متاحًا';

  @override
  String get couldNotCreateBooking => 'تعذر إنشاء الحجز. حاول مرة أخرى.';

  @override
  String get doneServiceOption => 'الخدمة مكتملة';

  @override
  String get scheduleLaterOption => 'جدولة لاحقًا';

  @override
  String get customerNameLabel => 'اسم العميل';

  @override
  String get customerPhoneLabel => 'هاتف العميل';

  @override
  String recordedNowDate(String date) {
    return 'تم التسجيل الآن — $date';
  }

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'المواعيد المتاحة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get saveBooking => 'حفظ الحجز';

  @override
  String saveBookingWithTotal(String total) {
    return 'حفظ الحجز · $total';
  }

  @override
  String get addServiceTitle => 'إضافة خدمة';

  @override
  String get serviceNameLabel => 'اسم الخدمة';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get priceLabel => 'السعر';

  @override
  String get durationMinutesLabel => 'المدة (دقائق)';

  @override
  String get deleteServiceButton => 'حذف الخدمة';

  @override
  String get fillServiceFields => 'أدخل الاسم والفئة والسعر والمدة';

  @override
  String get couldNotSaveService => 'تعذر حفظ الخدمة';

  @override
  String get noServicesInCatalog => 'لا توجد خدمات بعد. أضف أول خدمة.';

  @override
  String get searchServicesHint => 'البحث عن الخدمات';

  @override
  String get filterAllCategories => 'الكل';

  @override
  String get assignToStaffLabel => 'تعيين لموظف';

  @override
  String get anyStaffOption => 'أي موظف';

  @override
  String get addStarterServicesButton => 'إضافة خدمات شائعة';

  @override
  String get bookingLinkSectionTitle => 'رابط الحجز';

  @override
  String get bookingLinkSectionSubtitle =>
      'شارك هذا الرابط أو رمز QR ليتمكن العملاء من الحجز عبر الإنترنت';

  @override
  String get copyLinkButton => 'نسخ';

  @override
  String get shareLinkButton => 'مشاركة';

  @override
  String get linkCopied => 'تم نسخ الرابط';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return 'احجز في $salonName: $link';
  }
}
