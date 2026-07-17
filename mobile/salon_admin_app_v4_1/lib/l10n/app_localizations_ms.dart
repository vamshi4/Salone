// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get insightsTitle => 'Cerapan';

  @override
  String get tabEarnings => 'Pendapatan';

  @override
  String get tabRetention => 'Pengekalan';

  @override
  String get periodToday => 'Hari ini';

  @override
  String get periodWeek => 'Minggu';

  @override
  String get periodMonth => 'Bulan';

  @override
  String get periodLast7Days => '7 hari lepas';

  @override
  String get periodLast30Days => '30 hari lepas';

  @override
  String get earningsLoadError => 'Tidak dapat memuatkan pendapatan.';

  @override
  String get retry => 'Cuba lagi';

  @override
  String completedServicesCount(int count) {
    return '$count perkhidmatan';
  }

  @override
  String get completedServicesHeading => 'Perkhidmatan selesai';

  @override
  String get noCompletedServices =>
      'Belum ada perkhidmatan selesai dalam tempoh ini.';

  @override
  String get topServicesHeading => 'Perkhidmatan terbaik';

  @override
  String get byStaffHeading => 'Mengikut kakitangan';

  @override
  String get vsYesterday => 'berbanding semalam';

  @override
  String get vsLastWeek => 'berbanding minggu lepas';

  @override
  String get vsLastMonth => 'berbanding bulan lepas';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Pelanggan yang kembali';

  @override
  String reactivatedSummary(int count) {
    return '$count pelanggan kembali bulan ini';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Tidak dapat memuatkan laporan pengekalan.';

  @override
  String get couldNotOpenWhatsapp => 'Tidak dapat membuka WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Hai $name! Kami rindukan anda di $salonName. Tempah lawatan seterusnya anda dan nikmati tawaran istimewa selamat kembali. Jumpa lagi tidak lama lagi!';
  }

  @override
  String get customerCohortsHeading => 'Kumpulan pelanggan';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count pelanggan';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Tiada pelanggan $label dalam tempoh ini.';
  }

  @override
  String get missedCustomersHeading => 'Pelanggan terlepas';

  @override
  String get missedCustomersHint =>
      'Ketik \"Ingatkan\" untuk hantar mesej kepada mereka melalui WhatsApp.';

  @override
  String get noMissedCustomers => 'Tiada pelanggan terlepas bulan ini.';

  @override
  String get cohortRegulars => 'Pelanggan tetap';

  @override
  String get cohortNew => 'Baharu';

  @override
  String get cohortCameBack => 'Kembali';

  @override
  String get cohortStoppedComing => 'Berhenti datang';

  @override
  String get customersLabel => 'pelanggan';

  @override
  String get reachOutNow => 'Hubungi sekarang';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count pelanggan tetap semakin berkurangan · $revenue berisiko';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× tertunggak';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Biasanya setiap $cadence hari · $overdue hari tertunggak';
  }

  @override
  String get remind => 'Ingatkan';

  @override
  String get remindOnWhatsappTooltip => 'Ingatkan melalui WhatsApp';

  @override
  String get retentionProTitle => 'Cerapan pengekalan ialah ciri PRO';

  @override
  String get retentionProBody =>
      'Lihat siapa yang berhenti datang, nisbah pelanggan baharu berbanding kembali, dan dapatkan semula pelanggan yang hilang dengan peringatan sentuhan tunggal.';

  @override
  String get upgradeToPro => 'Naik taraf ke PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits lawatan · $spend dibelanjakan';
  }

  @override
  String get createYourAccount => 'Cipta akaun anda';

  @override
  String get basics => 'Maklumat asas';

  @override
  String get country => 'Negara';

  @override
  String get countryHelperText =>
      'Menetapkan mata wang, format telefon, dan bahasa lalai anda.';

  @override
  String get language => 'Bahasa';

  @override
  String get phoneNumberLabel => 'Nombor telefon';

  @override
  String get passwordLabel => 'Kata laluan';

  @override
  String stepOfTotal(int step, int total) {
    return 'Langkah $step daripada $total';
  }

  @override
  String get createAccountButton => 'Cipta akaun';

  @override
  String get continueButton => 'Teruskan';

  @override
  String get enterPhoneNumber => 'Masukkan nombor telefon';

  @override
  String get passwordMinLength =>
      'Kata laluan mestilah sekurang-kurangnya 6 aksara';

  @override
  String get fillOwnerSalonAddress =>
      'Isikan nama pemilik, nama salun, dan alamat';

  @override
  String get turnOnLocationPermission =>
      'Hidupkan lokasi dan benarkan akses untuk menggunakan ini';

  @override
  String get couldNotGetLocation => 'Tidak dapat memperoleh lokasi anda';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Telefon ini sudah didaftarkan. Sila log masuk sebagai gantinya.';

  @override
  String get signupFailedCheckBackend =>
      'Pendaftaran gagal. Semak sambungan pelayan.';

  @override
  String get signupFailedTryAgain => 'Pendaftaran gagal. Sila cuba lagi.';

  @override
  String get yourSalon => 'Salun anda';

  @override
  String get salonDetailsSubtitle => 'Langkah 2 daripada 3 · Butiran salun';

  @override
  String get ownerNameLabel => 'Nama pemilik';

  @override
  String get salonNameLabel => 'Nama salun';

  @override
  String get salonAddressLabel => 'Alamat salun';

  @override
  String get locationSet => 'Lokasi ditetapkan';

  @override
  String get useMyCurrentLocation => 'Gunakan lokasi semasa saya';

  @override
  String get pickYourColor => 'Pilih warna anda';

  @override
  String get colorPreviewHelp =>
      'Ini ialah warna aksen salun anda di seluruh apl. Tukar pada bila-bila masa dalam Akaun.';

  @override
  String get previewLabel => 'Pratonton';

  @override
  String get newBooking => 'Tempahan baharu';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorTerracotta => 'Terracotta';

  @override
  String get colorBlue => 'Biru';

  @override
  String get colorViolet => 'Ungu';

  @override
  String get colorRose => 'Merah jambu';

  @override
  String get welcomeBack => 'Selamat kembali';

  @override
  String get signInToDashboard => 'Log masuk ke papan pemuka salun anda';

  @override
  String get enterSalonOwnerPhone => 'Masukkan telefon pemilik salun';

  @override
  String get enterYourPassword => 'Masukkan kata laluan anda';

  @override
  String get noSalonOwnerFound =>
      'Tiada akaun pemilik salun ditemui untuk telefon ini.';

  @override
  String get loginFailedCheckBackend =>
      'Log masuk gagal. Semak sambungan pelayan.';

  @override
  String get loginFailedTryAgain => 'Log masuk gagal. Sila cuba lagi.';

  @override
  String get hidePassword => 'Sembunyikan kata laluan';

  @override
  String get showPassword => 'Tunjukkan kata laluan';

  @override
  String get signIn => 'Log masuk';

  @override
  String get newHere => 'Baharu di sini?';

  @override
  String get createAccount => 'Cipta akaun';

  @override
  String get forgotPassword => 'Lupa kata laluan?';

  @override
  String get resetPasswordTitle => 'Tetapkan semula kata laluan';

  @override
  String get resetPasswordEnterPhone =>
      'Masukkan nombor telefon anda dan kami akan menghantar kod 6-digit melalui WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Hantar kod melalui WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Jika akaun itu wujud, kod telah dihantar melalui WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Masukkan kod yang kami hantar melalui WhatsApp, kemudian pilih kata laluan baharu.';

  @override
  String get otpCodeLabel => 'Kod 6-digit';

  @override
  String get resetPasswordButton => 'Tetapkan semula kata laluan';

  @override
  String get resendCode => 'Hantar semula kod';

  @override
  String get changePhoneNumber => 'Tukar nombor telefon';

  @override
  String get enterSixDigitCode => 'Masukkan kod 6-digit';

  @override
  String get passwordsDoNotMatch => 'Kata laluan tidak sepadan';

  @override
  String get passwordResetSuccess =>
      'Kata laluan ditetapkan semula. Sila log masuk dengan kata laluan baharu.';

  @override
  String get waitBeforeRetryingCode =>
      'Sila tunggu seminit sebelum meminta kod lain';

  @override
  String get invalidOrExpiredCode => 'Kod itu tidak sah atau telah luput';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Terlalu banyak percubaan — minta kod baharu';

  @override
  String get continueWithGoogle => 'Teruskan dengan Google';

  @override
  String get signedInWithGoogle => 'Log masuk dengan Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Log masuk dengan Google sebagai $email';
  }

  @override
  String get usePasswordInstead => 'Gunakan kata laluan sebaliknya';

  @override
  String get googleSignInNotConfigured => 'Log masuk Google belum disediakan';

  @override
  String get googleSignInFailed => 'Log masuk Google gagal. Sila cuba lagi.';

  @override
  String get googleNoAccountFound =>
      'Tiada akaun ditemui untuk akaun Google itu. Cipta satu dahulu.';

  @override
  String get linkGoogleAccount => 'Pautkan akaun Google';

  @override
  String get googleAccountLinked =>
      'Akaun Google dipautkan — kini anda boleh log masuk dengannya';

  @override
  String get addStaffBeforeBookings =>
      'Tambah kakitangan aktif sebelum membuat tempahan';

  @override
  String get salonLabel => 'Salun';

  @override
  String get statToday => 'Hari ini';

  @override
  String get statRepeat => 'Berulang';

  @override
  String get statLoggedHelper => 'direkodkan';

  @override
  String get statBackHelper => 'kembali';

  @override
  String get statWeek => 'Minggu';

  @override
  String get statMonth => 'Bulan';

  @override
  String get loggedTodayHeading => 'Direkodkan hari ini';

  @override
  String get nothingLoggedToday =>
      'Belum ada yang direkodkan hari ini. Ketik \"Tempahan baharu\" apabila perkhidmatan selesai.';

  @override
  String get navHome => 'Utama';

  @override
  String get navBookings => 'Tempahan';

  @override
  String get navStaff => 'Kakitangan';

  @override
  String get navInsights => 'Cerapan';

  @override
  String get navAccount => 'Akaun';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked => 'Belum ada salun dipautkan ke akaun pemilik ini.';

  @override
  String get bookingsTitle => 'Tempahan';

  @override
  String get searchCustomerOrService => 'Cari pelanggan atau perkhidmatan';

  @override
  String get filterThisWeek => 'Minggu ini';

  @override
  String get filterAllTime => 'Sepanjang masa';

  @override
  String get filterAllStaff => 'Semua kakitangan';

  @override
  String get staffLabel => 'Kakitangan';

  @override
  String get needsActionHeading => 'Memerlukan tindakan';

  @override
  String get statTotal => 'Jumlah';

  @override
  String get statServices => 'Perkhidmatan';

  @override
  String get statAvgTicket => 'Purata bil';

  @override
  String get noBookingsMatchFilter =>
      'Tiada tempahan sepadan dengan penapis ini';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Semalam';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count perkhidmatan';
  }

  @override
  String get couldNotOpenStore => 'Tidak dapat membuka kedai';

  @override
  String get updateRequired => 'Kemas kini diperlukan';

  @override
  String get updateRequiredBody =>
      'Versi baharu apl tersedia. Sila kemas kini untuk terus menggunakan papan pemuka salun anda.';

  @override
  String get updateNow => 'Kemas kini sekarang';

  @override
  String get themeColorTitle => 'Warna tema';

  @override
  String get save => 'Simpan';

  @override
  String get staffTitle => 'Kakitangan';

  @override
  String get addStaff => 'Tambah kakitangan';

  @override
  String get statActive => 'Aktif';

  @override
  String get statTodaysTotal => 'Jumlah hari ini';

  @override
  String get noActiveStaffYet => 'Belum ada kakitangan aktif';

  @override
  String get addFirstStaff => 'Tambah kakitangan pertama';

  @override
  String get noServicesYet => 'Belum ada perkhidmatan';

  @override
  String get notActive => 'Tidak aktif';

  @override
  String get canSetOwnPrice => 'Boleh menetapkan harga sendiri';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count perkhidmatan · $revenue';
  }

  @override
  String get newLabel => 'Baharu';

  @override
  String get serviceLabel => 'Perkhidmatan';

  @override
  String get customerLabel => 'Pelanggan';

  @override
  String get repeatLabel => 'Berulang';

  @override
  String get couldNotUpdateBooking =>
      'Tidak dapat mengemas kini tempahan. Sila cuba lagi.';

  @override
  String get couldNotAcceptReschedule =>
      'Tidak dapat menerima penjadualan semula. Sila cuba lagi.';

  @override
  String get couldNotRejectReschedule =>
      'Tidak dapat menolak penjadualan semula. Sila cuba lagi.';

  @override
  String get rescheduleLabel => 'Jadual semula';

  @override
  String get pendingLabel => 'Belum selesai';

  @override
  String get scheduledLabel => 'Dijadualkan';

  @override
  String get inProgressLabel => 'Sedang berlangsung';

  @override
  String get startBookingButton => 'Mula';

  @override
  String get doneBookingButton => 'Selesai';

  @override
  String get todayScheduleHeading => 'Jadual hari ini';

  @override
  String get paymentMethodLabel => 'Pembayaran';

  @override
  String get paymentMethodCash => 'Tunai';

  @override
  String get paymentMethodCard => 'Kad';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'Tempah semula';

  @override
  String get couldNotLoadCustomerProfile =>
      'Profil pelanggan tidak dapat dimuatkan';

  @override
  String get notesSaved => 'Nota disimpan';

  @override
  String get couldNotSaveNotes => 'Nota tidak dapat disimpan. Cuba lagi.';

  @override
  String get statsVisitsLabel => 'Lawatan';

  @override
  String get statsTotalSpentLabel => 'Jumlah perbelanjaan';

  @override
  String lastServiceSummary(String service, String date) {
    return 'Terakhir: $service pada $date';
  }

  @override
  String get notesLabel => 'Nota';

  @override
  String get notesHint => 'Keutamaan, alahan, apa-apa yang patut diingati';

  @override
  String get tagsLabel => 'Tag';

  @override
  String get addTagHint => 'Tambah tag';

  @override
  String get saveNotesButton => 'Simpan nota';

  @override
  String get visitHistoryHeading => 'Sejarah lawatan';

  @override
  String get noVisitsYet => 'Belum ada lawatan';

  @override
  String get viewProfileTooltip => 'Lihat profil';

  @override
  String get dailyRevenueGoalLabel => 'Sasaran pendapatan harian';

  @override
  String get dailyRevenueGoalHint =>
      'Pilihan — biarkan kosong untuk menyembunyikan bar kemajuan di Utama';

  @override
  String get payoutsTooltip => 'Bayaran';

  @override
  String get staffActiveLabel => 'Aktif';

  @override
  String get canCancelBookingLabel => 'Boleh batalkan tempahan';

  @override
  String get couldNotLoadPayouts => 'Bayaran tidak dapat dimuatkan';

  @override
  String get payoutSettled => 'Bayaran direkodkan';

  @override
  String get couldNotMarkPaid =>
      'Tidak dapat menandakan sebagai dibayar. Cuba lagi.';

  @override
  String get payoutsTitle => 'Pendapatan & bayaran';

  @override
  String get unpaidLabel => 'Belum dibayar';

  @override
  String get markAsPaidButton => 'Tandakan sebagai dibayar';

  @override
  String get grossRevenueLabel => 'Pendapatan';

  @override
  String get totalPayoutLabel => 'Bayaran';

  @override
  String get payoutHistoryHeading => 'Sejarah bayaran';

  @override
  String get noPayoutsYet => 'Belum ada bayaran';

  @override
  String get payTypeLabel => 'Jenis gaji';

  @override
  String get payTypeCommission => 'Komisen';

  @override
  String get payTypeSalary => 'Gaji';

  @override
  String get payTypeBoth => 'Kedua-duanya';

  @override
  String get commissionRateLabel => 'Komisen %';

  @override
  String get monthlySalaryLabel => 'Gaji bulanan';

  @override
  String get couldNotSavePayType =>
      'Tetapan gaji tidak dapat disimpan. Cuba lagi.';

  @override
  String get salaryThisMonthLabel => 'Gaji bulan ini';

  @override
  String get salaryPaidStatus => 'Dibayar';

  @override
  String get paySalaryButton => 'Bayar gaji';

  @override
  String get salaryPaid => 'Gaji dibayar';

  @override
  String get couldNotPaySalary => 'Gaji tidak dapat dibayar. Cuba lagi.';

  @override
  String get searchStaffHint => 'Cari staf';

  @override
  String get filterActiveStaff => 'Aktif';

  @override
  String get filterInactiveStaff => 'Tidak aktif';

  @override
  String get switchBranchTitle => 'Tukar cawangan';

  @override
  String get switchLabel => 'Tukar cawangan';

  @override
  String get allBranchesLabel => 'Semua cawangan';

  @override
  String get allBranchesSubtitle => 'Jumlah gabungan semua cawangan';

  @override
  String get pickBranchFirst => 'Pilih cawangan tertentu dahulu';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count direkodkan · $revenue · $staff staf';
  }

  @override
  String get dayOffLabel => 'Cuti';

  @override
  String get addBranchButton => 'Tambah cawangan';

  @override
  String get addBranchTitle => 'Tambah cawangan';

  @override
  String get branchNameAddressRequired => 'Nama dan alamat cawangan diperlukan';

  @override
  String get couldNotAddBranch => 'Cawangan tidak dapat ditambah. Cuba lagi.';

  @override
  String get fillProductFields => 'Sila isi semua medan produk dengan betul';

  @override
  String get couldNotSaveProduct => 'Produk tidak dapat disimpan. Cuba lagi.';

  @override
  String get editProductTitle => 'Edit produk';

  @override
  String get addProductTitle => 'Tambah produk';

  @override
  String get productNameLabel => 'Nama produk';

  @override
  String get skuLabel => 'SKU (pilihan)';

  @override
  String get stockQtyLabel => 'Stok';

  @override
  String get lowStockThresholdLabel => 'Had stok rendah';

  @override
  String get deleteProductButton => 'Padam produk';

  @override
  String get productsTitle => 'Produk';

  @override
  String get searchProductsHint => 'Cari produk';

  @override
  String get filterLowStock => 'Stok rendah';

  @override
  String get noLowStockProducts => 'Tiada produk berstok rendah';

  @override
  String get noProductsInCatalog => 'Belum ada produk';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dalam stok',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'Stok rendah';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produk berstok rendah',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'Hari ini';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count temu janji direkodkan',
      zero: 'Belum ada temu janji direkodkan',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$current daripada sasaran $goal';
  }

  @override
  String get worthReachingOutHeading => 'Wajar dihubungi hari ini';

  @override
  String get exportCsvTooltip => 'Eksport CSV';

  @override
  String get couldNotExportEarnings =>
      'Pendapatan tidak dapat dieksport. Cuba lagi.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'lewat $days hari',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer bersama $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Pelanggan meminta $time';
  }

  @override
  String get reject => 'Tolak';

  @override
  String get accept => 'Terima';

  @override
  String get confirm => 'Sahkan';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count lagi';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Tidak dapat memuatkan butiran akaun';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Isikan pemilik, telefon, nama salun, dan alamat';

  @override
  String get accountUpdated => 'Akaun dikemas kini';

  @override
  String get phoneOrEmailUsed => 'Telefon atau e-mel sudah digunakan';

  @override
  String get couldNotSaveAccount => 'Tidak dapat menyimpan butiran akaun';

  @override
  String get newPasswordMinLength =>
      'Kata laluan baharu mestilah sekurang-kurangnya 6 aksara';

  @override
  String get newPasswordsDontMatch => 'Kata laluan baharu tidak sepadan';

  @override
  String get passwordChanged => 'Kata laluan ditukar';

  @override
  String get currentPasswordIncorrect => 'Kata laluan semasa tidak betul';

  @override
  String get couldNotChangePassword => 'Tidak dapat menukar kata laluan';

  @override
  String get countryAndCurrency => 'Negara dan mata wang';

  @override
  String get accountTitle => 'Akaun';

  @override
  String ownerSinceDate(String date) {
    return 'Pemilik sejak $date';
  }

  @override
  String planLabel(String plan) {
    return 'Pelan $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Cerapan pengekalan percuma selama 6 bulan';

  @override
  String get upgrade => 'Naik taraf';

  @override
  String get appearance => 'Penampilan';

  @override
  String get salonProfile => 'Profil salun';

  @override
  String get emailLabel => 'E-mel';

  @override
  String get locationUpdated => 'Lokasi dikemas kini';

  @override
  String get saveDetailsButton => 'Simpan butiran';

  @override
  String get savingEllipsis => 'Menyimpan...';

  @override
  String get security => 'Keselamatan';

  @override
  String get currentPasswordLabel => 'Kata laluan semasa';

  @override
  String get newPasswordLabel => 'Kata laluan baharu';

  @override
  String get confirmNewPasswordLabel => 'Sahkan kata laluan baharu';

  @override
  String get changePasswordButton => 'Tukar kata laluan';

  @override
  String get changingEllipsis => 'Menukar...';

  @override
  String get signOut => 'Log keluar';

  @override
  String get enterServiceNamePrice => 'Masukkan nama dan harga perkhidmatan';

  @override
  String get fillStaffNamePhone => 'Isikan nama dan telefon kakitangan';

  @override
  String get addAtLeastOneService =>
      'Tambah sekurang-kurangnya satu perkhidmatan';

  @override
  String get enterValidOpenCloseTimes =>
      'Masukkan waktu buka dan tutup yang sah (HH:MM, 24-jam)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Pilih sekurang-kurangnya satu hari bekerja';

  @override
  String get staffPhoneInUse => 'Telefon kakitangan itu sudah digunakan';

  @override
  String get couldNotAddStaff =>
      'Tidak dapat menambah kakitangan. Sila cuba lagi.';

  @override
  String get addStaffSubtitle =>
      'Sediakan profil, perkhidmatan, dan hari bekerja mereka.';

  @override
  String get staffNameLabel => 'Nama kakitangan';

  @override
  String get staffPhoneLabel => 'Telefon kakitangan';

  @override
  String get servicesLabel => 'Perkhidmatan';

  @override
  String servicesAddedCount(int count) {
    return '$count ditambah';
  }

  @override
  String get workingHours => 'Waktu bekerja';

  @override
  String get opens => 'Buka';

  @override
  String get closes => 'Tutup';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Hari bekerja';

  @override
  String get serviceNameHint => 'Nama perkhidmatan';

  @override
  String get priceHint => 'Harga';

  @override
  String get dayMon => 'Isn';

  @override
  String get dayTue => 'Sel';

  @override
  String get dayWed => 'Rab';

  @override
  String get dayThu => 'Kha';

  @override
  String get dayFri => 'Jum';

  @override
  String get daySat => 'Sab';

  @override
  String get daySun => 'Ahd';

  @override
  String get enterValidStaffNamePhone =>
      'Masukkan nama dan telefon kakitangan yang sah';

  @override
  String get staffDetailsSaved => 'Butiran kakitangan disimpan';

  @override
  String get phoneAlreadyInUse => 'Telefon itu sudah digunakan';

  @override
  String get couldNotUpdateStaff => 'Tidak dapat mengemas kini kakitangan';

  @override
  String get enterServiceNameAndPriceShort =>
      'Masukkan nama dan harga perkhidmatan';

  @override
  String get couldNotAddService => 'Tidak dapat menambah perkhidmatan';

  @override
  String get editServiceTitle => 'Edit perkhidmatan';

  @override
  String get enterValidServiceNamePrice =>
      'Masukkan nama dan harga perkhidmatan yang sah';

  @override
  String get couldNotUpdateService => 'Tidak dapat mengemas kini perkhidmatan';

  @override
  String get saveServiceButton => 'Simpan perkhidmatan';

  @override
  String get couldNotRemoveServiceDefault =>
      'Tidak dapat mengeluarkan perkhidmatan';

  @override
  String get useHHmmWorkingHours => 'Gunakan HH:mm untuk waktu bekerja';

  @override
  String get hoursAdded => 'Waktu ditambah';

  @override
  String get couldNotAddWorkingHours => 'Tidak dapat menambah waktu bekerja';

  @override
  String get couldNotRemoveTiming => 'Tidak dapat mengeluarkan waktu';

  @override
  String get manageStaffTitle => 'Urus kakitangan';

  @override
  String get done => 'Selesai';

  @override
  String get manageStaffSubtitle =>
      'Tambah, edit, atau keluarkan perkhidmatan dan waktu, kemudian ketik Selesai.';

  @override
  String get saveStaffButton => 'Simpan kakitangan';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Padam';

  @override
  String get newServiceLabel => 'Perkhidmatan baharu';

  @override
  String get addingEllipsis => 'Menambah...';

  @override
  String get addServiceButton => 'Tambah perkhidmatan';

  @override
  String get noTimingsYet => 'Belum ada waktu';

  @override
  String get removeLabel => 'Keluarkan';

  @override
  String get startLabel => 'Mula';

  @override
  String get endLabel => 'Tamat';

  @override
  String get addMonSatHoursButton => 'Tambah waktu Isn-Sab';

  @override
  String get saveHoursButton => 'Simpan waktu';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate =>
      'Pilih kakitangan, perkhidmatan, dan tarikh';

  @override
  String get noSlotsForDate => 'Tiada slot tersedia untuk tarikh ini.';

  @override
  String get couldNotLoadSlots => 'Tidak dapat memuatkan slot';

  @override
  String get enterCustomerName => 'Masukkan nama pelanggan';

  @override
  String get chooseStaffAndService =>
      'Pilih kakitangan dan sekurang-kurangnya satu perkhidmatan';

  @override
  String get enterCustomerPhone => 'Masukkan telefon pelanggan';

  @override
  String get chooseAvailableSlot => 'Pilih slot yang tersedia';

  @override
  String get couldNotCreateBooking =>
      'Tidak dapat membuat tempahan. Sila cuba lagi.';

  @override
  String get doneServiceOption => 'Perkhidmatan selesai';

  @override
  String get scheduleLaterOption => 'Jadualkan kemudian';

  @override
  String get customerNameLabel => 'Nama pelanggan';

  @override
  String get customerPhoneLabel => 'Telefon pelanggan';

  @override
  String recordedNowDate(String date) {
    return 'Direkodkan sekarang — $date';
  }

  @override
  String get dateLabel => 'Tarikh';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'Slot tersedia';

  @override
  String get cancel => 'Batal';

  @override
  String get saveBooking => 'Simpan tempahan';

  @override
  String saveBookingWithTotal(String total) {
    return 'Simpan tempahan · $total';
  }

  @override
  String get addServiceTitle => 'Tambah perkhidmatan';

  @override
  String get serviceNameLabel => 'Nama perkhidmatan';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get priceLabel => 'Harga';

  @override
  String get durationMinutesLabel => 'Tempoh (minit)';

  @override
  String get deleteServiceButton => 'Padam perkhidmatan';

  @override
  String get fillServiceFields => 'Masukkan nama, kategori, harga, dan tempoh';

  @override
  String get couldNotSaveService => 'Perkhidmatan tidak dapat disimpan';

  @override
  String get noServicesInCatalog =>
      'Belum ada perkhidmatan. Tambah yang pertama.';

  @override
  String get searchServicesHint => 'Cari perkhidmatan';

  @override
  String get filterAllCategories => 'Semua';

  @override
  String get assignToStaffLabel => 'Tetapkan kepada staf';

  @override
  String get anyStaffOption => 'Mana-mana staf';

  @override
  String get addStarterServicesButton => 'Tambah perkhidmatan biasa';

  @override
  String get bookingLinkSectionTitle => 'Pautan tempahan';

  @override
  String get bookingLinkSectionSubtitle =>
      'Kongsi pautan atau kod QR ini supaya pelanggan boleh menempah dalam talian';

  @override
  String get copyLinkButton => 'Salin';

  @override
  String get shareLinkButton => 'Kongsi';

  @override
  String get linkCopied => 'Pautan disalin';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return 'Tempah di $salonName: $link';
  }
}
