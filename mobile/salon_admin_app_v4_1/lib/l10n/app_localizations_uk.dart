// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get insightsTitle => 'Аналітика';

  @override
  String get tabEarnings => 'Дохід';

  @override
  String get tabRetention => 'Утримання';

  @override
  String get periodToday => 'Сьогодні';

  @override
  String get periodWeek => 'Тиждень';

  @override
  String get periodMonth => 'Місяць';

  @override
  String get periodLast7Days => 'Останні 7 днів';

  @override
  String get periodLast30Days => 'Останні 30 днів';

  @override
  String get earningsLoadError => 'Не вдалося завантажити дохід.';

  @override
  String get retry => 'Повторити';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count послуги',
      many: '$count послуг',
      few: '$count послуги',
      one: '$count послуга',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Завершені послуги';

  @override
  String get noCompletedServices => 'За цей період ще немає завершених послуг.';

  @override
  String get topServicesHeading => 'Топ послуг';

  @override
  String get byStaffHeading => 'За персоналом';

  @override
  String get vsYesterday => 'порівняно з учора';

  @override
  String get vsLastWeek => 'порівняно з минулим тижнем';

  @override
  String get vsLastMonth => 'порівняно з минулим місяцем';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Повернені клієнти';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count клієнта повернулося цього місяця',
      many: '$count клієнтів повернулося цього місяця',
      few: '$count клієнти повернулися цього місяця',
      one: '$count клієнт повернувся цього місяця',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Не вдалося завантажити звіт про утримання.';

  @override
  String get couldNotOpenWhatsapp => 'Не вдалося відкрити WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Привіт, $name! Ми сумуємо за тобою в $salonName. Забронюй наступний візит і скористайся спеціальною пропозицією повернення. До зустрічі!';
  }

  @override
  String get customerCohortsHeading => 'Групи клієнтів';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count клієнтів';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Немає клієнтів «$label» за цей період.';
  }

  @override
  String get missedCustomersHeading => 'Пропущені клієнти';

  @override
  String get missedCustomersHint =>
      'Натисніть «Нагадати», щоб надіслати повідомлення у WhatsApp.';

  @override
  String get noMissedCustomers => 'Цього місяця немає пропущених клієнтів.';

  @override
  String get cohortRegulars => 'Постійні';

  @override
  String get cohortNew => 'Нові';

  @override
  String get cohortCameBack => 'Повернулися';

  @override
  String get cohortStoppedComing => 'Перестали приходити';

  @override
  String get customersLabel => 'клієнти';

  @override
  String get reachOutNow => 'Зв\'язатися зараз';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count постійних клієнтів зменшуються · $revenue під загрозою';
  }

  @override
  String overdueBadge(String ratio) {
    return 'прострочено на $ratio×';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Зазвичай кожні $cadence дн. · прострочка $overdue дн.';
  }

  @override
  String get remind => 'Нагадати';

  @override
  String get remindOnWhatsappTooltip => 'Нагадати через WhatsApp';

  @override
  String get retentionProTitle => 'Аналітика утримання — функція PRO';

  @override
  String get retentionProBody =>
      'Дізнайтеся, хто перестав приходити, співвідношення нових і постійних клієнтів, і поверніть втрачених клієнтів нагадуваннями в один дотик.';

  @override
  String get upgradeToPro => 'Перейти на PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits візитів · витрачено $spend';
  }

  @override
  String get createYourAccount => 'Створіть обліковий запис';

  @override
  String get basics => 'Основне';

  @override
  String get country => 'Країна';

  @override
  String get countryHelperText =>
      'Визначає вашу валюту, формат телефону та мову за замовчуванням.';

  @override
  String get language => 'Мова';

  @override
  String get phoneNumberLabel => 'Номер телефону';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String stepOfTotal(int step, int total) {
    return 'Крок $step з $total';
  }

  @override
  String get createAccountButton => 'Створити обліковий запис';

  @override
  String get continueButton => 'Продовжити';

  @override
  String get enterPhoneNumber => 'Введіть номер телефону';

  @override
  String get passwordMinLength => 'Пароль має містити щонайменше 6 символів';

  @override
  String get fillOwnerSalonAddress =>
      'Вкажіть ім\'я власника, назву салону та адресу';

  @override
  String get turnOnLocationPermission =>
      'Увімкніть геолокацію та дозвольте доступ, щоб скористатися цим';

  @override
  String get couldNotGetLocation =>
      'Не вдалося визначити ваше місцезнаходження';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Цей телефон уже зареєстровано. Будь ласка, увійдіть у систему.';

  @override
  String get signupFailedCheckBackend =>
      'Реєстрація не вдалася. Перевірте з\'єднання із сервером.';

  @override
  String get signupFailedTryAgain => 'Реєстрація не вдалася. Спробуйте ще раз.';

  @override
  String get yourSalon => 'Ваш салон';

  @override
  String get salonDetailsSubtitle => 'Крок 2 з 3 · Дані салону';

  @override
  String get ownerNameLabel => 'Ім\'я власника';

  @override
  String get salonNameLabel => 'Назва салону';

  @override
  String get salonAddressLabel => 'Адреса салону';

  @override
  String get locationSet => 'Місцезнаходження встановлено';

  @override
  String get useMyCurrentLocation => 'Використати моє поточне місцезнаходження';

  @override
  String get pickYourColor => 'Виберіть колір';

  @override
  String get colorPreviewHelp =>
      'Це акцентний колір вашого салону в усьому додатку. Змінюйте будь-коли в розділі «Обліковий запис».';

  @override
  String get previewLabel => 'Попередній перегляд';

  @override
  String get newBooking => 'Новий запис';

  @override
  String get colorTeal => 'Бірюзовий';

  @override
  String get colorTerracotta => 'Теракотовий';

  @override
  String get colorBlue => 'Синій';

  @override
  String get colorViolet => 'Фіолетовий';

  @override
  String get colorRose => 'Рожевий';

  @override
  String get welcomeBack => 'З поверненням';

  @override
  String get signInToDashboard => 'Увійдіть до панелі керування салоном';

  @override
  String get enterSalonOwnerPhone => 'Введіть телефон власника салону';

  @override
  String get enterYourPassword => 'Введіть пароль';

  @override
  String get noSalonOwnerFound =>
      'Не знайдено обліковий запис власника салону для цього телефону.';

  @override
  String get loginFailedCheckBackend =>
      'Вхід не вдався. Перевірте з\'єднання із сервером.';

  @override
  String get loginFailedTryAgain => 'Вхід не вдався. Спробуйте ще раз.';

  @override
  String get hidePassword => 'Приховати пароль';

  @override
  String get showPassword => 'Показати пароль';

  @override
  String get signIn => 'Увійти';

  @override
  String get newHere => 'Вперше тут?';

  @override
  String get createAccount => 'Створити обліковий запис';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get resetPasswordTitle => 'Скидання пароля';

  @override
  String get resetPasswordEnterPhone =>
      'Введіть номер телефону, і ми надішлемо 6-значний код через WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Надіслати код через WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Якщо такий обліковий запис існує, код надіслано через WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Введіть код, надісланий у WhatsApp, потім оберіть новий пароль.';

  @override
  String get otpCodeLabel => '6-значний код';

  @override
  String get resetPasswordButton => 'Скинути пароль';

  @override
  String get resendCode => 'Надіслати код повторно';

  @override
  String get changePhoneNumber => 'Змінити номер телефону';

  @override
  String get enterSixDigitCode => 'Введіть 6-значний код';

  @override
  String get passwordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get passwordResetSuccess =>
      'Пароль скинуто. Будь ласка, увійдіть із новим паролем.';

  @override
  String get waitBeforeRetryingCode =>
      'Зачекайте хвилину, перш ніж запитати інший код';

  @override
  String get invalidOrExpiredCode =>
      'Цей код недійсний або термін його дії минув';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Забагато спроб — запросіть новий код';

  @override
  String get continueWithGoogle => 'Продовжити з Google';

  @override
  String get signedInWithGoogle => 'Вхід виконано через Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Вхід виконано через Google як $email';
  }

  @override
  String get usePasswordInstead => 'Використати пароль натомість';

  @override
  String get googleSignInNotConfigured => 'Вхід через Google ще не налаштовано';

  @override
  String get googleSignInFailed =>
      'Не вдалося увійти через Google. Спробуйте ще раз.';

  @override
  String get googleNoAccountFound =>
      'Обліковий запис для цього облікового запису Google не знайдено. Спочатку створіть його.';

  @override
  String get linkGoogleAccount => 'Прив\'язати обліковий запис Google';

  @override
  String get googleAccountLinked =>
      'Обліковий запис Google прив\'язано — тепер ви можете входити з ним';

  @override
  String get addStaffBeforeBookings =>
      'Додайте активних співробітників перед створенням записів';

  @override
  String get salonLabel => 'Салон';

  @override
  String get statToday => 'Сьогодні';

  @override
  String get statRepeat => 'Повторні';

  @override
  String get statLoggedHelper => 'записано';

  @override
  String get statBackHelper => 'повернулися';

  @override
  String get statWeek => 'Тиждень';

  @override
  String get statMonth => 'Місяць';

  @override
  String get loggedTodayHeading => 'Записано сьогодні';

  @override
  String get nothingLoggedToday =>
      'Сьогодні ще нічого не записано. Натисніть «Новий запис», коли послугу завершено.';

  @override
  String get navHome => 'Головна';

  @override
  String get navBookings => 'Записи';

  @override
  String get navStaff => 'Персонал';

  @override
  String get navInsights => 'Аналітика';

  @override
  String get navAccount => 'Обліковий запис';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'До цього облікового запису власника ще не прив\'язано салон.';

  @override
  String get bookingsTitle => 'Записи';

  @override
  String get searchCustomerOrService => 'Пошук клієнта або послуги';

  @override
  String get filterThisWeek => 'Цього тижня';

  @override
  String get filterAllTime => 'За весь час';

  @override
  String get filterAllStaff => 'Весь персонал';

  @override
  String get staffLabel => 'Персонал';

  @override
  String get needsActionHeading => 'Потребує дії';

  @override
  String get statTotal => 'Разом';

  @override
  String get statServices => 'Послуги';

  @override
  String get statAvgTicket => 'Середній чек';

  @override
  String get noBookingsMatchFilter =>
      'Немає записів, що відповідають цьому фільтру';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Вчора';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count послуги',
      many: '$count послуг',
      few: '$count послуги',
      one: '$count послуга',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Не вдалося відкрити магазин';

  @override
  String get updateRequired => 'Потрібне оновлення';

  @override
  String get updateRequiredBody =>
      'Доступна нова версія додатка. Оновіть, щоб продовжити користуватися панеллю керування салоном.';

  @override
  String get updateNow => 'Оновити зараз';

  @override
  String get themeColorTitle => 'Колір теми';

  @override
  String get save => 'Зберегти';

  @override
  String get staffTitle => 'Персонал';

  @override
  String get addStaff => 'Додати співробітника';

  @override
  String get statActive => 'Активні';

  @override
  String get statTodaysTotal => 'Разом сьогодні';

  @override
  String get noActiveStaffYet => 'Поки немає активного персоналу';

  @override
  String get addFirstStaff => 'Додати першого співробітника';

  @override
  String get noServicesYet => 'Поки немає послуг';

  @override
  String get notActive => 'Неактивний';

  @override
  String get canSetOwnPrice => 'Може встановлювати власну ціну';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count послуги',
      many: '$count послуг',
      few: '$count послуги',
      one: '$count послуга',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Новий';

  @override
  String get serviceLabel => 'Послуга';

  @override
  String get customerLabel => 'Клієнт';

  @override
  String get repeatLabel => 'Повторний';

  @override
  String get couldNotUpdateBooking =>
      'Не вдалося оновити запис. Спробуйте ще раз.';

  @override
  String get couldNotAcceptReschedule =>
      'Не вдалося прийняти перенесення. Спробуйте ще раз.';

  @override
  String get couldNotRejectReschedule =>
      'Не вдалося відхилити перенесення. Спробуйте ще раз.';

  @override
  String get rescheduleLabel => 'Перенести';

  @override
  String get pendingLabel => 'Очікує';

  @override
  String get scheduledLabel => 'Заплановано';

  @override
  String get inProgressLabel => 'У процесі';

  @override
  String get startBookingButton => 'Почати';

  @override
  String get doneBookingButton => 'Готово';

  @override
  String get todayScheduleHeading => 'Розклад на сьогодні';

  @override
  String get paymentMethodLabel => 'Оплата';

  @override
  String get paymentMethodCash => 'Готівка';

  @override
  String get paymentMethodCard => 'Картка';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'Забронювати знову';

  @override
  String get couldNotLoadCustomerProfile =>
      'Не вдалося завантажити профіль клієнта';

  @override
  String get notesSaved => 'Нотатки збережено';

  @override
  String get couldNotSaveNotes =>
      'Не вдалося зберегти нотатки. Спробуйте ще раз.';

  @override
  String get statsVisitsLabel => 'Візити';

  @override
  String get statsTotalSpentLabel => 'Всього витрачено';

  @override
  String lastServiceSummary(String service, String date) {
    return 'Останній: $service, $date';
  }

  @override
  String get notesLabel => 'Нотатки';

  @override
  String get notesHint => 'Уподобання, алергії, все варте уваги';

  @override
  String get tagsLabel => 'Теги';

  @override
  String get addTagHint => 'Додати тег';

  @override
  String get saveNotesButton => 'Зберегти нотатки';

  @override
  String get visitHistoryHeading => 'Історія візитів';

  @override
  String get noVisitsYet => 'Поки що немає візитів';

  @override
  String get viewProfileTooltip => 'Переглянути профіль';

  @override
  String get dailyRevenueGoalLabel => 'Денна ціль доходу';

  @override
  String get dailyRevenueGoalHint =>
      'Необов\'язково — залиште порожнім, щоб приховати індикатор прогресу на головній';

  @override
  String get payoutsTooltip => 'Виплати';

  @override
  String get staffActiveLabel => 'Активний';

  @override
  String get canCancelBookingLabel => 'Може скасовувати записи';

  @override
  String get couldNotLoadPayouts => 'Не вдалося завантажити виплати';

  @override
  String get payoutSettled => 'Виплату зафіксовано';

  @override
  String get couldNotMarkPaid =>
      'Не вдалося позначити як оплачено. Спробуйте ще раз.';

  @override
  String get payoutsTitle => 'Дохід і виплати';

  @override
  String get unpaidLabel => 'Не виплачено';

  @override
  String get markAsPaidButton => 'Позначити як оплачено';

  @override
  String get grossRevenueLabel => 'Дохід';

  @override
  String get totalPayoutLabel => 'Виплата';

  @override
  String get payoutHistoryHeading => 'Історія виплат';

  @override
  String get noPayoutsYet => 'Поки що немає виплат';

  @override
  String get payTypeLabel => 'Тип оплати';

  @override
  String get payTypeCommission => 'Комісія';

  @override
  String get payTypeSalary => 'Оклад';

  @override
  String get payTypeBoth => 'Обидва';

  @override
  String get commissionRateLabel => 'Комісія %';

  @override
  String get monthlySalaryLabel => 'Місячний оклад';

  @override
  String get couldNotSavePayType =>
      'Не вдалося зберегти налаштування оплати. Спробуйте ще раз.';

  @override
  String get salaryThisMonthLabel => 'Оклад за цей місяць';

  @override
  String get salaryPaidStatus => 'Оплачено';

  @override
  String get paySalaryButton => 'Виплатити оклад';

  @override
  String get salaryPaid => 'Оклад виплачено';

  @override
  String get couldNotPaySalary =>
      'Не вдалося виплатити оклад. Спробуйте ще раз.';

  @override
  String get searchStaffHint => 'Пошук персоналу';

  @override
  String get filterActiveStaff => 'Активні';

  @override
  String get filterInactiveStaff => 'Неактивні';

  @override
  String get switchBranchTitle => 'Змінити філію';

  @override
  String get switchLabel => 'Змінити філію';

  @override
  String get allBranchesLabel => 'Усі філії';

  @override
  String get allBranchesSubtitle => 'Загальні підсумки з усіх філій';

  @override
  String get pickBranchFirst => 'Спершу оберіть конкретну філію';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count записано · $revenue · $staff персоналу';
  }

  @override
  String get dayOffLabel => 'Вихідний';

  @override
  String get addBranchButton => 'Додати філію';

  @override
  String get addBranchTitle => 'Додати філію';

  @override
  String get branchNameAddressRequired => 'Назва та адреса філії обов\'язкові';

  @override
  String get couldNotAddBranch => 'Не вдалося додати філію. Спробуйте ще раз.';

  @override
  String get fillProductFields => 'Заповніть коректно всі поля товару';

  @override
  String get couldNotSaveProduct =>
      'Не вдалося зберегти товар. Спробуйте ще раз.';

  @override
  String get editProductTitle => 'Редагувати товар';

  @override
  String get addProductTitle => 'Додати товар';

  @override
  String get productNameLabel => 'Назва товару';

  @override
  String get skuLabel => 'Артикул (необов\'язково)';

  @override
  String get stockQtyLabel => 'Залишок';

  @override
  String get lowStockThresholdLabel => 'Низький залишок при';

  @override
  String get deleteProductButton => 'Видалити товар';

  @override
  String get productsTitle => 'Товари';

  @override
  String get searchProductsHint => 'Пошук товарів';

  @override
  String get filterLowStock => 'Низький залишок';

  @override
  String get noLowStockProducts => 'Немає товарів з низьким залишком';

  @override
  String get noProductsInCatalog => 'Поки що немає товарів';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count в наявності',
      many: '$count в наявності',
      few: '$count в наявності',
      one: '1 в наявності',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'Низький залишок';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товару мають низький залишок',
      many: '$count товарів мають низький залишок',
      few: '$count товари мають низький залишок',
      one: '1 товар має низький залишок',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'Сьогодні';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count візиту записано',
      many: '$count візитів записано',
      few: '$count візити записано',
      one: '1 візит записано',
      zero: 'Поки що немає записаних візитів',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$current з цілі $goal';
  }

  @override
  String get worthReachingOutHeading => 'Варто зв\'язатися сьогодні';

  @override
  String get exportCsvTooltip => 'Експорт CSV';

  @override
  String get couldNotExportEarnings =>
      'Не вдалося експортувати дохід. Спробуйте ще раз.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'прострочка $days дня',
      many: 'прострочка $days днів',
      few: 'прострочка $days дні',
      one: 'прострочка 1 день',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer у $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Клієнт запросив $time';
  }

  @override
  String get reject => 'Відхилити';

  @override
  String get accept => 'Прийняти';

  @override
  String get confirm => 'Підтвердити';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + ще $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount =>
      'Не вдалося завантажити дані облікового запису';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Вкажіть власника, телефон, назву салону та адресу';

  @override
  String get accountUpdated => 'Обліковий запис оновлено';

  @override
  String get phoneOrEmailUsed => 'Телефон або e-mail уже використовується';

  @override
  String get couldNotSaveAccount =>
      'Не вдалося зберегти дані облікового запису';

  @override
  String get newPasswordMinLength =>
      'Новий пароль має містити щонайменше 6 символів';

  @override
  String get newPasswordsDontMatch => 'Нові паролі не збігаються';

  @override
  String get passwordChanged => 'Пароль змінено';

  @override
  String get currentPasswordIncorrect => 'Поточний пароль неправильний';

  @override
  String get couldNotChangePassword => 'Не вдалося змінити пароль';

  @override
  String get countryAndCurrency => 'Країна і валюта';

  @override
  String get accountTitle => 'Обліковий запис';

  @override
  String ownerSinceDate(String date) {
    return 'Власник з $date';
  }

  @override
  String planLabel(String plan) {
    return 'Тариф $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Аналітика утримання безкоштовно на 6 місяців';

  @override
  String get upgrade => 'Покращити';

  @override
  String get appearance => 'Вигляд';

  @override
  String get salonProfile => 'Профіль салону';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get locationUpdated => 'Місцезнаходження оновлено';

  @override
  String get saveDetailsButton => 'Зберегти дані';

  @override
  String get savingEllipsis => 'Збереження...';

  @override
  String get security => 'Безпека';

  @override
  String get currentPasswordLabel => 'Поточний пароль';

  @override
  String get newPasswordLabel => 'Новий пароль';

  @override
  String get confirmNewPasswordLabel => 'Підтвердіть новий пароль';

  @override
  String get changePasswordButton => 'Змінити пароль';

  @override
  String get changingEllipsis => 'Зміна...';

  @override
  String get signOut => 'Вийти';

  @override
  String get enterServiceNamePrice => 'Введіть назву та ціну послуги';

  @override
  String get fillStaffNamePhone => 'Вкажіть ім\'я та телефон співробітника';

  @override
  String get addAtLeastOneService => 'Додайте принаймні одну послугу';

  @override
  String get enterValidOpenCloseTimes =>
      'Введіть коректний час відкриття та закриття (ГГ:ХХ, 24 години)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Виберіть принаймні один робочий день';

  @override
  String get staffPhoneInUse =>
      'Цей телефон співробітника вже використовується';

  @override
  String get couldNotAddStaff =>
      'Не вдалося додати співробітника. Спробуйте ще раз.';

  @override
  String get addStaffSubtitle => 'Налаштуйте профіль, послуги та робочі дні.';

  @override
  String get staffNameLabel => 'Ім\'я співробітника';

  @override
  String get staffPhoneLabel => 'Телефон співробітника';

  @override
  String get servicesLabel => 'Послуги';

  @override
  String servicesAddedCount(int count) {
    return 'Додано: $count';
  }

  @override
  String get workingHours => 'Робочі години';

  @override
  String get opens => 'Відкриття';

  @override
  String get closes => 'Закриття';

  @override
  String get hhmmHint => 'ГГ:ХХ';

  @override
  String get workingDays => 'Робочі дні';

  @override
  String get serviceNameHint => 'Назва послуги';

  @override
  String get priceHint => 'Ціна';

  @override
  String get dayMon => 'Пн';

  @override
  String get dayTue => 'Вт';

  @override
  String get dayWed => 'Ср';

  @override
  String get dayThu => 'Чт';

  @override
  String get dayFri => 'Пт';

  @override
  String get daySat => 'Сб';

  @override
  String get daySun => 'Нд';

  @override
  String get enterValidStaffNamePhone =>
      'Введіть коректне ім\'я та телефон співробітника';

  @override
  String get staffDetailsSaved => 'Дані співробітника збережено';

  @override
  String get phoneAlreadyInUse => 'Цей телефон уже використовується';

  @override
  String get couldNotUpdateStaff => 'Не вдалося оновити співробітника';

  @override
  String get enterServiceNameAndPriceShort => 'Введіть назву та ціну послуги';

  @override
  String get couldNotAddService => 'Не вдалося додати послугу';

  @override
  String get editServiceTitle => 'Редагувати послугу';

  @override
  String get enterValidServiceNamePrice =>
      'Введіть коректну назву та ціну послуги';

  @override
  String get couldNotUpdateService => 'Не вдалося оновити послугу';

  @override
  String get saveServiceButton => 'Зберегти послугу';

  @override
  String get couldNotRemoveServiceDefault => 'Не вдалося видалити послугу';

  @override
  String get useHHmmWorkingHours => 'Використовуйте ГГ:хх для робочих годин';

  @override
  String get hoursAdded => 'Години додано';

  @override
  String get couldNotAddWorkingHours => 'Не вдалося додати робочі години';

  @override
  String get couldNotRemoveTiming => 'Не вдалося видалити час';

  @override
  String get manageStaffTitle => 'Керування співробітником';

  @override
  String get done => 'Готово';

  @override
  String get manageStaffSubtitle =>
      'Додавайте, редагуйте або видаляйте послуги й години, потім натисніть «Готово».';

  @override
  String get saveStaffButton => 'Зберегти співробітника';

  @override
  String get edit => 'Редагувати';

  @override
  String get delete => 'Видалити';

  @override
  String get newServiceLabel => 'Нова послуга';

  @override
  String get addingEllipsis => 'Додавання...';

  @override
  String get addServiceButton => 'Додати послугу';

  @override
  String get noTimingsYet => 'Поки немає розкладу';

  @override
  String get removeLabel => 'Видалити';

  @override
  String get startLabel => 'Початок';

  @override
  String get endLabel => 'Кінець';

  @override
  String get addMonSatHoursButton => 'Додати години Пн-Сб';

  @override
  String get saveHoursButton => 'Зберегти години';

  @override
  String get hhmmLowerHint => 'ГГ:хх';

  @override
  String get chooseStaffServiceDate =>
      'Виберіть співробітника, послугу та дату';

  @override
  String get noSlotsForDate => 'Немає доступних слотів на цю дату.';

  @override
  String get couldNotLoadSlots => 'Не вдалося завантажити слоти';

  @override
  String get enterCustomerName => 'Введіть ім\'я клієнта';

  @override
  String get chooseStaffAndService =>
      'Виберіть співробітника та принаймні одну послугу';

  @override
  String get enterCustomerPhone => 'Введіть телефон клієнта';

  @override
  String get chooseAvailableSlot => 'Виберіть доступний слот';

  @override
  String get couldNotCreateBooking =>
      'Не вдалося створити запис. Спробуйте ще раз.';

  @override
  String get doneServiceOption => 'Послугу виконано';

  @override
  String get scheduleLaterOption => 'Запланувати пізніше';

  @override
  String get customerNameLabel => 'Ім\'я клієнта';

  @override
  String get customerPhoneLabel => 'Телефон клієнта';

  @override
  String recordedNowDate(String date) {
    return 'Записано зараз — $date';
  }

  @override
  String get dateLabel => 'Дата';

  @override
  String get yyyymmddHint => 'РРРР-ММ-ДД';

  @override
  String get availableSlots => 'Доступні слоти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get saveBooking => 'Зберегти запис';

  @override
  String saveBookingWithTotal(String total) {
    return 'Зберегти запис · $total';
  }

  @override
  String get addServiceTitle => 'Додати послугу';

  @override
  String get serviceNameLabel => 'Назва послуги';

  @override
  String get categoryLabel => 'Категорія';

  @override
  String get priceLabel => 'Ціна';

  @override
  String get durationMinutesLabel => 'Тривалість (хв)';

  @override
  String get deleteServiceButton => 'Видалити послугу';

  @override
  String get fillServiceFields => 'Введіть назву, категорію, ціну і тривалість';

  @override
  String get couldNotSaveService => 'Не вдалося зберегти послугу';

  @override
  String get noServicesInCatalog => 'Ще немає послуг. Додайте першу.';

  @override
  String get searchServicesHint => 'Пошук послуг';

  @override
  String get filterAllCategories => 'Усі';

  @override
  String get assignToStaffLabel => 'Призначити співробітнику';

  @override
  String get anyStaffOption => 'Будь-який співробітник';

  @override
  String get addStarterServicesButton => 'Додати популярні послуги';

  @override
  String get bookingLinkSectionTitle => 'Посилання для запису';

  @override
  String get bookingLinkSectionSubtitle =>
      'Поділіться цим посиланням або QR-кодом, щоб клієнти могли записатися онлайн';

  @override
  String get copyLinkButton => 'Копіювати';

  @override
  String get shareLinkButton => 'Поділитися';

  @override
  String get linkCopied => 'Посилання скопійовано';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return 'Запис у $salonName: $link';
  }
}
