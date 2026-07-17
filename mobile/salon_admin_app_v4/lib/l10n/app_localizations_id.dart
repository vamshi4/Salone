// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get insightsTitle => 'Wawasan';

  @override
  String get tabEarnings => 'Pendapatan';

  @override
  String get tabRetention => 'Retensi';

  @override
  String get periodToday => 'Hari ini';

  @override
  String get periodWeek => 'Minggu';

  @override
  String get periodMonth => 'Bulan';

  @override
  String get periodLast7Days => '7 hari terakhir';

  @override
  String get periodLast30Days => '30 hari terakhir';

  @override
  String get earningsLoadError => 'Pendapatan tidak dapat dimuat.';

  @override
  String get retry => 'Coba lagi';

  @override
  String completedServicesCount(int count) {
    return '$count layanan';
  }

  @override
  String get completedServicesHeading => 'Layanan selesai';

  @override
  String get noCompletedServices =>
      'Belum ada layanan selesai pada periode ini.';

  @override
  String get topServicesHeading => 'Layanan teratas';

  @override
  String get byStaffHeading => 'Berdasarkan staf';

  @override
  String get vsYesterday => 'vs kemarin';

  @override
  String get vsLastWeek => 'vs minggu lalu';

  @override
  String get vsLastMonth => 'vs bulan lalu';

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
  String get retentionLoadError => 'Laporan retensi tidak dapat dimuat.';

  @override
  String get couldNotOpenWhatsapp => 'WhatsApp tidak dapat dibuka';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Hai $name! Kami merindukanmu di $salonName. Pesan kunjungan berikutnya dan nikmati penawaran selamat datang kembali. Sampai jumpa!';
  }

  @override
  String get customerCohortsHeading => 'Kelompok pelanggan';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count pelanggan';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Tidak ada pelanggan $label pada periode ini.';
  }

  @override
  String get missedCustomersHeading => 'Pelanggan yang terlewat';

  @override
  String get missedCustomersHint =>
      'Ketuk \"Ingatkan\" untuk mengirim pesan WhatsApp.';

  @override
  String get noMissedCustomers =>
      'Tidak ada pelanggan yang terlewat bulan ini.';

  @override
  String get cohortRegulars => 'Pelanggan tetap';

  @override
  String get cohortNew => 'Baru';

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
    return '$count pelanggan tetap mulai jarang datang · $revenue berisiko';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× terlambat';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Biasanya setiap $cadence hari · terlambat $overdue hari';
  }

  @override
  String get remind => 'Ingatkan';

  @override
  String get remindOnWhatsappTooltip => 'Ingatkan lewat WhatsApp';

  @override
  String get retentionProTitle => 'Wawasan retensi adalah fitur PRO';

  @override
  String get retentionProBody =>
      'Lihat siapa yang berhenti datang, rasio pelanggan baru vs kembali, dan dapatkan kembali pelanggan yang hilang dengan pengingat sekali ketuk.';

  @override
  String get upgradeToPro => 'Tingkatkan ke PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits kunjungan · dibelanjakan $spend';
  }

  @override
  String get createYourAccount => 'Buat akunmu';

  @override
  String get basics => 'Dasar-dasar';

  @override
  String get country => 'Negara';

  @override
  String get countryHelperText =>
      'Menentukan mata uang, format telepon, dan bahasa default.';

  @override
  String get language => 'Bahasa';

  @override
  String get phoneNumberLabel => 'Nomor telepon';

  @override
  String get passwordLabel => 'Kata sandi';

  @override
  String stepOfTotal(int step, int total) {
    return 'Langkah $step dari $total';
  }

  @override
  String get createAccountButton => 'Buat akun';

  @override
  String get continueButton => 'Lanjutkan';

  @override
  String get enterPhoneNumber => 'Masukkan nomor telepon';

  @override
  String get passwordMinLength => 'Kata sandi harus minimal 6 karakter';

  @override
  String get fillOwnerSalonAddress =>
      'Isi nama pemilik, nama salon, dan alamat';

  @override
  String get turnOnLocationPermission =>
      'Aktifkan lokasi dan izinkan akses untuk menggunakan ini';

  @override
  String get couldNotGetLocation => 'Lokasi tidak dapat ditemukan';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Nomor telepon ini sudah terdaftar. Silakan masuk.';

  @override
  String get signupFailedCheckBackend =>
      'Pendaftaran gagal. Periksa koneksi server.';

  @override
  String get signupFailedTryAgain => 'Pendaftaran gagal. Coba lagi.';

  @override
  String get yourSalon => 'Salonmu';

  @override
  String get salonDetailsSubtitle => 'Langkah 2 dari 3 · Detail salon';

  @override
  String get ownerNameLabel => 'Nama pemilik';

  @override
  String get salonNameLabel => 'Nama salon';

  @override
  String get salonAddressLabel => 'Alamat salon';

  @override
  String get locationSet => 'Lokasi ditetapkan';

  @override
  String get useMyCurrentLocation => 'Gunakan lokasi saat ini';

  @override
  String get pickYourColor => 'Pilih warnamu';

  @override
  String get colorPreviewHelp =>
      'Ini adalah warna aksen salonmu di seluruh aplikasi. Ubah kapan saja di Akun.';

  @override
  String get previewLabel => 'Pratinjau';

  @override
  String get newBooking => 'Pemesanan baru';

  @override
  String get colorTeal => 'Toska';

  @override
  String get colorTerracotta => 'Terakota';

  @override
  String get colorBlue => 'Biru';

  @override
  String get colorViolet => 'Ungu';

  @override
  String get colorRose => 'Merah muda';

  @override
  String get welcomeBack => 'Selamat datang kembali';

  @override
  String get signInToDashboard => 'Masuk ke dasbor salonmu';

  @override
  String get enterSalonOwnerPhone => 'Masukkan nomor telepon pemilik salon';

  @override
  String get enterYourPassword => 'Masukkan kata sandimu';

  @override
  String get noSalonOwnerFound =>
      'Tidak ditemukan akun pemilik salon untuk nomor ini.';

  @override
  String get loginFailedCheckBackend => 'Masuk gagal. Periksa koneksi server.';

  @override
  String get loginFailedTryAgain => 'Masuk gagal. Coba lagi.';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get signIn => 'Masuk';

  @override
  String get newHere => 'Baru di sini?';

  @override
  String get createAccount => 'Buat akun';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get resetPasswordTitle => 'Atur ulang kata sandi';

  @override
  String get resetPasswordEnterPhone =>
      'Masukkan nomor teleponmu, kami akan mengirim kode 6 digit lewat WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Kirim kode lewat WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Jika akun itu ada, kode telah dikirim lewat WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Masukkan kode yang kami kirim lewat WhatsApp, lalu pilih kata sandi baru.';

  @override
  String get otpCodeLabel => 'Kode 6 digit';

  @override
  String get resetPasswordButton => 'Atur ulang kata sandi';

  @override
  String get resendCode => 'Kirim ulang kode';

  @override
  String get changePhoneNumber => 'Ubah nomor telepon';

  @override
  String get enterSixDigitCode => 'Masukkan kode 6 digit';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get passwordResetSuccess =>
      'Kata sandi diatur ulang. Silakan masuk dengan kata sandi baru.';

  @override
  String get waitBeforeRetryingCode =>
      'Tunggu satu menit sebelum meminta kode lain';

  @override
  String get invalidOrExpiredCode =>
      'Kode itu tidak valid atau sudah kedaluwarsa';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Terlalu banyak percobaan — minta kode baru';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get signedInWithGoogle => 'Masuk dengan Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Masuk dengan Google sebagai $email';
  }

  @override
  String get usePasswordInstead => 'Gunakan kata sandi saja';

  @override
  String get googleSignInNotConfigured => 'Masuk dengan Google belum diatur';

  @override
  String get googleSignInFailed => 'Masuk dengan Google gagal. Coba lagi.';

  @override
  String get googleNoAccountFound =>
      'Tidak ditemukan akun untuk akun Google itu. Buat akun terlebih dahulu.';

  @override
  String get linkGoogleAccount => 'Tautkan akun Google';

  @override
  String get googleAccountLinked =>
      'Akun Google tertaut — sekarang kamu bisa masuk dengannya';

  @override
  String get addStaffBeforeBookings =>
      'Tambahkan staf aktif sebelum membuat pemesanan';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Hari ini';

  @override
  String get statRepeat => 'Berulang';

  @override
  String get statLoggedHelper => 'tercatat';

  @override
  String get statBackHelper => 'kembali';

  @override
  String get statWeek => 'Minggu';

  @override
  String get statMonth => 'Bulan';

  @override
  String get loggedTodayHeading => 'Tercatat hari ini';

  @override
  String get nothingLoggedToday =>
      'Belum ada yang tercatat hari ini. Ketuk \"Pemesanan baru\" setelah layanan selesai.';

  @override
  String get navHome => 'Beranda';

  @override
  String get navBookings => 'Pemesanan';

  @override
  String get navStaff => 'Staf';

  @override
  String get navInsights => 'Wawasan';

  @override
  String get navAccount => 'Akun';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Belum ada salon yang terhubung ke akun pemilik ini.';

  @override
  String get bookingsTitle => 'Pemesanan';

  @override
  String get searchCustomerOrService => 'Cari pelanggan atau layanan';

  @override
  String get filterThisWeek => 'Minggu ini';

  @override
  String get filterAllTime => 'Semua waktu';

  @override
  String get filterAllStaff => 'Semua staf';

  @override
  String get staffLabel => 'Staf';

  @override
  String get needsActionHeading => 'Perlu tindakan';

  @override
  String get statTotal => 'Total';

  @override
  String get statServices => 'Layanan';

  @override
  String get statAvgTicket => 'Rata-rata transaksi';

  @override
  String get noBookingsMatchFilter =>
      'Tidak ada pemesanan yang cocok dengan filter ini';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count layanan';
  }

  @override
  String get couldNotOpenStore => 'Toko tidak dapat dibuka';

  @override
  String get updateRequired => 'Pembaruan diperlukan';

  @override
  String get updateRequiredBody =>
      'Versi baru aplikasi tersedia. Perbarui untuk terus menggunakan dasbor salonmu.';

  @override
  String get updateNow => 'Perbarui sekarang';

  @override
  String get themeColorTitle => 'Warna tema';

  @override
  String get save => 'Simpan';

  @override
  String get staffTitle => 'Staf';

  @override
  String get addStaff => 'Tambah staf';

  @override
  String get statActive => 'Aktif';

  @override
  String get statTodaysTotal => 'Total hari ini';

  @override
  String get noActiveStaffYet => 'Belum ada staf aktif';

  @override
  String get addFirstStaff => 'Tambah staf pertama';

  @override
  String get noServicesYet => 'Belum ada layanan';

  @override
  String get notActive => 'Tidak aktif';

  @override
  String get canSetOwnPrice => 'Dapat menetapkan harga sendiri';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count layanan · $revenue';
  }

  @override
  String get newLabel => 'Baru';

  @override
  String get serviceLabel => 'Layanan';

  @override
  String get customerLabel => 'Pelanggan';

  @override
  String get repeatLabel => 'Berulang';

  @override
  String get couldNotUpdateBooking =>
      'Pemesanan tidak dapat diperbarui. Coba lagi.';

  @override
  String get couldNotAcceptReschedule =>
      'Penjadwalan ulang tidak dapat diterima. Coba lagi.';

  @override
  String get couldNotRejectReschedule =>
      'Penjadwalan ulang tidak dapat ditolak. Coba lagi.';

  @override
  String get rescheduleLabel => 'Jadwal ulang';

  @override
  String get pendingLabel => 'Menunggu';

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
  String get confirm => 'Konfirmasi';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count lainnya';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Detail akun tidak dapat dimuat';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Isi pemilik, telepon, nama salon, dan alamat';

  @override
  String get accountUpdated => 'Akun diperbarui';

  @override
  String get phoneOrEmailUsed => 'Telepon atau email sudah digunakan';

  @override
  String get couldNotSaveAccount => 'Detail akun tidak dapat disimpan';

  @override
  String get newPasswordMinLength => 'Kata sandi baru harus minimal 6 karakter';

  @override
  String get newPasswordsDontMatch => 'Kata sandi baru tidak cocok';

  @override
  String get passwordChanged => 'Kata sandi diubah';

  @override
  String get currentPasswordIncorrect => 'Kata sandi saat ini salah';

  @override
  String get couldNotChangePassword => 'Kata sandi tidak dapat diubah';

  @override
  String get countryAndCurrency => 'Negara dan mata uang';

  @override
  String get accountTitle => 'Akun';

  @override
  String ownerSinceDate(String date) {
    return 'Pemilik sejak $date';
  }

  @override
  String planLabel(String plan) {
    return 'Paket $plan';
  }

  @override
  String get retentionFreeFor6Months => 'Wawasan retensi gratis selama 6 bulan';

  @override
  String get upgrade => 'Tingkatkan';

  @override
  String get appearance => 'Tampilan';

  @override
  String get salonProfile => 'Profil salon';

  @override
  String get emailLabel => 'Email';

  @override
  String get locationUpdated => 'Lokasi diperbarui';

  @override
  String get saveDetailsButton => 'Simpan detail';

  @override
  String get savingEllipsis => 'Menyimpan...';

  @override
  String get security => 'Keamanan';

  @override
  String get currentPasswordLabel => 'Kata sandi saat ini';

  @override
  String get newPasswordLabel => 'Kata sandi baru';

  @override
  String get confirmNewPasswordLabel => 'Konfirmasi kata sandi baru';

  @override
  String get changePasswordButton => 'Ubah kata sandi';

  @override
  String get changingEllipsis => 'Mengubah...';

  @override
  String get signOut => 'Keluar';

  @override
  String get enterServiceNamePrice => 'Masukkan nama dan harga layanan';

  @override
  String get fillStaffNamePhone => 'Isi nama dan telepon staf';

  @override
  String get addAtLeastOneService => 'Tambahkan setidaknya satu layanan';

  @override
  String get enterValidOpenCloseTimes =>
      'Masukkan waktu buka dan tutup yang valid (JJ:MM, 24 jam)';

  @override
  String get selectAtLeastOneWorkingDay => 'Pilih setidaknya satu hari kerja';

  @override
  String get staffPhoneInUse => 'Nomor telepon staf itu sudah digunakan';

  @override
  String get couldNotAddStaff => 'Staf tidak dapat ditambahkan. Coba lagi.';

  @override
  String get addStaffSubtitle => 'Atur profil, layanan, dan hari kerja mereka.';

  @override
  String get staffNameLabel => 'Nama staf';

  @override
  String get staffPhoneLabel => 'Telepon staf';

  @override
  String get servicesLabel => 'Layanan';

  @override
  String servicesAddedCount(int count) {
    return '$count ditambahkan';
  }

  @override
  String get workingHours => 'Jam kerja';

  @override
  String get opens => 'Buka';

  @override
  String get closes => 'Tutup';

  @override
  String get hhmmHint => 'JJ:MM';

  @override
  String get workingDays => 'Hari kerja';

  @override
  String get serviceNameHint => 'Nama layanan';

  @override
  String get priceHint => 'Harga';

  @override
  String get dayMon => 'Sen';

  @override
  String get dayTue => 'Sel';

  @override
  String get dayWed => 'Rab';

  @override
  String get dayThu => 'Kam';

  @override
  String get dayFri => 'Jum';

  @override
  String get daySat => 'Sab';

  @override
  String get daySun => 'Min';

  @override
  String get enterValidStaffNamePhone =>
      'Masukkan nama dan telepon staf yang valid';

  @override
  String get staffDetailsSaved => 'Detail staf disimpan';

  @override
  String get phoneAlreadyInUse => 'Telepon itu sudah digunakan';

  @override
  String get couldNotUpdateStaff => 'Staf tidak dapat diperbarui';

  @override
  String get enterServiceNameAndPriceShort => 'Masukkan nama dan harga layanan';

  @override
  String get couldNotAddService => 'Layanan tidak dapat ditambahkan';

  @override
  String get editServiceTitle => 'Edit layanan';

  @override
  String get enterValidServiceNamePrice =>
      'Masukkan nama dan harga layanan yang valid';

  @override
  String get couldNotUpdateService => 'Layanan tidak dapat diperbarui';

  @override
  String get saveServiceButton => 'Simpan layanan';

  @override
  String get couldNotRemoveServiceDefault => 'Layanan tidak dapat dihapus';

  @override
  String get useHHmmWorkingHours => 'Gunakan JJ:mm untuk jam kerja';

  @override
  String get hoursAdded => 'Jam ditambahkan';

  @override
  String get couldNotAddWorkingHours => 'Jam kerja tidak dapat ditambahkan';

  @override
  String get couldNotRemoveTiming => 'Waktu tidak dapat dihapus';

  @override
  String get manageStaffTitle => 'Kelola staf';

  @override
  String get done => 'Selesai';

  @override
  String get manageStaffSubtitle =>
      'Tambah, edit, atau hapus layanan dan jam kerja, lalu ketuk Selesai.';

  @override
  String get saveStaffButton => 'Simpan staf';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Hapus';

  @override
  String get newServiceLabel => 'Layanan baru';

  @override
  String get addingEllipsis => 'Menambahkan...';

  @override
  String get addServiceButton => 'Tambah layanan';

  @override
  String get noTimingsYet => 'Belum ada jadwal';

  @override
  String get removeLabel => 'Hapus';

  @override
  String get startLabel => 'Mulai';

  @override
  String get endLabel => 'Selesai';

  @override
  String get addMonSatHoursButton => 'Tambah jam Sen-Sab';

  @override
  String get saveHoursButton => 'Simpan jam';

  @override
  String get hhmmLowerHint => 'JJ:mm';

  @override
  String get chooseStaffServiceDate => 'Pilih staf, layanan, dan tanggal';

  @override
  String get noSlotsForDate => 'Tidak ada slot tersedia untuk tanggal ini.';

  @override
  String get couldNotLoadSlots => 'Slot tidak dapat dimuat';

  @override
  String get enterCustomerName => 'Masukkan nama pelanggan';

  @override
  String get chooseStaffAndService => 'Pilih staf dan setidaknya satu layanan';

  @override
  String get enterCustomerPhone => 'Masukkan telepon pelanggan';

  @override
  String get chooseAvailableSlot => 'Pilih slot yang tersedia';

  @override
  String get couldNotCreateBooking =>
      'Pemesanan tidak dapat dibuat. Coba lagi.';

  @override
  String get doneServiceOption => 'Layanan selesai';

  @override
  String get scheduleLaterOption => 'Jadwalkan nanti';

  @override
  String get customerNameLabel => 'Nama pelanggan';

  @override
  String get customerPhoneLabel => 'Telepon pelanggan';

  @override
  String recordedNowDate(String date) {
    return 'Dicatat sekarang — $date';
  }

  @override
  String get dateLabel => 'Tanggal';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'Slot tersedia';

  @override
  String get cancel => 'Batal';

  @override
  String get saveBooking => 'Simpan pemesanan';

  @override
  String saveBookingWithTotal(String total) {
    return 'Simpan pemesanan · $total';
  }

  @override
  String get addServiceTitle => 'Tambah layanan';

  @override
  String get serviceNameLabel => 'Nama layanan';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get priceLabel => 'Harga';

  @override
  String get durationMinutesLabel => 'Durasi (menit)';

  @override
  String get deleteServiceButton => 'Hapus layanan';

  @override
  String get fillServiceFields => 'Masukkan nama, kategori, harga, dan durasi';

  @override
  String get couldNotSaveService => 'Layanan tidak dapat disimpan';

  @override
  String get noServicesInCatalog =>
      'Belum ada layanan. Tambahkan yang pertama.';

  @override
  String get searchServicesHint => 'Cari layanan';

  @override
  String get filterAllCategories => 'Semua';

  @override
  String get assignToStaffLabel => 'Tetapkan ke staf';

  @override
  String get anyStaffOption => 'Staf mana pun';

  @override
  String get addStarterServicesButton => 'Tambah layanan umum';
}
