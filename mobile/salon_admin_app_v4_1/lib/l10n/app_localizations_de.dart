// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get insightsTitle => 'Einblicke';

  @override
  String get tabEarnings => 'Einnahmen';

  @override
  String get tabRetention => 'Kundenbindung';

  @override
  String get periodToday => 'Heute';

  @override
  String get periodWeek => 'Woche';

  @override
  String get periodMonth => 'Monat';

  @override
  String get periodLast7Days => 'Letzte 7 Tage';

  @override
  String get periodLast30Days => 'Letzte 30 Tage';

  @override
  String get earningsLoadError => 'Einnahmen konnten nicht geladen werden.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Leistungen',
      one: '$count Leistung',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Abgeschlossene Leistungen';

  @override
  String get noCompletedServices =>
      'In diesem Zeitraum noch keine Leistungen abgeschlossen.';

  @override
  String get topServicesHeading => 'Top-Leistungen';

  @override
  String get byStaffHeading => 'Nach Personal';

  @override
  String get vsYesterday => 'vs. gestern';

  @override
  String get vsLastWeek => 'vs. letzte Woche';

  @override
  String get vsLastMonth => 'vs. letzten Monat';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Zurückgewonnene Kunden';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kunden sind diesen Monat zurückgekehrt',
      one: '$count Kunde ist diesen Monat zurückgekehrt',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError =>
      'Kundenbindungsbericht konnte nicht geladen werden.';

  @override
  String get couldNotOpenWhatsapp => 'WhatsApp konnte nicht geöffnet werden';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Hallo $name! Wir haben dich bei $salonName vermisst. Buche deinen nächsten Besuch und sichere dir ein besonderes Willkommensangebot. Bis bald!';
  }

  @override
  String get customerCohortsHeading => 'Kundengruppen';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count Kunden';
  }

  @override
  String noCohortCustomers(String label) {
    return 'In diesem Zeitraum keine $label-Kunden.';
  }

  @override
  String get missedCustomersHeading => 'Verpasste Kunden';

  @override
  String get missedCustomersHint =>
      'Tippe auf \"Erinnern\", um ihnen eine WhatsApp-Nachricht zu senden.';

  @override
  String get noMissedCustomers => 'Diesen Monat keine verpassten Kunden.';

  @override
  String get cohortRegulars => 'Stammkunden';

  @override
  String get cohortNew => 'Neu';

  @override
  String get cohortCameBack => 'Zurückgekehrt';

  @override
  String get cohortStoppedComing => 'Nicht mehr gekommen';

  @override
  String get customersLabel => 'Kunden';

  @override
  String get reachOutNow => 'Jetzt kontaktieren';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count Stammkunden werden seltener · $revenue gefährdet';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× überfällig';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Normalerweise alle $cadence Tage · $overdue Tage überfällig';
  }

  @override
  String get remind => 'Erinnern';

  @override
  String get remindOnWhatsappTooltip => 'Per WhatsApp erinnern';

  @override
  String get retentionProTitle =>
      'Kundenbindungs-Einblicke sind eine PRO-Funktion';

  @override
  String get retentionProBody =>
      'Sieh, wer nicht mehr kommt, dein Verhältnis von neuen zu wiederkehrenden Kunden, und gewinne verlorene Kunden mit Erinnerungen per Fingertipp zurück.';

  @override
  String get upgradeToPro => 'Auf PRO upgraden';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits Besuche · $spend ausgegeben';
  }

  @override
  String get createYourAccount => 'Erstelle dein Konto';

  @override
  String get basics => 'Grunddaten';

  @override
  String get country => 'Land';

  @override
  String get countryHelperText =>
      'Legt deine Währung, dein Telefonformat und deine Standardsprache fest.';

  @override
  String get language => 'Sprache';

  @override
  String get phoneNumberLabel => 'Telefonnummer';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String stepOfTotal(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String get createAccountButton => 'Konto erstellen';

  @override
  String get continueButton => 'Weiter';

  @override
  String get enterPhoneNumber => 'Telefonnummer eingeben';

  @override
  String get passwordMinLength =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get fillOwnerSalonAddress =>
      'Namen des Inhabers, Salonnamen und Adresse ausfüllen';

  @override
  String get turnOnLocationPermission =>
      'Standort aktivieren und Zugriff erlauben, um dies zu nutzen';

  @override
  String get couldNotGetLocation =>
      'Dein Standort konnte nicht ermittelt werden';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Diese Telefonnummer ist bereits registriert. Bitte melde dich stattdessen an.';

  @override
  String get signupFailedCheckBackend =>
      'Registrierung fehlgeschlagen. Serververbindung prüfen.';

  @override
  String get signupFailedTryAgain =>
      'Registrierung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get yourSalon => 'Dein Salon';

  @override
  String get salonDetailsSubtitle => 'Schritt 2 von 3 · Salondetails';

  @override
  String get ownerNameLabel => 'Name des Inhabers';

  @override
  String get salonNameLabel => 'Salonname';

  @override
  String get salonAddressLabel => 'Salonadresse';

  @override
  String get locationSet => 'Standort festgelegt';

  @override
  String get useMyCurrentLocation => 'Meinen aktuellen Standort verwenden';

  @override
  String get pickYourColor => 'Wähle deine Farbe';

  @override
  String get colorPreviewHelp =>
      'Dies ist die Akzentfarbe deines Salons in der gesamten App. Ändere sie jederzeit im Konto.';

  @override
  String get previewLabel => 'Vorschau';

  @override
  String get newBooking => 'Neue Buchung';

  @override
  String get colorTeal => 'Petrol';

  @override
  String get colorTerracotta => 'Terrakotta';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorViolet => 'Violett';

  @override
  String get colorRose => 'Rosa';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get signInToDashboard => 'Bei deinem Salon-Dashboard anmelden';

  @override
  String get enterSalonOwnerPhone => 'Telefonnummer des Saloninhabers eingeben';

  @override
  String get enterYourPassword => 'Passwort eingeben';

  @override
  String get noSalonOwnerFound =>
      'Kein Saloninhaber-Konto für diese Telefonnummer gefunden.';

  @override
  String get loginFailedCheckBackend =>
      'Anmeldung fehlgeschlagen. Serververbindung prüfen.';

  @override
  String get loginFailedTryAgain =>
      'Anmeldung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get hidePassword => 'Passwort ausblenden';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get newHere => 'Neu hier?';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordEnterPhone =>
      'Gib deine Telefonnummer ein, wir senden dir einen 6-stelligen Code per WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Code per WhatsApp senden';

  @override
  String get codeSentViaWhatsApp =>
      'Falls dieses Konto existiert, wurde ein Code per WhatsApp gesendet.';

  @override
  String get resetPasswordEnterCode =>
      'Gib den per WhatsApp gesendeten Code ein und wähle dann ein neues Passwort.';

  @override
  String get otpCodeLabel => '6-stelliger Code';

  @override
  String get resetPasswordButton => 'Passwort zurücksetzen';

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get changePhoneNumber => 'Telefonnummer ändern';

  @override
  String get enterSixDigitCode => 'Gib den 6-stelligen Code ein';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordResetSuccess =>
      'Passwort zurückgesetzt. Bitte melde dich mit dem neuen Passwort an.';

  @override
  String get waitBeforeRetryingCode =>
      'Bitte warte eine Minute, bevor du einen weiteren Code anforderst';

  @override
  String get invalidOrExpiredCode => 'Dieser Code ist ungültig oder abgelaufen';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Zu viele Versuche — fordere einen neuen Code an';

  @override
  String get continueWithGoogle => 'Weiter mit Google';

  @override
  String get signedInWithGoogle => 'Mit Google angemeldet';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Mit Google angemeldet als $email';
  }

  @override
  String get usePasswordInstead => 'Stattdessen Passwort verwenden';

  @override
  String get googleSignInNotConfigured =>
      'Google-Anmeldung ist noch nicht eingerichtet';

  @override
  String get googleSignInFailed =>
      'Google-Anmeldung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get googleNoAccountFound =>
      'Kein Konto für dieses Google-Konto gefunden. Erstelle zuerst eines.';

  @override
  String get linkGoogleAccount => 'Google-Konto verknüpfen';

  @override
  String get googleAccountLinked =>
      'Google-Konto verknüpft — du kannst dich jetzt damit anmelden';

  @override
  String get addStaffBeforeBookings =>
      'Füge aktives Personal hinzu, bevor du Buchungen erstellst';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Heute';

  @override
  String get statRepeat => 'Stammkunden';

  @override
  String get statLoggedHelper => 'erfasst';

  @override
  String get statBackHelper => 'zurück';

  @override
  String get statWeek => 'Woche';

  @override
  String get statMonth => 'Monat';

  @override
  String get loggedTodayHeading => 'Heute erfasst';

  @override
  String get nothingLoggedToday =>
      'Heute noch nichts erfasst. Tippe auf \"Neue Buchung\", sobald eine Leistung abgeschlossen ist.';

  @override
  String get navHome => 'Start';

  @override
  String get navBookings => 'Buchungen';

  @override
  String get navStaff => 'Personal';

  @override
  String get navInsights => 'Einblicke';

  @override
  String get navAccount => 'Konto';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Diesem Inhaberkonto ist noch kein Salon zugeordnet.';

  @override
  String get bookingsTitle => 'Buchungen';

  @override
  String get searchCustomerOrService => 'Kunde oder Leistung suchen';

  @override
  String get filterThisWeek => 'Diese Woche';

  @override
  String get filterAllTime => 'Gesamter Zeitraum';

  @override
  String get filterAllStaff => 'Gesamtes Personal';

  @override
  String get staffLabel => 'Personal';

  @override
  String get needsActionHeading => 'Aktion erforderlich';

  @override
  String get statTotal => 'Gesamt';

  @override
  String get statServices => 'Leistungen';

  @override
  String get statAvgTicket => 'Ø Bon';

  @override
  String get noBookingsMatchFilter =>
      'Keine Buchungen entsprechen diesem Filter';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Leistungen',
      one: '$count Leistung',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Store konnte nicht geöffnet werden';

  @override
  String get updateRequired => 'Update erforderlich';

  @override
  String get updateRequiredBody =>
      'Eine neue Version der App ist verfügbar. Bitte aktualisiere, um dein Salon-Dashboard weiter zu nutzen.';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String get themeColorTitle => 'Themenfarbe';

  @override
  String get save => 'Speichern';

  @override
  String get staffTitle => 'Personal';

  @override
  String get addStaff => 'Personal hinzufügen';

  @override
  String get statActive => 'Aktiv';

  @override
  String get statTodaysTotal => 'Heutiger Gesamtbetrag';

  @override
  String get noActiveStaffYet => 'Noch kein aktives Personal';

  @override
  String get addFirstStaff => 'Erstes Personal hinzufügen';

  @override
  String get noServicesYet => 'Noch keine Leistungen';

  @override
  String get notActive => 'Nicht aktiv';

  @override
  String get canSetOwnPrice => 'Kann eigenen Preis festlegen';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Leistungen',
      one: '$count Leistung',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Neu';

  @override
  String get serviceLabel => 'Leistung';

  @override
  String get customerLabel => 'Kunde';

  @override
  String get repeatLabel => 'Stammkunde';

  @override
  String get couldNotUpdateBooking =>
      'Buchung konnte nicht aktualisiert werden. Bitte erneut versuchen.';

  @override
  String get couldNotAcceptReschedule =>
      'Terminverschiebung konnte nicht akzeptiert werden. Bitte erneut versuchen.';

  @override
  String get couldNotRejectReschedule =>
      'Terminverschiebung konnte nicht abgelehnt werden. Bitte erneut versuchen.';

  @override
  String get rescheduleLabel => 'Verschieben';

  @override
  String get pendingLabel => 'Ausstehend';

  @override
  String get scheduledLabel => 'Geplant';

  @override
  String get inProgressLabel => 'In Bearbeitung';

  @override
  String get startBookingButton => 'Starten';

  @override
  String get doneBookingButton => 'Fertig';

  @override
  String get todayScheduleHeading => 'Heutiger Zeitplan';

  @override
  String get paymentMethodLabel => 'Zahlung';

  @override
  String get paymentMethodCash => 'Bar';

  @override
  String get paymentMethodCard => 'Karte';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'Erneut buchen';

  @override
  String get couldNotLoadCustomerProfile =>
      'Kundenprofil konnte nicht geladen werden';

  @override
  String get notesSaved => 'Notizen gespeichert';

  @override
  String get couldNotSaveNotes =>
      'Notizen konnten nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get statsVisitsLabel => 'Besuche';

  @override
  String get statsTotalSpentLabel => 'Gesamtausgaben';

  @override
  String lastServiceSummary(String service, String date) {
    return 'Zuletzt: $service am $date';
  }

  @override
  String get notesLabel => 'Notizen';

  @override
  String get notesHint => 'Vorlieben, Allergien, alles Wichtige';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get addTagHint => 'Tag hinzufügen';

  @override
  String get saveNotesButton => 'Notizen speichern';

  @override
  String get visitHistoryHeading => 'Besuchsverlauf';

  @override
  String get noVisitsYet => 'Noch keine Besuche';

  @override
  String get viewProfileTooltip => 'Profil ansehen';

  @override
  String get dailyRevenueGoalLabel => 'Tägliches Umsatzziel';

  @override
  String get dailyRevenueGoalHint =>
      'Optional — leer lassen, um die Fortschrittsanzeige auf Home auszublenden';

  @override
  String get payoutsTooltip => 'Auszahlungen';

  @override
  String get staffActiveLabel => 'Aktiv';

  @override
  String get canCancelBookingLabel => 'Kann Buchungen stornieren';

  @override
  String get couldNotLoadPayouts => 'Auszahlungen konnten nicht geladen werden';

  @override
  String get payoutSettled => 'Auszahlung erfasst';

  @override
  String get couldNotMarkPaid =>
      'Konnte nicht als bezahlt markiert werden. Bitte erneut versuchen.';

  @override
  String get payoutsTitle => 'Einnahmen & Auszahlungen';

  @override
  String get unpaidLabel => 'Unbezahlt';

  @override
  String get markAsPaidButton => 'Als bezahlt markieren';

  @override
  String get grossRevenueLabel => 'Umsatz';

  @override
  String get totalPayoutLabel => 'Auszahlung';

  @override
  String get payoutHistoryHeading => 'Auszahlungsverlauf';

  @override
  String get noPayoutsYet => 'Noch keine Auszahlungen';

  @override
  String get payTypeLabel => 'Vergütungsart';

  @override
  String get payTypeCommission => 'Provision';

  @override
  String get payTypeSalary => 'Gehalt';

  @override
  String get payTypeBoth => 'Beides';

  @override
  String get commissionRateLabel => 'Provision %';

  @override
  String get monthlySalaryLabel => 'Monatsgehalt';

  @override
  String get couldNotSavePayType =>
      'Vergütungseinstellungen konnten nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get salaryThisMonthLabel => 'Gehalt diesen Monat';

  @override
  String get salaryPaidStatus => 'Bezahlt';

  @override
  String get paySalaryButton => 'Gehalt auszahlen';

  @override
  String get salaryPaid => 'Gehalt ausgezahlt';

  @override
  String get couldNotPaySalary =>
      'Gehalt konnte nicht ausgezahlt werden. Bitte erneut versuchen.';

  @override
  String get searchStaffHint => 'Mitarbeiter suchen';

  @override
  String get filterActiveStaff => 'Aktiv';

  @override
  String get filterInactiveStaff => 'Inaktiv';

  @override
  String get switchBranchTitle => 'Filiale wechseln';

  @override
  String get switchLabel => 'Filiale wechseln';

  @override
  String get allBranchesLabel => 'Alle Filialen';

  @override
  String get allBranchesSubtitle => 'Kombinierte Summen aller Filialen';

  @override
  String get pickBranchFirst => 'Bitte zuerst eine Filiale auswählen';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count erfasst · $revenue · $staff Mitarbeiter';
  }

  @override
  String get dayOffLabel => 'Frei';

  @override
  String get addBranchButton => 'Filiale hinzufügen';

  @override
  String get addBranchTitle => 'Filiale hinzufügen';

  @override
  String get branchNameAddressRequired =>
      'Name und Adresse der Filiale sind erforderlich';

  @override
  String get couldNotAddBranch =>
      'Filiale konnte nicht hinzugefügt werden. Bitte erneut versuchen.';

  @override
  String get fillProductFields => 'Bitte alle Produktfelder korrekt ausfüllen';

  @override
  String get couldNotSaveProduct =>
      'Produkt konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get editProductTitle => 'Produkt bearbeiten';

  @override
  String get addProductTitle => 'Produkt hinzufügen';

  @override
  String get productNameLabel => 'Produktname';

  @override
  String get skuLabel => 'SKU (optional)';

  @override
  String get stockQtyLabel => 'Bestand';

  @override
  String get lowStockThresholdLabel => 'Niedriger Bestand bei';

  @override
  String get deleteProductButton => 'Produkt löschen';

  @override
  String get productsTitle => 'Produkte';

  @override
  String get searchProductsHint => 'Produkte suchen';

  @override
  String get filterLowStock => 'Niedriger Bestand';

  @override
  String get noLowStockProducts => 'Kein Produkt mit niedrigem Bestand';

  @override
  String get noProductsInCatalog => 'Noch keine Produkte';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count auf Lager',
      one: '1 auf Lager',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'Niedriger Bestand';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Produkte haben niedrigen Bestand',
      one: '1 Produkt hat niedrigen Bestand',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'Heute';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Termine erfasst',
      one: '1 Termin erfasst',
      zero: 'Noch keine Termine erfasst',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$current von $goal Ziel';
  }

  @override
  String get worthReachingOutHeading => 'Heute lohnt sich Kontakt';

  @override
  String get exportCsvTooltip => 'CSV exportieren';

  @override
  String get couldNotExportEarnings =>
      'Einnahmen konnten nicht exportiert werden. Bitte erneut versuchen.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage überfällig',
      one: '1 Tag überfällig',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer mit $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Kunde hat $time angefragt';
  }

  @override
  String get reject => 'Ablehnen';

  @override
  String get accept => 'Annehmen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count weitere';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Kontodetails konnten nicht geladen werden';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Inhaber, Telefon, Salonname und Adresse ausfüllen';

  @override
  String get accountUpdated => 'Konto aktualisiert';

  @override
  String get phoneOrEmailUsed => 'Telefon oder E-Mail wird bereits verwendet';

  @override
  String get couldNotSaveAccount =>
      'Kontodetails konnten nicht gespeichert werden';

  @override
  String get newPasswordMinLength =>
      'Das neue Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get newPasswordsDontMatch =>
      'Die neuen Passwörter stimmen nicht überein';

  @override
  String get passwordChanged => 'Passwort geändert';

  @override
  String get currentPasswordIncorrect => 'Aktuelles Passwort ist falsch';

  @override
  String get couldNotChangePassword => 'Passwort konnte nicht geändert werden';

  @override
  String get countryAndCurrency => 'Land und Währung';

  @override
  String get accountTitle => 'Konto';

  @override
  String ownerSinceDate(String date) {
    return 'Inhaber seit $date';
  }

  @override
  String planLabel(String plan) {
    return '$plan-Plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Kundenbindungs-Einblicke 6 Monate kostenlos';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get salonProfile => 'Salonprofil';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get locationUpdated => 'Standort aktualisiert';

  @override
  String get saveDetailsButton => 'Details speichern';

  @override
  String get savingEllipsis => 'Wird gespeichert...';

  @override
  String get security => 'Sicherheit';

  @override
  String get currentPasswordLabel => 'Aktuelles Passwort';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get confirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get changePasswordButton => 'Passwort ändern';

  @override
  String get changingEllipsis => 'Wird geändert...';

  @override
  String get signOut => 'Abmelden';

  @override
  String get enterServiceNamePrice => 'Leistungsname und Preis eingeben';

  @override
  String get fillStaffNamePhone =>
      'Name und Telefonnummer des Personals ausfüllen';

  @override
  String get addAtLeastOneService => 'Füge mindestens eine Leistung hinzu';

  @override
  String get enterValidOpenCloseTimes =>
      'Gültige Öffnungs- und Schließzeiten eingeben (HH:MM, 24 Stunden)';

  @override
  String get selectAtLeastOneWorkingDay => 'Wähle mindestens einen Arbeitstag';

  @override
  String get staffPhoneInUse => 'Diese Telefonnummer wird bereits verwendet';

  @override
  String get couldNotAddStaff =>
      'Personal konnte nicht hinzugefügt werden. Bitte erneut versuchen.';

  @override
  String get addStaffSubtitle =>
      'Profil, Leistungen und Arbeitstage einrichten.';

  @override
  String get staffNameLabel => 'Name des Personals';

  @override
  String get staffPhoneLabel => 'Telefon des Personals';

  @override
  String get servicesLabel => 'Leistungen';

  @override
  String servicesAddedCount(int count) {
    return '$count hinzugefügt';
  }

  @override
  String get workingHours => 'Arbeitszeiten';

  @override
  String get opens => 'Öffnet';

  @override
  String get closes => 'Schließt';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Arbeitstage';

  @override
  String get serviceNameHint => 'Leistungsname';

  @override
  String get priceHint => 'Preis';

  @override
  String get dayMon => 'Mo';

  @override
  String get dayTue => 'Di';

  @override
  String get dayWed => 'Mi';

  @override
  String get dayThu => 'Do';

  @override
  String get dayFri => 'Fr';

  @override
  String get daySat => 'Sa';

  @override
  String get daySun => 'So';

  @override
  String get enterValidStaffNamePhone =>
      'Gültigen Namen und Telefonnummer des Personals eingeben';

  @override
  String get staffDetailsSaved => 'Personaldetails gespeichert';

  @override
  String get phoneAlreadyInUse => 'Diese Telefonnummer wird bereits verwendet';

  @override
  String get couldNotUpdateStaff => 'Personal konnte nicht aktualisiert werden';

  @override
  String get enterServiceNameAndPriceShort =>
      'Leistungsname und Preis eingeben';

  @override
  String get couldNotAddService => 'Leistung konnte nicht hinzugefügt werden';

  @override
  String get editServiceTitle => 'Leistung bearbeiten';

  @override
  String get enterValidServiceNamePrice =>
      'Gültigen Leistungsnamen und Preis eingeben';

  @override
  String get couldNotUpdateService =>
      'Leistung konnte nicht aktualisiert werden';

  @override
  String get saveServiceButton => 'Leistung speichern';

  @override
  String get couldNotRemoveServiceDefault =>
      'Leistung konnte nicht entfernt werden';

  @override
  String get useHHmmWorkingHours => 'Verwende HH:mm für Arbeitszeiten';

  @override
  String get hoursAdded => 'Zeiten hinzugefügt';

  @override
  String get couldNotAddWorkingHours =>
      'Arbeitszeiten konnten nicht hinzugefügt werden';

  @override
  String get couldNotRemoveTiming => 'Zeit konnte nicht entfernt werden';

  @override
  String get manageStaffTitle => 'Personal verwalten';

  @override
  String get done => 'Fertig';

  @override
  String get manageStaffSubtitle =>
      'Leistungen und Zeiten hinzufügen, bearbeiten oder entfernen, dann auf Fertig tippen.';

  @override
  String get saveStaffButton => 'Personal speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get newServiceLabel => 'Neue Leistung';

  @override
  String get addingEllipsis => 'Wird hinzugefügt...';

  @override
  String get addServiceButton => 'Leistung hinzufügen';

  @override
  String get noTimingsYet => 'Noch keine Zeiten';

  @override
  String get removeLabel => 'Entfernen';

  @override
  String get startLabel => 'Beginn';

  @override
  String get endLabel => 'Ende';

  @override
  String get addMonSatHoursButton => 'Mo-Sa-Zeiten hinzufügen';

  @override
  String get saveHoursButton => 'Zeiten speichern';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Personal, Leistung und Datum wählen';

  @override
  String get noSlotsForDate => 'Keine verfügbaren Termine für dieses Datum.';

  @override
  String get couldNotLoadSlots => 'Termine konnten nicht geladen werden';

  @override
  String get enterCustomerName => 'Kundenname eingeben';

  @override
  String get chooseStaffAndService =>
      'Personal und mindestens eine Leistung wählen';

  @override
  String get enterCustomerPhone => 'Telefonnummer des Kunden eingeben';

  @override
  String get chooseAvailableSlot => 'Verfügbaren Termin wählen';

  @override
  String get couldNotCreateBooking =>
      'Buchung konnte nicht erstellt werden. Bitte erneut versuchen.';

  @override
  String get doneServiceOption => 'Leistung abgeschlossen';

  @override
  String get scheduleLaterOption => 'Später planen';

  @override
  String get customerNameLabel => 'Kundenname';

  @override
  String get customerPhoneLabel => 'Telefon des Kunden';

  @override
  String recordedNowDate(String date) {
    return 'Jetzt erfasst — $date';
  }

  @override
  String get dateLabel => 'Datum';

  @override
  String get yyyymmddHint => 'JJJJ-MM-TT';

  @override
  String get availableSlots => 'Verfügbare Termine';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get saveBooking => 'Buchung speichern';

  @override
  String saveBookingWithTotal(String total) {
    return 'Buchung speichern · $total';
  }

  @override
  String get addServiceTitle => 'Leistung hinzufügen';

  @override
  String get serviceNameLabel => 'Leistungsname';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get priceLabel => 'Preis';

  @override
  String get durationMinutesLabel => 'Dauer (Minuten)';

  @override
  String get deleteServiceButton => 'Leistung löschen';

  @override
  String get fillServiceFields => 'Name, Kategorie, Preis und Dauer eingeben';

  @override
  String get couldNotSaveService => 'Leistung konnte nicht gespeichert werden';

  @override
  String get noServicesInCatalog =>
      'Noch keine Leistungen. Füge die erste hinzu.';

  @override
  String get searchServicesHint => 'Leistungen suchen';

  @override
  String get filterAllCategories => 'Alle';

  @override
  String get assignToStaffLabel => 'Mitarbeiter zuweisen';

  @override
  String get anyStaffOption => 'Beliebiger Mitarbeiter';

  @override
  String get addStarterServicesButton => 'Häufige Leistungen hinzufügen';

  @override
  String get bookingLinkSectionTitle => 'Buchungslink';

  @override
  String get bookingLinkSectionSubtitle =>
      'Teile diesen Link oder QR-Code, damit Kunden online buchen können';

  @override
  String get copyLinkButton => 'Kopieren';

  @override
  String get shareLinkButton => 'Teilen';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return 'Buche bei $salonName: $link';
  }
}
