// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get insightsTitle => 'Statistiques';

  @override
  String get tabEarnings => 'Revenus';

  @override
  String get tabRetention => 'Fidélisation';

  @override
  String get periodToday => 'Aujourd\'hui';

  @override
  String get periodWeek => 'Semaine';

  @override
  String get periodMonth => 'Mois';

  @override
  String get periodLast7Days => '7 derniers jours';

  @override
  String get periodLast30Days => '30 derniers jours';

  @override
  String get earningsLoadError => 'Impossible de charger les revenus.';

  @override
  String get retry => 'Réessayer';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '$count service',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Services terminés';

  @override
  String get noCompletedServices => 'Aucun service terminé pour cette période.';

  @override
  String get topServicesHeading => 'Meilleurs services';

  @override
  String get byStaffHeading => 'Par personnel';

  @override
  String get vsYesterday => 'vs hier';

  @override
  String get vsLastWeek => 'vs semaine dernière';

  @override
  String get vsLastMonth => 'vs mois dernier';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Clients récupérés';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clients sont revenus ce mois-ci',
      one: '$count client est revenu ce mois-ci',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError =>
      'Impossible de charger le rapport de fidélisation.';

  @override
  String get couldNotOpenWhatsapp => 'Impossible d\'ouvrir WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Bonjour $name ! Vous nous manquez chez $salonName. Réservez votre prochaine visite et profitez d\'une offre spéciale de bienvenue. À bientôt !';
  }

  @override
  String get customerCohortsHeading => 'Groupes de clients';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count clients';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Aucun client $label pour cette période.';
  }

  @override
  String get missedCustomersHeading => 'Clients manqués';

  @override
  String get missedCustomersHint =>
      'Appuyez sur \"Rappeler\" pour leur envoyer un message WhatsApp.';

  @override
  String get noMissedCustomers => 'Aucun client manqué ce mois-ci.';

  @override
  String get cohortRegulars => 'Habitués';

  @override
  String get cohortNew => 'Nouveaux';

  @override
  String get cohortCameBack => 'Revenus';

  @override
  String get cohortStoppedComing => 'Ne viennent plus';

  @override
  String get customersLabel => 'clients';

  @override
  String get reachOutNow => 'Contacter maintenant';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count clients habitués s\'éloignent · $revenue à risque';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× en retard';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Généralement tous les ${cadence}j · ${overdue}j de retard';
  }

  @override
  String get remind => 'Rappeler';

  @override
  String get remindOnWhatsappTooltip => 'Rappeler via WhatsApp';

  @override
  String get retentionProTitle =>
      'Les statistiques de fidélisation sont une fonctionnalité PRO';

  @override
  String get retentionProBody =>
      'Découvrez qui ne vient plus, votre ratio de clients nouveaux/récurrents, et récupérez les clients perdus grâce à des rappels en un clic.';

  @override
  String get upgradeToPro => 'Passer à PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits visites · $spend dépensés';
  }

  @override
  String get createYourAccount => 'Créez votre compte';

  @override
  String get basics => 'Informations de base';

  @override
  String get country => 'Pays';

  @override
  String get countryHelperText =>
      'Définit votre devise, le format de téléphone et la langue par défaut.';

  @override
  String get language => 'Langue';

  @override
  String get phoneNumberLabel => 'Numéro de téléphone';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String stepOfTotal(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get createAccountButton => 'Créer un compte';

  @override
  String get continueButton => 'Continuer';

  @override
  String get enterPhoneNumber => 'Entrez un numéro de téléphone';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get fillOwnerSalonAddress =>
      'Renseignez le nom du propriétaire, le nom du salon et l\'adresse';

  @override
  String get turnOnLocationPermission =>
      'Activez la localisation et autorisez l\'accès pour utiliser cette fonction';

  @override
  String get couldNotGetLocation => 'Impossible d\'obtenir votre position';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Ce téléphone est déjà enregistré. Veuillez plutôt vous connecter.';

  @override
  String get signupFailedCheckBackend =>
      'Échec de l\'inscription. Vérifiez la connexion au serveur.';

  @override
  String get signupFailedTryAgain =>
      'Échec de l\'inscription. Veuillez réessayer.';

  @override
  String get yourSalon => 'Votre salon';

  @override
  String get salonDetailsSubtitle => 'Étape 2 sur 3 · Détails du salon';

  @override
  String get ownerNameLabel => 'Nom du propriétaire';

  @override
  String get salonNameLabel => 'Nom du salon';

  @override
  String get salonAddressLabel => 'Adresse du salon';

  @override
  String get locationSet => 'Position définie';

  @override
  String get useMyCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String get pickYourColor => 'Choisissez votre couleur';

  @override
  String get colorPreviewHelp =>
      'C\'est la couleur d\'accent de votre salon dans toute l\'application. Changez-la à tout moment dans Compte.';

  @override
  String get previewLabel => 'Aperçu';

  @override
  String get newBooking => 'Nouvelle réservation';

  @override
  String get colorTeal => 'Sarcelle';

  @override
  String get colorTerracotta => 'Terre cuite';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorRose => 'Rose';

  @override
  String get welcomeBack => 'Content de vous revoir';

  @override
  String get signInToDashboard =>
      'Connectez-vous au tableau de bord de votre salon';

  @override
  String get enterSalonOwnerPhone =>
      'Entrez le téléphone du propriétaire du salon';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get noSalonOwnerFound =>
      'Aucun compte de propriétaire de salon trouvé pour ce téléphone.';

  @override
  String get loginFailedCheckBackend =>
      'Échec de la connexion. Vérifiez la connexion au serveur.';

  @override
  String get loginFailedTryAgain =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get newHere => 'Nouveau ici ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordEnterPhone =>
      'Entrez votre numéro de téléphone, nous vous enverrons un code à 6 chiffres via WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Envoyer le code via WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Si ce compte existe, un code a été envoyé via WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Entrez le code envoyé sur WhatsApp, puis choisissez un nouveau mot de passe.';

  @override
  String get otpCodeLabel => 'Code à 6 chiffres';

  @override
  String get resetPasswordButton => 'Réinitialiser le mot de passe';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get changePhoneNumber => 'Changer de numéro de téléphone';

  @override
  String get enterSixDigitCode => 'Entrez le code à 6 chiffres';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordResetSuccess =>
      'Mot de passe réinitialisé. Connectez-vous avec votre nouveau mot de passe.';

  @override
  String get waitBeforeRetryingCode =>
      'Veuillez attendre une minute avant de demander un autre code';

  @override
  String get invalidOrExpiredCode => 'Ce code est invalide ou a expiré';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Trop de tentatives — demandez un nouveau code';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get signedInWithGoogle => 'Connecté avec Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Connecté avec Google en tant que $email';
  }

  @override
  String get usePasswordInstead => 'Utiliser un mot de passe à la place';

  @override
  String get googleSignInNotConfigured =>
      'La connexion Google n\'est pas encore configurée';

  @override
  String get googleSignInFailed =>
      'Échec de la connexion Google. Veuillez réessayer.';

  @override
  String get googleNoAccountFound =>
      'Aucun compte trouvé pour ce compte Google. Créez-en un d\'abord.';

  @override
  String get linkGoogleAccount => 'Lier un compte Google';

  @override
  String get googleAccountLinked =>
      'Compte Google lié — vous pouvez maintenant l\'utiliser pour vous connecter';

  @override
  String get addStaffBeforeBookings =>
      'Ajoutez du personnel actif avant de créer des réservations';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Aujourd\'hui';

  @override
  String get statRepeat => 'Récurrents';

  @override
  String get statLoggedHelper => 'enregistrés';

  @override
  String get statBackHelper => 'revenus';

  @override
  String get statWeek => 'Semaine';

  @override
  String get statMonth => 'Mois';

  @override
  String get loggedTodayHeading => 'Enregistré aujourd\'hui';

  @override
  String get nothingLoggedToday =>
      'Rien d\'enregistré aujourd\'hui pour l\'instant. Appuyez sur \"Nouvelle réservation\" une fois un service terminé.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navBookings => 'Réservations';

  @override
  String get navStaff => 'Personnel';

  @override
  String get navInsights => 'Statistiques';

  @override
  String get navAccount => 'Compte';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Aucun salon n\'est encore lié à ce compte propriétaire.';

  @override
  String get bookingsTitle => 'Réservations';

  @override
  String get searchCustomerOrService => 'Rechercher un client ou un service';

  @override
  String get filterThisWeek => 'Cette semaine';

  @override
  String get filterAllTime => 'Toute la période';

  @override
  String get filterAllStaff => 'Tout le personnel';

  @override
  String get staffLabel => 'Personnel';

  @override
  String get needsActionHeading => 'Action requise';

  @override
  String get statTotal => 'Total';

  @override
  String get statServices => 'Services';

  @override
  String get statAvgTicket => 'Panier moyen';

  @override
  String get noBookingsMatchFilter =>
      'Aucune réservation ne correspond à ce filtre';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '$count service',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Impossible d\'ouvrir la boutique';

  @override
  String get updateRequired => 'Mise à jour requise';

  @override
  String get updateRequiredBody =>
      'Une nouvelle version de l\'application est disponible. Veuillez mettre à jour pour continuer à utiliser le tableau de bord de votre salon.';

  @override
  String get updateNow => 'Mettre à jour maintenant';

  @override
  String get themeColorTitle => 'Couleur du thème';

  @override
  String get save => 'Enregistrer';

  @override
  String get staffTitle => 'Personnel';

  @override
  String get addStaff => 'Ajouter du personnel';

  @override
  String get statActive => 'Actifs';

  @override
  String get statTodaysTotal => 'Total du jour';

  @override
  String get noActiveStaffYet => 'Aucun personnel actif pour l\'instant';

  @override
  String get addFirstStaff => 'Ajouter le premier membre du personnel';

  @override
  String get noServicesYet => 'Aucun service pour l\'instant';

  @override
  String get notActive => 'Non actif';

  @override
  String get canSetOwnPrice => 'Peut fixer son propre prix';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '$count service',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Nouveau';

  @override
  String get serviceLabel => 'Service';

  @override
  String get customerLabel => 'Client';

  @override
  String get repeatLabel => 'Récurrent';

  @override
  String get couldNotUpdateBooking =>
      'Impossible de mettre à jour la réservation. Veuillez réessayer.';

  @override
  String get couldNotAcceptReschedule =>
      'Impossible d\'accepter le report. Veuillez réessayer.';

  @override
  String get couldNotRejectReschedule =>
      'Impossible de refuser le report. Veuillez réessayer.';

  @override
  String get rescheduleLabel => 'Reporter';

  @override
  String get pendingLabel => 'En attente';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer avec $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Le client a demandé $time';
  }

  @override
  String get reject => 'Refuser';

  @override
  String get accept => 'Accepter';

  @override
  String get confirm => 'Confirmer';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count de plus';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount =>
      'Impossible de charger les détails du compte';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Renseignez propriétaire, téléphone, nom du salon et adresse';

  @override
  String get accountUpdated => 'Compte mis à jour';

  @override
  String get phoneOrEmailUsed => 'Téléphone ou e-mail déjà utilisé';

  @override
  String get couldNotSaveAccount =>
      'Impossible d\'enregistrer les détails du compte';

  @override
  String get newPasswordMinLength =>
      'Le nouveau mot de passe doit comporter au moins 6 caractères';

  @override
  String get newPasswordsDontMatch =>
      'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get passwordChanged => 'Mot de passe modifié';

  @override
  String get currentPasswordIncorrect => 'Le mot de passe actuel est incorrect';

  @override
  String get couldNotChangePassword => 'Impossible de modifier le mot de passe';

  @override
  String get countryAndCurrency => 'Pays et devise';

  @override
  String get accountTitle => 'Compte';

  @override
  String ownerSinceDate(String date) {
    return 'Propriétaire depuis le $date';
  }

  @override
  String planLabel(String plan) {
    return 'Forfait $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Statistiques de fidélisation gratuites pendant 6 mois';

  @override
  String get upgrade => 'Améliorer';

  @override
  String get appearance => 'Apparence';

  @override
  String get salonProfile => 'Profil du salon';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get locationUpdated => 'Position mise à jour';

  @override
  String get saveDetailsButton => 'Enregistrer les détails';

  @override
  String get savingEllipsis => 'Enregistrement...';

  @override
  String get security => 'Sécurité';

  @override
  String get currentPasswordLabel => 'Mot de passe actuel';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get changePasswordButton => 'Changer le mot de passe';

  @override
  String get changingEllipsis => 'Modification...';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get enterServiceNamePrice => 'Entrez le nom et le prix du service';

  @override
  String get fillStaffNamePhone =>
      'Renseignez le nom et le téléphone du personnel';

  @override
  String get addAtLeastOneService => 'Ajoutez au moins un service';

  @override
  String get enterValidOpenCloseTimes =>
      'Entrez des horaires d\'ouverture et de fermeture valides (HH:MM, 24 heures)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Sélectionnez au moins un jour de travail';

  @override
  String get staffPhoneInUse => 'Ce téléphone du personnel est déjà utilisé';

  @override
  String get couldNotAddStaff =>
      'Impossible d\'ajouter le personnel. Veuillez réessayer.';

  @override
  String get addStaffSubtitle =>
      'Configurez son profil, ses services et ses jours de travail.';

  @override
  String get staffNameLabel => 'Nom du personnel';

  @override
  String get staffPhoneLabel => 'Téléphone du personnel';

  @override
  String get servicesLabel => 'Services';

  @override
  String servicesAddedCount(int count) {
    return '$count ajoutés';
  }

  @override
  String get workingHours => 'Heures de travail';

  @override
  String get opens => 'Ouvre';

  @override
  String get closes => 'Ferme';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Jours de travail';

  @override
  String get serviceNameHint => 'Nom du service';

  @override
  String get priceHint => 'Prix';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mer';

  @override
  String get dayThu => 'Jeu';

  @override
  String get dayFri => 'Ven';

  @override
  String get daySat => 'Sam';

  @override
  String get daySun => 'Dim';

  @override
  String get enterValidStaffNamePhone =>
      'Entrez un nom et un téléphone valides du personnel';

  @override
  String get staffDetailsSaved => 'Détails du personnel enregistrés';

  @override
  String get phoneAlreadyInUse => 'Ce téléphone est déjà utilisé';

  @override
  String get couldNotUpdateStaff => 'Impossible de mettre à jour le personnel';

  @override
  String get enterServiceNameAndPriceShort =>
      'Entrez le nom et le prix du service';

  @override
  String get couldNotAddService => 'Impossible d\'ajouter le service';

  @override
  String get editServiceTitle => 'Modifier le service';

  @override
  String get enterValidServiceNamePrice =>
      'Entrez un nom et un prix de service valides';

  @override
  String get couldNotUpdateService => 'Impossible de mettre à jour le service';

  @override
  String get saveServiceButton => 'Enregistrer le service';

  @override
  String get couldNotRemoveServiceDefault =>
      'Impossible de supprimer le service';

  @override
  String get useHHmmWorkingHours => 'Utilisez HH:mm pour les heures de travail';

  @override
  String get hoursAdded => 'Horaires ajoutés';

  @override
  String get couldNotAddWorkingHours =>
      'Impossible d\'ajouter les heures de travail';

  @override
  String get couldNotRemoveTiming => 'Impossible de supprimer l\'horaire';

  @override
  String get manageStaffTitle => 'Gérer le personnel';

  @override
  String get done => 'Terminé';

  @override
  String get manageStaffSubtitle =>
      'Ajoutez, modifiez ou supprimez des services et des horaires, puis appuyez sur Terminé.';

  @override
  String get saveStaffButton => 'Enregistrer le personnel';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get newServiceLabel => 'Nouveau service';

  @override
  String get addingEllipsis => 'Ajout en cours...';

  @override
  String get addServiceButton => 'Ajouter un service';

  @override
  String get noTimingsYet => 'Aucun horaire pour l\'instant';

  @override
  String get removeLabel => 'Supprimer';

  @override
  String get startLabel => 'Début';

  @override
  String get endLabel => 'Fin';

  @override
  String get addMonSatHoursButton => 'Ajouter horaires Lun-Sam';

  @override
  String get saveHoursButton => 'Enregistrer les horaires';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate =>
      'Choisissez le personnel, le service et la date';

  @override
  String get noSlotsForDate => 'Aucun créneau disponible pour cette date.';

  @override
  String get couldNotLoadSlots => 'Impossible de charger les créneaux';

  @override
  String get enterCustomerName => 'Entrez le nom du client';

  @override
  String get chooseStaffAndService =>
      'Choisissez le personnel et au moins un service';

  @override
  String get enterCustomerPhone => 'Entrez le téléphone du client';

  @override
  String get chooseAvailableSlot => 'Choisissez un créneau disponible';

  @override
  String get couldNotCreateBooking =>
      'Impossible de créer la réservation. Veuillez réessayer.';

  @override
  String get doneServiceOption => 'Service terminé';

  @override
  String get scheduleLaterOption => 'Programmer plus tard';

  @override
  String get customerNameLabel => 'Nom du client';

  @override
  String get customerPhoneLabel => 'Téléphone du client';

  @override
  String recordedNowDate(String date) {
    return 'Enregistré maintenant — $date';
  }

  @override
  String get dateLabel => 'Date';

  @override
  String get yyyymmddHint => 'AAAA-MM-JJ';

  @override
  String get availableSlots => 'Créneaux disponibles';

  @override
  String get cancel => 'Annuler';

  @override
  String get saveBooking => 'Enregistrer la réservation';

  @override
  String saveBookingWithTotal(String total) {
    return 'Enregistrer la réservation · $total';
  }
}
