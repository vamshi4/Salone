// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get insightsTitle => 'Аналитика';

  @override
  String get tabEarnings => 'Доходы';

  @override
  String get tabRetention => 'Удержание';

  @override
  String get periodToday => 'Сегодня';

  @override
  String get periodWeek => 'Неделя';

  @override
  String get periodMonth => 'Месяц';

  @override
  String get periodLast7Days => 'Последние 7 дней';

  @override
  String get periodLast30Days => 'Последние 30 дней';

  @override
  String get earningsLoadError => 'Не удалось загрузить доходы.';

  @override
  String get retry => 'Повторить';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count услуги',
      many: '$count услуг',
      few: '$count услуги',
      one: '$count услуга',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Завершённые услуги';

  @override
  String get noCompletedServices =>
      'За этот период пока нет завершённых услуг.';

  @override
  String get topServicesHeading => 'Топ услуг';

  @override
  String get byStaffHeading => 'По сотрудникам';

  @override
  String get vsYesterday => 'по сравнению со вчера';

  @override
  String get vsLastWeek => 'по сравнению с прошлой неделей';

  @override
  String get vsLastMonth => 'по сравнению с прошлым месяцем';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Возвращённые клиенты';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count клиента вернулось в этом месяце',
      many: '$count клиентов вернулось в этом месяце',
      few: '$count клиента вернулось в этом месяце',
      one: '$count клиент вернулся в этом месяце',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Не удалось загрузить отчёт по удержанию.';

  @override
  String get couldNotOpenWhatsapp => 'Не удалось открыть WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Привет, $name! Мы скучаем по тебе в $salonName. Забронируй следующий визит и получи специальное приветственное предложение. До скорой встречи!';
  }

  @override
  String get customerCohortsHeading => 'Группы клиентов';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count клиентов';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Нет клиентов «$label» за этот период.';
  }

  @override
  String get missedCustomersHeading => 'Пропавшие клиенты';

  @override
  String get missedCustomersHint =>
      'Нажмите «Напомнить», чтобы отправить сообщение в WhatsApp.';

  @override
  String get noMissedCustomers => 'В этом месяце нет пропавших клиентов.';

  @override
  String get cohortRegulars => 'Постоянные';

  @override
  String get cohortNew => 'Новые';

  @override
  String get cohortCameBack => 'Вернулись';

  @override
  String get cohortStoppedComing => 'Перестали приходить';

  @override
  String get customersLabel => 'клиенты';

  @override
  String get reachOutNow => 'Связаться сейчас';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count постоянных клиентов уходят · $revenue под угрозой';
  }

  @override
  String overdueBadge(String ratio) {
    return 'просрочено в $ratio×';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Обычно каждые $cadence дн. · просрочка $overdue дн.';
  }

  @override
  String get remind => 'Напомнить';

  @override
  String get remindOnWhatsappTooltip => 'Напомнить через WhatsApp';

  @override
  String get retentionProTitle => 'Аналитика удержания — функция PRO';

  @override
  String get retentionProBody =>
      'Узнайте, кто перестал приходить, соотношение новых и вернувшихся клиентов, и верните потерянных клиентов напоминаниями в один клик.';

  @override
  String get upgradeToPro => 'Перейти на PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits визитов · потрачено $spend';
  }

  @override
  String get createYourAccount => 'Создайте аккаунт';

  @override
  String get basics => 'Основное';

  @override
  String get country => 'Страна';

  @override
  String get countryHelperText =>
      'Определяет валюту, формат телефона и язык по умолчанию.';

  @override
  String get language => 'Язык';

  @override
  String get phoneNumberLabel => 'Номер телефона';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String stepOfTotal(int step, int total) {
    return 'Шаг $step из $total';
  }

  @override
  String get createAccountButton => 'Создать аккаунт';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get enterPhoneNumber => 'Введите номер телефона';

  @override
  String get passwordMinLength => 'Пароль должен содержать не менее 6 символов';

  @override
  String get fillOwnerSalonAddress =>
      'Укажите имя владельца, название салона и адрес';

  @override
  String get turnOnLocationPermission =>
      'Включите геолокацию и разрешите доступ, чтобы использовать эту функцию';

  @override
  String get couldNotGetLocation => 'Не удалось определить местоположение';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Этот телефон уже зарегистрирован. Пожалуйста, войдите в систему.';

  @override
  String get signupFailedCheckBackend =>
      'Регистрация не удалась. Проверьте соединение с сервером.';

  @override
  String get signupFailedTryAgain =>
      'Регистрация не удалась. Попробуйте ещё раз.';

  @override
  String get yourSalon => 'Ваш салон';

  @override
  String get salonDetailsSubtitle => 'Шаг 2 из 3 · Данные салона';

  @override
  String get ownerNameLabel => 'Имя владельца';

  @override
  String get salonNameLabel => 'Название салона';

  @override
  String get salonAddressLabel => 'Адрес салона';

  @override
  String get locationSet => 'Местоположение установлено';

  @override
  String get useMyCurrentLocation => 'Использовать текущее местоположение';

  @override
  String get pickYourColor => 'Выберите цвет';

  @override
  String get colorPreviewHelp =>
      'Это акцентный цвет вашего салона во всём приложении. Изменить можно в любое время в разделе «Аккаунт».';

  @override
  String get previewLabel => 'Предпросмотр';

  @override
  String get newBooking => 'Новая запись';

  @override
  String get colorTeal => 'Бирюзовый';

  @override
  String get colorTerracotta => 'Терракотовый';

  @override
  String get colorBlue => 'Синий';

  @override
  String get colorViolet => 'Фиолетовый';

  @override
  String get colorRose => 'Розовый';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get signInToDashboard => 'Войдите в панель управления салоном';

  @override
  String get enterSalonOwnerPhone => 'Введите телефон владельца салона';

  @override
  String get enterYourPassword => 'Введите пароль';

  @override
  String get noSalonOwnerFound =>
      'Не найден аккаунт владельца салона для этого телефона.';

  @override
  String get loginFailedCheckBackend =>
      'Вход не удался. Проверьте соединение с сервером.';

  @override
  String get loginFailedTryAgain => 'Вход не удался. Попробуйте ещё раз.';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get newHere => 'Впервые здесь?';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get resetPasswordTitle => 'Сброс пароля';

  @override
  String get resetPasswordEnterPhone =>
      'Введите номер телефона, и мы отправим 6-значный код через WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Отправить код через WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Если такой аккаунт существует, код был отправлен через WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Введите код, отправленный в WhatsApp, затем выберите новый пароль.';

  @override
  String get otpCodeLabel => '6-значный код';

  @override
  String get resetPasswordButton => 'Сбросить пароль';

  @override
  String get resendCode => 'Отправить код повторно';

  @override
  String get changePhoneNumber => 'Изменить номер телефона';

  @override
  String get enterSixDigitCode => 'Введите 6-значный код';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get passwordResetSuccess =>
      'Пароль сброшен. Пожалуйста, войдите с новым паролем.';

  @override
  String get waitBeforeRetryingCode =>
      'Подождите минуту, прежде чем запросить другой код';

  @override
  String get invalidOrExpiredCode => 'Этот код недействителен или истёк';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Слишком много попыток — запросите новый код';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get signedInWithGoogle => 'Вход выполнен через Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Вход выполнен через Google как $email';
  }

  @override
  String get usePasswordInstead => 'Использовать пароль вместо этого';

  @override
  String get googleSignInNotConfigured => 'Вход через Google ещё не настроен';

  @override
  String get googleSignInFailed =>
      'Не удалось войти через Google. Попробуйте ещё раз.';

  @override
  String get googleNoAccountFound =>
      'Аккаунт для этого Google-аккаунта не найден. Сначала создайте его.';

  @override
  String get linkGoogleAccount => 'Привязать аккаунт Google';

  @override
  String get googleAccountLinked =>
      'Аккаунт Google привязан — теперь вы можете входить с его помощью';

  @override
  String get addStaffBeforeBookings =>
      'Добавьте активных сотрудников перед созданием записей';

  @override
  String get salonLabel => 'Салон';

  @override
  String get statToday => 'Сегодня';

  @override
  String get statRepeat => 'Повторные';

  @override
  String get statLoggedHelper => 'записано';

  @override
  String get statBackHelper => 'вернулись';

  @override
  String get statWeek => 'Неделя';

  @override
  String get statMonth => 'Месяц';

  @override
  String get loggedTodayHeading => 'Записано сегодня';

  @override
  String get nothingLoggedToday =>
      'Сегодня пока ничего не записано. Нажмите «Новая запись», когда услуга будет завершена.';

  @override
  String get navHome => 'Главная';

  @override
  String get navBookings => 'Записи';

  @override
  String get navStaff => 'Персонал';

  @override
  String get navInsights => 'Аналитика';

  @override
  String get navAccount => 'Аккаунт';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'К этому аккаунту владельца пока не привязан салон.';

  @override
  String get bookingsTitle => 'Записи';

  @override
  String get searchCustomerOrService => 'Поиск клиента или услуги';

  @override
  String get filterThisWeek => 'На этой неделе';

  @override
  String get filterAllTime => 'За всё время';

  @override
  String get filterAllStaff => 'Весь персонал';

  @override
  String get staffLabel => 'Персонал';

  @override
  String get needsActionHeading => 'Требует действия';

  @override
  String get statTotal => 'Всего';

  @override
  String get statServices => 'Услуги';

  @override
  String get statAvgTicket => 'Средний чек';

  @override
  String get noBookingsMatchFilter =>
      'Нет записей, соответствующих этому фильтру';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count услуги',
      many: '$count услуг',
      few: '$count услуги',
      one: '$count услуга',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Не удалось открыть магазин';

  @override
  String get updateRequired => 'Требуется обновление';

  @override
  String get updateRequiredBody =>
      'Доступна новая версия приложения. Обновите, чтобы продолжить пользоваться панелью управления салоном.';

  @override
  String get updateNow => 'Обновить сейчас';

  @override
  String get themeColorTitle => 'Цвет темы';

  @override
  String get save => 'Сохранить';

  @override
  String get staffTitle => 'Персонал';

  @override
  String get addStaff => 'Добавить сотрудника';

  @override
  String get statActive => 'Активные';

  @override
  String get statTodaysTotal => 'Итого за сегодня';

  @override
  String get noActiveStaffYet => 'Пока нет активных сотрудников';

  @override
  String get addFirstStaff => 'Добавить первого сотрудника';

  @override
  String get noServicesYet => 'Пока нет услуг';

  @override
  String get notActive => 'Не активен';

  @override
  String get canSetOwnPrice => 'Может устанавливать собственную цену';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count услуги',
      many: '$count услуг',
      few: '$count услуги',
      one: '$count услуга',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Новая';

  @override
  String get serviceLabel => 'Услуга';

  @override
  String get customerLabel => 'Клиент';

  @override
  String get repeatLabel => 'Повторный';

  @override
  String get couldNotUpdateBooking =>
      'Не удалось обновить запись. Попробуйте ещё раз.';

  @override
  String get couldNotAcceptReschedule =>
      'Не удалось принять перенос. Попробуйте ещё раз.';

  @override
  String get couldNotRejectReschedule =>
      'Не удалось отклонить перенос. Попробуйте ещё раз.';

  @override
  String get rescheduleLabel => 'Перенести';

  @override
  String get pendingLabel => 'В ожидании';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer у $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Клиент запросил $time';
  }

  @override
  String get reject => 'Отклонить';

  @override
  String get accept => 'Принять';

  @override
  String get confirm => 'Подтвердить';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + ещё $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Не удалось загрузить данные аккаунта';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Укажите владельца, телефон, название салона и адрес';

  @override
  String get accountUpdated => 'Аккаунт обновлён';

  @override
  String get phoneOrEmailUsed => 'Телефон или email уже используются';

  @override
  String get couldNotSaveAccount => 'Не удалось сохранить данные аккаунта';

  @override
  String get newPasswordMinLength =>
      'Новый пароль должен содержать не менее 6 символов';

  @override
  String get newPasswordsDontMatch => 'Новые пароли не совпадают';

  @override
  String get passwordChanged => 'Пароль изменён';

  @override
  String get currentPasswordIncorrect => 'Текущий пароль неверен';

  @override
  String get couldNotChangePassword => 'Не удалось изменить пароль';

  @override
  String get countryAndCurrency => 'Страна и валюта';

  @override
  String get accountTitle => 'Аккаунт';

  @override
  String ownerSinceDate(String date) {
    return 'Владелец с $date';
  }

  @override
  String planLabel(String plan) {
    return 'Тариф $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Аналитика удержания бесплатно на 6 месяцев';

  @override
  String get upgrade => 'Улучшить';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get salonProfile => 'Профиль салона';

  @override
  String get emailLabel => 'Email';

  @override
  String get locationUpdated => 'Местоположение обновлено';

  @override
  String get saveDetailsButton => 'Сохранить данные';

  @override
  String get savingEllipsis => 'Сохранение...';

  @override
  String get security => 'Безопасность';

  @override
  String get currentPasswordLabel => 'Текущий пароль';

  @override
  String get newPasswordLabel => 'Новый пароль';

  @override
  String get confirmNewPasswordLabel => 'Подтвердите новый пароль';

  @override
  String get changePasswordButton => 'Изменить пароль';

  @override
  String get changingEllipsis => 'Изменение...';

  @override
  String get signOut => 'Выйти';

  @override
  String get enterServiceNamePrice => 'Введите название и цену услуги';

  @override
  String get fillStaffNamePhone => 'Укажите имя и телефон сотрудника';

  @override
  String get addAtLeastOneService => 'Добавьте хотя бы одну услугу';

  @override
  String get enterValidOpenCloseTimes =>
      'Введите корректное время открытия и закрытия (ЧЧ:ММ, 24 часа)';

  @override
  String get selectAtLeastOneWorkingDay => 'Выберите хотя бы один рабочий день';

  @override
  String get staffPhoneInUse => 'Этот телефон сотрудника уже используется';

  @override
  String get couldNotAddStaff =>
      'Не удалось добавить сотрудника. Попробуйте ещё раз.';

  @override
  String get addStaffSubtitle => 'Настройте профиль, услуги и рабочие дни.';

  @override
  String get staffNameLabel => 'Имя сотрудника';

  @override
  String get staffPhoneLabel => 'Телефон сотрудника';

  @override
  String get servicesLabel => 'Услуги';

  @override
  String servicesAddedCount(int count) {
    return 'Добавлено: $count';
  }

  @override
  String get workingHours => 'Рабочие часы';

  @override
  String get opens => 'Открытие';

  @override
  String get closes => 'Закрытие';

  @override
  String get hhmmHint => 'ЧЧ:ММ';

  @override
  String get workingDays => 'Рабочие дни';

  @override
  String get serviceNameHint => 'Название услуги';

  @override
  String get priceHint => 'Цена';

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
  String get daySun => 'Вс';

  @override
  String get enterValidStaffNamePhone =>
      'Введите корректные имя и телефон сотрудника';

  @override
  String get staffDetailsSaved => 'Данные сотрудника сохранены';

  @override
  String get phoneAlreadyInUse => 'Этот телефон уже используется';

  @override
  String get couldNotUpdateStaff => 'Не удалось обновить сотрудника';

  @override
  String get enterServiceNameAndPriceShort => 'Введите название и цену услуги';

  @override
  String get couldNotAddService => 'Не удалось добавить услугу';

  @override
  String get editServiceTitle => 'Изменить услугу';

  @override
  String get enterValidServiceNamePrice =>
      'Введите корректное название и цену услуги';

  @override
  String get couldNotUpdateService => 'Не удалось обновить услугу';

  @override
  String get saveServiceButton => 'Сохранить услугу';

  @override
  String get couldNotRemoveServiceDefault => 'Не удалось удалить услугу';

  @override
  String get useHHmmWorkingHours => 'Используйте ЧЧ:мм для рабочих часов';

  @override
  String get hoursAdded => 'Часы добавлены';

  @override
  String get couldNotAddWorkingHours => 'Не удалось добавить рабочие часы';

  @override
  String get couldNotRemoveTiming => 'Не удалось удалить время';

  @override
  String get manageStaffTitle => 'Управление сотрудником';

  @override
  String get done => 'Готово';

  @override
  String get manageStaffSubtitle =>
      'Добавляйте, редактируйте или удаляйте услуги и часы, затем нажмите «Готово».';

  @override
  String get saveStaffButton => 'Сохранить сотрудника';

  @override
  String get edit => 'Редактировать';

  @override
  String get delete => 'Удалить';

  @override
  String get newServiceLabel => 'Новая услуга';

  @override
  String get addingEllipsis => 'Добавление...';

  @override
  String get addServiceButton => 'Добавить услугу';

  @override
  String get noTimingsYet => 'Пока нет расписания';

  @override
  String get removeLabel => 'Удалить';

  @override
  String get startLabel => 'Начало';

  @override
  String get endLabel => 'Конец';

  @override
  String get addMonSatHoursButton => 'Добавить часы Пн-Сб';

  @override
  String get saveHoursButton => 'Сохранить часы';

  @override
  String get hhmmLowerHint => 'ЧЧ:мм';

  @override
  String get chooseStaffServiceDate => 'Выберите сотрудника, услугу и дату';

  @override
  String get noSlotsForDate => 'Нет доступных слотов на эту дату.';

  @override
  String get couldNotLoadSlots => 'Не удалось загрузить слоты';

  @override
  String get enterCustomerName => 'Введите имя клиента';

  @override
  String get chooseStaffAndService =>
      'Выберите сотрудника и хотя бы одну услугу';

  @override
  String get enterCustomerPhone => 'Введите телефон клиента';

  @override
  String get chooseAvailableSlot => 'Выберите доступный слот';

  @override
  String get couldNotCreateBooking =>
      'Не удалось создать запись. Попробуйте ещё раз.';

  @override
  String get doneServiceOption => 'Услуга выполнена';

  @override
  String get scheduleLaterOption => 'Запланировать позже';

  @override
  String get customerNameLabel => 'Имя клиента';

  @override
  String get customerPhoneLabel => 'Телефон клиента';

  @override
  String recordedNowDate(String date) {
    return 'Записано сейчас — $date';
  }

  @override
  String get dateLabel => 'Дата';

  @override
  String get yyyymmddHint => 'ГГГГ-ММ-ДД';

  @override
  String get availableSlots => 'Доступные слоты';

  @override
  String get cancel => 'Отмена';

  @override
  String get saveBooking => 'Сохранить запись';

  @override
  String saveBookingWithTotal(String total) {
    return 'Сохранить запись · $total';
  }

  @override
  String get addServiceTitle => 'Добавить услугу';

  @override
  String get serviceNameLabel => 'Название услуги';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get priceLabel => 'Цена';

  @override
  String get durationMinutesLabel => 'Длительность (мин)';

  @override
  String get deleteServiceButton => 'Удалить услугу';

  @override
  String get fillServiceFields =>
      'Введите название, категорию, цену и длительность';

  @override
  String get couldNotSaveService => 'Не удалось сохранить услугу';

  @override
  String get noServicesInCatalog => 'Пока нет услуг. Добавьте первую.';

  @override
  String get searchServicesHint => 'Поиск услуг';

  @override
  String get filterAllCategories => 'Все';

  @override
  String get assignToStaffLabel => 'Назначить сотруднику';

  @override
  String get anyStaffOption => 'Любой сотрудник';

  @override
  String get addStarterServicesButton => 'Добавить популярные услуги';
}
