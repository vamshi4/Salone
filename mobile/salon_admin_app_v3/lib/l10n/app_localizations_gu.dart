// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get insightsTitle => 'ઇનસાઇટ્સ';

  @override
  String get tabEarnings => 'કમાણી';

  @override
  String get tabRetention => 'રિટેન્શન';

  @override
  String get periodToday => 'આજે';

  @override
  String get periodWeek => 'અઠવાડિયું';

  @override
  String get periodMonth => 'મહિનો';

  @override
  String get periodLast7Days => 'છેલ્લા 7 દિવસ';

  @override
  String get periodLast30Days => 'છેલ્લા 30 દિવસ';

  @override
  String get earningsLoadError => 'કમાણી લોડ થઈ શકી નહીં.';

  @override
  String get retry => 'ફરી પ્રયાસ કરો';

  @override
  String completedServicesCount(int count) {
    return '$count સેવાઓ';
  }

  @override
  String get completedServicesHeading => 'પૂર્ણ થયેલી સેવાઓ';

  @override
  String get noCompletedServices => 'આ સમયગાળામાં હજી કોઈ સેવા પૂર્ણ થઈ નથી.';

  @override
  String get topServicesHeading => 'ટોચની સેવાઓ';

  @override
  String get byStaffHeading => 'સ્ટાફ પ્રમાણે';

  @override
  String get vsYesterday => 'ગઈકાલની સરખામણીમાં';

  @override
  String get vsLastWeek => 'ગયા અઠવાડિયાની સરખામણીમાં';

  @override
  String get vsLastMonth => 'ગયા મહિનાની સરખામણીમાં';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'પાછા આવેલા ગ્રાહકો';

  @override
  String reactivatedSummary(int count) {
    return 'આ મહિને $count ગ્રાહકો પાછા આવ્યા';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'રિટેન્શન રિપોર્ટ લોડ થઈ શક્યો નહીં.';

  @override
  String get couldNotOpenWhatsapp => 'વોટ્સએપ ખોલી શકાયું નહીં';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'નમસ્તે $name! અમને $salonName ખાતે તમારી યાદ આવે છે. તમારી આગલી મુલાકાત બુક કરો અને ખાસ વેલકમ-બેક ઓફરનો આનંદ માણો. જલ્દી મળીશું!';
  }

  @override
  String get customerCohortsHeading => 'ગ્રાહક જૂથો';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count ગ્રાહકો';
  }

  @override
  String noCohortCustomers(String label) {
    return 'આ સમયગાળામાં કોઈ $label ગ્રાહકો નથી.';
  }

  @override
  String get missedCustomersHeading => 'ચૂકી ગયેલા ગ્રાહકો';

  @override
  String get missedCustomersHint =>
      'તેમને વોટ્સએપ પર સંદેશ મોકલવા માટે \"યાદ કરાવો\" પર ટેપ કરો.';

  @override
  String get noMissedCustomers => 'આ મહિને કોઈ ગ્રાહક ચૂક્યો નથી.';

  @override
  String get cohortRegulars => 'નિયમિત';

  @override
  String get cohortNew => 'નવા';

  @override
  String get cohortCameBack => 'પાછા આવ્યા';

  @override
  String get cohortStoppedComing => 'આવવાનું બંધ કર્યું';

  @override
  String get customersLabel => 'ગ્રાહકો';

  @override
  String get reachOutNow => 'હમણાં સંપર્ક કરો';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count નિયમિત ગ્રાહકો ઘટી રહ્યા છે · $revenue જોખમમાં';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× મોડું';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'સામાન્ય રીતે દર $cadence દિવસે · $overdue દિવસ મોડું';
  }

  @override
  String get remind => 'યાદ કરાવો';

  @override
  String get remindOnWhatsappTooltip => 'વોટ્સએપ પર યાદ કરાવો';

  @override
  String get retentionProTitle => 'રિટેન્શન ઇનસાઇટ્સ એક PRO ફીચર છે';

  @override
  String get retentionProBody =>
      'કોણે આવવાનું બંધ કર્યું તે જુઓ, તમારો નવા વિરુદ્ધ પાછા આવતા ગ્રાહકોનો ગુણોત્તર, અને એક-ટેપ રિમાઇન્ડર્સ સાથે ખોવાયેલા ગ્રાહકોને પાછા મેળવો.';

  @override
  String get upgradeToPro => 'PRO પર અપગ્રેડ કરો';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits મુલાકાતો · $spend ખર્ચ';
  }

  @override
  String get createYourAccount => 'તમારું ખાતું બનાવો';

  @override
  String get basics => 'મૂળભૂત માહિતી';

  @override
  String get country => 'દેશ';

  @override
  String get countryHelperText =>
      'તમારી ચલણ, ફોન ફોર્મેટ અને મૂળભૂત ભાષા નક્કી કરે છે.';

  @override
  String get language => 'ભાષા';

  @override
  String get phoneNumberLabel => 'ફોન નંબર';

  @override
  String get passwordLabel => 'પાસવર્ડ';

  @override
  String stepOfTotal(int step, int total) {
    return 'પગલું $step / $total';
  }

  @override
  String get createAccountButton => 'ખાતું બનાવો';

  @override
  String get continueButton => 'ચાલુ રાખો';

  @override
  String get enterPhoneNumber => 'ફોન નંબર દાખલ કરો';

  @override
  String get passwordMinLength => 'પાસવર્ડ ઓછામાં ઓછો 6 અક્ષરોનો હોવો જોઈએ';

  @override
  String get fillOwnerSalonAddress =>
      'માલિકનું નામ, સલૂનનું નામ અને સરનામું ભરો';

  @override
  String get turnOnLocationPermission =>
      'આનો ઉપયોગ કરવા માટે લોકેશન ચાલુ કરો અને પરવાનગી આપો';

  @override
  String get couldNotGetLocation => 'તમારું લોકેશન મળી શક્યું નહીં';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'આ ફોન પહેલેથી નોંધાયેલ છે. કૃપા કરીને સાઇન ઇન કરો.';

  @override
  String get signupFailedCheckBackend =>
      'સાઇનઅપ નિષ્ફળ. બેકએન્ડ કનેક્શન તપાસો.';

  @override
  String get signupFailedTryAgain =>
      'સાઇનઅપ નિષ્ફળ. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get yourSalon => 'તમારું સલૂન';

  @override
  String get salonDetailsSubtitle => 'પગલું 2/3 · સલૂનની વિગતો';

  @override
  String get ownerNameLabel => 'માલિકનું નામ';

  @override
  String get salonNameLabel => 'સલૂનનું નામ';

  @override
  String get salonAddressLabel => 'સલૂનનું સરનામું';

  @override
  String get locationSet => 'લોકેશન સેટ થયું';

  @override
  String get useMyCurrentLocation => 'મારું વર્તમાન લોકેશન વાપરો';

  @override
  String get pickYourColor => 'તમારો રંગ પસંદ કરો';

  @override
  String get colorPreviewHelp =>
      'આ સમગ્ર એપમાં તમારા સલૂનનો ઉચ્ચાર રંગ છે. ખાતામાં કોઈપણ સમયે બદલો.';

  @override
  String get previewLabel => 'પૂર્વાવલોકન';

  @override
  String get newBooking => 'નવું બુકિંગ';

  @override
  String get colorTeal => 'ટીલ';

  @override
  String get colorTerracotta => 'ટેરાકોટા';

  @override
  String get colorBlue => 'વાદળી';

  @override
  String get colorViolet => 'જાંબલી';

  @override
  String get colorRose => 'ગુલાબી';

  @override
  String get welcomeBack => 'ફરી સ્વાગત છે';

  @override
  String get signInToDashboard => 'તમારા સલૂન ડેશબોર્ડમાં સાઇન ઇન કરો';

  @override
  String get enterSalonOwnerPhone => 'સલૂન માલિકનો ફોન દાખલ કરો';

  @override
  String get enterYourPassword => 'તમારો પાસવર્ડ દાખલ કરો';

  @override
  String get noSalonOwnerFound => 'આ ફોન માટે કોઈ સલૂન માલિક ખાતું મળ્યું નથી.';

  @override
  String get loginFailedCheckBackend => 'લોગિન નિષ્ફળ. બેકએન્ડ કનેક્શન તપાસો.';

  @override
  String get loginFailedTryAgain => 'લોગિન નિષ્ફળ. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get hidePassword => 'પાસવર્ડ છુપાવો';

  @override
  String get showPassword => 'પાસવર્ડ બતાવો';

  @override
  String get signIn => 'સાઇન ઇન કરો';

  @override
  String get newHere => 'અહીં નવા છો?';

  @override
  String get createAccount => 'ખાતું બનાવો';

  @override
  String get forgotPassword => 'પાસવર્ડ ભૂલી ગયા?';

  @override
  String get resetPasswordTitle => 'પાસવર્ડ રીસેટ કરો';

  @override
  String get resetPasswordEnterPhone =>
      'તમારો ફોન નંબર દાખલ કરો, અમે વોટ્સએપ પર 6-અંકનો કોડ મોકલીશું.';

  @override
  String get sendCodeViaWhatsApp => 'વોટ્સએપ પર કોડ મોકલો';

  @override
  String get codeSentViaWhatsApp =>
      'જો તે ખાતું અસ્તિત્વમાં હોય, તો વોટ્સએપ પર કોડ મોકલવામાં આવ્યો છે.';

  @override
  String get resetPasswordEnterCode =>
      'અમે વોટ્સએપ પર મોકલેલો કોડ દાખલ કરો, પછી નવો પાસવર્ડ પસંદ કરો.';

  @override
  String get otpCodeLabel => '6-અંકનો કોડ';

  @override
  String get resetPasswordButton => 'પાસવર્ડ રીસેટ કરો';

  @override
  String get resendCode => 'કોડ ફરીથી મોકલો';

  @override
  String get changePhoneNumber => 'ફોન નંબર બદલો';

  @override
  String get enterSixDigitCode => '6-અંકનો કોડ દાખલ કરો';

  @override
  String get passwordsDoNotMatch => 'પાસવર્ડ મેળ ખાતા નથી';

  @override
  String get passwordResetSuccess =>
      'પાસવર્ડ રીસેટ થયો. કૃપા કરીને નવા પાસવર્ડ સાથે સાઇન ઇન કરો.';

  @override
  String get waitBeforeRetryingCode => 'બીજો કોડ માંગતા પહેલા એક મિનિટ રાહ જુઓ';

  @override
  String get invalidOrExpiredCode => 'તે કોડ અમાન્ય છે અથવા સમાપ્ત થઈ ગયો છે';

  @override
  String get tooManyAttemptsRequestNewCode => 'ઘણા બધા પ્રયાસો — નવો કોડ માંગો';

  @override
  String get continueWithGoogle => 'Google સાથે ચાલુ રાખો';

  @override
  String get signedInWithGoogle => 'Google સાથે સાઇન ઇન થયું';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google સાથે $email તરીકે સાઇન ઇન થયું';
  }

  @override
  String get usePasswordInstead => 'તેના બદલે પાસવર્ડ વાપરો';

  @override
  String get googleSignInNotConfigured => 'Google સાઇન-ઇન હજી સેટ અપ થયું નથી';

  @override
  String get googleSignInFailed =>
      'Google સાઇન-ઇન નિષ્ફળ. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get googleNoAccountFound =>
      'તે Google ખાતા માટે કોઈ ખાતું મળ્યું નથી. પહેલા એક બનાવો.';

  @override
  String get linkGoogleAccount => 'Google ખાતું લિંક કરો';

  @override
  String get googleAccountLinked =>
      'Google ખાતું લિંક થયું — હવે તમે તેનાથી સાઇન ઇન કરી શકો છો';

  @override
  String get addStaffBeforeBookings => 'બુકિંગ બનાવતા પહેલા સક્રિય સ્ટાફ ઉમેરો';

  @override
  String get salonLabel => 'સલૂન';

  @override
  String get statToday => 'આજે';

  @override
  String get statRepeat => 'પુનરાવર્તિત';

  @override
  String get statLoggedHelper => 'નોંધાયેલ';

  @override
  String get statBackHelper => 'પાછા આવ્યા';

  @override
  String get statWeek => 'અઠવાડિયું';

  @override
  String get statMonth => 'મહિનો';

  @override
  String get loggedTodayHeading => 'આજે નોંધાયેલ';

  @override
  String get nothingLoggedToday =>
      'આજે હજી કંઈ નોંધાયું નથી. સેવા પૂર્ણ થાય ત્યારે \"નવું બુકિંગ\" પર ટેપ કરો.';

  @override
  String get navHome => 'હોમ';

  @override
  String get navBookings => 'બુકિંગ્સ';

  @override
  String get navStaff => 'સ્ટાફ';

  @override
  String get navInsights => 'ઇનસાઇટ્સ';

  @override
  String get navAccount => 'ખાતું';

  @override
  String get salonAdminTitle => 'સલૂન એડમિન';

  @override
  String get noSalonLinked => 'આ માલિક ખાતા સાથે હજી કોઈ સલૂન જોડાયેલ નથી.';

  @override
  String get bookingsTitle => 'બુકિંગ્સ';

  @override
  String get searchCustomerOrService => 'ગ્રાહક અથવા સેવા શોધો';

  @override
  String get filterThisWeek => 'આ અઠવાડિયે';

  @override
  String get filterAllTime => 'બધો સમય';

  @override
  String get filterAllStaff => 'બધા સ્ટાફ';

  @override
  String get staffLabel => 'સ્ટાફ';

  @override
  String get needsActionHeading => 'કાર્યવાહી જરૂરી';

  @override
  String get statTotal => 'કુલ';

  @override
  String get statServices => 'સેવાઓ';

  @override
  String get statAvgTicket => 'સરેરાશ બિલ';

  @override
  String get noBookingsMatchFilter => 'આ ફિલ્ટર સાથે કોઈ બુકિંગ મેળ ખાતું નથી';

  @override
  String get today => 'આજે';

  @override
  String get yesterday => 'ગઈકાલે';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count સેવાઓ';
  }

  @override
  String get couldNotOpenStore => 'સ્ટોર ખોલી શકાયો નહીં';

  @override
  String get updateRequired => 'અપડેટ જરૂરી છે';

  @override
  String get updateRequiredBody =>
      'એપનું નવું વર્ઝન ઉપલબ્ધ છે. તમારા સલૂન ડેશબોર્ડનો ઉપયોગ ચાલુ રાખવા માટે કૃપા કરીને અપડેટ કરો.';

  @override
  String get updateNow => 'હમણાં અપડેટ કરો';

  @override
  String get themeColorTitle => 'થીમ રંગ';

  @override
  String get save => 'સાચવો';

  @override
  String get staffTitle => 'સ્ટાફ';

  @override
  String get addStaff => 'સ્ટાફ ઉમેરો';

  @override
  String get statActive => 'સક્રિય';

  @override
  String get statTodaysTotal => 'આજની કુલ રકમ';

  @override
  String get noActiveStaffYet => 'હજી કોઈ સક્રિય સ્ટાફ નથી';

  @override
  String get addFirstStaff => 'પ્રથમ સ્ટાફ ઉમેરો';

  @override
  String get noServicesYet => 'હજી કોઈ સેવા નથી';

  @override
  String get notActive => 'સક્રિય નથી';

  @override
  String get canSetOwnPrice => 'પોતાની કિંમત નક્કી કરી શકે છે';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count સેવાઓ · $revenue';
  }

  @override
  String get newLabel => 'નવું';

  @override
  String get serviceLabel => 'સેવા';

  @override
  String get customerLabel => 'ગ્રાહક';

  @override
  String get repeatLabel => 'પુનરાવર્તિત';

  @override
  String get couldNotUpdateBooking =>
      'બુકિંગ અપડેટ થઈ શક્યું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get couldNotAcceptReschedule =>
      'રિશેડ્યુલ સ્વીકારી શકાયું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get couldNotRejectReschedule =>
      'રિશેડ્યુલ નકારી શકાયું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get rescheduleLabel => 'રિશેડ્યુલ';

  @override
  String get pendingLabel => 'બાકી';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist સાથે';
  }

  @override
  String customerRequestedTime(String time) {
    return 'ગ્રાહકે $time વિનંતી કરી';
  }

  @override
  String get reject => 'નકારો';

  @override
  String get accept => 'સ્વીકારો';

  @override
  String get confirm => 'પુષ્ટિ કરો';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + વધુ $count';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'ખાતાની વિગતો લોડ થઈ શકી નહીં';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'માલિક, ફોન, સલૂનનું નામ અને સરનામું ભરો';

  @override
  String get accountUpdated => 'ખાતું અપડેટ થયું';

  @override
  String get phoneOrEmailUsed => 'ફોન અથવા ઈમેલ પહેલેથી વપરાયેલ છે';

  @override
  String get couldNotSaveAccount => 'ખાતાની વિગતો સાચવી શકાઈ નહીં';

  @override
  String get newPasswordMinLength =>
      'નવો પાસવર્ડ ઓછામાં ઓછો 6 અક્ષરોનો હોવો જોઈએ';

  @override
  String get newPasswordsDontMatch => 'નવા પાસવર્ડ મેળ ખાતા નથી';

  @override
  String get passwordChanged => 'પાસવર્ડ બદલાયો';

  @override
  String get currentPasswordIncorrect => 'વર્તમાન પાસવર્ડ ખોટો છે';

  @override
  String get couldNotChangePassword => 'પાસવર્ડ બદલી શકાયો નહીં';

  @override
  String get countryAndCurrency => 'દેશ અને ચલણ';

  @override
  String get accountTitle => 'ખાતું';

  @override
  String ownerSinceDate(String date) {
    return '$date થી માલિક';
  }

  @override
  String planLabel(String plan) {
    return '$plan પ્લાન';
  }

  @override
  String get retentionFreeFor6Months => '6 મહિના માટે રિટેન્શન ઇનસાઇટ્સ મફત';

  @override
  String get upgrade => 'અપગ્રેડ કરો';

  @override
  String get appearance => 'દેખાવ';

  @override
  String get salonProfile => 'સલૂન પ્રોફાઇલ';

  @override
  String get emailLabel => 'ઈમેલ';

  @override
  String get locationUpdated => 'લોકેશન અપડેટ થયું';

  @override
  String get saveDetailsButton => 'વિગતો સાચવો';

  @override
  String get savingEllipsis => 'સાચવી રહ્યું છે...';

  @override
  String get security => 'સુરક્ષા';

  @override
  String get currentPasswordLabel => 'વર્તમાન પાસવર્ડ';

  @override
  String get newPasswordLabel => 'નવો પાસવર્ડ';

  @override
  String get confirmNewPasswordLabel => 'નવો પાસવર્ડ પુષ્ટિ કરો';

  @override
  String get changePasswordButton => 'પાસવર્ડ બદલો';

  @override
  String get changingEllipsis => 'બદલી રહ્યું છે...';

  @override
  String get signOut => 'સાઇન આઉટ કરો';

  @override
  String get enterServiceNamePrice => 'સેવાનું નામ અને કિંમત દાખલ કરો';

  @override
  String get fillStaffNamePhone => 'સ્ટાફનું નામ અને ફોન ભરો';

  @override
  String get addAtLeastOneService => 'ઓછામાં ઓછી એક સેવા ઉમેરો';

  @override
  String get enterValidOpenCloseTimes =>
      'માન્ય ખુલવાનો અને બંધ થવાનો સમય દાખલ કરો (HH:MM, 24-કલાક)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'ઓછામાં ઓછો એક કાર્યકારી દિવસ પસંદ કરો';

  @override
  String get staffPhoneInUse => 'તે સ્ટાફ ફોન પહેલેથી વપરાયેલ છે';

  @override
  String get couldNotAddStaff =>
      'સ્ટાફ ઉમેરી શકાયો નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get addStaffSubtitle =>
      'તેમની પ્રોફાઇલ, સેવાઓ અને કાર્યકારી દિવસો સેટ કરો.';

  @override
  String get staffNameLabel => 'સ્ટાફનું નામ';

  @override
  String get staffPhoneLabel => 'સ્ટાફનો ફોન';

  @override
  String get servicesLabel => 'સેવાઓ';

  @override
  String servicesAddedCount(int count) {
    return '$count ઉમેરાયા';
  }

  @override
  String get workingHours => 'કાર્યકારી કલાકો';

  @override
  String get opens => 'ખુલે છે';

  @override
  String get closes => 'બંધ થાય છે';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'કાર્યકારી દિવસો';

  @override
  String get serviceNameHint => 'સેવાનું નામ';

  @override
  String get priceHint => 'કિંમત';

  @override
  String get dayMon => 'સોમ';

  @override
  String get dayTue => 'મંગળ';

  @override
  String get dayWed => 'બુધ';

  @override
  String get dayThu => 'ગુરુ';

  @override
  String get dayFri => 'શુક્ર';

  @override
  String get daySat => 'શનિ';

  @override
  String get daySun => 'રવિ';

  @override
  String get enterValidStaffNamePhone => 'માન્ય સ્ટાફ નામ અને ફોન દાખલ કરો';

  @override
  String get staffDetailsSaved => 'સ્ટાફ વિગતો સાચવી';

  @override
  String get phoneAlreadyInUse => 'તે ફોન પહેલેથી વપરાયેલ છે';

  @override
  String get couldNotUpdateStaff => 'સ્ટાફ અપડેટ થઈ શક્યો નહીં';

  @override
  String get enterServiceNameAndPriceShort => 'સેવાનું નામ અને કિંમત દાખલ કરો';

  @override
  String get couldNotAddService => 'સેવા ઉમેરી શકાઈ નહીં';

  @override
  String get editServiceTitle => 'સેવા સંપાદિત કરો';

  @override
  String get enterValidServiceNamePrice =>
      'માન્ય સેવાનું નામ અને કિંમત દાખલ કરો';

  @override
  String get couldNotUpdateService => 'સેવા અપડેટ થઈ શકી નહીં';

  @override
  String get saveServiceButton => 'સેવા સાચવો';

  @override
  String get couldNotRemoveServiceDefault => 'સેવા દૂર કરી શકાઈ નહીં';

  @override
  String get useHHmmWorkingHours => 'કાર્યકારી કલાકો માટે HH:mm વાપરો';

  @override
  String get hoursAdded => 'કલાકો ઉમેરાયા';

  @override
  String get couldNotAddWorkingHours => 'કાર્યકારી કલાકો ઉમેરી શકાયા નહીં';

  @override
  String get couldNotRemoveTiming => 'સમય દૂર કરી શકાયો નહીં';

  @override
  String get manageStaffTitle => 'સ્ટાફનું સંચાલન કરો';

  @override
  String get done => 'પૂર્ણ';

  @override
  String get manageStaffSubtitle =>
      'સેવાઓ અને કલાકો ઉમેરો, સંપાદિત કરો અથવા દૂર કરો, પછી પૂર્ણ પર ટેપ કરો.';

  @override
  String get saveStaffButton => 'સ્ટાફ સાચવો';

  @override
  String get edit => 'સંપાદિત કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get newServiceLabel => 'નવી સેવા';

  @override
  String get addingEllipsis => 'ઉમેરી રહ્યું છે...';

  @override
  String get addServiceButton => 'સેવા ઉમેરો';

  @override
  String get noTimingsYet => 'હજી કોઈ સમય નથી';

  @override
  String get removeLabel => 'દૂર કરો';

  @override
  String get startLabel => 'શરૂઆત';

  @override
  String get endLabel => 'અંત';

  @override
  String get addMonSatHoursButton => 'સોમ-શનિ કલાકો ઉમેરો';

  @override
  String get saveHoursButton => 'સમય સાચવો';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'સ્ટાફ, સેવા અને તારીખ પસંદ કરો';

  @override
  String get noSlotsForDate => 'આ તારીખ માટે કોઈ ઉપલબ્ધ સ્લોટ નથી.';

  @override
  String get couldNotLoadSlots => 'સ્લોટ લોડ થઈ શક્યા નહીં';

  @override
  String get enterCustomerName => 'ગ્રાહકનું નામ દાખલ કરો';

  @override
  String get chooseStaffAndService => 'સ્ટાફ અને ઓછામાં ઓછી એક સેવા પસંદ કરો';

  @override
  String get enterCustomerPhone => 'ગ્રાહકનો ફોન દાખલ કરો';

  @override
  String get chooseAvailableSlot => 'ઉપલબ્ધ સ્લોટ પસંદ કરો';

  @override
  String get couldNotCreateBooking =>
      'બુકિંગ બનાવી શકાયું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get doneServiceOption => 'સેવા પૂર્ણ';

  @override
  String get scheduleLaterOption => 'પછી શેડ્યુલ કરો';

  @override
  String get customerNameLabel => 'ગ્રાહકનું નામ';

  @override
  String get customerPhoneLabel => 'ગ્રાહકનો ફોન';

  @override
  String recordedNowDate(String date) {
    return 'હમણાં નોંધાયું — $date';
  }

  @override
  String get dateLabel => 'તારીખ';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'ઉપલબ્ધ સ્લોટ';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get saveBooking => 'બુકિંગ સાચવો';

  @override
  String saveBookingWithTotal(String total) {
    return 'બુકિંગ સાચવો · $total';
  }
}
