// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get insightsTitle => 'Insights';

  @override
  String get tabEarnings => 'Earnings';

  @override
  String get tabRetention => 'Retention';

  @override
  String get periodToday => 'Today';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodLast7Days => 'Last 7 days';

  @override
  String get periodLast30Days => 'Last 30 days';

  @override
  String get earningsLoadError => 'Could not load earnings.';

  @override
  String get retry => 'Retry';

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
  String get completedServicesHeading => 'Completed services';

  @override
  String get noCompletedServices => 'No completed services in this period yet.';

  @override
  String get topServicesHeading => 'Top services';

  @override
  String get byStaffHeading => 'By staff';

  @override
  String get vsYesterday => 'vs yesterday';

  @override
  String get vsLastWeek => 'vs last week';

  @override
  String get vsLastMonth => 'vs last month';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Customers you won back';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count customers came back this month',
      one: '$count customer came back this month',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Could not load retention report.';

  @override
  String get couldNotOpenWhatsapp => 'Could not open WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Hi $name! We\'ve missed you at $salonName. Book your next visit and enjoy a special welcome-back offer. See you soon!';
  }

  @override
  String get customerCohortsHeading => 'Customer cohorts';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count customers';
  }

  @override
  String noCohortCustomers(String label) {
    return 'No $label customers this period.';
  }

  @override
  String get missedCustomersHeading => 'Missed customers';

  @override
  String get missedCustomersHint =>
      'Tap \"Remind\" to message them on WhatsApp.';

  @override
  String get noMissedCustomers => 'No customers missed this month.';

  @override
  String get cohortRegulars => 'Regulars';

  @override
  String get cohortNew => 'New';

  @override
  String get cohortCameBack => 'Came back';

  @override
  String get cohortStoppedComing => 'Stopped coming';

  @override
  String get customersLabel => 'customers';

  @override
  String get reachOutNow => 'Reach out now';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count regulars are slipping · $revenue at risk';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× overdue';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Usually every ${cadence}d · ${overdue}d overdue';
  }

  @override
  String get remind => 'Remind';

  @override
  String get remindOnWhatsappTooltip => 'Remind on WhatsApp';

  @override
  String get retentionProTitle => 'Retention insights are a PRO feature';

  @override
  String get retentionProBody =>
      'See who stopped coming, your new-vs-returning split, and win back lost customers with one-tap reminders.';

  @override
  String get upgradeToPro => 'Upgrade to PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits visits · spent $spend';
  }

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get basics => 'Basics';

  @override
  String get country => 'Country';

  @override
  String get countryHelperText =>
      'Sets your currency, phone format, and default language.';

  @override
  String get language => 'Language';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get passwordLabel => 'Password';

  @override
  String stepOfTotal(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get createAccountButton => 'Create account';

  @override
  String get continueButton => 'Continue';

  @override
  String get enterPhoneNumber => 'Enter a phone number';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get fillOwnerSalonAddress =>
      'Fill owner name, salon name, and address';

  @override
  String get turnOnLocationPermission =>
      'Turn on location and allow permission to use this';

  @override
  String get couldNotGetLocation => 'Could not get your location';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'This phone is already registered. Please sign in instead.';

  @override
  String get signupFailedCheckBackend =>
      'Signup failed. Check backend connection.';

  @override
  String get signupFailedTryAgain => 'Signup failed. Please try again.';

  @override
  String get yourSalon => 'Your salon';

  @override
  String get salonDetailsSubtitle => 'Step 2 of 3 · Salon details';

  @override
  String get ownerNameLabel => 'Owner name';

  @override
  String get salonNameLabel => 'Salon name';

  @override
  String get salonAddressLabel => 'Salon address';

  @override
  String get locationSet => 'Location set';

  @override
  String get useMyCurrentLocation => 'Use my current location';

  @override
  String get pickYourColor => 'Pick your color';

  @override
  String get colorPreviewHelp =>
      'This is your salon\'s accent color across the app. Change it anytime in Account.';

  @override
  String get previewLabel => 'Preview';

  @override
  String get newBooking => 'New booking';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorTerracotta => 'Terracotta';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorRose => 'Rose';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInToDashboard => 'Sign in to your salon dashboard';

  @override
  String get enterSalonOwnerPhone => 'Enter salon owner phone';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get noSalonOwnerFound =>
      'No salon owner account found for this phone.';

  @override
  String get loginFailedCheckBackend =>
      'Login failed. Check backend connection.';

  @override
  String get loginFailedTryAgain => 'Login failed. Please try again.';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String get signIn => 'Sign in';

  @override
  String get newHere => 'New here?';

  @override
  String get createAccount => 'Create account';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordEnterPhone =>
      'Enter your phone number and we\'ll send a 6-digit code via WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Send code via WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'If that account exists, a code was sent via WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Enter the code we sent you on WhatsApp, then choose a new password.';

  @override
  String get otpCodeLabel => '6-digit code';

  @override
  String get resetPasswordButton => 'Reset password';

  @override
  String get resendCode => 'Resend code';

  @override
  String get changePhoneNumber => 'Change phone number';

  @override
  String get enterSixDigitCode => 'Enter the 6-digit code';

  @override
  String get passwordsDoNotMatch => 'Passwords don\'t match';

  @override
  String get passwordResetSuccess =>
      'Password reset. Please sign in with your new password.';

  @override
  String get waitBeforeRetryingCode =>
      'Please wait a minute before requesting another code';

  @override
  String get invalidOrExpiredCode => 'That code is invalid or has expired';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Too many attempts — request a new code';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signedInWithGoogle => 'Signed in with Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Signed in with Google as $email';
  }

  @override
  String get usePasswordInstead => 'Use password instead';

  @override
  String get googleSignInNotConfigured => 'Google sign-in isn\'t set up yet';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Please try again.';

  @override
  String get googleNoAccountFound =>
      'No account found for that Google account. Create one first.';

  @override
  String get linkGoogleAccount => 'Link Google account';

  @override
  String get googleAccountLinked =>
      'Google account linked — you can now sign in with it';

  @override
  String get addStaffBeforeBookings =>
      'Add active staff before creating bookings';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Today';

  @override
  String get statRepeat => 'Repeat';

  @override
  String get statLoggedHelper => 'logged';

  @override
  String get statBackHelper => 'back';

  @override
  String get statWeek => 'Week';

  @override
  String get statMonth => 'Month';

  @override
  String get loggedTodayHeading => 'Logged today';

  @override
  String get nothingLoggedToday =>
      'Nothing logged yet today. Tap \"New booking\" once a service is done.';

  @override
  String get navHome => 'Home';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navStaff => 'Staff';

  @override
  String get navInsights => 'Insights';

  @override
  String get navAccount => 'Account';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked => 'No salon is linked to this owner account yet.';

  @override
  String get bookingsTitle => 'Bookings';

  @override
  String get searchCustomerOrService => 'Search customer or service';

  @override
  String get filterThisWeek => 'This week';

  @override
  String get filterAllTime => 'All time';

  @override
  String get filterAllStaff => 'All staff';

  @override
  String get staffLabel => 'Staff';

  @override
  String get needsActionHeading => 'Needs action';

  @override
  String get statTotal => 'Total';

  @override
  String get statServices => 'Services';

  @override
  String get statAvgTicket => 'Avg ticket';

  @override
  String get noBookingsMatchFilter => 'No bookings match this filter yet';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

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
  String get couldNotOpenStore => 'Could not open the store';

  @override
  String get updateRequired => 'Update required';

  @override
  String get updateRequiredBody =>
      'A newer version of the app is available. Please update to keep using your salon dashboard.';

  @override
  String get updateNow => 'Update now';

  @override
  String get themeColorTitle => 'Theme color';

  @override
  String get save => 'Save';

  @override
  String get staffTitle => 'Staff';

  @override
  String get addStaff => 'Add staff';

  @override
  String get statActive => 'Active';

  @override
  String get statTodaysTotal => 'Today\'s total';

  @override
  String get noActiveStaffYet => 'No active staff yet';

  @override
  String get addFirstStaff => 'Add first staff';

  @override
  String get noServicesYet => 'No services yet';

  @override
  String get notActive => 'Not active';

  @override
  String get canSetOwnPrice => 'Can set own price';

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
  String get newLabel => 'New';

  @override
  String get serviceLabel => 'Service';

  @override
  String get customerLabel => 'Customer';

  @override
  String get repeatLabel => 'Repeat';

  @override
  String get couldNotUpdateBooking =>
      'Could not update booking. Please try again.';

  @override
  String get couldNotAcceptReschedule =>
      'Could not accept reschedule. Please try again.';

  @override
  String get couldNotRejectReschedule =>
      'Could not reject reschedule. Please try again.';

  @override
  String get rescheduleLabel => 'Reschedule';

  @override
  String get pendingLabel => 'Pending';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer with $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Customer requested $time';
  }

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Accept';

  @override
  String get confirm => 'Confirm';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count more';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Could not load account details';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Fill owner, phone, salon name, and address';

  @override
  String get accountUpdated => 'Account updated';

  @override
  String get phoneOrEmailUsed => 'Phone or email is already used';

  @override
  String get couldNotSaveAccount => 'Could not save account details';

  @override
  String get newPasswordMinLength =>
      'New password must be at least 6 characters';

  @override
  String get newPasswordsDontMatch => 'New passwords do not match';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get currentPasswordIncorrect => 'Current password is incorrect';

  @override
  String get couldNotChangePassword => 'Could not change password';

  @override
  String get countryAndCurrency => 'Country and currency';

  @override
  String get accountTitle => 'Account';

  @override
  String ownerSinceDate(String date) {
    return 'Owner since $date';
  }

  @override
  String planLabel(String plan) {
    return '$plan plan';
  }

  @override
  String get retentionFreeFor6Months => 'Retention insights free for 6 months';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get appearance => 'Appearance';

  @override
  String get salonProfile => 'Salon profile';

  @override
  String get emailLabel => 'Email';

  @override
  String get locationUpdated => 'Location updated';

  @override
  String get saveDetailsButton => 'Save details';

  @override
  String get savingEllipsis => 'Saving...';

  @override
  String get security => 'Security';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmNewPasswordLabel => 'Confirm new password';

  @override
  String get changePasswordButton => 'Change password';

  @override
  String get changingEllipsis => 'Changing...';

  @override
  String get signOut => 'Sign out';

  @override
  String get enterServiceNamePrice => 'Enter a service name and price';

  @override
  String get fillStaffNamePhone => 'Fill staff name and phone';

  @override
  String get addAtLeastOneService => 'Add at least one service';

  @override
  String get enterValidOpenCloseTimes =>
      'Enter valid open and close times (HH:MM, 24-hour)';

  @override
  String get selectAtLeastOneWorkingDay => 'Select at least one working day';

  @override
  String get staffPhoneInUse => 'That staff phone is already in use';

  @override
  String get couldNotAddStaff => 'Could not add staff. Please try again.';

  @override
  String get addStaffSubtitle =>
      'Set up their profile, services, and working days.';

  @override
  String get staffNameLabel => 'Staff name';

  @override
  String get staffPhoneLabel => 'Staff phone';

  @override
  String get servicesLabel => 'Services';

  @override
  String servicesAddedCount(int count) {
    return '$count added';
  }

  @override
  String get workingHours => 'Working hours';

  @override
  String get opens => 'Opens';

  @override
  String get closes => 'Closes';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Working days';

  @override
  String get serviceNameHint => 'Service name';

  @override
  String get priceHint => 'Price';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get enterValidStaffNamePhone => 'Enter valid staff name and phone';

  @override
  String get staffDetailsSaved => 'Staff details saved';

  @override
  String get phoneAlreadyInUse => 'That phone is already in use';

  @override
  String get couldNotUpdateStaff => 'Could not update staff';

  @override
  String get enterServiceNameAndPriceShort => 'Enter service name and price';

  @override
  String get couldNotAddService => 'Could not add service';

  @override
  String get editServiceTitle => 'Edit service';

  @override
  String get enterValidServiceNamePrice => 'Enter valid service name and price';

  @override
  String get couldNotUpdateService => 'Could not update service';

  @override
  String get saveServiceButton => 'Save service';

  @override
  String get couldNotRemoveServiceDefault => 'Could not remove service';

  @override
  String get useHHmmWorkingHours => 'Use HH:mm for working hours';

  @override
  String get hoursAdded => 'Hours added';

  @override
  String get couldNotAddWorkingHours => 'Could not add working hours';

  @override
  String get couldNotRemoveTiming => 'Could not remove timing';

  @override
  String get manageStaffTitle => 'Manage staff';

  @override
  String get done => 'Done';

  @override
  String get manageStaffSubtitle =>
      'Add, edit, or remove services and hours, then tap Done.';

  @override
  String get saveStaffButton => 'Save staff';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get newServiceLabel => 'New service';

  @override
  String get addingEllipsis => 'Adding...';

  @override
  String get addServiceButton => 'Add service';

  @override
  String get noTimingsYet => 'No timings yet';

  @override
  String get removeLabel => 'Remove';

  @override
  String get startLabel => 'Start';

  @override
  String get endLabel => 'End';

  @override
  String get addMonSatHoursButton => 'Add Mon-Sat hours';

  @override
  String get saveHoursButton => 'Save hours';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Choose staff, service, and date';

  @override
  String get noSlotsForDate => 'No available slots for this date.';

  @override
  String get couldNotLoadSlots => 'Could not load slots';

  @override
  String get enterCustomerName => 'Enter customer name';

  @override
  String get chooseStaffAndService => 'Choose staff and at least one service';

  @override
  String get enterCustomerPhone => 'Enter customer phone';

  @override
  String get chooseAvailableSlot => 'Choose an available slot';

  @override
  String get couldNotCreateBooking =>
      'Could not create booking. Please try again.';

  @override
  String get doneServiceOption => 'Done service';

  @override
  String get scheduleLaterOption => 'Schedule later';

  @override
  String get customerNameLabel => 'Customer name';

  @override
  String get customerPhoneLabel => 'Customer phone';

  @override
  String recordedNowDate(String date) {
    return 'Recorded now — $date';
  }

  @override
  String get dateLabel => 'Date';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'Available slots';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveBooking => 'Save booking';

  @override
  String saveBookingWithTotal(String total) {
    return 'Save booking · $total';
  }

  @override
  String get addServiceTitle => 'Add service';

  @override
  String get serviceNameLabel => 'Service name';

  @override
  String get categoryLabel => 'Category';

  @override
  String get priceLabel => 'Price';

  @override
  String get durationMinutesLabel => 'Duration (minutes)';

  @override
  String get deleteServiceButton => 'Delete service';

  @override
  String get fillServiceFields => 'Enter a name, category, price, and duration';

  @override
  String get couldNotSaveService => 'Could not save service';

  @override
  String get noServicesInCatalog => 'No services yet. Add your first one.';

  @override
  String get searchServicesHint => 'Search services';

  @override
  String get filterAllCategories => 'All';

  @override
  String get assignToStaffLabel => 'Assign to staff';

  @override
  String get anyStaffOption => 'Any staff';

  @override
  String get addStarterServicesButton => 'Add common services';
}
