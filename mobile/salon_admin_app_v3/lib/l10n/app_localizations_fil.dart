// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get insightsTitle => 'Mga Insight';

  @override
  String get tabEarnings => 'Kita';

  @override
  String get tabRetention => 'Retensyon';

  @override
  String get periodToday => 'Ngayon';

  @override
  String get periodWeek => 'Linggo';

  @override
  String get periodMonth => 'Buwan';

  @override
  String get periodLast7Days => 'Huling 7 araw';

  @override
  String get periodLast30Days => 'Huling 30 araw';

  @override
  String get earningsLoadError => 'Hindi ma-load ang kita.';

  @override
  String get retry => 'Subukan ulit';

  @override
  String completedServicesCount(int count) {
    return '$count serbisyo';
  }

  @override
  String get completedServicesHeading => 'Nakumpletong serbisyo';

  @override
  String get noCompletedServices =>
      'Wala pang nakumpletong serbisyo sa panahong ito.';

  @override
  String get topServicesHeading => 'Pinakamahusay na serbisyo';

  @override
  String get byStaffHeading => 'Ayon sa staff';

  @override
  String get vsYesterday => 'kumpara kahapon';

  @override
  String get vsLastWeek => 'kumpara noong nakaraang linggo';

  @override
  String get vsLastMonth => 'kumpara noong nakaraang buwan';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Mga customer na nabawi';

  @override
  String reactivatedSummary(int count) {
    return '$count customer ang bumalik ngayong buwan';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Hindi ma-load ang ulat ng retensyon.';

  @override
  String get couldNotOpenWhatsapp => 'Hindi mabuksan ang WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Hi $name! Namiss ka namin sa $salonName. Mag-book ng susunod mong bisita at tamasahin ang espesyal na welcome-back offer. Kita-kits sa lalong madaling panahon!';
  }

  @override
  String get customerCohortsHeading => 'Mga grupo ng customer';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count customer';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Walang $label na customer sa panahong ito.';
  }

  @override
  String get missedCustomersHeading => 'Nawawalang customer';

  @override
  String get missedCustomersHint =>
      'I-tap ang \"Paalalahanan\" para magpadala sa kanila ng mensahe sa WhatsApp.';

  @override
  String get noMissedCustomers => 'Walang nawawalang customer ngayong buwan.';

  @override
  String get cohortRegulars => 'Mga regular';

  @override
  String get cohortNew => 'Bago';

  @override
  String get cohortCameBack => 'Bumalik';

  @override
  String get cohortStoppedComing => 'Tumigil sa pagpunta';

  @override
  String get customersLabel => 'customer';

  @override
  String get reachOutNow => 'Makipag-ugnayan na ngayon';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count regular na customer ang bumababa · $revenue ang nasa panganib';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× overdue';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Karaniwang bawat $cadence araw · $overdue araw na overdue';
  }

  @override
  String get remind => 'Paalalahanan';

  @override
  String get remindOnWhatsappTooltip => 'Paalalahanan sa WhatsApp';

  @override
  String get retentionProTitle => 'Ang retention insights ay isang PRO feature';

  @override
  String get retentionProBody =>
      'Tingnan kung sino ang tumigil sa pagpunta, ang ratio ng bago kumpara sa bumabalik na customer, at bawiin ang nawalang customer gamit ang one-tap na paalala.';

  @override
  String get upgradeToPro => 'I-upgrade sa PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits pagbisita · $spend ang nagastos';
  }

  @override
  String get createYourAccount => 'Gumawa ng iyong account';

  @override
  String get basics => 'Mga pangunahing detalye';

  @override
  String get country => 'Bansa';

  @override
  String get countryHelperText =>
      'Tinutukoy ang iyong currency, format ng telepono, at default na wika.';

  @override
  String get language => 'Wika';

  @override
  String get phoneNumberLabel => 'Numero ng telepono';

  @override
  String get passwordLabel => 'Password';

  @override
  String stepOfTotal(int step, int total) {
    return 'Hakbang $step ng $total';
  }

  @override
  String get createAccountButton => 'Gumawa ng account';

  @override
  String get continueButton => 'Magpatuloy';

  @override
  String get enterPhoneNumber => 'Maglagay ng numero ng telepono';

  @override
  String get passwordMinLength =>
      'Dapat hindi bababa sa 6 na karakter ang password';

  @override
  String get fillOwnerSalonAddress =>
      'Punan ang pangalan ng may-ari, pangalan ng salon, at address';

  @override
  String get turnOnLocationPermission =>
      'I-on ang lokasyon at payagan ang access para magamit ito';

  @override
  String get couldNotGetLocation => 'Hindi makuha ang iyong lokasyon';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Nakarehistro na ang telepong ito. Mag-sign in na lang.';

  @override
  String get signupFailedCheckBackend =>
      'Nabigo ang pag-sign up. Suriin ang koneksyon sa server.';

  @override
  String get signupFailedTryAgain => 'Nabigo ang pag-sign up. Subukan ulit.';

  @override
  String get yourSalon => 'Ang iyong salon';

  @override
  String get salonDetailsSubtitle => 'Hakbang 2 ng 3 · Detalye ng salon';

  @override
  String get ownerNameLabel => 'Pangalan ng may-ari';

  @override
  String get salonNameLabel => 'Pangalan ng salon';

  @override
  String get salonAddressLabel => 'Address ng salon';

  @override
  String get locationSet => 'Naitakda ang lokasyon';

  @override
  String get useMyCurrentLocation => 'Gamitin ang kasalukuyan kong lokasyon';

  @override
  String get pickYourColor => 'Piliin ang iyong kulay';

  @override
  String get colorPreviewHelp =>
      'Ito ang accent color ng iyong salon sa buong app. Baguhin anumang oras sa Account.';

  @override
  String get previewLabel => 'Preview';

  @override
  String get newBooking => 'Bagong booking';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorTerracotta => 'Terracotta';

  @override
  String get colorBlue => 'Asul';

  @override
  String get colorViolet => 'Lila';

  @override
  String get colorRose => 'Rosas';

  @override
  String get welcomeBack => 'Maligayang pagbabalik';

  @override
  String get signInToDashboard => 'Mag-sign in sa dashboard ng iyong salon';

  @override
  String get enterSalonOwnerPhone => 'Ilagay ang telepono ng may-ari ng salon';

  @override
  String get enterYourPassword => 'Ilagay ang iyong password';

  @override
  String get noSalonOwnerFound =>
      'Walang nahanap na account ng may-ari ng salon para sa teleponong ito.';

  @override
  String get loginFailedCheckBackend =>
      'Nabigo ang pag-login. Suriin ang koneksyon sa server.';

  @override
  String get loginFailedTryAgain => 'Nabigo ang pag-login. Subukan ulit.';

  @override
  String get hidePassword => 'Itago ang password';

  @override
  String get showPassword => 'Ipakita ang password';

  @override
  String get signIn => 'Mag-sign in';

  @override
  String get newHere => 'Bago dito?';

  @override
  String get createAccount => 'Gumawa ng account';

  @override
  String get forgotPassword => 'Nakalimutan ang password?';

  @override
  String get resetPasswordTitle => 'I-reset ang password';

  @override
  String get resetPasswordEnterPhone =>
      'Ilagay ang iyong numero ng telepono at magpapadala kami ng 6-digit na code sa WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Ipadala ang code sa WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Kung mayroong account na iyon, may naipadala nang code sa WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Ilagay ang code na ipinadala namin sa WhatsApp, pagkatapos ay pumili ng bagong password.';

  @override
  String get otpCodeLabel => '6-digit na code';

  @override
  String get resetPasswordButton => 'I-reset ang password';

  @override
  String get resendCode => 'Ipadala ulit ang code';

  @override
  String get changePhoneNumber => 'Palitan ang numero ng telepono';

  @override
  String get enterSixDigitCode => 'Ilagay ang 6-digit na code';

  @override
  String get passwordsDoNotMatch => 'Hindi magkatugma ang mga password';

  @override
  String get passwordResetSuccess =>
      'Na-reset na ang password. Mag-sign in gamit ang bagong password.';

  @override
  String get waitBeforeRetryingCode =>
      'Maghintay ng isang minuto bago humiling ng isa pang code';

  @override
  String get invalidOrExpiredCode =>
      'Hindi valid o expired na ang code na iyon';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Sobra nang subok — humiling ng bagong code';

  @override
  String get continueWithGoogle => 'Magpatuloy gamit ang Google';

  @override
  String get signedInWithGoogle => 'Naka-sign in gamit ang Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Naka-sign in gamit ang Google bilang $email';
  }

  @override
  String get usePasswordInstead => 'Gamitin na lang ang password';

  @override
  String get googleSignInNotConfigured =>
      'Hindi pa naka-set up ang pag-sign in gamit ang Google';

  @override
  String get googleSignInFailed =>
      'Nabigo ang pag-sign in gamit ang Google. Subukan ulit.';

  @override
  String get googleNoAccountFound =>
      'Walang nahanap na account para sa Google account na iyon. Gumawa muna ng isa.';

  @override
  String get linkGoogleAccount => 'I-link ang Google account';

  @override
  String get googleAccountLinked =>
      'Naka-link na ang Google account — puwede ka nang mag-sign in gamit ito';

  @override
  String get addStaffBeforeBookings =>
      'Magdagdag ng aktibong staff bago gumawa ng mga booking';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Ngayon';

  @override
  String get statRepeat => 'Umuulit';

  @override
  String get statLoggedHelper => 'naitala';

  @override
  String get statBackHelper => 'bumalik';

  @override
  String get statWeek => 'Linggo';

  @override
  String get statMonth => 'Buwan';

  @override
  String get loggedTodayHeading => 'Naitala ngayon';

  @override
  String get nothingLoggedToday =>
      'Wala pang naitala ngayon. I-tap ang \"Bagong booking\" kapag natapos na ang isang serbisyo.';

  @override
  String get navHome => 'Home';

  @override
  String get navBookings => 'Mga Booking';

  @override
  String get navStaff => 'Staff';

  @override
  String get navInsights => 'Mga Insight';

  @override
  String get navAccount => 'Account';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Wala pang naka-link na salon sa account na ito ng may-ari.';

  @override
  String get bookingsTitle => 'Mga Booking';

  @override
  String get searchCustomerOrService => 'Maghanap ng customer o serbisyo';

  @override
  String get filterThisWeek => 'Ngayong linggo';

  @override
  String get filterAllTime => 'Lahat ng oras';

  @override
  String get filterAllStaff => 'Lahat ng staff';

  @override
  String get staffLabel => 'Staff';

  @override
  String get needsActionHeading => 'Kailangan ng aksyon';

  @override
  String get statTotal => 'Kabuuan';

  @override
  String get statServices => 'Mga serbisyo';

  @override
  String get statAvgTicket => 'Avg. resibo';

  @override
  String get noBookingsMatchFilter =>
      'Walang booking na tumutugma sa filter na ito';

  @override
  String get today => 'Ngayon';

  @override
  String get yesterday => 'Kahapon';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count serbisyo';
  }

  @override
  String get couldNotOpenStore => 'Hindi mabuksan ang store';

  @override
  String get updateRequired => 'Kailangan ng update';

  @override
  String get updateRequiredBody =>
      'May bagong bersyon ng app na available. Mag-update para magpatuloy sa paggamit ng dashboard ng iyong salon.';

  @override
  String get updateNow => 'I-update na ngayon';

  @override
  String get themeColorTitle => 'Kulay ng tema';

  @override
  String get save => 'I-save';

  @override
  String get staffTitle => 'Staff';

  @override
  String get addStaff => 'Magdagdag ng staff';

  @override
  String get statActive => 'Aktibo';

  @override
  String get statTodaysTotal => 'Kabuuan ngayon';

  @override
  String get noActiveStaffYet => 'Wala pang aktibong staff';

  @override
  String get addFirstStaff => 'Magdagdag ng unang staff';

  @override
  String get noServicesYet => 'Wala pang serbisyo';

  @override
  String get notActive => 'Hindi aktibo';

  @override
  String get canSetOwnPrice => 'Puwedeng magtakda ng sariling presyo';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count serbisyo · $revenue';
  }

  @override
  String get newLabel => 'Bago';

  @override
  String get serviceLabel => 'Serbisyo';

  @override
  String get customerLabel => 'Customer';

  @override
  String get repeatLabel => 'Umuulit';

  @override
  String get couldNotUpdateBooking =>
      'Hindi ma-update ang booking. Subukan ulit.';

  @override
  String get couldNotAcceptReschedule =>
      'Hindi matanggap ang reschedule. Subukan ulit.';

  @override
  String get couldNotRejectReschedule =>
      'Hindi matanggihan ang reschedule. Subukan ulit.';

  @override
  String get rescheduleLabel => 'I-reschedule';

  @override
  String get pendingLabel => 'Nakabinbin';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer kasama si $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Humiling ang customer ng $time';
  }

  @override
  String get reject => 'Tanggihan';

  @override
  String get accept => 'Tanggapin';

  @override
  String get confirm => 'Kumpirmahin';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count pa';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Hindi ma-load ang mga detalye ng account';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Punan ang may-ari, telepono, pangalan ng salon, at address';

  @override
  String get accountUpdated => 'Na-update ang account';

  @override
  String get phoneOrEmailUsed => 'Nagamit na ang telepono o email';

  @override
  String get couldNotSaveAccount => 'Hindi ma-save ang mga detalye ng account';

  @override
  String get newPasswordMinLength =>
      'Dapat hindi bababa sa 6 na karakter ang bagong password';

  @override
  String get newPasswordsDontMatch =>
      'Hindi magkatugma ang mga bagong password';

  @override
  String get passwordChanged => 'Nabago ang password';

  @override
  String get currentPasswordIncorrect => 'Mali ang kasalukuyang password';

  @override
  String get couldNotChangePassword => 'Hindi mabago ang password';

  @override
  String get countryAndCurrency => 'Bansa at currency';

  @override
  String get accountTitle => 'Account';

  @override
  String ownerSinceDate(String date) {
    return 'May-ari mula $date';
  }

  @override
  String planLabel(String plan) {
    return 'Plano na $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Libre ang retention insights sa loob ng 6 na buwan';

  @override
  String get upgrade => 'I-upgrade';

  @override
  String get appearance => 'Anyo';

  @override
  String get salonProfile => 'Profile ng salon';

  @override
  String get emailLabel => 'Email';

  @override
  String get locationUpdated => 'Na-update ang lokasyon';

  @override
  String get saveDetailsButton => 'I-save ang mga detalye';

  @override
  String get savingEllipsis => 'Sine-save...';

  @override
  String get security => 'Seguridad';

  @override
  String get currentPasswordLabel => 'Kasalukuyang password';

  @override
  String get newPasswordLabel => 'Bagong password';

  @override
  String get confirmNewPasswordLabel => 'Kumpirmahin ang bagong password';

  @override
  String get changePasswordButton => 'Baguhin ang password';

  @override
  String get changingEllipsis => 'Binabago...';

  @override
  String get signOut => 'Mag-sign out';

  @override
  String get enterServiceNamePrice =>
      'Ilagay ang pangalan at presyo ng serbisyo';

  @override
  String get fillStaffNamePhone => 'Punan ang pangalan at telepono ng staff';

  @override
  String get addAtLeastOneService => 'Magdagdag ng kahit isang serbisyo';

  @override
  String get enterValidOpenCloseTimes =>
      'Ilagay ang wastong oras ng pagbukas at pagsara (HH:MM, 24-oras)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Pumili ng kahit isang araw ng trabaho';

  @override
  String get staffPhoneInUse => 'Nagamit na ang teleponong iyon ng staff';

  @override
  String get couldNotAddStaff => 'Hindi maidagdag ang staff. Subukan ulit.';

  @override
  String get addStaffSubtitle =>
      'I-set up ang kanilang profile, serbisyo, at mga araw ng trabaho.';

  @override
  String get staffNameLabel => 'Pangalan ng staff';

  @override
  String get staffPhoneLabel => 'Telepono ng staff';

  @override
  String get servicesLabel => 'Mga serbisyo';

  @override
  String servicesAddedCount(int count) {
    return '$count naidagdag';
  }

  @override
  String get workingHours => 'Oras ng trabaho';

  @override
  String get opens => 'Nagbubukas';

  @override
  String get closes => 'Nagsasara';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Mga araw ng trabaho';

  @override
  String get serviceNameHint => 'Pangalan ng serbisyo';

  @override
  String get priceHint => 'Presyo';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Miy';

  @override
  String get dayThu => 'Huw';

  @override
  String get dayFri => 'Biy';

  @override
  String get daySat => 'Sab';

  @override
  String get daySun => 'Lin';

  @override
  String get enterValidStaffNamePhone =>
      'Ilagay ang wastong pangalan at telepono ng staff';

  @override
  String get staffDetailsSaved => 'Na-save ang mga detalye ng staff';

  @override
  String get phoneAlreadyInUse => 'Nagamit na ang teleponong iyon';

  @override
  String get couldNotUpdateStaff => 'Hindi ma-update ang staff';

  @override
  String get enterServiceNameAndPriceShort =>
      'Ilagay ang pangalan at presyo ng serbisyo';

  @override
  String get couldNotAddService => 'Hindi maidagdag ang serbisyo';

  @override
  String get editServiceTitle => 'I-edit ang serbisyo';

  @override
  String get enterValidServiceNamePrice =>
      'Ilagay ang wastong pangalan at presyo ng serbisyo';

  @override
  String get couldNotUpdateService => 'Hindi ma-update ang serbisyo';

  @override
  String get saveServiceButton => 'I-save ang serbisyo';

  @override
  String get couldNotRemoveServiceDefault => 'Hindi maalis ang serbisyo';

  @override
  String get useHHmmWorkingHours => 'Gamitin ang HH:mm para sa oras ng trabaho';

  @override
  String get hoursAdded => 'Naidagdag ang oras';

  @override
  String get couldNotAddWorkingHours => 'Hindi maidagdag ang oras ng trabaho';

  @override
  String get couldNotRemoveTiming => 'Hindi maalis ang oras';

  @override
  String get manageStaffTitle => 'Pamahalaan ang staff';

  @override
  String get done => 'Tapos na';

  @override
  String get manageStaffSubtitle =>
      'Magdagdag, mag-edit, o mag-alis ng mga serbisyo at oras, pagkatapos ay i-tap ang Tapos na.';

  @override
  String get saveStaffButton => 'I-save ang staff';

  @override
  String get edit => 'I-edit';

  @override
  String get delete => 'Burahin';

  @override
  String get newServiceLabel => 'Bagong serbisyo';

  @override
  String get addingEllipsis => 'Idinaragdag...';

  @override
  String get addServiceButton => 'Magdagdag ng serbisyo';

  @override
  String get noTimingsYet => 'Wala pang oras';

  @override
  String get removeLabel => 'Alisin';

  @override
  String get startLabel => 'Simula';

  @override
  String get endLabel => 'Katapusan';

  @override
  String get addMonSatHoursButton => 'Magdagdag ng oras Lun-Sab';

  @override
  String get saveHoursButton => 'I-save ang oras';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Piliin ang staff, serbisyo, at petsa';

  @override
  String get noSlotsForDate => 'Walang available na slot para sa petsang ito.';

  @override
  String get couldNotLoadSlots => 'Hindi ma-load ang mga slot';

  @override
  String get enterCustomerName => 'Ilagay ang pangalan ng customer';

  @override
  String get chooseStaffAndService =>
      'Piliin ang staff at kahit isang serbisyo';

  @override
  String get enterCustomerPhone => 'Ilagay ang telepono ng customer';

  @override
  String get chooseAvailableSlot => 'Piliin ang available na slot';

  @override
  String get couldNotCreateBooking => 'Hindi magawa ang booking. Subukan ulit.';

  @override
  String get doneServiceOption => 'Tapos na ang serbisyo';

  @override
  String get scheduleLaterOption => 'I-schedule sa ibang pagkakataon';

  @override
  String get customerNameLabel => 'Pangalan ng customer';

  @override
  String get customerPhoneLabel => 'Telepono ng customer';

  @override
  String recordedNowDate(String date) {
    return 'Naitala ngayon — $date';
  }

  @override
  String get dateLabel => 'Petsa';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'Mga available na slot';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get saveBooking => 'I-save ang booking';

  @override
  String saveBookingWithTotal(String total) {
    return 'I-save ang booking · $total';
  }
}
