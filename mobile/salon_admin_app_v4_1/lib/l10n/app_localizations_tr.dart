// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get insightsTitle => 'İstatistikler';

  @override
  String get tabEarnings => 'Kazançlar';

  @override
  String get tabRetention => 'Müşteri Tutma';

  @override
  String get periodToday => 'Bugün';

  @override
  String get periodWeek => 'Hafta';

  @override
  String get periodMonth => 'Ay';

  @override
  String get periodLast7Days => 'Son 7 gün';

  @override
  String get periodLast30Days => 'Son 30 gün';

  @override
  String get earningsLoadError => 'Kazançlar yüklenemedi.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String completedServicesCount(int count) {
    return '$count hizmet';
  }

  @override
  String get completedServicesHeading => 'Tamamlanan hizmetler';

  @override
  String get noCompletedServices => 'Bu dönemde henüz tamamlanan hizmet yok.';

  @override
  String get topServicesHeading => 'En çok kazandıran hizmetler';

  @override
  String get byStaffHeading => 'Personele göre';

  @override
  String get vsYesterday => 'düne göre';

  @override
  String get vsLastWeek => 'geçen haftaya göre';

  @override
  String get vsLastMonth => 'geçen aya göre';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Geri kazandığınız müşteriler';

  @override
  String reactivatedSummary(int count) {
    return '$count müşteri bu ay geri döndü';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Müşteri tutma raporu yüklenemedi.';

  @override
  String get couldNotOpenWhatsapp => 'WhatsApp açılamadı';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Merhaba $name! $salonName olarak sizi özledik. Bir sonraki ziyaretinizi ayırtın ve özel hoş geldin teklifinin keyfini çıkarın. Yakında görüşürüz!';
  }

  @override
  String get customerCohortsHeading => 'Müşteri grupları';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count müşteri';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Bu dönemde $label müşteri yok.';
  }

  @override
  String get missedCustomersHeading => 'Kaçırılan müşteriler';

  @override
  String get missedCustomersHint =>
      'WhatsApp üzerinden mesaj göndermek için \"Hatırlat\"a dokunun.';

  @override
  String get noMissedCustomers => 'Bu ay kaçırılan müşteri yok.';

  @override
  String get cohortRegulars => 'Sadık müşteriler';

  @override
  String get cohortNew => 'Yeni';

  @override
  String get cohortCameBack => 'Geri döndü';

  @override
  String get cohortStoppedComing => 'Gelmeyi bıraktı';

  @override
  String get customersLabel => 'müşteri';

  @override
  String get reachOutNow => 'Şimdi ulaşın';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count sadık müşteri azalıyor · $revenue risk altında';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× gecikmiş';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Genellikle her $cadence günde bir · $overdue gün gecikmiş';
  }

  @override
  String get remind => 'Hatırlat';

  @override
  String get remindOnWhatsappTooltip => 'WhatsApp üzerinden hatırlat';

  @override
  String get retentionProTitle =>
      'Müşteri tutma istatistikleri bir PRO özelliğidir';

  @override
  String get retentionProBody =>
      'Kimin gelmeyi bıraktığını, yeni ile geri dönen müşteri oranınızı görün ve tek dokunuşla hatırlatmalarla kayıp müşterileri geri kazanın.';

  @override
  String get upgradeToPro => 'PRO\'ya yükselt';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits ziyaret · $spend harcandı';
  }

  @override
  String get createYourAccount => 'Hesabınızı oluşturun';

  @override
  String get basics => 'Temel bilgiler';

  @override
  String get country => 'Ülke';

  @override
  String get countryHelperText =>
      'Para biriminizi, telefon biçiminizi ve varsayılan dilinizi belirler.';

  @override
  String get language => 'Dil';

  @override
  String get phoneNumberLabel => 'Telefon numarası';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String stepOfTotal(int step, int total) {
    return 'Adım $step / $total';
  }

  @override
  String get createAccountButton => 'Hesap oluştur';

  @override
  String get continueButton => 'Devam et';

  @override
  String get enterPhoneNumber => 'Bir telefon numarası girin';

  @override
  String get passwordMinLength => 'Şifre en az 6 karakter olmalıdır';

  @override
  String get fillOwnerSalonAddress =>
      'Sahip adını, salon adını ve adresi doldurun';

  @override
  String get turnOnLocationPermission =>
      'Bunu kullanmak için konumu açın ve izin verin';

  @override
  String get couldNotGetLocation => 'Konumunuz alınamadı';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Bu telefon zaten kayıtlı. Lütfen giriş yapın.';

  @override
  String get signupFailedCheckBackend =>
      'Kayıt başarısız. Sunucu bağlantısını kontrol edin.';

  @override
  String get signupFailedTryAgain => 'Kayıt başarısız. Lütfen tekrar deneyin.';

  @override
  String get yourSalon => 'Salonunuz';

  @override
  String get salonDetailsSubtitle => 'Adım 2/3 · Salon detayları';

  @override
  String get ownerNameLabel => 'Sahip adı';

  @override
  String get salonNameLabel => 'Salon adı';

  @override
  String get salonAddressLabel => 'Salon adresi';

  @override
  String get locationSet => 'Konum ayarlandı';

  @override
  String get useMyCurrentLocation => 'Mevcut konumumu kullan';

  @override
  String get pickYourColor => 'Rengini seç';

  @override
  String get colorPreviewHelp =>
      'Bu, uygulama genelinde salonunuzun vurgu rengidir. İstediğiniz zaman Hesap\'tan değiştirin.';

  @override
  String get previewLabel => 'Önizleme';

  @override
  String get newBooking => 'Yeni randevu';

  @override
  String get colorTeal => 'Camgöbeği';

  @override
  String get colorTerracotta => 'Terrakota';

  @override
  String get colorBlue => 'Mavi';

  @override
  String get colorViolet => 'Menekşe';

  @override
  String get colorRose => 'Gül';

  @override
  String get welcomeBack => 'Tekrar hoş geldiniz';

  @override
  String get signInToDashboard => 'Salon panonuza giriş yapın';

  @override
  String get enterSalonOwnerPhone => 'Salon sahibinin telefonunu girin';

  @override
  String get enterYourPassword => 'Şifrenizi girin';

  @override
  String get noSalonOwnerFound =>
      'Bu telefon için salon sahibi hesabı bulunamadı.';

  @override
  String get loginFailedCheckBackend =>
      'Giriş başarısız. Sunucu bağlantısını kontrol edin.';

  @override
  String get loginFailedTryAgain => 'Giriş başarısız. Lütfen tekrar deneyin.';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get newHere => 'Yeni misiniz?';

  @override
  String get createAccount => 'Hesap oluştur';

  @override
  String get forgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get resetPasswordTitle => 'Şifreyi sıfırla';

  @override
  String get resetPasswordEnterPhone =>
      'Telefon numaranızı girin, WhatsApp üzerinden 6 haneli bir kod göndereceğiz.';

  @override
  String get sendCodeViaWhatsApp => 'Kodu WhatsApp ile gönder';

  @override
  String get codeSentViaWhatsApp =>
      'Bu hesap varsa, WhatsApp üzerinden bir kod gönderildi.';

  @override
  String get resetPasswordEnterCode =>
      'WhatsApp\'ta gönderdiğimiz kodu girin, ardından yeni bir şifre seçin.';

  @override
  String get otpCodeLabel => '6 haneli kod';

  @override
  String get resetPasswordButton => 'Şifreyi sıfırla';

  @override
  String get resendCode => 'Kodu yeniden gönder';

  @override
  String get changePhoneNumber => 'Telefon numarasını değiştir';

  @override
  String get enterSixDigitCode => '6 haneli kodu girin';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get passwordResetSuccess =>
      'Şifre sıfırlandı. Lütfen yeni şifrenizle giriş yapın.';

  @override
  String get waitBeforeRetryingCode =>
      'Başka bir kod istemeden önce bir dakika bekleyin';

  @override
  String get invalidOrExpiredCode => 'Bu kod geçersiz veya süresi dolmuş';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Çok fazla deneme — yeni bir kod isteyin';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get signedInWithGoogle => 'Google ile giriş yapıldı';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Google ile $email olarak giriş yapıldı';
  }

  @override
  String get usePasswordInstead => 'Bunun yerine şifre kullan';

  @override
  String get googleSignInNotConfigured => 'Google ile giriş henüz ayarlanmadı';

  @override
  String get googleSignInFailed =>
      'Google ile giriş başarısız. Lütfen tekrar deneyin.';

  @override
  String get googleNoAccountFound =>
      'Bu Google hesabı için bir hesap bulunamadı. Önce bir hesap oluşturun.';

  @override
  String get linkGoogleAccount => 'Google hesabını bağla';

  @override
  String get googleAccountLinked =>
      'Google hesabı bağlandı — artık onunla giriş yapabilirsiniz';

  @override
  String get addStaffBeforeBookings =>
      'Randevu oluşturmadan önce aktif personel ekleyin';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Bugün';

  @override
  String get statRepeat => 'Tekrar';

  @override
  String get statLoggedHelper => 'kaydedildi';

  @override
  String get statBackHelper => 'geri döndü';

  @override
  String get statWeek => 'Hafta';

  @override
  String get statMonth => 'Ay';

  @override
  String get loggedTodayHeading => 'Bugün kaydedilenler';

  @override
  String get nothingLoggedToday =>
      'Bugün henüz bir şey kaydedilmedi. Bir hizmet tamamlanınca \"Yeni randevu\"ya dokunun.';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navBookings => 'Randevular';

  @override
  String get navStaff => 'Personel';

  @override
  String get navInsights => 'İstatistikler';

  @override
  String get navAccount => 'Hesap';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked => 'Bu sahip hesabına henüz bağlı bir salon yok.';

  @override
  String get bookingsTitle => 'Randevular';

  @override
  String get searchCustomerOrService => 'Müşteri veya hizmet ara';

  @override
  String get filterThisWeek => 'Bu hafta';

  @override
  String get filterAllTime => 'Tüm zamanlar';

  @override
  String get filterAllStaff => 'Tüm personel';

  @override
  String get staffLabel => 'Personel';

  @override
  String get needsActionHeading => 'İşlem gerekli';

  @override
  String get statTotal => 'Toplam';

  @override
  String get statServices => 'Hizmetler';

  @override
  String get statAvgTicket => 'Ort. fiş tutarı';

  @override
  String get noBookingsMatchFilter => 'Bu filtreyle eşleşen randevu yok';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count hizmet';
  }

  @override
  String get couldNotOpenStore => 'Mağaza açılamadı';

  @override
  String get updateRequired => 'Güncelleme gerekli';

  @override
  String get updateRequiredBody =>
      'Uygulamanın yeni bir sürümü mevcut. Salon panonuzu kullanmaya devam etmek için lütfen güncelleyin.';

  @override
  String get updateNow => 'Şimdi güncelle';

  @override
  String get themeColorTitle => 'Tema rengi';

  @override
  String get save => 'Kaydet';

  @override
  String get staffTitle => 'Personel';

  @override
  String get addStaff => 'Personel ekle';

  @override
  String get statActive => 'Aktif';

  @override
  String get statTodaysTotal => 'Bugünkü toplam';

  @override
  String get noActiveStaffYet => 'Henüz aktif personel yok';

  @override
  String get addFirstStaff => 'İlk personeli ekle';

  @override
  String get noServicesYet => 'Henüz hizmet yok';

  @override
  String get notActive => 'Aktif değil';

  @override
  String get canSetOwnPrice => 'Kendi fiyatını belirleyebilir';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count hizmet · $revenue';
  }

  @override
  String get newLabel => 'Yeni';

  @override
  String get serviceLabel => 'Hizmet';

  @override
  String get customerLabel => 'Müşteri';

  @override
  String get repeatLabel => 'Tekrar';

  @override
  String get couldNotUpdateBooking =>
      'Randevu güncellenemedi. Lütfen tekrar deneyin.';

  @override
  String get couldNotAcceptReschedule =>
      'Yeniden planlama kabul edilemedi. Lütfen tekrar deneyin.';

  @override
  String get couldNotRejectReschedule =>
      'Yeniden planlama reddedilemedi. Lütfen tekrar deneyin.';

  @override
  String get rescheduleLabel => 'Yeniden planla';

  @override
  String get pendingLabel => 'Beklemede';

  @override
  String get scheduledLabel => 'Planlandı';

  @override
  String get inProgressLabel => 'Devam ediyor';

  @override
  String get startBookingButton => 'Başlat';

  @override
  String get doneBookingButton => 'Tamamlandı';

  @override
  String get todayScheduleHeading => 'Bugünkü program';

  @override
  String get paymentMethodLabel => 'Ödeme';

  @override
  String get paymentMethodCash => 'Nakit';

  @override
  String get paymentMethodCard => 'Kart';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'Tekrar rezervasyon yap';

  @override
  String get couldNotLoadCustomerProfile => 'Müşteri profili yüklenemedi';

  @override
  String get notesSaved => 'Notlar kaydedildi';

  @override
  String get couldNotSaveNotes => 'Notlar kaydedilemedi. Tekrar deneyin.';

  @override
  String get statsVisitsLabel => 'Ziyaretler';

  @override
  String get statsTotalSpentLabel => 'Toplam harcama';

  @override
  String lastServiceSummary(String service, String date) {
    return 'Son: $service, $date';
  }

  @override
  String get notesLabel => 'Notlar';

  @override
  String get notesHint => 'Tercihler, alerjiler, hatırlanmaya değer her şey';

  @override
  String get tagsLabel => 'Etiketler';

  @override
  String get addTagHint => 'Etiket ekle';

  @override
  String get saveNotesButton => 'Notları kaydet';

  @override
  String get visitHistoryHeading => 'Ziyaret geçmişi';

  @override
  String get noVisitsYet => 'Henüz ziyaret yok';

  @override
  String get viewProfileTooltip => 'Profili görüntüle';

  @override
  String get dailyRevenueGoalLabel => 'Günlük gelir hedefi';

  @override
  String get dailyRevenueGoalHint =>
      'İsteğe bağlı — Ana sayfadaki ilerleme çubuğunu gizlemek için boş bırakın';

  @override
  String get payoutsTooltip => 'Ödemeler';

  @override
  String get staffActiveLabel => 'Aktif';

  @override
  String get canCancelBookingLabel => 'Rezervasyonları iptal edebilir';

  @override
  String get couldNotLoadPayouts => 'Ödemeler yüklenemedi';

  @override
  String get payoutSettled => 'Ödeme kaydedildi';

  @override
  String get couldNotMarkPaid =>
      'Ödendi olarak işaretlenemedi. Tekrar deneyin.';

  @override
  String get payoutsTitle => 'Kazançlar ve ödemeler';

  @override
  String get unpaidLabel => 'Ödenmedi';

  @override
  String get markAsPaidButton => 'Ödendi olarak işaretle';

  @override
  String get grossRevenueLabel => 'Gelir';

  @override
  String get totalPayoutLabel => 'Ödeme';

  @override
  String get payoutHistoryHeading => 'Ödeme geçmişi';

  @override
  String get noPayoutsYet => 'Henüz ödeme yok';

  @override
  String get payTypeLabel => 'Ücret türü';

  @override
  String get payTypeCommission => 'Komisyon';

  @override
  String get payTypeSalary => 'Maaş';

  @override
  String get payTypeBoth => 'İkisi de';

  @override
  String get commissionRateLabel => 'Komisyon %';

  @override
  String get monthlySalaryLabel => 'Aylık maaş';

  @override
  String get couldNotSavePayType =>
      'Ücret ayarları kaydedilemedi. Tekrar deneyin.';

  @override
  String get salaryThisMonthLabel => 'Bu ayın maaşı';

  @override
  String get salaryPaidStatus => 'Ödendi';

  @override
  String get paySalaryButton => 'Maaş öde';

  @override
  String get salaryPaid => 'Maaş ödendi';

  @override
  String get couldNotPaySalary => 'Maaş ödenemedi. Tekrar deneyin.';

  @override
  String get searchStaffHint => 'Personel ara';

  @override
  String get filterActiveStaff => 'Aktif';

  @override
  String get filterInactiveStaff => 'Pasif';

  @override
  String get switchBranchTitle => 'Şube değiştir';

  @override
  String get switchLabel => 'Şube değiştir';

  @override
  String get allBranchesLabel => 'Tüm şubeler';

  @override
  String get allBranchesSubtitle => 'Tüm şubelerin birleşik toplamları';

  @override
  String get pickBranchFirst => 'Önce belirli bir şube seçin';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count kaydedildi · $revenue · $staff personel';
  }

  @override
  String get dayOffLabel => 'İzinli';

  @override
  String get addBranchButton => 'Şube ekle';

  @override
  String get addBranchTitle => 'Şube ekle';

  @override
  String get branchNameAddressRequired => 'Şube adı ve adresi gereklidir';

  @override
  String get couldNotAddBranch => 'Şube eklenemedi. Tekrar deneyin.';

  @override
  String get fillProductFields => 'Lütfen tüm ürün alanlarını doğru doldurun';

  @override
  String get couldNotSaveProduct => 'Ürün kaydedilemedi. Tekrar deneyin.';

  @override
  String get editProductTitle => 'Ürünü düzenle';

  @override
  String get addProductTitle => 'Ürün ekle';

  @override
  String get productNameLabel => 'Ürün adı';

  @override
  String get skuLabel => 'SKU (isteğe bağlı)';

  @override
  String get stockQtyLabel => 'Stok';

  @override
  String get lowStockThresholdLabel => 'Düşük stok eşiği';

  @override
  String get deleteProductButton => 'Ürünü sil';

  @override
  String get productsTitle => 'Ürünler';

  @override
  String get searchProductsHint => 'Ürün ara';

  @override
  String get filterLowStock => 'Düşük stok';

  @override
  String get noLowStockProducts => 'Düşük stoklu ürün yok';

  @override
  String get noProductsInCatalog => 'Henüz ürün yok';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stokta',
      one: '1 stokta',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'Düşük stok';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ürünün stoğu az',
      one: '1 ürünün stoğu az',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'Bugün';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count randevu kaydedildi',
      one: '1 randevu kaydedildi',
      zero: 'Henüz randevu kaydedilmedi',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$goal hedefinden $current';
  }

  @override
  String get worthReachingOutHeading => 'Bugün iletişime geçmeye değer';

  @override
  String get exportCsvTooltip => 'CSV dışa aktar';

  @override
  String get couldNotExportEarnings =>
      'Kazançlar dışa aktarılamadı. Tekrar deneyin.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün gecikme',
      one: '1 gün gecikme',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer · $stylist ile';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Müşteri $time talep etti';
  }

  @override
  String get reject => 'Reddet';

  @override
  String get accept => 'Kabul et';

  @override
  String get confirm => 'Onayla';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count daha';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Hesap bilgileri yüklenemedi';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Sahip, telefon, salon adı ve adresi doldurun';

  @override
  String get accountUpdated => 'Hesap güncellendi';

  @override
  String get phoneOrEmailUsed => 'Telefon veya e-posta zaten kullanımda';

  @override
  String get couldNotSaveAccount => 'Hesap bilgileri kaydedilemedi';

  @override
  String get newPasswordMinLength => 'Yeni şifre en az 6 karakter olmalıdır';

  @override
  String get newPasswordsDontMatch => 'Yeni şifreler eşleşmiyor';

  @override
  String get passwordChanged => 'Şifre değiştirildi';

  @override
  String get currentPasswordIncorrect => 'Mevcut şifre yanlış';

  @override
  String get couldNotChangePassword => 'Şifre değiştirilemedi';

  @override
  String get countryAndCurrency => 'Ülke ve para birimi';

  @override
  String get accountTitle => 'Hesap';

  @override
  String ownerSinceDate(String date) {
    return '$date tarihinden beri sahip';
  }

  @override
  String planLabel(String plan) {
    return '$plan planı';
  }

  @override
  String get retentionFreeFor6Months =>
      'Müşteri tutma istatistikleri 6 ay ücretsiz';

  @override
  String get upgrade => 'Yükselt';

  @override
  String get appearance => 'Görünüm';

  @override
  String get salonProfile => 'Salon profili';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get locationUpdated => 'Konum güncellendi';

  @override
  String get saveDetailsButton => 'Detayları kaydet';

  @override
  String get savingEllipsis => 'Kaydediliyor...';

  @override
  String get security => 'Güvenlik';

  @override
  String get currentPasswordLabel => 'Mevcut şifre';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get confirmNewPasswordLabel => 'Yeni şifreyi onayla';

  @override
  String get changePasswordButton => 'Şifreyi değiştir';

  @override
  String get changingEllipsis => 'Değiştiriliyor...';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get enterServiceNamePrice => 'Hizmet adı ve fiyatı girin';

  @override
  String get fillStaffNamePhone => 'Personel adı ve telefonunu doldurun';

  @override
  String get addAtLeastOneService => 'En az bir hizmet ekleyin';

  @override
  String get enterValidOpenCloseTimes =>
      'Geçerli açılış ve kapanış saatlerini girin (SS:DD, 24 saat)';

  @override
  String get selectAtLeastOneWorkingDay => 'En az bir çalışma günü seçin';

  @override
  String get staffPhoneInUse => 'Bu personel telefonu zaten kullanımda';

  @override
  String get couldNotAddStaff => 'Personel eklenemedi. Lütfen tekrar deneyin.';

  @override
  String get addStaffSubtitle =>
      'Profilini, hizmetlerini ve çalışma günlerini ayarlayın.';

  @override
  String get staffNameLabel => 'Personel adı';

  @override
  String get staffPhoneLabel => 'Personel telefonu';

  @override
  String get servicesLabel => 'Hizmetler';

  @override
  String servicesAddedCount(int count) {
    return '$count eklendi';
  }

  @override
  String get workingHours => 'Çalışma saatleri';

  @override
  String get opens => 'Açılış';

  @override
  String get closes => 'Kapanış';

  @override
  String get hhmmHint => 'SS:DD';

  @override
  String get workingDays => 'Çalışma günleri';

  @override
  String get serviceNameHint => 'Hizmet adı';

  @override
  String get priceHint => 'Fiyat';

  @override
  String get dayMon => 'Pzt';

  @override
  String get dayTue => 'Sal';

  @override
  String get dayWed => 'Çar';

  @override
  String get dayThu => 'Per';

  @override
  String get dayFri => 'Cum';

  @override
  String get daySat => 'Cmt';

  @override
  String get daySun => 'Paz';

  @override
  String get enterValidStaffNamePhone =>
      'Geçerli personel adı ve telefonu girin';

  @override
  String get staffDetailsSaved => 'Personel bilgileri kaydedildi';

  @override
  String get phoneAlreadyInUse => 'Bu telefon zaten kullanımda';

  @override
  String get couldNotUpdateStaff => 'Personel güncellenemedi';

  @override
  String get enterServiceNameAndPriceShort => 'Hizmet adı ve fiyatı girin';

  @override
  String get couldNotAddService => 'Hizmet eklenemedi';

  @override
  String get editServiceTitle => 'Hizmeti düzenle';

  @override
  String get enterValidServiceNamePrice => 'Geçerli hizmet adı ve fiyatı girin';

  @override
  String get couldNotUpdateService => 'Hizmet güncellenemedi';

  @override
  String get saveServiceButton => 'Hizmeti kaydet';

  @override
  String get couldNotRemoveServiceDefault => 'Hizmet kaldırılamadı';

  @override
  String get useHHmmWorkingHours => 'Çalışma saatleri için SS:dd kullanın';

  @override
  String get hoursAdded => 'Saatler eklendi';

  @override
  String get couldNotAddWorkingHours => 'Çalışma saatleri eklenemedi';

  @override
  String get couldNotRemoveTiming => 'Zamanlama kaldırılamadı';

  @override
  String get manageStaffTitle => 'Personeli yönet';

  @override
  String get done => 'Tamam';

  @override
  String get manageStaffSubtitle =>
      'Hizmet ve saatleri ekleyin, düzenleyin veya kaldırın, sonra Tamam\'a dokunun.';

  @override
  String get saveStaffButton => 'Personeli kaydet';

  @override
  String get edit => 'Düzenle';

  @override
  String get delete => 'Sil';

  @override
  String get newServiceLabel => 'Yeni hizmet';

  @override
  String get addingEllipsis => 'Ekleniyor...';

  @override
  String get addServiceButton => 'Hizmet ekle';

  @override
  String get noTimingsYet => 'Henüz zamanlama yok';

  @override
  String get removeLabel => 'Kaldır';

  @override
  String get startLabel => 'Başlangıç';

  @override
  String get endLabel => 'Bitiş';

  @override
  String get addMonSatHoursButton => 'Pzt-Cmt saatlerini ekle';

  @override
  String get saveHoursButton => 'Saatleri kaydet';

  @override
  String get hhmmLowerHint => 'SS:dd';

  @override
  String get chooseStaffServiceDate => 'Personel, hizmet ve tarih seçin';

  @override
  String get noSlotsForDate => 'Bu tarih için uygun randevu yok.';

  @override
  String get couldNotLoadSlots => 'Randevu saatleri yüklenemedi';

  @override
  String get enterCustomerName => 'Müşteri adını girin';

  @override
  String get chooseStaffAndService => 'Personel ve en az bir hizmet seçin';

  @override
  String get enterCustomerPhone => 'Müşteri telefonunu girin';

  @override
  String get chooseAvailableSlot => 'Uygun bir saat seçin';

  @override
  String get couldNotCreateBooking =>
      'Randevu oluşturulamadı. Lütfen tekrar deneyin.';

  @override
  String get doneServiceOption => 'Hizmet tamamlandı';

  @override
  String get scheduleLaterOption => 'Sonra planla';

  @override
  String get customerNameLabel => 'Müşteri adı';

  @override
  String get customerPhoneLabel => 'Müşteri telefonu';

  @override
  String recordedNowDate(String date) {
    return 'Şimdi kaydedildi — $date';
  }

  @override
  String get dateLabel => 'Tarih';

  @override
  String get yyyymmddHint => 'YYYY-AA-GG';

  @override
  String get availableSlots => 'Uygun saatler';

  @override
  String get cancel => 'İptal';

  @override
  String get saveBooking => 'Randevuyu kaydet';

  @override
  String saveBookingWithTotal(String total) {
    return 'Randevuyu kaydet · $total';
  }

  @override
  String get addServiceTitle => 'Hizmet ekle';

  @override
  String get serviceNameLabel => 'Hizmet adı';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get priceLabel => 'Fiyat';

  @override
  String get durationMinutesLabel => 'Süre (dakika)';

  @override
  String get deleteServiceButton => 'Hizmeti sil';

  @override
  String get fillServiceFields => 'Ad, kategori, fiyat ve süre girin';

  @override
  String get couldNotSaveService => 'Hizmet kaydedilemedi';

  @override
  String get noServicesInCatalog => 'Henüz hizmet yok. İlkini ekleyin.';

  @override
  String get searchServicesHint => 'Hizmet ara';

  @override
  String get filterAllCategories => 'Tümü';

  @override
  String get assignToStaffLabel => 'Personele ata';

  @override
  String get anyStaffOption => 'Herhangi bir personel';

  @override
  String get addStarterServicesButton => 'Yaygın hizmetleri ekle';

  @override
  String get bookingLinkSectionTitle => 'Randevu bağlantısı';

  @override
  String get bookingLinkSectionSubtitle =>
      'Müşterilerin çevrimiçi randevu alabilmesi için bu bağlantıyı veya QR kodunu paylaşın';

  @override
  String get copyLinkButton => 'Kopyala';

  @override
  String get shareLinkButton => 'Paylaş';

  @override
  String get linkCopied => 'Bağlantı kopyalandı';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return '$salonName için randevu alın: $link';
  }
}
