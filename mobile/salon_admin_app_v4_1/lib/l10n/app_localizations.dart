import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fil'),
    Locale('fr'),
    Locale('gu'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('mr'),
    Locale('ms'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sw'),
    Locale('ta'),
    Locale('te'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi')
  ];

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @tabEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get tabEarnings;

  /// No description provided for @tabRetention.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get tabRetention;

  /// No description provided for @periodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodToday;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get periodLast7Days;

  /// No description provided for @periodLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get periodLast30Days;

  /// No description provided for @earningsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load earnings.'**
  String get earningsLoadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @completedServicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} service} other{{count} services}}'**
  String completedServicesCount(int count);

  /// No description provided for @completedServicesHeading.
  ///
  /// In en, this message translates to:
  /// **'Completed services'**
  String get completedServicesHeading;

  /// No description provided for @noCompletedServices.
  ///
  /// In en, this message translates to:
  /// **'No completed services in this period yet.'**
  String get noCompletedServices;

  /// No description provided for @topServicesHeading.
  ///
  /// In en, this message translates to:
  /// **'Top services'**
  String get topServicesHeading;

  /// No description provided for @byStaffHeading.
  ///
  /// In en, this message translates to:
  /// **'By staff'**
  String get byStaffHeading;

  /// No description provided for @vsYesterday.
  ///
  /// In en, this message translates to:
  /// **'vs yesterday'**
  String get vsYesterday;

  /// No description provided for @vsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'vs last week'**
  String get vsLastWeek;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get vsLastMonth;

  /// No description provided for @percentChangeLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% {label}'**
  String percentChangeLabel(int percent, String label);

  /// No description provided for @reactivatedWinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers you won back'**
  String get reactivatedWinsTitle;

  /// No description provided for @reactivatedSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} customer came back this month} other{{count} customers came back this month}}'**
  String reactivatedSummary(int count);

  /// No description provided for @customerServicePair.
  ///
  /// In en, this message translates to:
  /// **'{customer} · {service}'**
  String customerServicePair(String customer, String service);

  /// No description provided for @retentionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load retention report.'**
  String get retentionLoadError;

  /// No description provided for @couldNotOpenWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp'**
  String get couldNotOpenWhatsapp;

  /// No description provided for @whatsappReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}! We\'ve missed you at {salonName}. Book your next visit and enjoy a special welcome-back offer. See you soon!'**
  String whatsappReminderMessage(String name, String salonName);

  /// No description provided for @customerCohortsHeading.
  ///
  /// In en, this message translates to:
  /// **'Customer cohorts'**
  String get customerCohortsHeading;

  /// No description provided for @cohortMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} · {count} customers'**
  String cohortMembersLabel(String label, int count);

  /// No description provided for @noCohortCustomers.
  ///
  /// In en, this message translates to:
  /// **'No {label} customers this period.'**
  String noCohortCustomers(String label);

  /// No description provided for @missedCustomersHeading.
  ///
  /// In en, this message translates to:
  /// **'Missed customers'**
  String get missedCustomersHeading;

  /// No description provided for @missedCustomersHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Remind\" to message them on WhatsApp.'**
  String get missedCustomersHint;

  /// No description provided for @noMissedCustomers.
  ///
  /// In en, this message translates to:
  /// **'No customers missed this month.'**
  String get noMissedCustomers;

  /// No description provided for @cohortRegulars.
  ///
  /// In en, this message translates to:
  /// **'Regulars'**
  String get cohortRegulars;

  /// No description provided for @cohortNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get cohortNew;

  /// No description provided for @cohortCameBack.
  ///
  /// In en, this message translates to:
  /// **'Came back'**
  String get cohortCameBack;

  /// No description provided for @cohortStoppedComing.
  ///
  /// In en, this message translates to:
  /// **'Stopped coming'**
  String get cohortStoppedComing;

  /// No description provided for @customersLabel.
  ///
  /// In en, this message translates to:
  /// **'customers'**
  String get customersLabel;

  /// No description provided for @reachOutNow.
  ///
  /// In en, this message translates to:
  /// **'Reach out now'**
  String get reachOutNow;

  /// No description provided for @atRiskSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} regulars are slipping · {revenue} at risk'**
  String atRiskSummary(int count, String revenue);

  /// No description provided for @overdueBadge.
  ///
  /// In en, this message translates to:
  /// **'{ratio}× overdue'**
  String overdueBadge(String ratio);

  /// No description provided for @cadenceOverdue.
  ///
  /// In en, this message translates to:
  /// **'Usually every {cadence}d · {overdue}d overdue'**
  String cadenceOverdue(String cadence, String overdue);

  /// No description provided for @remind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remind;

  /// No description provided for @remindOnWhatsappTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remind on WhatsApp'**
  String get remindOnWhatsappTooltip;

  /// No description provided for @retentionProTitle.
  ///
  /// In en, this message translates to:
  /// **'Retention insights are a PRO feature'**
  String get retentionProTitle;

  /// No description provided for @retentionProBody.
  ///
  /// In en, this message translates to:
  /// **'See who stopped coming, your new-vs-returning split, and win back lost customers with one-tap reminders.'**
  String get retentionProBody;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to PRO'**
  String get upgradeToPro;

  /// No description provided for @visitsSpentSummary.
  ///
  /// In en, this message translates to:
  /// **'{visits} visits · spent {spend}'**
  String visitsSpentSummary(int visits, String spend);

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @basics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get basics;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @countryHelperText.
  ///
  /// In en, this message translates to:
  /// **'Sets your currency, phone format, and default language.'**
  String get countryHelperText;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @stepOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepOfTotal(int step, int total);

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number'**
  String get enterPhoneNumber;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @fillOwnerSalonAddress.
  ///
  /// In en, this message translates to:
  /// **'Fill owner name, salon name, and address'**
  String get fillOwnerSalonAddress;

  /// No description provided for @turnOnLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Turn on location and allow permission to use this'**
  String get turnOnLocationPermission;

  /// No description provided for @couldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location'**
  String get couldNotGetLocation;

  /// No description provided for @phoneAlreadyRegisteredSignIn.
  ///
  /// In en, this message translates to:
  /// **'This phone is already registered. Please sign in instead.'**
  String get phoneAlreadyRegisteredSignIn;

  /// No description provided for @signupFailedCheckBackend.
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Check backend connection.'**
  String get signupFailedCheckBackend;

  /// No description provided for @signupFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please try again.'**
  String get signupFailedTryAgain;

  /// No description provided for @yourSalon.
  ///
  /// In en, this message translates to:
  /// **'Your salon'**
  String get yourSalon;

  /// No description provided for @salonDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 3 · Salon details'**
  String get salonDetailsSubtitle;

  /// No description provided for @ownerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get ownerNameLabel;

  /// No description provided for @salonNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Salon name'**
  String get salonNameLabel;

  /// No description provided for @salonAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Salon address'**
  String get salonAddressLabel;

  /// No description provided for @locationSet.
  ///
  /// In en, this message translates to:
  /// **'Location set'**
  String get locationSet;

  /// No description provided for @useMyCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useMyCurrentLocation;

  /// No description provided for @pickYourColor.
  ///
  /// In en, this message translates to:
  /// **'Pick your color'**
  String get pickYourColor;

  /// No description provided for @colorPreviewHelp.
  ///
  /// In en, this message translates to:
  /// **'This is your salon\'s accent color across the app. Change it anytime in Account.'**
  String get colorPreviewHelp;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @newBooking.
  ///
  /// In en, this message translates to:
  /// **'New booking'**
  String get newBooking;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorTerracotta.
  ///
  /// In en, this message translates to:
  /// **'Terracotta'**
  String get colorTerracotta;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get colorViolet;

  /// No description provided for @colorRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get colorRose;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your salon dashboard'**
  String get signInToDashboard;

  /// No description provided for @enterSalonOwnerPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter salon owner phone'**
  String get enterSalonOwnerPhone;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @noSalonOwnerFound.
  ///
  /// In en, this message translates to:
  /// **'No salon owner account found for this phone.'**
  String get noSalonOwnerFound;

  /// No description provided for @loginFailedCheckBackend.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Check backend connection.'**
  String get loginFailedCheckBackend;

  /// No description provided for @loginFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailedTryAgain;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newHere;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send a 6-digit code via WhatsApp.'**
  String get resetPasswordEnterPhone;

  /// No description provided for @sendCodeViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send code via WhatsApp'**
  String get sendCodeViaWhatsApp;

  /// No description provided for @codeSentViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'If that account exists, a code was sent via WhatsApp.'**
  String get codeSentViaWhatsApp;

  /// No description provided for @resetPasswordEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent you on WhatsApp, then choose a new password.'**
  String get resetPasswordEnterCode;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpCodeLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhoneNumber;

  /// No description provided for @enterSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get enterSixDigitCode;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset. Please sign in with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @waitBeforeRetryingCode.
  ///
  /// In en, this message translates to:
  /// **'Please wait a minute before requesting another code'**
  String get waitBeforeRetryingCode;

  /// No description provided for @invalidOrExpiredCode.
  ///
  /// In en, this message translates to:
  /// **'That code is invalid or has expired'**
  String get invalidOrExpiredCode;

  /// No description provided for @tooManyAttemptsRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts — request a new code'**
  String get tooManyAttemptsRequestNewCode;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @signedInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google'**
  String get signedInWithGoogle;

  /// No description provided for @signedInWithGoogleAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google as {email}'**
  String signedInWithGoogleAs(String email);

  /// No description provided for @usePasswordInstead.
  ///
  /// In en, this message translates to:
  /// **'Use password instead'**
  String get usePasswordInstead;

  /// No description provided for @googleSignInNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in isn\'t set up yet'**
  String get googleSignInNotConfigured;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @googleNoAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for that Google account. Create one first.'**
  String get googleNoAccountFound;

  /// No description provided for @linkGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Link Google account'**
  String get linkGoogleAccount;

  /// No description provided for @googleAccountLinked.
  ///
  /// In en, this message translates to:
  /// **'Google account linked — you can now sign in with it'**
  String get googleAccountLinked;

  /// No description provided for @addStaffBeforeBookings.
  ///
  /// In en, this message translates to:
  /// **'Add active staff before creating bookings'**
  String get addStaffBeforeBookings;

  /// No description provided for @salonLabel.
  ///
  /// In en, this message translates to:
  /// **'Salon'**
  String get salonLabel;

  /// No description provided for @statToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statToday;

  /// No description provided for @statRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get statRepeat;

  /// No description provided for @statLoggedHelper.
  ///
  /// In en, this message translates to:
  /// **'logged'**
  String get statLoggedHelper;

  /// No description provided for @statBackHelper.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get statBackHelper;

  /// No description provided for @statWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statWeek;

  /// No description provided for @statMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statMonth;

  /// No description provided for @loggedTodayHeading.
  ///
  /// In en, this message translates to:
  /// **'Logged today'**
  String get loggedTodayHeading;

  /// No description provided for @nothingLoggedToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet today. Tap \"New booking\" once a service is done.'**
  String get nothingLoggedToday;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @salonAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Salon Admin'**
  String get salonAdminTitle;

  /// No description provided for @noSalonLinked.
  ///
  /// In en, this message translates to:
  /// **'No salon is linked to this owner account yet.'**
  String get noSalonLinked;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTitle;

  /// No description provided for @searchCustomerOrService.
  ///
  /// In en, this message translates to:
  /// **'Search customer or service'**
  String get searchCustomerOrService;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get filterThisWeek;

  /// No description provided for @filterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get filterAllTime;

  /// No description provided for @filterAllStaff.
  ///
  /// In en, this message translates to:
  /// **'All staff'**
  String get filterAllStaff;

  /// No description provided for @staffLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffLabel;

  /// No description provided for @needsActionHeading.
  ///
  /// In en, this message translates to:
  /// **'Needs action'**
  String get needsActionHeading;

  /// No description provided for @statTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statTotal;

  /// No description provided for @statServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get statServices;

  /// No description provided for @statAvgTicket.
  ///
  /// In en, this message translates to:
  /// **'Avg ticket'**
  String get statAvgTicket;

  /// No description provided for @noBookingsMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No bookings match this filter yet'**
  String get noBookingsMatchFilter;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @dayTotalServices.
  ///
  /// In en, this message translates to:
  /// **'{total} · {count, plural, one{{count} service} other{{count} services}}'**
  String dayTotalServices(String total, int count);

  /// No description provided for @couldNotOpenStore.
  ///
  /// In en, this message translates to:
  /// **'Could not open the store'**
  String get couldNotOpenStore;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequired;

  /// No description provided for @updateRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'A newer version of the app is available. Please update to keep using your salon dashboard.'**
  String get updateRequiredBody;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @themeColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColorTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get addStaff;

  /// No description provided for @statActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statActive;

  /// No description provided for @statTodaysTotal.
  ///
  /// In en, this message translates to:
  /// **'Today\'s total'**
  String get statTodaysTotal;

  /// No description provided for @noActiveStaffYet.
  ///
  /// In en, this message translates to:
  /// **'No active staff yet'**
  String get noActiveStaffYet;

  /// No description provided for @addFirstStaff.
  ///
  /// In en, this message translates to:
  /// **'Add first staff'**
  String get addFirstStaff;

  /// No description provided for @noServicesYet.
  ///
  /// In en, this message translates to:
  /// **'No services yet'**
  String get noServicesYet;

  /// No description provided for @notActive.
  ///
  /// In en, this message translates to:
  /// **'Not active'**
  String get notActive;

  /// No description provided for @canSetOwnPrice.
  ///
  /// In en, this message translates to:
  /// **'Can set own price'**
  String get canSetOwnPrice;

  /// No description provided for @staffTodayTally.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} service} other{{count} services}} · {revenue}'**
  String staffTodayTally(int count, String revenue);

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @serviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceLabel;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @repeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeatLabel;

  /// No description provided for @couldNotUpdateBooking.
  ///
  /// In en, this message translates to:
  /// **'Could not update booking. Please try again.'**
  String get couldNotUpdateBooking;

  /// No description provided for @couldNotAcceptReschedule.
  ///
  /// In en, this message translates to:
  /// **'Could not accept reschedule. Please try again.'**
  String get couldNotAcceptReschedule;

  /// No description provided for @couldNotRejectReschedule.
  ///
  /// In en, this message translates to:
  /// **'Could not reject reschedule. Please try again.'**
  String get couldNotRejectReschedule;

  /// No description provided for @rescheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get rescheduleLabel;

  /// No description provided for @pendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingLabel;

  /// No description provided for @scheduledLabel.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduledLabel;

  /// No description provided for @inProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgressLabel;

  /// No description provided for @startBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startBookingButton;

  /// No description provided for @doneBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneBookingButton;

  /// No description provided for @todayScheduleHeading.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get todayScheduleHeading;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentMethodLabel;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentMethodUpi;

  /// No description provided for @rebookAction.
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get rebookAction;

  /// No description provided for @couldNotLoadCustomerProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load customer profile'**
  String get couldNotLoadCustomerProfile;

  /// No description provided for @notesSaved.
  ///
  /// In en, this message translates to:
  /// **'Notes saved'**
  String get notesSaved;

  /// No description provided for @couldNotSaveNotes.
  ///
  /// In en, this message translates to:
  /// **'Could not save notes. Please try again.'**
  String get couldNotSaveNotes;

  /// No description provided for @statsVisitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get statsVisitsLabel;

  /// No description provided for @statsTotalSpentLabel.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get statsTotalSpentLabel;

  /// No description provided for @lastServiceSummary.
  ///
  /// In en, this message translates to:
  /// **'Last: {service} on {date}'**
  String lastServiceSummary(String service, String date);

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Preferences, allergies, anything worth remembering'**
  String get notesHint;

  /// No description provided for @tagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsLabel;

  /// No description provided for @addTagHint.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get addTagHint;

  /// No description provided for @saveNotesButton.
  ///
  /// In en, this message translates to:
  /// **'Save notes'**
  String get saveNotesButton;

  /// No description provided for @visitHistoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Visit history'**
  String get visitHistoryHeading;

  /// No description provided for @noVisitsYet.
  ///
  /// In en, this message translates to:
  /// **'No visits yet'**
  String get noVisitsYet;

  /// No description provided for @viewProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfileTooltip;

  /// No description provided for @dailyRevenueGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily revenue goal'**
  String get dailyRevenueGoalLabel;

  /// No description provided for @dailyRevenueGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — leave blank to hide the pace bar on Home'**
  String get dailyRevenueGoalHint;

  /// No description provided for @payoutsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get payoutsTooltip;

  /// No description provided for @staffActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffActiveLabel;

  /// No description provided for @canCancelBookingLabel.
  ///
  /// In en, this message translates to:
  /// **'Can cancel bookings'**
  String get canCancelBookingLabel;

  /// No description provided for @couldNotLoadPayouts.
  ///
  /// In en, this message translates to:
  /// **'Could not load payouts'**
  String get couldNotLoadPayouts;

  /// No description provided for @payoutSettled.
  ///
  /// In en, this message translates to:
  /// **'Payout recorded'**
  String get payoutSettled;

  /// No description provided for @couldNotMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Could not mark as paid. Please try again.'**
  String get couldNotMarkPaid;

  /// No description provided for @payoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings & payouts'**
  String get payoutsTitle;

  /// No description provided for @unpaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaidLabel;

  /// No description provided for @markAsPaidButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaidButton;

  /// No description provided for @grossRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get grossRevenueLabel;

  /// No description provided for @totalPayoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get totalPayoutLabel;

  /// No description provided for @payoutHistoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Payout history'**
  String get payoutHistoryHeading;

  /// No description provided for @noPayoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No payouts yet'**
  String get noPayoutsYet;

  /// No description provided for @payTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pay type'**
  String get payTypeLabel;

  /// No description provided for @payTypeCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get payTypeCommission;

  /// No description provided for @payTypeSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get payTypeSalary;

  /// No description provided for @payTypeBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get payTypeBoth;

  /// No description provided for @commissionRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Commission %'**
  String get commissionRateLabel;

  /// No description provided for @monthlySalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly salary'**
  String get monthlySalaryLabel;

  /// No description provided for @couldNotSavePayType.
  ///
  /// In en, this message translates to:
  /// **'Could not save pay settings. Please try again.'**
  String get couldNotSavePayType;

  /// No description provided for @salaryThisMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'This month\'s salary'**
  String get salaryThisMonthLabel;

  /// No description provided for @salaryPaidStatus.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get salaryPaidStatus;

  /// No description provided for @paySalaryButton.
  ///
  /// In en, this message translates to:
  /// **'Pay salary'**
  String get paySalaryButton;

  /// No description provided for @salaryPaid.
  ///
  /// In en, this message translates to:
  /// **'Salary paid'**
  String get salaryPaid;

  /// No description provided for @couldNotPaySalary.
  ///
  /// In en, this message translates to:
  /// **'Could not pay salary. Please try again.'**
  String get couldNotPaySalary;

  /// No description provided for @searchStaffHint.
  ///
  /// In en, this message translates to:
  /// **'Search staff'**
  String get searchStaffHint;

  /// No description provided for @filterActiveStaff.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActiveStaff;

  /// No description provided for @filterInactiveStaff.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get filterInactiveStaff;

  /// No description provided for @switchBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch branch'**
  String get switchBranchTitle;

  /// No description provided for @switchLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch branch'**
  String get switchLabel;

  /// No description provided for @allBranchesLabel.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get allBranchesLabel;

  /// No description provided for @allBranchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Combined totals across every branch'**
  String get allBranchesSubtitle;

  /// No description provided for @pickBranchFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a specific branch first'**
  String get pickBranchFirst;

  /// No description provided for @branchStatsLine.
  ///
  /// In en, this message translates to:
  /// **'{count} logged · {revenue} · {staff} staff'**
  String branchStatsLine(int count, String revenue, int staff);

  /// No description provided for @dayOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get dayOffLabel;

  /// No description provided for @addBranchButton.
  ///
  /// In en, this message translates to:
  /// **'Add branch'**
  String get addBranchButton;

  /// No description provided for @addBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a branch'**
  String get addBranchTitle;

  /// No description provided for @branchNameAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch name and address are required'**
  String get branchNameAddressRequired;

  /// No description provided for @couldNotAddBranch.
  ///
  /// In en, this message translates to:
  /// **'Could not add branch. Please try again.'**
  String get couldNotAddBranch;

  /// No description provided for @fillProductFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all product fields correctly'**
  String get fillProductFields;

  /// No description provided for @couldNotSaveProduct.
  ///
  /// In en, this message translates to:
  /// **'Could not save product. Please try again.'**
  String get couldNotSaveProduct;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductTitle;

  /// No description provided for @addProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProductTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productNameLabel;

  /// No description provided for @skuLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU (optional)'**
  String get skuLabel;

  /// No description provided for @stockQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockQtyLabel;

  /// No description provided for @lowStockThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Low stock at'**
  String get lowStockThresholdLabel;

  /// No description provided for @deleteProductButton.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProductButton;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProductsHint;

  /// No description provided for @filterLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get filterLowStock;

  /// No description provided for @noLowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'Nothing is low on stock'**
  String get noLowStockProducts;

  /// No description provided for @noProductsInCatalog.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsInCatalog;

  /// No description provided for @stockCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 in stock} other{{count} in stock}}'**
  String stockCount(int count);

  /// No description provided for @lowStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get lowStockLabel;

  /// No description provided for @lowStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 product is low on stock} other{{count} products are low on stock}}'**
  String lowStockCount(int count);

  /// No description provided for @morningBriefingHeading.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get morningBriefingHeading;

  /// No description provided for @todaysAppointmentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No appointments logged yet} one{1 appointment logged} other{{count} appointments logged}}'**
  String todaysAppointmentsCount(int count);

  /// No description provided for @revenueGoalPace.
  ///
  /// In en, this message translates to:
  /// **'{current} of {goal} goal'**
  String revenueGoalPace(String current, String goal);

  /// No description provided for @worthReachingOutHeading.
  ///
  /// In en, this message translates to:
  /// **'Worth reaching out today'**
  String get worthReachingOutHeading;

  /// No description provided for @exportCsvTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsvTooltip;

  /// No description provided for @couldNotExportEarnings.
  ///
  /// In en, this message translates to:
  /// **'Could not export earnings. Please try again.'**
  String get couldNotExportEarnings;

  /// No description provided for @overdueDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{1 day overdue} other{{days} days overdue}}'**
  String overdueDaysCount(int days);

  /// No description provided for @customerWithStylist.
  ///
  /// In en, this message translates to:
  /// **'{customer} with {stylist}'**
  String customerWithStylist(String customer, String stylist);

  /// No description provided for @customerRequestedTime.
  ///
  /// In en, this message translates to:
  /// **'Customer requested {time}'**
  String customerRequestedTime(String time);

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @plusMoreServices.
  ///
  /// In en, this message translates to:
  /// **'{first} + {count} more'**
  String plusMoreServices(String first, int count);

  /// No description provided for @twoServicesJoin.
  ///
  /// In en, this message translates to:
  /// **'{a} + {b}'**
  String twoServicesJoin(String a, String b);

  /// No description provided for @couldNotLoadAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not load account details'**
  String get couldNotLoadAccount;

  /// No description provided for @fillOwnerPhoneSalonAddress.
  ///
  /// In en, this message translates to:
  /// **'Fill owner, phone, salon name, and address'**
  String get fillOwnerPhoneSalonAddress;

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated'**
  String get accountUpdated;

  /// No description provided for @phoneOrEmailUsed.
  ///
  /// In en, this message translates to:
  /// **'Phone or email is already used'**
  String get phoneOrEmailUsed;

  /// No description provided for @couldNotSaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not save account details'**
  String get couldNotSaveAccount;

  /// No description provided for @newPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters'**
  String get newPasswordMinLength;

  /// No description provided for @newPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get newPasswordsDontMatch;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @couldNotChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Could not change password'**
  String get couldNotChangePassword;

  /// No description provided for @countryAndCurrency.
  ///
  /// In en, this message translates to:
  /// **'Country and currency'**
  String get countryAndCurrency;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @ownerSinceDate.
  ///
  /// In en, this message translates to:
  /// **'Owner since {date}'**
  String ownerSinceDate(String date);

  /// No description provided for @planLabel.
  ///
  /// In en, this message translates to:
  /// **'{plan} plan'**
  String planLabel(String plan);

  /// No description provided for @retentionFreeFor6Months.
  ///
  /// In en, this message translates to:
  /// **'Retention insights free for 6 months'**
  String get retentionFreeFor6Months;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @salonProfile.
  ///
  /// In en, this message translates to:
  /// **'Salon profile'**
  String get salonProfile;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location updated'**
  String get locationUpdated;

  /// No description provided for @saveDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'Save details'**
  String get saveDetailsButton;

  /// No description provided for @savingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingEllipsis;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordButton;

  /// No description provided for @changingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Changing...'**
  String get changingEllipsis;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @enterServiceNamePrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a service name and price'**
  String get enterServiceNamePrice;

  /// No description provided for @fillStaffNamePhone.
  ///
  /// In en, this message translates to:
  /// **'Fill staff name and phone'**
  String get fillStaffNamePhone;

  /// No description provided for @addAtLeastOneService.
  ///
  /// In en, this message translates to:
  /// **'Add at least one service'**
  String get addAtLeastOneService;

  /// No description provided for @enterValidOpenCloseTimes.
  ///
  /// In en, this message translates to:
  /// **'Enter valid open and close times (HH:MM, 24-hour)'**
  String get enterValidOpenCloseTimes;

  /// No description provided for @selectAtLeastOneWorkingDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one working day'**
  String get selectAtLeastOneWorkingDay;

  /// No description provided for @staffPhoneInUse.
  ///
  /// In en, this message translates to:
  /// **'That staff phone is already in use'**
  String get staffPhoneInUse;

  /// No description provided for @couldNotAddStaff.
  ///
  /// In en, this message translates to:
  /// **'Could not add staff. Please try again.'**
  String get couldNotAddStaff;

  /// No description provided for @addStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up their profile, services, and working days.'**
  String get addStaffSubtitle;

  /// No description provided for @staffNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff name'**
  String get staffNameLabel;

  /// No description provided for @staffPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff phone'**
  String get staffPhoneLabel;

  /// No description provided for @servicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesLabel;

  /// No description provided for @servicesAddedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} added'**
  String servicesAddedCount(int count);

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHours;

  /// No description provided for @opens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get opens;

  /// No description provided for @closes.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get closes;

  /// No description provided for @hhmmHint.
  ///
  /// In en, this message translates to:
  /// **'HH:MM'**
  String get hhmmHint;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get workingDays;

  /// No description provided for @serviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceNameHint;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceHint;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @enterValidStaffNamePhone.
  ///
  /// In en, this message translates to:
  /// **'Enter valid staff name and phone'**
  String get enterValidStaffNamePhone;

  /// No description provided for @staffDetailsSaved.
  ///
  /// In en, this message translates to:
  /// **'Staff details saved'**
  String get staffDetailsSaved;

  /// No description provided for @phoneAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'That phone is already in use'**
  String get phoneAlreadyInUse;

  /// No description provided for @couldNotUpdateStaff.
  ///
  /// In en, this message translates to:
  /// **'Could not update staff'**
  String get couldNotUpdateStaff;

  /// No description provided for @enterServiceNameAndPriceShort.
  ///
  /// In en, this message translates to:
  /// **'Enter service name and price'**
  String get enterServiceNameAndPriceShort;

  /// No description provided for @couldNotAddService.
  ///
  /// In en, this message translates to:
  /// **'Could not add service'**
  String get couldNotAddService;

  /// No description provided for @editServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get editServiceTitle;

  /// No description provided for @enterValidServiceNamePrice.
  ///
  /// In en, this message translates to:
  /// **'Enter valid service name and price'**
  String get enterValidServiceNamePrice;

  /// No description provided for @couldNotUpdateService.
  ///
  /// In en, this message translates to:
  /// **'Could not update service'**
  String get couldNotUpdateService;

  /// No description provided for @saveServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Save service'**
  String get saveServiceButton;

  /// No description provided for @couldNotRemoveServiceDefault.
  ///
  /// In en, this message translates to:
  /// **'Could not remove service'**
  String get couldNotRemoveServiceDefault;

  /// No description provided for @useHHmmWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Use HH:mm for working hours'**
  String get useHHmmWorkingHours;

  /// No description provided for @hoursAdded.
  ///
  /// In en, this message translates to:
  /// **'Hours added'**
  String get hoursAdded;

  /// No description provided for @couldNotAddWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Could not add working hours'**
  String get couldNotAddWorkingHours;

  /// No description provided for @couldNotRemoveTiming.
  ///
  /// In en, this message translates to:
  /// **'Could not remove timing'**
  String get couldNotRemoveTiming;

  /// No description provided for @manageStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage staff'**
  String get manageStaffTitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @manageStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, or remove services and hours, then tap Done.'**
  String get manageStaffSubtitle;

  /// No description provided for @saveStaffButton.
  ///
  /// In en, this message translates to:
  /// **'Save staff'**
  String get saveStaffButton;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @newServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'New service'**
  String get newServiceLabel;

  /// No description provided for @addingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get addingEllipsis;

  /// No description provided for @addServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get addServiceButton;

  /// No description provided for @noTimingsYet.
  ///
  /// In en, this message translates to:
  /// **'No timings yet'**
  String get noTimingsYet;

  /// No description provided for @removeLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeLabel;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endLabel;

  /// No description provided for @addMonSatHoursButton.
  ///
  /// In en, this message translates to:
  /// **'Add Mon-Sat hours'**
  String get addMonSatHoursButton;

  /// No description provided for @saveHoursButton.
  ///
  /// In en, this message translates to:
  /// **'Save hours'**
  String get saveHoursButton;

  /// No description provided for @hhmmLowerHint.
  ///
  /// In en, this message translates to:
  /// **'HH:mm'**
  String get hhmmLowerHint;

  /// No description provided for @chooseStaffServiceDate.
  ///
  /// In en, this message translates to:
  /// **'Choose staff, service, and date'**
  String get chooseStaffServiceDate;

  /// No description provided for @noSlotsForDate.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this date.'**
  String get noSlotsForDate;

  /// No description provided for @couldNotLoadSlots.
  ///
  /// In en, this message translates to:
  /// **'Could not load slots'**
  String get couldNotLoadSlots;

  /// No description provided for @enterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enterCustomerName;

  /// No description provided for @chooseStaffAndService.
  ///
  /// In en, this message translates to:
  /// **'Choose staff and at least one service'**
  String get chooseStaffAndService;

  /// No description provided for @enterCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter customer phone'**
  String get enterCustomerPhone;

  /// No description provided for @chooseAvailableSlot.
  ///
  /// In en, this message translates to:
  /// **'Choose an available slot'**
  String get chooseAvailableSlot;

  /// No description provided for @couldNotCreateBooking.
  ///
  /// In en, this message translates to:
  /// **'Could not create booking. Please try again.'**
  String get couldNotCreateBooking;

  /// No description provided for @doneServiceOption.
  ///
  /// In en, this message translates to:
  /// **'Done service'**
  String get doneServiceOption;

  /// No description provided for @scheduleLaterOption.
  ///
  /// In en, this message translates to:
  /// **'Schedule later'**
  String get scheduleLaterOption;

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerNameLabel;

  /// No description provided for @customerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer phone'**
  String get customerPhoneLabel;

  /// No description provided for @recordedNowDate.
  ///
  /// In en, this message translates to:
  /// **'Recorded now — {date}'**
  String recordedNowDate(String date);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @yyyymmddHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get yyyymmddHint;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available slots'**
  String get availableSlots;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveBooking.
  ///
  /// In en, this message translates to:
  /// **'Save booking'**
  String get saveBooking;

  /// No description provided for @saveBookingWithTotal.
  ///
  /// In en, this message translates to:
  /// **'Save booking · {total}'**
  String saveBookingWithTotal(String total);

  /// No description provided for @addServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get addServiceTitle;

  /// No description provided for @serviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceNameLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @durationMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutesLabel;

  /// No description provided for @deleteServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Delete service'**
  String get deleteServiceButton;

  /// No description provided for @fillServiceFields.
  ///
  /// In en, this message translates to:
  /// **'Enter a name, category, price, and duration'**
  String get fillServiceFields;

  /// No description provided for @couldNotSaveService.
  ///
  /// In en, this message translates to:
  /// **'Could not save service'**
  String get couldNotSaveService;

  /// No description provided for @noServicesInCatalog.
  ///
  /// In en, this message translates to:
  /// **'No services yet. Add your first one.'**
  String get noServicesInCatalog;

  /// No description provided for @searchServicesHint.
  ///
  /// In en, this message translates to:
  /// **'Search services'**
  String get searchServicesHint;

  /// No description provided for @filterAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAllCategories;

  /// No description provided for @assignToStaffLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign to staff'**
  String get assignToStaffLabel;

  /// No description provided for @anyStaffOption.
  ///
  /// In en, this message translates to:
  /// **'Any staff'**
  String get anyStaffOption;

  /// No description provided for @addStarterServicesButton.
  ///
  /// In en, this message translates to:
  /// **'Add common services'**
  String get addStarterServicesButton;

  /// No description provided for @bookingLinkSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking link'**
  String get bookingLinkSectionTitle;

  /// No description provided for @bookingLinkSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share this link or QR code so customers can book online'**
  String get bookingLinkSectionSubtitle;

  /// No description provided for @copyLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyLinkButton;

  /// No description provided for @shareLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareLinkButton;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @bookingLinkShareText.
  ///
  /// In en, this message translates to:
  /// **'Book at {salonName}: {link}'**
  String bookingLinkShareText(String salonName, String link);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'de',
        'en',
        'es',
        'fa',
        'fil',
        'fr',
        'gu',
        'hi',
        'id',
        'it',
        'mr',
        'ms',
        'pl',
        'pt',
        'ro',
        'ru',
        'sw',
        'ta',
        'te',
        'tr',
        'uk',
        'ur',
        'vi'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
