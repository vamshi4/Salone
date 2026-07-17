// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get insightsTitle => 'Statystyki';

  @override
  String get tabEarnings => 'Zarobki';

  @override
  String get tabRetention => 'Retencja';

  @override
  String get periodToday => 'Dziś';

  @override
  String get periodWeek => 'Tydzień';

  @override
  String get periodMonth => 'Miesiąc';

  @override
  String get periodLast7Days => 'Ostatnie 7 dni';

  @override
  String get periodLast30Days => 'Ostatnie 30 dni';

  @override
  String get earningsLoadError => 'Nie udało się załadować zarobków.';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usługi',
      many: '$count usług',
      few: '$count usługi',
      one: '$count usługa',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Ukończone usługi';

  @override
  String get noCompletedServices =>
      'W tym okresie nie ukończono jeszcze żadnych usług.';

  @override
  String get topServicesHeading => 'Najlepsze usługi';

  @override
  String get byStaffHeading => 'Według personelu';

  @override
  String get vsYesterday => 'vs wczoraj';

  @override
  String get vsLastWeek => 'vs zeszły tydzień';

  @override
  String get vsLastMonth => 'vs zeszły miesiąc';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Odzyskani klienci';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klienta wróciło w tym miesiącu',
      many: '$count klientów wróciło w tym miesiącu',
      few: '$count klientów wróciło w tym miesiącu',
      one: '$count klient wrócił w tym miesiącu',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Nie udało się załadować raportu retencji.';

  @override
  String get couldNotOpenWhatsapp => 'Nie udało się otworzyć WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Cześć $name! Tęsknimy za Tobą w $salonName. Zarezerwuj kolejną wizytę i skorzystaj ze specjalnej oferty powitalnej. Do zobaczenia wkrótce!';
  }

  @override
  String get customerCohortsHeading => 'Grupy klientów';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count klientów';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Brak klientów „$label” w tym okresie.';
  }

  @override
  String get missedCustomersHeading => 'Utraceni klienci';

  @override
  String get missedCustomersHint =>
      'Dotknij „Przypomnij”, aby wysłać im wiadomość na WhatsApp.';

  @override
  String get noMissedCustomers =>
      'W tym miesiącu nie utracono żadnych klientów.';

  @override
  String get cohortRegulars => 'Stali klienci';

  @override
  String get cohortNew => 'Nowi';

  @override
  String get cohortCameBack => 'Wrócili';

  @override
  String get cohortStoppedComing => 'Przestali przychodzić';

  @override
  String get customersLabel => 'klienci';

  @override
  String get reachOutNow => 'Skontaktuj się teraz';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count stałych klientów przestaje przychodzić · $revenue zagrożone';
  }

  @override
  String overdueBadge(String ratio) {
    return 'opóźnienie $ratio×';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Zwykle co $cadence dni · opóźnienie $overdue dni';
  }

  @override
  String get remind => 'Przypomnij';

  @override
  String get remindOnWhatsappTooltip => 'Przypomnij przez WhatsApp';

  @override
  String get retentionProTitle => 'Statystyki retencji to funkcja PRO';

  @override
  String get retentionProBody =>
      'Zobacz, kto przestał przychodzić, proporcję nowych do powracających klientów, i odzyskaj utraconych klientów dzięki przypomnieniom jednym dotknięciem.';

  @override
  String get upgradeToPro => 'Ulepsz do PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits wizyt · wydano $spend';
  }

  @override
  String get createYourAccount => 'Utwórz konto';

  @override
  String get basics => 'Podstawowe informacje';

  @override
  String get country => 'Kraj';

  @override
  String get countryHelperText =>
      'Określa Twoją walutę, format telefonu i domyślny język.';

  @override
  String get language => 'Język';

  @override
  String get phoneNumberLabel => 'Numer telefonu';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String stepOfTotal(int step, int total) {
    return 'Krok $step z $total';
  }

  @override
  String get createAccountButton => 'Utwórz konto';

  @override
  String get continueButton => 'Kontynuuj';

  @override
  String get enterPhoneNumber => 'Wprowadź numer telefonu';

  @override
  String get passwordMinLength => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get fillOwnerSalonAddress =>
      'Podaj imię i nazwisko właściciela, nazwę salonu i adres';

  @override
  String get turnOnLocationPermission =>
      'Włącz lokalizację i zezwól na dostęp, aby z tego korzystać';

  @override
  String get couldNotGetLocation => 'Nie udało się ustalić Twojej lokalizacji';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Ten telefon jest już zarejestrowany. Zaloguj się zamiast tego.';

  @override
  String get signupFailedCheckBackend =>
      'Rejestracja nie powiodła się. Sprawdź połączenie z serwerem.';

  @override
  String get signupFailedTryAgain =>
      'Rejestracja nie powiodła się. Spróbuj ponownie.';

  @override
  String get yourSalon => 'Twój salon';

  @override
  String get salonDetailsSubtitle => 'Krok 2 z 3 · Dane salonu';

  @override
  String get ownerNameLabel => 'Imię i nazwisko właściciela';

  @override
  String get salonNameLabel => 'Nazwa salonu';

  @override
  String get salonAddressLabel => 'Adres salonu';

  @override
  String get locationSet => 'Lokalizacja ustawiona';

  @override
  String get useMyCurrentLocation => 'Użyj mojej aktualnej lokalizacji';

  @override
  String get pickYourColor => 'Wybierz swój kolor';

  @override
  String get colorPreviewHelp =>
      'To jest kolor akcentu Twojego salonu w całej aplikacji. Zmień go w dowolnym momencie w Koncie.';

  @override
  String get previewLabel => 'Podgląd';

  @override
  String get newBooking => 'Nowa rezerwacja';

  @override
  String get colorTeal => 'Morski';

  @override
  String get colorTerracotta => 'Terakota';

  @override
  String get colorBlue => 'Niebieski';

  @override
  String get colorViolet => 'Fioletowy';

  @override
  String get colorRose => 'Różowy';

  @override
  String get welcomeBack => 'Witaj ponownie';

  @override
  String get signInToDashboard => 'Zaloguj się do panelu swojego salonu';

  @override
  String get enterSalonOwnerPhone => 'Wprowadź telefon właściciela salonu';

  @override
  String get enterYourPassword => 'Wprowadź hasło';

  @override
  String get noSalonOwnerFound =>
      'Nie znaleziono konta właściciela salonu dla tego telefonu.';

  @override
  String get loginFailedCheckBackend =>
      'Logowanie nie powiodło się. Sprawdź połączenie z serwerem.';

  @override
  String get loginFailedTryAgain =>
      'Logowanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get hidePassword => 'Ukryj hasło';

  @override
  String get showPassword => 'Pokaż hasło';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get newHere => 'Nowy tutaj?';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get forgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get resetPasswordTitle => 'Zresetuj hasło';

  @override
  String get resetPasswordEnterPhone =>
      'Podaj swój numer telefonu, a wyślemy 6-cyfrowy kod przez WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Wyślij kod przez WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Jeśli to konto istnieje, kod został wysłany przez WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Wpisz kod, który wysłaliśmy na WhatsApp, a następnie wybierz nowe hasło.';

  @override
  String get otpCodeLabel => '6-cyfrowy kod';

  @override
  String get resetPasswordButton => 'Zresetuj hasło';

  @override
  String get resendCode => 'Wyślij kod ponownie';

  @override
  String get changePhoneNumber => 'Zmień numer telefonu';

  @override
  String get enterSixDigitCode => 'Wpisz 6-cyfrowy kod';

  @override
  String get passwordsDoNotMatch => 'Hasła się nie zgadzają';

  @override
  String get passwordResetSuccess =>
      'Hasło zresetowane. Zaloguj się nowym hasłem.';

  @override
  String get waitBeforeRetryingCode =>
      'Poczekaj minutę przed poproszeniem o kolejny kod';

  @override
  String get invalidOrExpiredCode => 'Ten kod jest nieprawidłowy lub wygasł';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Zbyt wiele prób — poproś o nowy kod';

  @override
  String get continueWithGoogle => 'Kontynuuj z Google';

  @override
  String get signedInWithGoogle => 'Zalogowano przez Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Zalogowano przez Google jako $email';
  }

  @override
  String get usePasswordInstead => 'Użyj hasła zamiast tego';

  @override
  String get googleSignInNotConfigured =>
      'Logowanie przez Google nie zostało jeszcze skonfigurowane';

  @override
  String get googleSignInFailed =>
      'Logowanie przez Google nie powiodło się. Spróbuj ponownie.';

  @override
  String get googleNoAccountFound =>
      'Nie znaleziono konta dla tego konta Google. Najpierw je utwórz.';

  @override
  String get linkGoogleAccount => 'Połącz konto Google';

  @override
  String get googleAccountLinked =>
      'Konto Google połączone — możesz teraz się nim zalogować';

  @override
  String get addStaffBeforeBookings =>
      'Dodaj aktywnych pracowników przed utworzeniem rezerwacji';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Dziś';

  @override
  String get statRepeat => 'Powracający';

  @override
  String get statLoggedHelper => 'zarejestrowane';

  @override
  String get statBackHelper => 'wrócili';

  @override
  String get statWeek => 'Tydzień';

  @override
  String get statMonth => 'Miesiąc';

  @override
  String get loggedTodayHeading => 'Zarejestrowane dziś';

  @override
  String get nothingLoggedToday =>
      'Dziś nic jeszcze nie zarejestrowano. Dotknij „Nowa rezerwacja”, gdy usługa zostanie ukończona.';

  @override
  String get navHome => 'Start';

  @override
  String get navBookings => 'Rezerwacje';

  @override
  String get navStaff => 'Personel';

  @override
  String get navInsights => 'Statystyki';

  @override
  String get navAccount => 'Konto';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Do tego konta właściciela nie przypisano jeszcze żadnego salonu.';

  @override
  String get bookingsTitle => 'Rezerwacje';

  @override
  String get searchCustomerOrService => 'Szukaj klienta lub usługi';

  @override
  String get filterThisWeek => 'W tym tygodniu';

  @override
  String get filterAllTime => 'Cały czas';

  @override
  String get filterAllStaff => 'Cały personel';

  @override
  String get staffLabel => 'Personel';

  @override
  String get needsActionHeading => 'Wymaga działania';

  @override
  String get statTotal => 'Razem';

  @override
  String get statServices => 'Usługi';

  @override
  String get statAvgTicket => 'Śr. rachunek';

  @override
  String get noBookingsMatchFilter =>
      'Żadna rezerwacja nie pasuje do tego filtra';

  @override
  String get today => 'Dziś';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usługi',
      many: '$count usług',
      few: '$count usługi',
      one: '$count usługa',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Nie udało się otworzyć sklepu';

  @override
  String get updateRequired => 'Wymagana aktualizacja';

  @override
  String get updateRequiredBody =>
      'Dostępna jest nowa wersja aplikacji. Zaktualizuj, aby kontynuować korzystanie z panelu swojego salonu.';

  @override
  String get updateNow => 'Zaktualizuj teraz';

  @override
  String get themeColorTitle => 'Kolor motywu';

  @override
  String get save => 'Zapisz';

  @override
  String get staffTitle => 'Personel';

  @override
  String get addStaff => 'Dodaj pracownika';

  @override
  String get statActive => 'Aktywni';

  @override
  String get statTodaysTotal => 'Suma dzisiaj';

  @override
  String get noActiveStaffYet => 'Brak jeszcze aktywnego personelu';

  @override
  String get addFirstStaff => 'Dodaj pierwszego pracownika';

  @override
  String get noServicesYet => 'Brak jeszcze usług';

  @override
  String get notActive => 'Nieaktywny';

  @override
  String get canSetOwnPrice => 'Może ustalać własną cenę';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usługi',
      many: '$count usług',
      few: '$count usługi',
      one: '$count usługa',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Nowa';

  @override
  String get serviceLabel => 'Usługa';

  @override
  String get customerLabel => 'Klient';

  @override
  String get repeatLabel => 'Powracający';

  @override
  String get couldNotUpdateBooking =>
      'Nie udało się zaktualizować rezerwacji. Spróbuj ponownie.';

  @override
  String get couldNotAcceptReschedule =>
      'Nie udało się zaakceptować zmiany terminu. Spróbuj ponownie.';

  @override
  String get couldNotRejectReschedule =>
      'Nie udało się odrzucić zmiany terminu. Spróbuj ponownie.';

  @override
  String get rescheduleLabel => 'Zmień termin';

  @override
  String get pendingLabel => 'Oczekujące';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer z $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Klient poprosił o $time';
  }

  @override
  String get reject => 'Odrzuć';

  @override
  String get accept => 'Akceptuj';

  @override
  String get confirm => 'Potwierdź';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count więcej';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Nie udało się załadować danych konta';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Podaj właściciela, telefon, nazwę salonu i adres';

  @override
  String get accountUpdated => 'Konto zaktualizowane';

  @override
  String get phoneOrEmailUsed => 'Telefon lub e-mail jest już używany';

  @override
  String get couldNotSaveAccount => 'Nie udało się zapisać danych konta';

  @override
  String get newPasswordMinLength =>
      'Nowe hasło musi mieć co najmniej 6 znaków';

  @override
  String get newPasswordsDontMatch => 'Nowe hasła nie są zgodne';

  @override
  String get passwordChanged => 'Hasło zmienione';

  @override
  String get currentPasswordIncorrect => 'Bieżące hasło jest nieprawidłowe';

  @override
  String get couldNotChangePassword => 'Nie udało się zmienić hasła';

  @override
  String get countryAndCurrency => 'Kraj i waluta';

  @override
  String get accountTitle => 'Konto';

  @override
  String ownerSinceDate(String date) {
    return 'Właściciel od $date';
  }

  @override
  String planLabel(String plan) {
    return 'Plan $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Statystyki retencji za darmo przez 6 miesięcy';

  @override
  String get upgrade => 'Ulepsz';

  @override
  String get appearance => 'Wygląd';

  @override
  String get salonProfile => 'Profil salonu';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get locationUpdated => 'Lokalizacja zaktualizowana';

  @override
  String get saveDetailsButton => 'Zapisz dane';

  @override
  String get savingEllipsis => 'Zapisywanie...';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get currentPasswordLabel => 'Bieżące hasło';

  @override
  String get newPasswordLabel => 'Nowe hasło';

  @override
  String get confirmNewPasswordLabel => 'Potwierdź nowe hasło';

  @override
  String get changePasswordButton => 'Zmień hasło';

  @override
  String get changingEllipsis => 'Zmienianie...';

  @override
  String get signOut => 'Wyloguj się';

  @override
  String get enterServiceNamePrice => 'Wprowadź nazwę i cenę usługi';

  @override
  String get fillStaffNamePhone => 'Podaj imię i telefon pracownika';

  @override
  String get addAtLeastOneService => 'Dodaj przynajmniej jedną usługę';

  @override
  String get enterValidOpenCloseTimes =>
      'Wprowadź prawidłowe godziny otwarcia i zamknięcia (GG:MM, 24-godzinny)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Wybierz przynajmniej jeden dzień pracy';

  @override
  String get staffPhoneInUse => 'Ten telefon pracownika jest już używany';

  @override
  String get couldNotAddStaff =>
      'Nie udało się dodać pracownika. Spróbuj ponownie.';

  @override
  String get addStaffSubtitle => 'Skonfiguruj profil, usługi i dni pracy.';

  @override
  String get staffNameLabel => 'Imię pracownika';

  @override
  String get staffPhoneLabel => 'Telefon pracownika';

  @override
  String get servicesLabel => 'Usługi';

  @override
  String servicesAddedCount(int count) {
    return 'Dodano $count';
  }

  @override
  String get workingHours => 'Godziny pracy';

  @override
  String get opens => 'Otwarcie';

  @override
  String get closes => 'Zamknięcie';

  @override
  String get hhmmHint => 'GG:MM';

  @override
  String get workingDays => 'Dni pracy';

  @override
  String get serviceNameHint => 'Nazwa usługi';

  @override
  String get priceHint => 'Cena';

  @override
  String get dayMon => 'Pon';

  @override
  String get dayTue => 'Wt';

  @override
  String get dayWed => 'Śr';

  @override
  String get dayThu => 'Czw';

  @override
  String get dayFri => 'Pt';

  @override
  String get daySat => 'Sob';

  @override
  String get daySun => 'Nie';

  @override
  String get enterValidStaffNamePhone =>
      'Wprowadź prawidłowe imię i telefon pracownika';

  @override
  String get staffDetailsSaved => 'Dane pracownika zapisane';

  @override
  String get phoneAlreadyInUse => 'Ten telefon jest już używany';

  @override
  String get couldNotUpdateStaff => 'Nie udało się zaktualizować pracownika';

  @override
  String get enterServiceNameAndPriceShort => 'Wprowadź nazwę i cenę usługi';

  @override
  String get couldNotAddService => 'Nie udało się dodać usługi';

  @override
  String get editServiceTitle => 'Edytuj usługę';

  @override
  String get enterValidServiceNamePrice =>
      'Wprowadź prawidłową nazwę i cenę usługi';

  @override
  String get couldNotUpdateService => 'Nie udało się zaktualizować usługi';

  @override
  String get saveServiceButton => 'Zapisz usługę';

  @override
  String get couldNotRemoveServiceDefault => 'Nie udało się usunąć usługi';

  @override
  String get useHHmmWorkingHours => 'Użyj GG:mm dla godzin pracy';

  @override
  String get hoursAdded => 'Dodano godziny';

  @override
  String get couldNotAddWorkingHours => 'Nie udało się dodać godzin pracy';

  @override
  String get couldNotRemoveTiming => 'Nie udało się usunąć godzin';

  @override
  String get manageStaffTitle => 'Zarządzaj pracownikiem';

  @override
  String get done => 'Gotowe';

  @override
  String get manageStaffSubtitle =>
      'Dodaj, edytuj lub usuń usługi i godziny, a następnie dotknij Gotowe.';

  @override
  String get saveStaffButton => 'Zapisz pracownika';

  @override
  String get edit => 'Edytuj';

  @override
  String get delete => 'Usuń';

  @override
  String get newServiceLabel => 'Nowa usługa';

  @override
  String get addingEllipsis => 'Dodawanie...';

  @override
  String get addServiceButton => 'Dodaj usługę';

  @override
  String get noTimingsYet => 'Brak jeszcze godzin';

  @override
  String get removeLabel => 'Usuń';

  @override
  String get startLabel => 'Start';

  @override
  String get endLabel => 'Koniec';

  @override
  String get addMonSatHoursButton => 'Dodaj godziny Pon-Sob';

  @override
  String get saveHoursButton => 'Zapisz godziny';

  @override
  String get hhmmLowerHint => 'GG:mm';

  @override
  String get chooseStaffServiceDate => 'Wybierz pracownika, usługę i datę';

  @override
  String get noSlotsForDate => 'Brak dostępnych terminów na ten dzień.';

  @override
  String get couldNotLoadSlots => 'Nie udało się załadować terminów';

  @override
  String get enterCustomerName => 'Wprowadź imię klienta';

  @override
  String get chooseStaffAndService =>
      'Wybierz pracownika i przynajmniej jedną usługę';

  @override
  String get enterCustomerPhone => 'Wprowadź telefon klienta';

  @override
  String get chooseAvailableSlot => 'Wybierz dostępny termin';

  @override
  String get couldNotCreateBooking =>
      'Nie udało się utworzyć rezerwacji. Spróbuj ponownie.';

  @override
  String get doneServiceOption => 'Usługa ukończona';

  @override
  String get scheduleLaterOption => 'Zaplanuj później';

  @override
  String get customerNameLabel => 'Imię klienta';

  @override
  String get customerPhoneLabel => 'Telefon klienta';

  @override
  String recordedNowDate(String date) {
    return 'Zarejestrowano teraz — $date';
  }

  @override
  String get dateLabel => 'Data';

  @override
  String get yyyymmddHint => 'RRRR-MM-DD';

  @override
  String get availableSlots => 'Dostępne terminy';

  @override
  String get cancel => 'Anuluj';

  @override
  String get saveBooking => 'Zapisz rezerwację';

  @override
  String saveBookingWithTotal(String total) {
    return 'Zapisz rezerwację · $total';
  }

  @override
  String get addServiceTitle => 'Dodaj usługę';

  @override
  String get serviceNameLabel => 'Nazwa usługi';

  @override
  String get categoryLabel => 'Kategoria';

  @override
  String get priceLabel => 'Cena';

  @override
  String get durationMinutesLabel => 'Czas trwania (minuty)';

  @override
  String get deleteServiceButton => 'Usuń usługę';

  @override
  String get fillServiceFields => 'Podaj nazwę, kategorię, cenę i czas trwania';

  @override
  String get couldNotSaveService => 'Nie udało się zapisać usługi';

  @override
  String get noServicesInCatalog => 'Brak usług. Dodaj pierwszą.';

  @override
  String get searchServicesHint => 'Szukaj usług';

  @override
  String get filterAllCategories => 'Wszystkie';

  @override
  String get assignToStaffLabel => 'Przypisz do pracownika';

  @override
  String get anyStaffOption => 'Dowolny pracownik';

  @override
  String get addStarterServicesButton => 'Dodaj typowe usługi';
}
