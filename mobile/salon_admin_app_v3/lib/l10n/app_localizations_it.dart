// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get insightsTitle => 'Statistiche';

  @override
  String get tabEarnings => 'Guadagni';

  @override
  String get tabRetention => 'Fidelizzazione';

  @override
  String get periodToday => 'Oggi';

  @override
  String get periodWeek => 'Settimana';

  @override
  String get periodMonth => 'Mese';

  @override
  String get periodLast7Days => 'Ultimi 7 giorni';

  @override
  String get periodLast30Days => 'Ultimi 30 giorni';

  @override
  String get earningsLoadError => 'Impossibile caricare i guadagni.';

  @override
  String get retry => 'Riprova';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servizi',
      one: '$count servizio',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Servizi completati';

  @override
  String get noCompletedServices =>
      'Nessun servizio completato in questo periodo.';

  @override
  String get topServicesHeading => 'Servizi principali';

  @override
  String get byStaffHeading => 'Per personale';

  @override
  String get vsYesterday => 'vs ieri';

  @override
  String get vsLastWeek => 'vs settimana scorsa';

  @override
  String get vsLastMonth => 'vs mese scorso';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Clienti recuperati';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clienti sono tornati questo mese',
      one: '$count cliente è tornato questo mese',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError =>
      'Impossibile caricare il report di fidelizzazione.';

  @override
  String get couldNotOpenWhatsapp => 'Impossibile aprire WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Ciao $name! Ci sei mancato/a da $salonName. Prenota la tua prossima visita e goditi un\'offerta speciale di bentornato. A presto!';
  }

  @override
  String get customerCohortsHeading => 'Gruppi di clienti';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count clienti';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Nessun cliente $label in questo periodo.';
  }

  @override
  String get missedCustomersHeading => 'Clienti persi';

  @override
  String get missedCustomersHint =>
      'Tocca \"Ricorda\" per inviare loro un messaggio su WhatsApp.';

  @override
  String get noMissedCustomers => 'Nessun cliente perso questo mese.';

  @override
  String get cohortRegulars => 'Abituali';

  @override
  String get cohortNew => 'Nuovi';

  @override
  String get cohortCameBack => 'Tornati';

  @override
  String get cohortStoppedComing => 'Non vengono più';

  @override
  String get customersLabel => 'clienti';

  @override
  String get reachOutNow => 'Contatta ora';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count clienti abituali si stanno perdendo · $revenue a rischio';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× in ritardo';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Di solito ogni ${cadence}gg · ${overdue}gg di ritardo';
  }

  @override
  String get remind => 'Ricorda';

  @override
  String get remindOnWhatsappTooltip => 'Ricorda su WhatsApp';

  @override
  String get retentionProTitle =>
      'Le statistiche di fidelizzazione sono una funzione PRO';

  @override
  String get retentionProBody =>
      'Scopri chi non viene più, il tuo rapporto tra clienti nuovi e di ritorno, e recupera i clienti persi con promemoria a un tocco.';

  @override
  String get upgradeToPro => 'Passa a PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits visite · speso $spend';
  }

  @override
  String get createYourAccount => 'Crea il tuo account';

  @override
  String get basics => 'Informazioni di base';

  @override
  String get country => 'Paese';

  @override
  String get countryHelperText =>
      'Imposta la tua valuta, il formato del telefono e la lingua predefinita.';

  @override
  String get language => 'Lingua';

  @override
  String get phoneNumberLabel => 'Numero di telefono';

  @override
  String get passwordLabel => 'Password';

  @override
  String stepOfTotal(int step, int total) {
    return 'Passo $step di $total';
  }

  @override
  String get createAccountButton => 'Crea account';

  @override
  String get continueButton => 'Continua';

  @override
  String get enterPhoneNumber => 'Inserisci un numero di telefono';

  @override
  String get passwordMinLength =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get fillOwnerSalonAddress =>
      'Inserisci nome del proprietario, nome del salone e indirizzo';

  @override
  String get turnOnLocationPermission =>
      'Attiva la posizione e consenti l\'accesso per usare questa funzione';

  @override
  String get couldNotGetLocation => 'Impossibile ottenere la tua posizione';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Questo telefono è già registrato. Accedi invece.';

  @override
  String get signupFailedCheckBackend =>
      'Registrazione non riuscita. Controlla la connessione al server.';

  @override
  String get signupFailedTryAgain => 'Registrazione non riuscita. Riprova.';

  @override
  String get yourSalon => 'Il tuo salone';

  @override
  String get salonDetailsSubtitle => 'Passo 2 di 3 · Dettagli del salone';

  @override
  String get ownerNameLabel => 'Nome del proprietario';

  @override
  String get salonNameLabel => 'Nome del salone';

  @override
  String get salonAddressLabel => 'Indirizzo del salone';

  @override
  String get locationSet => 'Posizione impostata';

  @override
  String get useMyCurrentLocation => 'Usa la mia posizione attuale';

  @override
  String get pickYourColor => 'Scegli il tuo colore';

  @override
  String get colorPreviewHelp =>
      'Questo è il colore d\'accento del tuo salone in tutta l\'app. Cambialo quando vuoi in Account.';

  @override
  String get previewLabel => 'Anteprima';

  @override
  String get newBooking => 'Nuova prenotazione';

  @override
  String get colorTeal => 'Verde acqua';

  @override
  String get colorTerracotta => 'Terracotta';

  @override
  String get colorBlue => 'Blu';

  @override
  String get colorViolet => 'Viola';

  @override
  String get colorRose => 'Rosa';

  @override
  String get welcomeBack => 'Bentornato/a';

  @override
  String get signInToDashboard => 'Accedi alla dashboard del tuo salone';

  @override
  String get enterSalonOwnerPhone =>
      'Inserisci il telefono del proprietario del salone';

  @override
  String get enterYourPassword => 'Inserisci la tua password';

  @override
  String get noSalonOwnerFound =>
      'Nessun account proprietario di salone trovato per questo telefono.';

  @override
  String get loginFailedCheckBackend =>
      'Accesso non riuscito. Controlla la connessione al server.';

  @override
  String get loginFailedTryAgain => 'Accesso non riuscito. Riprova.';

  @override
  String get hidePassword => 'Nascondi password';

  @override
  String get showPassword => 'Mostra password';

  @override
  String get signIn => 'Accedi';

  @override
  String get newHere => 'Nuovo qui?';

  @override
  String get createAccount => 'Crea account';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get resetPasswordTitle => 'Reimposta password';

  @override
  String get resetPasswordEnterPhone =>
      'Inserisci il tuo numero di telefono, ti invieremo un codice a 6 cifre via WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Invia codice via WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Se quell\'account esiste, è stato inviato un codice via WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Inserisci il codice che ti abbiamo inviato su WhatsApp, poi scegli una nuova password.';

  @override
  String get otpCodeLabel => 'Codice a 6 cifre';

  @override
  String get resetPasswordButton => 'Reimposta password';

  @override
  String get resendCode => 'Invia di nuovo il codice';

  @override
  String get changePhoneNumber => 'Cambia numero di telefono';

  @override
  String get enterSixDigitCode => 'Inserisci il codice a 6 cifre';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get passwordResetSuccess =>
      'Password reimpostata. Accedi con la nuova password.';

  @override
  String get waitBeforeRetryingCode =>
      'Attendi un minuto prima di richiedere un altro codice';

  @override
  String get invalidOrExpiredCode => 'Il codice non è valido o è scaduto';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Troppi tentativi — richiedi un nuovo codice';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get signedInWithGoogle => 'Accesso effettuato con Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Accesso effettuato con Google come $email';
  }

  @override
  String get usePasswordInstead => 'Usa invece la password';

  @override
  String get googleSignInNotConfigured =>
      'L\'accesso con Google non è ancora configurato';

  @override
  String get googleSignInFailed => 'Accesso con Google non riuscito. Riprova.';

  @override
  String get googleNoAccountFound =>
      'Nessun account trovato per quell\'account Google. Creane prima uno.';

  @override
  String get linkGoogleAccount => 'Collega account Google';

  @override
  String get googleAccountLinked =>
      'Account Google collegato — ora puoi accedere con esso';

  @override
  String get addStaffBeforeBookings =>
      'Aggiungi personale attivo prima di creare prenotazioni';

  @override
  String get salonLabel => 'Salone';

  @override
  String get statToday => 'Oggi';

  @override
  String get statRepeat => 'Ricorrenti';

  @override
  String get statLoggedHelper => 'registrati';

  @override
  String get statBackHelper => 'tornati';

  @override
  String get statWeek => 'Settimana';

  @override
  String get statMonth => 'Mese';

  @override
  String get loggedTodayHeading => 'Registrati oggi';

  @override
  String get nothingLoggedToday =>
      'Ancora nulla registrato oggi. Tocca \"Nuova prenotazione\" quando un servizio è completato.';

  @override
  String get navHome => 'Home';

  @override
  String get navBookings => 'Prenotazioni';

  @override
  String get navStaff => 'Personale';

  @override
  String get navInsights => 'Statistiche';

  @override
  String get navAccount => 'Account';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Nessun salone ancora collegato a questo account proprietario.';

  @override
  String get bookingsTitle => 'Prenotazioni';

  @override
  String get searchCustomerOrService => 'Cerca cliente o servizio';

  @override
  String get filterThisWeek => 'Questa settimana';

  @override
  String get filterAllTime => 'Sempre';

  @override
  String get filterAllStaff => 'Tutto il personale';

  @override
  String get staffLabel => 'Personale';

  @override
  String get needsActionHeading => 'Richiede azione';

  @override
  String get statTotal => 'Totale';

  @override
  String get statServices => 'Servizi';

  @override
  String get statAvgTicket => 'Scontrino medio';

  @override
  String get noBookingsMatchFilter =>
      'Nessuna prenotazione corrisponde a questo filtro';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servizi',
      one: '$count servizio',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Impossibile aprire lo store';

  @override
  String get updateRequired => 'Aggiornamento richiesto';

  @override
  String get updateRequiredBody =>
      'È disponibile una nuova versione dell\'app. Aggiorna per continuare a usare la dashboard del tuo salone.';

  @override
  String get updateNow => 'Aggiorna ora';

  @override
  String get themeColorTitle => 'Colore del tema';

  @override
  String get save => 'Salva';

  @override
  String get staffTitle => 'Personale';

  @override
  String get addStaff => 'Aggiungi personale';

  @override
  String get statActive => 'Attivi';

  @override
  String get statTodaysTotal => 'Totale di oggi';

  @override
  String get noActiveStaffYet => 'Ancora nessun personale attivo';

  @override
  String get addFirstStaff => 'Aggiungi il primo membro del personale';

  @override
  String get noServicesYet => 'Ancora nessun servizio';

  @override
  String get notActive => 'Non attivo';

  @override
  String get canSetOwnPrice => 'Può impostare il proprio prezzo';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servizi',
      one: '$count servizio',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Nuovo';

  @override
  String get serviceLabel => 'Servizio';

  @override
  String get customerLabel => 'Cliente';

  @override
  String get repeatLabel => 'Ricorrente';

  @override
  String get couldNotUpdateBooking =>
      'Impossibile aggiornare la prenotazione. Riprova.';

  @override
  String get couldNotAcceptReschedule =>
      'Impossibile accettare la riprogrammazione. Riprova.';

  @override
  String get couldNotRejectReschedule =>
      'Impossibile rifiutare la riprogrammazione. Riprova.';

  @override
  String get rescheduleLabel => 'Riprogramma';

  @override
  String get pendingLabel => 'In sospeso';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer con $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Il cliente ha richiesto $time';
  }

  @override
  String get reject => 'Rifiuta';

  @override
  String get accept => 'Accetta';

  @override
  String get confirm => 'Conferma';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + altri $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount =>
      'Impossibile caricare i dettagli dell\'account';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Inserisci proprietario, telefono, nome del salone e indirizzo';

  @override
  String get accountUpdated => 'Account aggiornato';

  @override
  String get phoneOrEmailUsed => 'Telefono o email già in uso';

  @override
  String get couldNotSaveAccount =>
      'Impossibile salvare i dettagli dell\'account';

  @override
  String get newPasswordMinLength =>
      'La nuova password deve contenere almeno 6 caratteri';

  @override
  String get newPasswordsDontMatch => 'Le nuove password non corrispondono';

  @override
  String get passwordChanged => 'Password cambiata';

  @override
  String get currentPasswordIncorrect => 'La password attuale non è corretta';

  @override
  String get couldNotChangePassword => 'Impossibile cambiare la password';

  @override
  String get countryAndCurrency => 'Paese e valuta';

  @override
  String get accountTitle => 'Account';

  @override
  String ownerSinceDate(String date) {
    return 'Proprietario dal $date';
  }

  @override
  String planLabel(String plan) {
    return 'Piano $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Statistiche di fidelizzazione gratuite per 6 mesi';

  @override
  String get upgrade => 'Aggiorna';

  @override
  String get appearance => 'Aspetto';

  @override
  String get salonProfile => 'Profilo del salone';

  @override
  String get emailLabel => 'Email';

  @override
  String get locationUpdated => 'Posizione aggiornata';

  @override
  String get saveDetailsButton => 'Salva dettagli';

  @override
  String get savingEllipsis => 'Salvataggio...';

  @override
  String get security => 'Sicurezza';

  @override
  String get currentPasswordLabel => 'Password attuale';

  @override
  String get newPasswordLabel => 'Nuova password';

  @override
  String get confirmNewPasswordLabel => 'Conferma nuova password';

  @override
  String get changePasswordButton => 'Cambia password';

  @override
  String get changingEllipsis => 'Modifica in corso...';

  @override
  String get signOut => 'Esci';

  @override
  String get enterServiceNamePrice => 'Inserisci nome e prezzo del servizio';

  @override
  String get fillStaffNamePhone => 'Inserisci nome e telefono del personale';

  @override
  String get addAtLeastOneService => 'Aggiungi almeno un servizio';

  @override
  String get enterValidOpenCloseTimes =>
      'Inserisci orari di apertura e chiusura validi (HH:MM, 24 ore)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Seleziona almeno un giorno lavorativo';

  @override
  String get staffPhoneInUse => 'Quel telefono del personale è già in uso';

  @override
  String get couldNotAddStaff =>
      'Impossibile aggiungere il personale. Riprova.';

  @override
  String get addStaffSubtitle =>
      'Configura profilo, servizi e giorni lavorativi.';

  @override
  String get staffNameLabel => 'Nome del personale';

  @override
  String get staffPhoneLabel => 'Telefono del personale';

  @override
  String get servicesLabel => 'Servizi';

  @override
  String servicesAddedCount(int count) {
    return '$count aggiunti';
  }

  @override
  String get workingHours => 'Orario di lavoro';

  @override
  String get opens => 'Apre';

  @override
  String get closes => 'Chiude';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Giorni lavorativi';

  @override
  String get serviceNameHint => 'Nome del servizio';

  @override
  String get priceHint => 'Prezzo';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mer';

  @override
  String get dayThu => 'Gio';

  @override
  String get dayFri => 'Ven';

  @override
  String get daySat => 'Sab';

  @override
  String get daySun => 'Dom';

  @override
  String get enterValidStaffNamePhone =>
      'Inserisci nome e telefono validi del personale';

  @override
  String get staffDetailsSaved => 'Dettagli del personale salvati';

  @override
  String get phoneAlreadyInUse => 'Quel telefono è già in uso';

  @override
  String get couldNotUpdateStaff => 'Impossibile aggiornare il personale';

  @override
  String get enterServiceNameAndPriceShort =>
      'Inserisci nome e prezzo del servizio';

  @override
  String get couldNotAddService => 'Impossibile aggiungere il servizio';

  @override
  String get editServiceTitle => 'Modifica servizio';

  @override
  String get enterValidServiceNamePrice =>
      'Inserisci nome e prezzo del servizio validi';

  @override
  String get couldNotUpdateService => 'Impossibile aggiornare il servizio';

  @override
  String get saveServiceButton => 'Salva servizio';

  @override
  String get couldNotRemoveServiceDefault =>
      'Impossibile rimuovere il servizio';

  @override
  String get useHHmmWorkingHours => 'Usa HH:mm per l\'orario di lavoro';

  @override
  String get hoursAdded => 'Orario aggiunto';

  @override
  String get couldNotAddWorkingHours =>
      'Impossibile aggiungere l\'orario di lavoro';

  @override
  String get couldNotRemoveTiming => 'Impossibile rimuovere l\'orario';

  @override
  String get manageStaffTitle => 'Gestisci personale';

  @override
  String get done => 'Fatto';

  @override
  String get manageStaffSubtitle =>
      'Aggiungi, modifica o rimuovi servizi e orari, poi tocca Fatto.';

  @override
  String get saveStaffButton => 'Salva personale';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get newServiceLabel => 'Nuovo servizio';

  @override
  String get addingEllipsis => 'Aggiunta in corso...';

  @override
  String get addServiceButton => 'Aggiungi servizio';

  @override
  String get noTimingsYet => 'Ancora nessun orario';

  @override
  String get removeLabel => 'Rimuovi';

  @override
  String get startLabel => 'Inizio';

  @override
  String get endLabel => 'Fine';

  @override
  String get addMonSatHoursButton => 'Aggiungi orario Lun-Sab';

  @override
  String get saveHoursButton => 'Salva orario';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Scegli personale, servizio e data';

  @override
  String get noSlotsForDate => 'Nessuno slot disponibile per questa data.';

  @override
  String get couldNotLoadSlots => 'Impossibile caricare gli slot';

  @override
  String get enterCustomerName => 'Inserisci il nome del cliente';

  @override
  String get chooseStaffAndService =>
      'Scegli il personale e almeno un servizio';

  @override
  String get enterCustomerPhone => 'Inserisci il telefono del cliente';

  @override
  String get chooseAvailableSlot => 'Scegli uno slot disponibile';

  @override
  String get couldNotCreateBooking =>
      'Impossibile creare la prenotazione. Riprova.';

  @override
  String get doneServiceOption => 'Servizio completato';

  @override
  String get scheduleLaterOption => 'Programma più tardi';

  @override
  String get customerNameLabel => 'Nome del cliente';

  @override
  String get customerPhoneLabel => 'Telefono del cliente';

  @override
  String recordedNowDate(String date) {
    return 'Registrato ora — $date';
  }

  @override
  String get dateLabel => 'Data';

  @override
  String get yyyymmddHint => 'AAAA-MM-GG';

  @override
  String get availableSlots => 'Slot disponibili';

  @override
  String get cancel => 'Annulla';

  @override
  String get saveBooking => 'Salva prenotazione';

  @override
  String saveBookingWithTotal(String total) {
    return 'Salva prenotazione · $total';
  }
}
