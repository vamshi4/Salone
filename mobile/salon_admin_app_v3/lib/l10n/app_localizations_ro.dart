// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get insightsTitle => 'Statistici';

  @override
  String get tabEarnings => 'Venituri';

  @override
  String get tabRetention => 'Retenție';

  @override
  String get periodToday => 'Astăzi';

  @override
  String get periodWeek => 'Săptămână';

  @override
  String get periodMonth => 'Lună';

  @override
  String get periodLast7Days => 'Ultimele 7 zile';

  @override
  String get periodLast30Days => 'Ultimele 30 de zile';

  @override
  String get earningsLoadError => 'Veniturile nu au putut fi încărcate.';

  @override
  String get retry => 'Reîncearcă';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de servicii',
      few: '$count servicii',
      one: '$count serviciu',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Servicii finalizate';

  @override
  String get noCompletedServices =>
      'Niciun serviciu finalizat încă în această perioadă.';

  @override
  String get topServicesHeading => 'Servicii de top';

  @override
  String get byStaffHeading => 'După personal';

  @override
  String get vsYesterday => 'vs ieri';

  @override
  String get vsLastWeek => 'vs săptămâna trecută';

  @override
  String get vsLastMonth => 'vs luna trecută';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Clienți recuperați';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de clienți s-au întors luna aceasta',
      few: '$count clienți s-au întors luna aceasta',
      one: '$count client s-a întors luna aceasta',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError =>
      'Raportul de retenție nu a putut fi încărcat.';

  @override
  String get couldNotOpenWhatsapp => 'WhatsApp nu a putut fi deschis';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Bună $name! Ne-a fost dor de tine la $salonName. Rezervă-ți următoarea vizită și bucură-te de o ofertă specială de bun venit. Ne vedem curând!';
  }

  @override
  String get customerCohortsHeading => 'Grupuri de clienți';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count clienți';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Niciun client $label în această perioadă.';
  }

  @override
  String get missedCustomersHeading => 'Clienți pierduți';

  @override
  String get missedCustomersHint =>
      'Atinge „Reamintește” pentru a le trimite un mesaj pe WhatsApp.';

  @override
  String get noMissedCustomers => 'Niciun client pierdut luna aceasta.';

  @override
  String get cohortRegulars => 'Fideli';

  @override
  String get cohortNew => 'Noi';

  @override
  String get cohortCameBack => 'Reveniți';

  @override
  String get cohortStoppedComing => 'Au încetat să mai vină';

  @override
  String get customersLabel => 'clienți';

  @override
  String get reachOutNow => 'Contactează acum';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count clienți fideli sunt în scădere · $revenue în risc';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× întârziat';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'De obicei la fiecare $cadence zile · $overdue zile întârziere';
  }

  @override
  String get remind => 'Reamintește';

  @override
  String get remindOnWhatsappTooltip => 'Reamintește pe WhatsApp';

  @override
  String get retentionProTitle => 'Statisticile de retenție sunt o funcție PRO';

  @override
  String get retentionProBody =>
      'Vezi cine a încetat să mai vină, raportul dintre clienții noi și cei care revin, și recuperează clienții pierduți cu remindere dintr-o atingere.';

  @override
  String get upgradeToPro => 'Fă upgrade la PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits vizite · $spend cheltuiți';
  }

  @override
  String get createYourAccount => 'Creează-ți contul';

  @override
  String get basics => 'Informații de bază';

  @override
  String get country => 'Țară';

  @override
  String get countryHelperText =>
      'Stabilește moneda, formatul telefonului și limba implicită.';

  @override
  String get language => 'Limbă';

  @override
  String get phoneNumberLabel => 'Număr de telefon';

  @override
  String get passwordLabel => 'Parolă';

  @override
  String stepOfTotal(int step, int total) {
    return 'Pasul $step din $total';
  }

  @override
  String get createAccountButton => 'Creează cont';

  @override
  String get continueButton => 'Continuă';

  @override
  String get enterPhoneNumber => 'Introdu un număr de telefon';

  @override
  String get passwordMinLength =>
      'Parola trebuie să aibă cel puțin 6 caractere';

  @override
  String get fillOwnerSalonAddress =>
      'Completează numele proprietarului, numele salonului și adresa';

  @override
  String get turnOnLocationPermission =>
      'Activează locația și permite accesul pentru a folosi această funcție';

  @override
  String get couldNotGetLocation => 'Locația nu a putut fi obținută';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Acest telefon este deja înregistrat. Te rugăm să te autentifici.';

  @override
  String get signupFailedCheckBackend =>
      'Înregistrarea a eșuat. Verifică conexiunea la server.';

  @override
  String get signupFailedTryAgain =>
      'Înregistrarea a eșuat. Te rugăm să încerci din nou.';

  @override
  String get yourSalon => 'Salonul tău';

  @override
  String get salonDetailsSubtitle => 'Pasul 2 din 3 · Detalii salon';

  @override
  String get ownerNameLabel => 'Numele proprietarului';

  @override
  String get salonNameLabel => 'Numele salonului';

  @override
  String get salonAddressLabel => 'Adresa salonului';

  @override
  String get locationSet => 'Locație setată';

  @override
  String get useMyCurrentLocation => 'Folosește locația mea curentă';

  @override
  String get pickYourColor => 'Alege-ți culoarea';

  @override
  String get colorPreviewHelp =>
      'Aceasta este culoarea de accent a salonului tău în întreaga aplicație. Schimb-o oricând din Cont.';

  @override
  String get previewLabel => 'Previzualizare';

  @override
  String get newBooking => 'Programare nouă';

  @override
  String get colorTeal => 'Turcoaz';

  @override
  String get colorTerracotta => 'Teracotă';

  @override
  String get colorBlue => 'Albastru';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorRose => 'Roz';

  @override
  String get welcomeBack => 'Bine ai revenit';

  @override
  String get signInToDashboard => 'Autentifică-te în panoul salonului tău';

  @override
  String get enterSalonOwnerPhone =>
      'Introdu telefonul proprietarului salonului';

  @override
  String get enterYourPassword => 'Introdu parola';

  @override
  String get noSalonOwnerFound =>
      'Niciun cont de proprietar de salon găsit pentru acest telefon.';

  @override
  String get loginFailedCheckBackend =>
      'Autentificarea a eșuat. Verifică conexiunea la server.';

  @override
  String get loginFailedTryAgain =>
      'Autentificarea a eșuat. Te rugăm să încerci din nou.';

  @override
  String get hidePassword => 'Ascunde parola';

  @override
  String get showPassword => 'Afișează parola';

  @override
  String get signIn => 'Autentifică-te';

  @override
  String get newHere => 'Ești nou aici?';

  @override
  String get createAccount => 'Creează cont';

  @override
  String get forgotPassword => 'Ai uitat parola?';

  @override
  String get resetPasswordTitle => 'Resetează parola';

  @override
  String get resetPasswordEnterPhone =>
      'Introdu numărul tău de telefon și îți vom trimite un cod din 6 cifre prin WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Trimite codul prin WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Dacă acel cont există, a fost trimis un cod prin WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Introdu codul trimis pe WhatsApp, apoi alege o parolă nouă.';

  @override
  String get otpCodeLabel => 'Cod din 6 cifre';

  @override
  String get resetPasswordButton => 'Resetează parola';

  @override
  String get resendCode => 'Retrimite codul';

  @override
  String get changePhoneNumber => 'Schimbă numărul de telefon';

  @override
  String get enterSixDigitCode => 'Introdu codul din 6 cifre';

  @override
  String get passwordsDoNotMatch => 'Parolele nu coincid';

  @override
  String get passwordResetSuccess =>
      'Parolă resetată. Te rugăm să te autentifici cu noua parolă.';

  @override
  String get waitBeforeRetryingCode =>
      'Te rugăm să aștepți un minut înainte de a cere alt cod';

  @override
  String get invalidOrExpiredCode => 'Acest cod este invalid sau a expirat';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Prea multe încercări — cere un cod nou';

  @override
  String get continueWithGoogle => 'Continuă cu Google';

  @override
  String get signedInWithGoogle => 'Conectat cu Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Conectat cu Google ca $email';
  }

  @override
  String get usePasswordInstead => 'Folosește parola în schimb';

  @override
  String get googleSignInNotConfigured =>
      'Autentificarea cu Google nu este încă configurată';

  @override
  String get googleSignInFailed =>
      'Autentificarea cu Google a eșuat. Te rugăm să încerci din nou.';

  @override
  String get googleNoAccountFound =>
      'Niciun cont găsit pentru acel cont Google. Creează unul mai întâi.';

  @override
  String get linkGoogleAccount => 'Conectează contul Google';

  @override
  String get googleAccountLinked =>
      'Cont Google conectat — acum te poți autentifica cu el';

  @override
  String get addStaffBeforeBookings =>
      'Adaugă personal activ înainte de a crea programări';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Astăzi';

  @override
  String get statRepeat => 'Recurenți';

  @override
  String get statLoggedHelper => 'înregistrați';

  @override
  String get statBackHelper => 'reveniți';

  @override
  String get statWeek => 'Săptămână';

  @override
  String get statMonth => 'Lună';

  @override
  String get loggedTodayHeading => 'Înregistrate azi';

  @override
  String get nothingLoggedToday =>
      'Nimic înregistrat încă azi. Atinge „Programare nouă” după finalizarea unui serviciu.';

  @override
  String get navHome => 'Acasă';

  @override
  String get navBookings => 'Programări';

  @override
  String get navStaff => 'Personal';

  @override
  String get navInsights => 'Statistici';

  @override
  String get navAccount => 'Cont';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Niciun salon nu este încă asociat acestui cont de proprietar.';

  @override
  String get bookingsTitle => 'Programări';

  @override
  String get searchCustomerOrService => 'Caută client sau serviciu';

  @override
  String get filterThisWeek => 'Săptămâna aceasta';

  @override
  String get filterAllTime => 'Tot timpul';

  @override
  String get filterAllStaff => 'Tot personalul';

  @override
  String get staffLabel => 'Personal';

  @override
  String get needsActionHeading => 'Necesită acțiune';

  @override
  String get statTotal => 'Total';

  @override
  String get statServices => 'Servicii';

  @override
  String get statAvgTicket => 'Bon mediu';

  @override
  String get noBookingsMatchFilter =>
      'Nicio programare nu corespunde acestui filtru';

  @override
  String get today => 'Astăzi';

  @override
  String get yesterday => 'Ieri';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de servicii',
      few: '$count servicii',
      one: '$count serviciu',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Magazinul nu a putut fi deschis';

  @override
  String get updateRequired => 'Actualizare necesară';

  @override
  String get updateRequiredBody =>
      'O versiune nouă a aplicației este disponibilă. Te rugăm să actualizezi pentru a continua să folosești panoul salonului tău.';

  @override
  String get updateNow => 'Actualizează acum';

  @override
  String get themeColorTitle => 'Culoarea temei';

  @override
  String get save => 'Salvează';

  @override
  String get staffTitle => 'Personal';

  @override
  String get addStaff => 'Adaugă personal';

  @override
  String get statActive => 'Activi';

  @override
  String get statTodaysTotal => 'Total astăzi';

  @override
  String get noActiveStaffYet => 'Niciun personal activ încă';

  @override
  String get addFirstStaff => 'Adaugă primul membru al personalului';

  @override
  String get noServicesYet => 'Niciun serviciu încă';

  @override
  String get notActive => 'Inactiv';

  @override
  String get canSetOwnPrice => 'Își poate stabili propriul preț';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de servicii',
      few: '$count servicii',
      one: '$count serviciu',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Nou';

  @override
  String get serviceLabel => 'Serviciu';

  @override
  String get customerLabel => 'Client';

  @override
  String get repeatLabel => 'Recurent';

  @override
  String get couldNotUpdateBooking =>
      'Programarea nu a putut fi actualizată. Te rugăm să încerci din nou.';

  @override
  String get couldNotAcceptReschedule =>
      'Reprogramarea nu a putut fi acceptată. Te rugăm să încerci din nou.';

  @override
  String get couldNotRejectReschedule =>
      'Reprogramarea nu a putut fi refuzată. Te rugăm să încerci din nou.';

  @override
  String get rescheduleLabel => 'Reprogramează';

  @override
  String get pendingLabel => 'În așteptare';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer cu $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Clientul a solicitat $time';
  }

  @override
  String get reject => 'Refuză';

  @override
  String get accept => 'Acceptă';

  @override
  String get confirm => 'Confirmă';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + încă $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount =>
      'Detaliile contului nu au putut fi încărcate';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Completează proprietar, telefon, numele salonului și adresa';

  @override
  String get accountUpdated => 'Cont actualizat';

  @override
  String get phoneOrEmailUsed => 'Telefonul sau e-mailul este deja folosit';

  @override
  String get couldNotSaveAccount => 'Detaliile contului nu au putut fi salvate';

  @override
  String get newPasswordMinLength =>
      'Parola nouă trebuie să aibă cel puțin 6 caractere';

  @override
  String get newPasswordsDontMatch => 'Parolele noi nu se potrivesc';

  @override
  String get passwordChanged => 'Parolă schimbată';

  @override
  String get currentPasswordIncorrect => 'Parola curentă este incorectă';

  @override
  String get couldNotChangePassword => 'Parola nu a putut fi schimbată';

  @override
  String get countryAndCurrency => 'Țară și monedă';

  @override
  String get accountTitle => 'Cont';

  @override
  String ownerSinceDate(String date) {
    return 'Proprietar din $date';
  }

  @override
  String planLabel(String plan) {
    return 'Plan $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Statistici de retenție gratuite timp de 6 luni';

  @override
  String get upgrade => 'Fă upgrade';

  @override
  String get appearance => 'Aspect';

  @override
  String get salonProfile => 'Profil salon';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get locationUpdated => 'Locație actualizată';

  @override
  String get saveDetailsButton => 'Salvează detaliile';

  @override
  String get savingEllipsis => 'Se salvează...';

  @override
  String get security => 'Securitate';

  @override
  String get currentPasswordLabel => 'Parola curentă';

  @override
  String get newPasswordLabel => 'Parolă nouă';

  @override
  String get confirmNewPasswordLabel => 'Confirmă parola nouă';

  @override
  String get changePasswordButton => 'Schimbă parola';

  @override
  String get changingEllipsis => 'Se schimbă...';

  @override
  String get signOut => 'Deconectare';

  @override
  String get enterServiceNamePrice => 'Introdu numele și prețul serviciului';

  @override
  String get fillStaffNamePhone =>
      'Completează numele și telefonul personalului';

  @override
  String get addAtLeastOneService => 'Adaugă cel puțin un serviciu';

  @override
  String get enterValidOpenCloseTimes =>
      'Introdu ore valide de deschidere și închidere (HH:MM, 24 de ore)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Selectează cel puțin o zi lucrătoare';

  @override
  String get staffPhoneInUse =>
      'Acel telefon al personalului este deja folosit';

  @override
  String get couldNotAddStaff =>
      'Personalul nu a putut fi adăugat. Te rugăm să încerci din nou.';

  @override
  String get addStaffSubtitle =>
      'Configurează profilul, serviciile și zilele lucrătoare.';

  @override
  String get staffNameLabel => 'Numele personalului';

  @override
  String get staffPhoneLabel => 'Telefonul personalului';

  @override
  String get servicesLabel => 'Servicii';

  @override
  String servicesAddedCount(int count) {
    return '$count adăugate';
  }

  @override
  String get workingHours => 'Program de lucru';

  @override
  String get opens => 'Deschide';

  @override
  String get closes => 'Închide';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Zile lucrătoare';

  @override
  String get serviceNameHint => 'Numele serviciului';

  @override
  String get priceHint => 'Preț';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mie';

  @override
  String get dayThu => 'Joi';

  @override
  String get dayFri => 'Vin';

  @override
  String get daySat => 'Sâm';

  @override
  String get daySun => 'Dum';

  @override
  String get enterValidStaffNamePhone =>
      'Introdu un nume și telefon valide ale personalului';

  @override
  String get staffDetailsSaved => 'Detaliile personalului au fost salvate';

  @override
  String get phoneAlreadyInUse => 'Acel telefon este deja folosit';

  @override
  String get couldNotUpdateStaff => 'Personalul nu a putut fi actualizat';

  @override
  String get enterServiceNameAndPriceShort =>
      'Introdu numele și prețul serviciului';

  @override
  String get couldNotAddService => 'Serviciul nu a putut fi adăugat';

  @override
  String get editServiceTitle => 'Editează serviciul';

  @override
  String get enterValidServiceNamePrice =>
      'Introdu un nume și preț valide ale serviciului';

  @override
  String get couldNotUpdateService => 'Serviciul nu a putut fi actualizat';

  @override
  String get saveServiceButton => 'Salvează serviciul';

  @override
  String get couldNotRemoveServiceDefault => 'Serviciul nu a putut fi eliminat';

  @override
  String get useHHmmWorkingHours => 'Folosește HH:mm pentru programul de lucru';

  @override
  String get hoursAdded => 'Ore adăugate';

  @override
  String get couldNotAddWorkingHours =>
      'Programul de lucru nu a putut fi adăugat';

  @override
  String get couldNotRemoveTiming => 'Ora nu a putut fi eliminată';

  @override
  String get manageStaffTitle => 'Gestionează personalul';

  @override
  String get done => 'Gata';

  @override
  String get manageStaffSubtitle =>
      'Adaugă, editează sau elimină servicii și ore, apoi atinge Gata.';

  @override
  String get saveStaffButton => 'Salvează personalul';

  @override
  String get edit => 'Editează';

  @override
  String get delete => 'Șterge';

  @override
  String get newServiceLabel => 'Serviciu nou';

  @override
  String get addingEllipsis => 'Se adaugă...';

  @override
  String get addServiceButton => 'Adaugă serviciu';

  @override
  String get noTimingsYet => 'Niciun program încă';

  @override
  String get removeLabel => 'Elimină';

  @override
  String get startLabel => 'Început';

  @override
  String get endLabel => 'Sfârșit';

  @override
  String get addMonSatHoursButton => 'Adaugă ore Lun-Sâm';

  @override
  String get saveHoursButton => 'Salvează orele';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Alege personalul, serviciul și data';

  @override
  String get noSlotsForDate =>
      'Niciun interval disponibil pentru această dată.';

  @override
  String get couldNotLoadSlots => 'Intervalele nu au putut fi încărcate';

  @override
  String get enterCustomerName => 'Introdu numele clientului';

  @override
  String get chooseStaffAndService =>
      'Alege personalul și cel puțin un serviciu';

  @override
  String get enterCustomerPhone => 'Introdu telefonul clientului';

  @override
  String get chooseAvailableSlot => 'Alege un interval disponibil';

  @override
  String get couldNotCreateBooking =>
      'Programarea nu a putut fi creată. Te rugăm să încerci din nou.';

  @override
  String get doneServiceOption => 'Serviciu finalizat';

  @override
  String get scheduleLaterOption => 'Programează mai târziu';

  @override
  String get customerNameLabel => 'Numele clientului';

  @override
  String get customerPhoneLabel => 'Telefonul clientului';

  @override
  String recordedNowDate(String date) {
    return 'Înregistrat acum — $date';
  }

  @override
  String get dateLabel => 'Data';

  @override
  String get yyyymmddHint => 'AAAA-LL-ZZ';

  @override
  String get availableSlots => 'Intervale disponibile';

  @override
  String get cancel => 'Anulează';

  @override
  String get saveBooking => 'Salvează programarea';

  @override
  String saveBookingWithTotal(String total) {
    return 'Salvează programarea · $total';
  }
}
