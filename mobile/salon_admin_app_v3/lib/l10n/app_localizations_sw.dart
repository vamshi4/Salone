// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get insightsTitle => 'Maarifa';

  @override
  String get tabEarnings => 'Mapato';

  @override
  String get tabRetention => 'Uhifadhi wa Wateja';

  @override
  String get periodToday => 'Leo';

  @override
  String get periodWeek => 'Wiki';

  @override
  String get periodMonth => 'Mwezi';

  @override
  String get periodLast7Days => 'Siku 7 zilizopita';

  @override
  String get periodLast30Days => 'Siku 30 zilizopita';

  @override
  String get earningsLoadError => 'Imeshindwa kupakia mapato.';

  @override
  String get retry => 'Jaribu tena';

  @override
  String completedServicesCount(int count) {
    return 'huduma $count';
  }

  @override
  String get completedServicesHeading => 'Huduma zilizokamilika';

  @override
  String get noCompletedServices =>
      'Hakuna huduma iliyokamilika bado katika kipindi hiki.';

  @override
  String get topServicesHeading => 'Huduma bora';

  @override
  String get byStaffHeading => 'Kwa mfanyakazi';

  @override
  String get vsYesterday => 'ikilinganishwa na jana';

  @override
  String get vsLastWeek => 'ikilinganishwa na wiki iliyopita';

  @override
  String get vsLastMonth => 'ikilinganishwa na mwezi uliopita';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Wateja uliowarudisha';

  @override
  String reactivatedSummary(int count) {
    return 'wateja $count walirudi mwezi huu';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError =>
      'Imeshindwa kupakia ripoti ya uhifadhi wa wateja.';

  @override
  String get couldNotOpenWhatsapp => 'Imeshindwa kufungua WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Habari $name! Tumekukosa katika $salonName. Weka nafasi ya ziara yako inayofuata na ufurahie ofa maalum ya kukukaribisha tena. Tuonane hivi karibuni!';
  }

  @override
  String get customerCohortsHeading => 'Makundi ya wateja';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · wateja $count';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Hakuna wateja wa $label katika kipindi hiki.';
  }

  @override
  String get missedCustomersHeading => 'Wateja waliokosekana';

  @override
  String get missedCustomersHint =>
      'Gusa \"Kumbusha\" kuwatumia ujumbe kupitia WhatsApp.';

  @override
  String get noMissedCustomers => 'Hakuna mteja aliyekosekana mwezi huu.';

  @override
  String get cohortRegulars => 'Wa kawaida';

  @override
  String get cohortNew => 'Wapya';

  @override
  String get cohortCameBack => 'Warudi';

  @override
  String get cohortStoppedComing => 'Waliacha kuja';

  @override
  String get customersLabel => 'wateja';

  @override
  String get reachOutNow => 'Wasiliana sasa';

  @override
  String atRiskSummary(int count, String revenue) {
    return 'Wateja $count wa kawaida wanapungua · $revenue iko hatarini';
  }

  @override
  String overdueBadge(String ratio) {
    return 'amechelewa $ratio×';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Kawaida kila siku $cadence · amechelewa siku $overdue';
  }

  @override
  String get remind => 'Kumbusha';

  @override
  String get remindOnWhatsappTooltip => 'Kumbusha kupitia WhatsApp';

  @override
  String get retentionProTitle =>
      'Maarifa ya uhifadhi wa wateja ni kipengele cha PRO';

  @override
  String get retentionProBody =>
      'Ona ni nani aliyeacha kuja, uwiano wako wa wateja wapya dhidi ya waliorudi, na urudishe wateja waliopotea kwa vikumbusho vya mguso mmoja.';

  @override
  String get upgradeToPro => 'Boresha hadi PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return 'ziara $visits · $spend zilitumika';
  }

  @override
  String get createYourAccount => 'Unda akaunti yako';

  @override
  String get basics => 'Mambo ya msingi';

  @override
  String get country => 'Nchi';

  @override
  String get countryHelperText =>
      'Huamua sarafu yako, muundo wa simu, na lugha chaguo-msingi.';

  @override
  String get language => 'Lugha';

  @override
  String get phoneNumberLabel => 'Nambari ya simu';

  @override
  String get passwordLabel => 'Nenosiri';

  @override
  String stepOfTotal(int step, int total) {
    return 'Hatua $step kati ya $total';
  }

  @override
  String get createAccountButton => 'Unda akaunti';

  @override
  String get continueButton => 'Endelea';

  @override
  String get enterPhoneNumber => 'Weka nambari ya simu';

  @override
  String get passwordMinLength => 'Nenosiri lazima liwe na herufi 6 angalau';

  @override
  String get fillOwnerSalonAddress =>
      'Jaza jina la mmiliki, jina la saluni, na anwani';

  @override
  String get turnOnLocationPermission =>
      'Washa eneo na uruhusu ufikiaji kutumia hii';

  @override
  String get couldNotGetLocation => 'Imeshindwa kupata eneo lako';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Simu hii tayari imesajiliwa. Tafadhali ingia badala yake.';

  @override
  String get signupFailedCheckBackend =>
      'Usajili umeshindwa. Angalia muunganisho wa seva.';

  @override
  String get signupFailedTryAgain =>
      'Usajili umeshindwa. Tafadhali jaribu tena.';

  @override
  String get yourSalon => 'Saluni yako';

  @override
  String get salonDetailsSubtitle => 'Hatua 2 kati ya 3 · Maelezo ya saluni';

  @override
  String get ownerNameLabel => 'Jina la mmiliki';

  @override
  String get salonNameLabel => 'Jina la saluni';

  @override
  String get salonAddressLabel => 'Anwani ya saluni';

  @override
  String get locationSet => 'Eneo limewekwa';

  @override
  String get useMyCurrentLocation => 'Tumia eneo langu la sasa';

  @override
  String get pickYourColor => 'Chagua rangi yako';

  @override
  String get colorPreviewHelp =>
      'Hii ni rangi ya msisitizo ya saluni yako katika programu nzima. Ibadilishe wakati wowote katika Akaunti.';

  @override
  String get previewLabel => 'Onyesho la awali';

  @override
  String get newBooking => 'Uwekaji nafasi mpya';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorTerracotta => 'Terracotta';

  @override
  String get colorBlue => 'Bluu';

  @override
  String get colorViolet => 'Zambarau';

  @override
  String get colorRose => 'Waridi';

  @override
  String get welcomeBack => 'Karibu tena';

  @override
  String get signInToDashboard => 'Ingia katika dashibodi ya saluni yako';

  @override
  String get enterSalonOwnerPhone => 'Weka simu ya mmiliki wa saluni';

  @override
  String get enterYourPassword => 'Weka nenosiri lako';

  @override
  String get noSalonOwnerFound =>
      'Hakuna akaunti ya mmiliki wa saluni iliyopatikana kwa simu hii.';

  @override
  String get loginFailedCheckBackend =>
      'Kuingia kumeshindwa. Angalia muunganisho wa seva.';

  @override
  String get loginFailedTryAgain =>
      'Kuingia kumeshindwa. Tafadhali jaribu tena.';

  @override
  String get hidePassword => 'Ficha nenosiri';

  @override
  String get showPassword => 'Onyesha nenosiri';

  @override
  String get signIn => 'Ingia';

  @override
  String get newHere => 'Mpya hapa?';

  @override
  String get createAccount => 'Unda akaunti';

  @override
  String get forgotPassword => 'Umesahau nenosiri?';

  @override
  String get resetPasswordTitle => 'Weka upya nenosiri';

  @override
  String get resetPasswordEnterPhone =>
      'Weka nambari yako ya simu, tutatuma msimbo wa tarakimu 6 kupitia WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Tuma msimbo kupitia WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Ikiwa akaunti hiyo ipo, msimbo umetumwa kupitia WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Weka msimbo tuliokutumia kwenye WhatsApp, kisha chagua nenosiri jipya.';

  @override
  String get otpCodeLabel => 'Msimbo wa tarakimu 6';

  @override
  String get resetPasswordButton => 'Weka upya nenosiri';

  @override
  String get resendCode => 'Tuma tena msimbo';

  @override
  String get changePhoneNumber => 'Badilisha nambari ya simu';

  @override
  String get enterSixDigitCode => 'Weka msimbo wa tarakimu 6';

  @override
  String get passwordsDoNotMatch => 'Manenosiri hayafanani';

  @override
  String get passwordResetSuccess =>
      'Nenosiri limewekwa upya. Tafadhali ingia kwa nenosiri jipya.';

  @override
  String get waitBeforeRetryingCode =>
      'Tafadhali subiri dakika moja kabla ya kuomba msimbo mwingine';

  @override
  String get invalidOrExpiredCode =>
      'Msimbo huo si sahihi au umeisha muda wake';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Majaribio mengi mno — omba msimbo mpya';

  @override
  String get continueWithGoogle => 'Endelea na Google';

  @override
  String get signedInWithGoogle => 'Umeingia kwa Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Umeingia kwa Google kama $email';
  }

  @override
  String get usePasswordInstead => 'Tumia nenosiri badala yake';

  @override
  String get googleSignInNotConfigured => 'Kuingia kwa Google bado hakujawekwa';

  @override
  String get googleSignInFailed =>
      'Kuingia kwa Google kumeshindwa. Tafadhali jaribu tena.';

  @override
  String get googleNoAccountFound =>
      'Hakuna akaunti iliyopatikana kwa akaunti hiyo ya Google. Unda moja kwanza.';

  @override
  String get linkGoogleAccount => 'Unganisha akaunti ya Google';

  @override
  String get googleAccountLinked =>
      'Akaunti ya Google imeunganishwa — sasa unaweza kuingia kwa akaunti hiyo';

  @override
  String get addStaffBeforeBookings =>
      'Ongeza wafanyakazi hai kabla ya kuunda uwekaji nafasi';

  @override
  String get salonLabel => 'Saluni';

  @override
  String get statToday => 'Leo';

  @override
  String get statRepeat => 'Warudiao';

  @override
  String get statLoggedHelper => 'walioandikwa';

  @override
  String get statBackHelper => 'walirudi';

  @override
  String get statWeek => 'Wiki';

  @override
  String get statMonth => 'Mwezi';

  @override
  String get loggedTodayHeading => 'Ilioandikwa leo';

  @override
  String get nothingLoggedToday =>
      'Hakuna kilichoandikwa bado leo. Gusa \"Uwekaji nafasi mpya\" mara huduma inapokamilika.';

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navBookings => 'Uwekaji nafasi';

  @override
  String get navStaff => 'Wafanyakazi';

  @override
  String get navInsights => 'Maarifa';

  @override
  String get navAccount => 'Akaunti';

  @override
  String get salonAdminTitle => 'Msimamizi wa Saluni';

  @override
  String get noSalonLinked =>
      'Hakuna saluni iliyounganishwa na akaunti hii ya mmiliki bado.';

  @override
  String get bookingsTitle => 'Uwekaji nafasi';

  @override
  String get searchCustomerOrService => 'Tafuta mteja au huduma';

  @override
  String get filterThisWeek => 'Wiki hii';

  @override
  String get filterAllTime => 'Muda wote';

  @override
  String get filterAllStaff => 'Wafanyakazi wote';

  @override
  String get staffLabel => 'Wafanyakazi';

  @override
  String get needsActionHeading => 'Inahitaji hatua';

  @override
  String get statTotal => 'Jumla';

  @override
  String get statServices => 'Huduma';

  @override
  String get statAvgTicket => 'Wastani wa ankara';

  @override
  String get noBookingsMatchFilter =>
      'Hakuna uwekaji nafasi unaolingana na kichujio hiki';

  @override
  String get today => 'Leo';

  @override
  String get yesterday => 'Jana';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · huduma $count';
  }

  @override
  String get couldNotOpenStore => 'Imeshindwa kufungua duka';

  @override
  String get updateRequired => 'Sasisho linahitajika';

  @override
  String get updateRequiredBody =>
      'Toleo jipya la programu linapatikana. Tafadhali sasisha ili kuendelea kutumia dashibodi ya saluni yako.';

  @override
  String get updateNow => 'Sasisha sasa';

  @override
  String get themeColorTitle => 'Rangi ya mandhari';

  @override
  String get save => 'Hifadhi';

  @override
  String get staffTitle => 'Wafanyakazi';

  @override
  String get addStaff => 'Ongeza mfanyakazi';

  @override
  String get statActive => 'Hai';

  @override
  String get statTodaysTotal => 'Jumla ya leo';

  @override
  String get noActiveStaffYet => 'Hakuna mfanyakazi hai bado';

  @override
  String get addFirstStaff => 'Ongeza mfanyakazi wa kwanza';

  @override
  String get noServicesYet => 'Hakuna huduma bado';

  @override
  String get notActive => 'Sio hai';

  @override
  String get canSetOwnPrice => 'Anaweza kuweka bei yake mwenyewe';

  @override
  String staffTodayTally(int count, String revenue) {
    return 'huduma $count · $revenue';
  }

  @override
  String get newLabel => 'Mpya';

  @override
  String get serviceLabel => 'Huduma';

  @override
  String get customerLabel => 'Mteja';

  @override
  String get repeatLabel => 'Anayerudia';

  @override
  String get couldNotUpdateBooking =>
      'Imeshindwa kusasisha uwekaji nafasi. Tafadhali jaribu tena.';

  @override
  String get couldNotAcceptReschedule =>
      'Imeshindwa kukubali kupanga upya. Tafadhali jaribu tena.';

  @override
  String get couldNotRejectReschedule =>
      'Imeshindwa kukataa kupanga upya. Tafadhali jaribu tena.';

  @override
  String get rescheduleLabel => 'Panga upya';

  @override
  String get pendingLabel => 'Inasubiri';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer na $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Mteja aliomba $time';
  }

  @override
  String get reject => 'Kataa';

  @override
  String get accept => 'Kubali';

  @override
  String get confirm => 'Thibitisha';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count zaidi';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Imeshindwa kupakia maelezo ya akaunti';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Jaza mmiliki, simu, jina la saluni, na anwani';

  @override
  String get accountUpdated => 'Akaunti imesasishwa';

  @override
  String get phoneOrEmailUsed => 'Simu au barua pepe tayari inatumika';

  @override
  String get couldNotSaveAccount => 'Imeshindwa kuhifadhi maelezo ya akaunti';

  @override
  String get newPasswordMinLength =>
      'Nenosiri jipya lazima liwe na herufi 6 angalau';

  @override
  String get newPasswordsDontMatch => 'Manenosiri mapya hayafanani';

  @override
  String get passwordChanged => 'Nenosiri limebadilishwa';

  @override
  String get currentPasswordIncorrect => 'Nenosiri la sasa si sahihi';

  @override
  String get couldNotChangePassword => 'Imeshindwa kubadilisha nenosiri';

  @override
  String get countryAndCurrency => 'Nchi na sarafu';

  @override
  String get accountTitle => 'Akaunti';

  @override
  String ownerSinceDate(String date) {
    return 'Mmiliki tangu $date';
  }

  @override
  String planLabel(String plan) {
    return 'Mpango wa $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Maarifa ya uhifadhi wa wateja bure kwa miezi 6';

  @override
  String get upgrade => 'Boresha';

  @override
  String get appearance => 'Muonekano';

  @override
  String get salonProfile => 'Wasifu wa saluni';

  @override
  String get emailLabel => 'Barua pepe';

  @override
  String get locationUpdated => 'Eneo limesasishwa';

  @override
  String get saveDetailsButton => 'Hifadhi maelezo';

  @override
  String get savingEllipsis => 'Inahifadhi...';

  @override
  String get security => 'Usalama';

  @override
  String get currentPasswordLabel => 'Nenosiri la sasa';

  @override
  String get newPasswordLabel => 'Nenosiri jipya';

  @override
  String get confirmNewPasswordLabel => 'Thibitisha nenosiri jipya';

  @override
  String get changePasswordButton => 'Badilisha nenosiri';

  @override
  String get changingEllipsis => 'Inabadilisha...';

  @override
  String get signOut => 'Toka';

  @override
  String get enterServiceNamePrice => 'Weka jina la huduma na bei';

  @override
  String get fillStaffNamePhone => 'Jaza jina la mfanyakazi na simu';

  @override
  String get addAtLeastOneService => 'Ongeza huduma moja angalau';

  @override
  String get enterValidOpenCloseTimes =>
      'Weka nyakati sahihi za kufungua na kufunga (SS:DD, saa 24)';

  @override
  String get selectAtLeastOneWorkingDay => 'Chagua siku moja ya kazi angalau';

  @override
  String get staffPhoneInUse => 'Simu hiyo ya mfanyakazi tayari inatumika';

  @override
  String get couldNotAddStaff =>
      'Imeshindwa kuongeza mfanyakazi. Tafadhali jaribu tena.';

  @override
  String get addStaffSubtitle => 'Weka wasifu wake, huduma, na siku za kazi.';

  @override
  String get staffNameLabel => 'Jina la mfanyakazi';

  @override
  String get staffPhoneLabel => 'Simu ya mfanyakazi';

  @override
  String get servicesLabel => 'Huduma';

  @override
  String servicesAddedCount(int count) {
    return '$count zimeongezwa';
  }

  @override
  String get workingHours => 'Saa za kazi';

  @override
  String get opens => 'Inafungua';

  @override
  String get closes => 'Inafunga';

  @override
  String get hhmmHint => 'SS:DD';

  @override
  String get workingDays => 'Siku za kazi';

  @override
  String get serviceNameHint => 'Jina la huduma';

  @override
  String get priceHint => 'Bei';

  @override
  String get dayMon => 'Jtt';

  @override
  String get dayTue => 'Jnn';

  @override
  String get dayWed => 'Jtn';

  @override
  String get dayThu => 'Alh';

  @override
  String get dayFri => 'Iju';

  @override
  String get daySat => 'Jmo';

  @override
  String get daySun => 'Jpi';

  @override
  String get enterValidStaffNamePhone =>
      'Weka jina na simu sahihi ya mfanyakazi';

  @override
  String get staffDetailsSaved => 'Maelezo ya mfanyakazi yamehifadhiwa';

  @override
  String get phoneAlreadyInUse => 'Simu hiyo tayari inatumika';

  @override
  String get couldNotUpdateStaff => 'Imeshindwa kusasisha mfanyakazi';

  @override
  String get enterServiceNameAndPriceShort => 'Weka jina la huduma na bei';

  @override
  String get couldNotAddService => 'Imeshindwa kuongeza huduma';

  @override
  String get editServiceTitle => 'Hariri huduma';

  @override
  String get enterValidServiceNamePrice => 'Weka jina na bei sahihi ya huduma';

  @override
  String get couldNotUpdateService => 'Imeshindwa kusasisha huduma';

  @override
  String get saveServiceButton => 'Hifadhi huduma';

  @override
  String get couldNotRemoveServiceDefault => 'Imeshindwa kuondoa huduma';

  @override
  String get useHHmmWorkingHours => 'Tumia SS:dd kwa saa za kazi';

  @override
  String get hoursAdded => 'Saa zimeongezwa';

  @override
  String get couldNotAddWorkingHours => 'Imeshindwa kuongeza saa za kazi';

  @override
  String get couldNotRemoveTiming => 'Imeshindwa kuondoa muda';

  @override
  String get manageStaffTitle => 'Simamia mfanyakazi';

  @override
  String get done => 'Imekamilika';

  @override
  String get manageStaffSubtitle =>
      'Ongeza, hariri, au ondoa huduma na saa, kisha gusa Imekamilika.';

  @override
  String get saveStaffButton => 'Hifadhi mfanyakazi';

  @override
  String get edit => 'Hariri';

  @override
  String get delete => 'Futa';

  @override
  String get newServiceLabel => 'Huduma mpya';

  @override
  String get addingEllipsis => 'Inaongeza...';

  @override
  String get addServiceButton => 'Ongeza huduma';

  @override
  String get noTimingsYet => 'Hakuna muda bado';

  @override
  String get removeLabel => 'Ondoa';

  @override
  String get startLabel => 'Anza';

  @override
  String get endLabel => 'Mwisho';

  @override
  String get addMonSatHoursButton => 'Ongeza saa za Jtt-Jmo';

  @override
  String get saveHoursButton => 'Hifadhi saa';

  @override
  String get hhmmLowerHint => 'SS:dd';

  @override
  String get chooseStaffServiceDate => 'Chagua mfanyakazi, huduma, na tarehe';

  @override
  String get noSlotsForDate => 'Hakuna nafasi zinazopatikana kwa tarehe hii.';

  @override
  String get couldNotLoadSlots => 'Imeshindwa kupakia nafasi';

  @override
  String get enterCustomerName => 'Weka jina la mteja';

  @override
  String get chooseStaffAndService =>
      'Chagua mfanyakazi na huduma moja angalau';

  @override
  String get enterCustomerPhone => 'Weka simu ya mteja';

  @override
  String get chooseAvailableSlot => 'Chagua nafasi inayopatikana';

  @override
  String get couldNotCreateBooking =>
      'Imeshindwa kuunda uwekaji nafasi. Tafadhali jaribu tena.';

  @override
  String get doneServiceOption => 'Huduma imekamilika';

  @override
  String get scheduleLaterOption => 'Panga baadaye';

  @override
  String get customerNameLabel => 'Jina la mteja';

  @override
  String get customerPhoneLabel => 'Simu ya mteja';

  @override
  String recordedNowDate(String date) {
    return 'Imeandikwa sasa — $date';
  }

  @override
  String get dateLabel => 'Tarehe';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'Nafasi zinazopatikana';

  @override
  String get cancel => 'Ghairi';

  @override
  String get saveBooking => 'Hifadhi uwekaji nafasi';

  @override
  String saveBookingWithTotal(String total) {
    return 'Hifadhi uwekaji nafasi · $total';
  }
}
