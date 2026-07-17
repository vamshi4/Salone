// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get insightsTitle => 'Thông tin chi tiết';

  @override
  String get tabEarnings => 'Doanh thu';

  @override
  String get tabRetention => 'Giữ chân khách';

  @override
  String get periodToday => 'Hôm nay';

  @override
  String get periodWeek => 'Tuần';

  @override
  String get periodMonth => 'Tháng';

  @override
  String get periodLast7Days => '7 ngày qua';

  @override
  String get periodLast30Days => '30 ngày qua';

  @override
  String get earningsLoadError => 'Không thể tải doanh thu.';

  @override
  String get retry => 'Thử lại';

  @override
  String completedServicesCount(int count) {
    return '$count dịch vụ';
  }

  @override
  String get completedServicesHeading => 'Dịch vụ đã hoàn thành';

  @override
  String get noCompletedServices =>
      'Chưa có dịch vụ nào hoàn thành trong giai đoạn này.';

  @override
  String get topServicesHeading => 'Dịch vụ hàng đầu';

  @override
  String get byStaffHeading => 'Theo nhân viên';

  @override
  String get vsYesterday => 'so với hôm qua';

  @override
  String get vsLastWeek => 'so với tuần trước';

  @override
  String get vsLastMonth => 'so với tháng trước';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Khách hàng đã quay lại';

  @override
  String reactivatedSummary(int count) {
    return '$count khách hàng đã quay lại trong tháng này';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'Không thể tải báo cáo giữ chân khách.';

  @override
  String get couldNotOpenWhatsapp => 'Không thể mở WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Chào $name! Chúng tôi nhớ bạn tại $salonName. Hãy đặt lịch cho lần ghé thăm tiếp theo và tận hưởng ưu đãi chào mừng trở lại đặc biệt. Hẹn gặp lại sớm!';
  }

  @override
  String get customerCohortsHeading => 'Nhóm khách hàng';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count khách hàng';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Không có khách hàng $label trong giai đoạn này.';
  }

  @override
  String get missedCustomersHeading => 'Khách hàng bị bỏ lỡ';

  @override
  String get missedCustomersHint =>
      'Chạm \"Nhắc nhở\" để gửi tin nhắn cho họ qua WhatsApp.';

  @override
  String get noMissedCustomers => 'Không có khách hàng bị bỏ lỡ tháng này.';

  @override
  String get cohortRegulars => 'Khách quen';

  @override
  String get cohortNew => 'Mới';

  @override
  String get cohortCameBack => 'Đã quay lại';

  @override
  String get cohortStoppedComing => 'Ngừng đến';

  @override
  String get customersLabel => 'khách hàng';

  @override
  String get reachOutNow => 'Liên hệ ngay';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count khách quen đang giảm dần · $revenue có nguy cơ';
  }

  @override
  String overdueBadge(String ratio) {
    return 'trễ $ratio×';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Thường mỗi $cadence ngày · trễ $overdue ngày';
  }

  @override
  String get remind => 'Nhắc nhở';

  @override
  String get remindOnWhatsappTooltip => 'Nhắc nhở qua WhatsApp';

  @override
  String get retentionProTitle => 'Thông tin giữ chân khách là tính năng PRO';

  @override
  String get retentionProBody =>
      'Xem ai đã ngừng đến, tỷ lệ khách mới so với khách quay lại, và lấy lại khách hàng đã mất bằng lời nhắc chỉ với một chạm.';

  @override
  String get upgradeToPro => 'Nâng cấp lên PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits lượt ghé · đã chi $spend';
  }

  @override
  String get createYourAccount => 'Tạo tài khoản của bạn';

  @override
  String get basics => 'Thông tin cơ bản';

  @override
  String get country => 'Quốc gia';

  @override
  String get countryHelperText =>
      'Xác định tiền tệ, định dạng số điện thoại và ngôn ngữ mặc định của bạn.';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get phoneNumberLabel => 'Số điện thoại';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String stepOfTotal(int step, int total) {
    return 'Bước $step/$total';
  }

  @override
  String get createAccountButton => 'Tạo tài khoản';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get enterPhoneNumber => 'Nhập số điện thoại';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get fillOwnerSalonAddress =>
      'Điền tên chủ salon, tên salon và địa chỉ';

  @override
  String get turnOnLocationPermission =>
      'Bật vị trí và cho phép truy cập để sử dụng chức năng này';

  @override
  String get couldNotGetLocation => 'Không thể lấy vị trí của bạn';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Số điện thoại này đã được đăng ký. Vui lòng đăng nhập.';

  @override
  String get signupFailedCheckBackend =>
      'Đăng ký thất bại. Kiểm tra kết nối máy chủ.';

  @override
  String get signupFailedTryAgain => 'Đăng ký thất bại. Vui lòng thử lại.';

  @override
  String get yourSalon => 'Salon của bạn';

  @override
  String get salonDetailsSubtitle => 'Bước 2/3 · Chi tiết salon';

  @override
  String get ownerNameLabel => 'Tên chủ salon';

  @override
  String get salonNameLabel => 'Tên salon';

  @override
  String get salonAddressLabel => 'Địa chỉ salon';

  @override
  String get locationSet => 'Đã đặt vị trí';

  @override
  String get useMyCurrentLocation => 'Sử dụng vị trí hiện tại của tôi';

  @override
  String get pickYourColor => 'Chọn màu của bạn';

  @override
  String get colorPreviewHelp =>
      'Đây là màu nhấn của salon bạn trong toàn bộ ứng dụng. Thay đổi bất cứ lúc nào trong Tài khoản.';

  @override
  String get previewLabel => 'Xem trước';

  @override
  String get newBooking => 'Đặt lịch mới';

  @override
  String get colorTeal => 'Xanh lam ngọc';

  @override
  String get colorTerracotta => 'Đất nung';

  @override
  String get colorBlue => 'Xanh dương';

  @override
  String get colorViolet => 'Tím';

  @override
  String get colorRose => 'Hồng';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get signInToDashboard => 'Đăng nhập vào bảng điều khiển salon của bạn';

  @override
  String get enterSalonOwnerPhone => 'Nhập số điện thoại chủ salon';

  @override
  String get enterYourPassword => 'Nhập mật khẩu của bạn';

  @override
  String get noSalonOwnerFound =>
      'Không tìm thấy tài khoản chủ salon cho số điện thoại này.';

  @override
  String get loginFailedCheckBackend =>
      'Đăng nhập thất bại. Kiểm tra kết nối máy chủ.';

  @override
  String get loginFailedTryAgain => 'Đăng nhập thất bại. Vui lòng thử lại.';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get newHere => 'Mới ở đây?';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get resetPasswordTitle => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordEnterPhone =>
      'Nhập số điện thoại của bạn, chúng tôi sẽ gửi mã 6 chữ số qua WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Gửi mã qua WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Nếu tài khoản đó tồn tại, một mã đã được gửi qua WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Nhập mã chúng tôi đã gửi qua WhatsApp, sau đó chọn mật khẩu mới.';

  @override
  String get otpCodeLabel => 'Mã 6 chữ số';

  @override
  String get resetPasswordButton => 'Đặt lại mật khẩu';

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String get changePhoneNumber => 'Đổi số điện thoại';

  @override
  String get enterSixDigitCode => 'Nhập mã 6 chữ số';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get passwordResetSuccess =>
      'Đã đặt lại mật khẩu. Vui lòng đăng nhập bằng mật khẩu mới.';

  @override
  String get waitBeforeRetryingCode =>
      'Vui lòng đợi một phút trước khi yêu cầu mã khác';

  @override
  String get invalidOrExpiredCode => 'Mã đó không hợp lệ hoặc đã hết hạn';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Quá nhiều lần thử — yêu cầu mã mới';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get signedInWithGoogle => 'Đã đăng nhập bằng Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Đã đăng nhập bằng Google với tên $email';
  }

  @override
  String get usePasswordInstead => 'Dùng mật khẩu thay thế';

  @override
  String get googleSignInNotConfigured =>
      'Đăng nhập bằng Google chưa được thiết lập';

  @override
  String get googleSignInFailed =>
      'Đăng nhập bằng Google thất bại. Vui lòng thử lại.';

  @override
  String get googleNoAccountFound =>
      'Không tìm thấy tài khoản cho tài khoản Google đó. Hãy tạo một tài khoản trước.';

  @override
  String get linkGoogleAccount => 'Liên kết tài khoản Google';

  @override
  String get googleAccountLinked =>
      'Đã liên kết tài khoản Google — giờ bạn có thể đăng nhập bằng tài khoản đó';

  @override
  String get addStaffBeforeBookings =>
      'Thêm nhân viên đang hoạt động trước khi tạo đặt lịch';

  @override
  String get salonLabel => 'Salon';

  @override
  String get statToday => 'Hôm nay';

  @override
  String get statRepeat => 'Khách quay lại';

  @override
  String get statLoggedHelper => 'đã ghi nhận';

  @override
  String get statBackHelper => 'quay lại';

  @override
  String get statWeek => 'Tuần';

  @override
  String get statMonth => 'Tháng';

  @override
  String get loggedTodayHeading => 'Đã ghi nhận hôm nay';

  @override
  String get nothingLoggedToday =>
      'Chưa có gì được ghi nhận hôm nay. Chạm \"Đặt lịch mới\" khi hoàn thành dịch vụ.';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navBookings => 'Đặt lịch';

  @override
  String get navStaff => 'Nhân viên';

  @override
  String get navInsights => 'Thông tin';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Chưa có salon nào được liên kết với tài khoản chủ này.';

  @override
  String get bookingsTitle => 'Đặt lịch';

  @override
  String get searchCustomerOrService => 'Tìm khách hàng hoặc dịch vụ';

  @override
  String get filterThisWeek => 'Tuần này';

  @override
  String get filterAllTime => 'Mọi lúc';

  @override
  String get filterAllStaff => 'Tất cả nhân viên';

  @override
  String get staffLabel => 'Nhân viên';

  @override
  String get needsActionHeading => 'Cần xử lý';

  @override
  String get statTotal => 'Tổng cộng';

  @override
  String get statServices => 'Dịch vụ';

  @override
  String get statAvgTicket => 'Hóa đơn TB';

  @override
  String get noBookingsMatchFilter =>
      'Không có đặt lịch nào khớp với bộ lọc này';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String dayTotalServices(String total, int count) {
    return '$total · $count dịch vụ';
  }

  @override
  String get couldNotOpenStore => 'Không thể mở cửa hàng';

  @override
  String get updateRequired => 'Cần cập nhật';

  @override
  String get updateRequiredBody =>
      'Có phiên bản mới của ứng dụng. Vui lòng cập nhật để tiếp tục sử dụng bảng điều khiển salon của bạn.';

  @override
  String get updateNow => 'Cập nhật ngay';

  @override
  String get themeColorTitle => 'Màu chủ đề';

  @override
  String get save => 'Lưu';

  @override
  String get staffTitle => 'Nhân viên';

  @override
  String get addStaff => 'Thêm nhân viên';

  @override
  String get statActive => 'Đang hoạt động';

  @override
  String get statTodaysTotal => 'Tổng hôm nay';

  @override
  String get noActiveStaffYet => 'Chưa có nhân viên hoạt động';

  @override
  String get addFirstStaff => 'Thêm nhân viên đầu tiên';

  @override
  String get noServicesYet => 'Chưa có dịch vụ';

  @override
  String get notActive => 'Không hoạt động';

  @override
  String get canSetOwnPrice => 'Có thể tự đặt giá';

  @override
  String staffTodayTally(int count, String revenue) {
    return '$count dịch vụ · $revenue';
  }

  @override
  String get newLabel => 'Mới';

  @override
  String get serviceLabel => 'Dịch vụ';

  @override
  String get customerLabel => 'Khách hàng';

  @override
  String get repeatLabel => 'Quay lại';

  @override
  String get couldNotUpdateBooking =>
      'Không thể cập nhật đặt lịch. Vui lòng thử lại.';

  @override
  String get couldNotAcceptReschedule =>
      'Không thể chấp nhận đổi lịch. Vui lòng thử lại.';

  @override
  String get couldNotRejectReschedule =>
      'Không thể từ chối đổi lịch. Vui lòng thử lại.';

  @override
  String get rescheduleLabel => 'Đổi lịch';

  @override
  String get pendingLabel => 'Đang chờ';

  @override
  String get scheduledLabel => 'Đã lên lịch';

  @override
  String get inProgressLabel => 'Đang thực hiện';

  @override
  String get startBookingButton => 'Bắt đầu';

  @override
  String get doneBookingButton => 'Hoàn tất';

  @override
  String get todayScheduleHeading => 'Lịch hôm nay';

  @override
  String get paymentMethodLabel => 'Thanh toán';

  @override
  String get paymentMethodCash => 'Tiền mặt';

  @override
  String get paymentMethodCard => 'Thẻ';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get rebookAction => 'Đặt lại';

  @override
  String get couldNotLoadCustomerProfile => 'Không thể tải hồ sơ khách hàng';

  @override
  String get notesSaved => 'Đã lưu ghi chú';

  @override
  String get couldNotSaveNotes => 'Không thể lưu ghi chú. Vui lòng thử lại.';

  @override
  String get statsVisitsLabel => 'Lượt ghé';

  @override
  String get statsTotalSpentLabel => 'Tổng chi tiêu';

  @override
  String lastServiceSummary(String service, String date) {
    return 'Gần nhất: $service vào $date';
  }

  @override
  String get notesLabel => 'Ghi chú';

  @override
  String get notesHint => 'Sở thích, dị ứng, bất cứ điều gì đáng nhớ';

  @override
  String get tagsLabel => 'Thẻ';

  @override
  String get addTagHint => 'Thêm thẻ';

  @override
  String get saveNotesButton => 'Lưu ghi chú';

  @override
  String get visitHistoryHeading => 'Lịch sử ghé thăm';

  @override
  String get noVisitsYet => 'Chưa có lượt ghé nào';

  @override
  String get viewProfileTooltip => 'Xem hồ sơ';

  @override
  String get dailyRevenueGoalLabel => 'Mục tiêu doanh thu hằng ngày';

  @override
  String get dailyRevenueGoalHint =>
      'Không bắt buộc — để trống để ẩn thanh tiến độ trên Trang chủ';

  @override
  String get payoutsTooltip => 'Thanh toán';

  @override
  String get staffActiveLabel => 'Đang hoạt động';

  @override
  String get canCancelBookingLabel => 'Có thể hủy đặt lịch';

  @override
  String get couldNotLoadPayouts => 'Không thể tải các khoản thanh toán';

  @override
  String get payoutSettled => 'Đã ghi nhận thanh toán';

  @override
  String get couldNotMarkPaid =>
      'Không thể đánh dấu là đã thanh toán. Vui lòng thử lại.';

  @override
  String get payoutsTitle => 'Thu nhập & thanh toán';

  @override
  String get unpaidLabel => 'Chưa thanh toán';

  @override
  String get markAsPaidButton => 'Đánh dấu là đã thanh toán';

  @override
  String get grossRevenueLabel => 'Doanh thu';

  @override
  String get totalPayoutLabel => 'Thanh toán';

  @override
  String get payoutHistoryHeading => 'Lịch sử thanh toán';

  @override
  String get noPayoutsYet => 'Chưa có khoản thanh toán nào';

  @override
  String get payTypeLabel => 'Hình thức trả lương';

  @override
  String get payTypeCommission => 'Hoa hồng';

  @override
  String get payTypeSalary => 'Lương';

  @override
  String get payTypeBoth => 'Cả hai';

  @override
  String get commissionRateLabel => 'Hoa hồng %';

  @override
  String get monthlySalaryLabel => 'Lương hàng tháng';

  @override
  String get couldNotSavePayType =>
      'Không thể lưu cài đặt lương. Vui lòng thử lại.';

  @override
  String get salaryThisMonthLabel => 'Lương tháng này';

  @override
  String get salaryPaidStatus => 'Đã trả';

  @override
  String get paySalaryButton => 'Trả lương';

  @override
  String get salaryPaid => 'Đã trả lương';

  @override
  String get couldNotPaySalary => 'Không thể trả lương. Vui lòng thử lại.';

  @override
  String get searchStaffHint => 'Tìm nhân viên';

  @override
  String get filterActiveStaff => 'Đang hoạt động';

  @override
  String get filterInactiveStaff => 'Ngừng hoạt động';

  @override
  String get switchBranchTitle => 'Chuyển chi nhánh';

  @override
  String get switchLabel => 'Chuyển chi nhánh';

  @override
  String get allBranchesLabel => 'Tất cả chi nhánh';

  @override
  String get allBranchesSubtitle => 'Tổng hợp của tất cả chi nhánh';

  @override
  String get pickBranchFirst => 'Vui lòng chọn một chi nhánh cụ thể trước';

  @override
  String branchStatsLine(int count, String revenue, int staff) {
    return '$count đã ghi nhận · $revenue · $staff nhân viên';
  }

  @override
  String get dayOffLabel => 'Nghỉ';

  @override
  String get addBranchButton => 'Thêm chi nhánh';

  @override
  String get addBranchTitle => 'Thêm chi nhánh';

  @override
  String get branchNameAddressRequired => 'Cần có tên và địa chỉ chi nhánh';

  @override
  String get couldNotAddBranch => 'Không thể thêm chi nhánh. Vui lòng thử lại.';

  @override
  String get fillProductFields =>
      'Vui lòng điền đầy đủ và chính xác các trường sản phẩm';

  @override
  String get couldNotSaveProduct => 'Không thể lưu sản phẩm. Vui lòng thử lại.';

  @override
  String get editProductTitle => 'Chỉnh sửa sản phẩm';

  @override
  String get addProductTitle => 'Thêm sản phẩm';

  @override
  String get productNameLabel => 'Tên sản phẩm';

  @override
  String get skuLabel => 'SKU (không bắt buộc)';

  @override
  String get stockQtyLabel => 'Tồn kho';

  @override
  String get lowStockThresholdLabel => 'Ngưỡng tồn kho thấp';

  @override
  String get deleteProductButton => 'Xóa sản phẩm';

  @override
  String get productsTitle => 'Sản phẩm';

  @override
  String get searchProductsHint => 'Tìm sản phẩm';

  @override
  String get filterLowStock => 'Tồn kho thấp';

  @override
  String get noLowStockProducts => 'Không có sản phẩm nào tồn kho thấp';

  @override
  String get noProductsInCatalog => 'Chưa có sản phẩm nào';

  @override
  String stockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count',
    );
    return '$_temp0';
  }

  @override
  String get lowStockLabel => 'Tồn kho thấp';

  @override
  String lowStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sản phẩm tồn kho thấp',
    );
    return '$_temp0';
  }

  @override
  String get morningBriefingHeading => 'Hôm nay';

  @override
  String todaysAppointmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã ghi nhận $count lịch hẹn',
      zero: 'Chưa ghi nhận lịch hẹn nào',
    );
    return '$_temp0';
  }

  @override
  String revenueGoalPace(String current, String goal) {
    return '$current trên mục tiêu $goal';
  }

  @override
  String get worthReachingOutHeading => 'Đáng liên hệ hôm nay';

  @override
  String get exportCsvTooltip => 'Xuất CSV';

  @override
  String get couldNotExportEarnings =>
      'Không thể xuất thu nhập. Vui lòng thử lại.';

  @override
  String overdueDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Trễ $days ngày',
    );
    return '$_temp0';
  }

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer với $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Khách hàng yêu cầu $time';
  }

  @override
  String get reject => 'Từ chối';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get confirm => 'Xác nhận';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count khác';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount => 'Không thể tải chi tiết tài khoản';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Điền chủ salon, điện thoại, tên salon và địa chỉ';

  @override
  String get accountUpdated => 'Đã cập nhật tài khoản';

  @override
  String get phoneOrEmailUsed => 'Điện thoại hoặc email đã được sử dụng';

  @override
  String get couldNotSaveAccount => 'Không thể lưu chi tiết tài khoản';

  @override
  String get newPasswordMinLength => 'Mật khẩu mới phải có ít nhất 6 ký tự';

  @override
  String get newPasswordsDontMatch => 'Mật khẩu mới không khớp';

  @override
  String get passwordChanged => 'Đã đổi mật khẩu';

  @override
  String get currentPasswordIncorrect => 'Mật khẩu hiện tại không đúng';

  @override
  String get couldNotChangePassword => 'Không thể đổi mật khẩu';

  @override
  String get countryAndCurrency => 'Quốc gia và tiền tệ';

  @override
  String get accountTitle => 'Tài khoản';

  @override
  String ownerSinceDate(String date) {
    return 'Chủ sở hữu từ $date';
  }

  @override
  String planLabel(String plan) {
    return 'Gói $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Thông tin giữ chân khách miễn phí trong 6 tháng';

  @override
  String get upgrade => 'Nâng cấp';

  @override
  String get appearance => 'Giao diện';

  @override
  String get salonProfile => 'Hồ sơ salon';

  @override
  String get emailLabel => 'Email';

  @override
  String get locationUpdated => 'Đã cập nhật vị trí';

  @override
  String get saveDetailsButton => 'Lưu chi tiết';

  @override
  String get savingEllipsis => 'Đang lưu...';

  @override
  String get security => 'Bảo mật';

  @override
  String get currentPasswordLabel => 'Mật khẩu hiện tại';

  @override
  String get newPasswordLabel => 'Mật khẩu mới';

  @override
  String get confirmNewPasswordLabel => 'Xác nhận mật khẩu mới';

  @override
  String get changePasswordButton => 'Đổi mật khẩu';

  @override
  String get changingEllipsis => 'Đang đổi...';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get enterServiceNamePrice => 'Nhập tên và giá dịch vụ';

  @override
  String get fillStaffNamePhone => 'Điền tên và điện thoại nhân viên';

  @override
  String get addAtLeastOneService => 'Thêm ít nhất một dịch vụ';

  @override
  String get enterValidOpenCloseTimes =>
      'Nhập giờ mở và đóng cửa hợp lệ (HH:MM, 24 giờ)';

  @override
  String get selectAtLeastOneWorkingDay => 'Chọn ít nhất một ngày làm việc';

  @override
  String get staffPhoneInUse => 'Số điện thoại nhân viên đó đã được sử dụng';

  @override
  String get couldNotAddStaff => 'Không thể thêm nhân viên. Vui lòng thử lại.';

  @override
  String get addStaffSubtitle =>
      'Thiết lập hồ sơ, dịch vụ và ngày làm việc của họ.';

  @override
  String get staffNameLabel => 'Tên nhân viên';

  @override
  String get staffPhoneLabel => 'Điện thoại nhân viên';

  @override
  String get servicesLabel => 'Dịch vụ';

  @override
  String servicesAddedCount(int count) {
    return 'Đã thêm $count';
  }

  @override
  String get workingHours => 'Giờ làm việc';

  @override
  String get opens => 'Mở cửa';

  @override
  String get closes => 'Đóng cửa';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Ngày làm việc';

  @override
  String get serviceNameHint => 'Tên dịch vụ';

  @override
  String get priceHint => 'Giá';

  @override
  String get dayMon => 'T2';

  @override
  String get dayTue => 'T3';

  @override
  String get dayWed => 'T4';

  @override
  String get dayThu => 'T5';

  @override
  String get dayFri => 'T6';

  @override
  String get daySat => 'T7';

  @override
  String get daySun => 'CN';

  @override
  String get enterValidStaffNamePhone =>
      'Nhập tên và điện thoại nhân viên hợp lệ';

  @override
  String get staffDetailsSaved => 'Đã lưu chi tiết nhân viên';

  @override
  String get phoneAlreadyInUse => 'Điện thoại đó đã được sử dụng';

  @override
  String get couldNotUpdateStaff => 'Không thể cập nhật nhân viên';

  @override
  String get enterServiceNameAndPriceShort => 'Nhập tên và giá dịch vụ';

  @override
  String get couldNotAddService => 'Không thể thêm dịch vụ';

  @override
  String get editServiceTitle => 'Sửa dịch vụ';

  @override
  String get enterValidServiceNamePrice => 'Nhập tên và giá dịch vụ hợp lệ';

  @override
  String get couldNotUpdateService => 'Không thể cập nhật dịch vụ';

  @override
  String get saveServiceButton => 'Lưu dịch vụ';

  @override
  String get couldNotRemoveServiceDefault => 'Không thể xóa dịch vụ';

  @override
  String get useHHmmWorkingHours => 'Sử dụng HH:mm cho giờ làm việc';

  @override
  String get hoursAdded => 'Đã thêm giờ';

  @override
  String get couldNotAddWorkingHours => 'Không thể thêm giờ làm việc';

  @override
  String get couldNotRemoveTiming => 'Không thể xóa thời gian';

  @override
  String get manageStaffTitle => 'Quản lý nhân viên';

  @override
  String get done => 'Xong';

  @override
  String get manageStaffSubtitle =>
      'Thêm, chỉnh sửa hoặc xóa dịch vụ và giờ làm việc, sau đó chạm Xong.';

  @override
  String get saveStaffButton => 'Lưu nhân viên';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get delete => 'Xóa';

  @override
  String get newServiceLabel => 'Dịch vụ mới';

  @override
  String get addingEllipsis => 'Đang thêm...';

  @override
  String get addServiceButton => 'Thêm dịch vụ';

  @override
  String get noTimingsYet => 'Chưa có lịch';

  @override
  String get removeLabel => 'Xóa';

  @override
  String get startLabel => 'Bắt đầu';

  @override
  String get endLabel => 'Kết thúc';

  @override
  String get addMonSatHoursButton => 'Thêm giờ T2-T7';

  @override
  String get saveHoursButton => 'Lưu giờ';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Chọn nhân viên, dịch vụ và ngày';

  @override
  String get noSlotsForDate => 'Không có khung giờ trống cho ngày này.';

  @override
  String get couldNotLoadSlots => 'Không thể tải khung giờ';

  @override
  String get enterCustomerName => 'Nhập tên khách hàng';

  @override
  String get chooseStaffAndService => 'Chọn nhân viên và ít nhất một dịch vụ';

  @override
  String get enterCustomerPhone => 'Nhập điện thoại khách hàng';

  @override
  String get chooseAvailableSlot => 'Chọn khung giờ trống';

  @override
  String get couldNotCreateBooking =>
      'Không thể tạo đặt lịch. Vui lòng thử lại.';

  @override
  String get doneServiceOption => 'Dịch vụ hoàn thành';

  @override
  String get scheduleLaterOption => 'Đặt lịch sau';

  @override
  String get customerNameLabel => 'Tên khách hàng';

  @override
  String get customerPhoneLabel => 'Điện thoại khách hàng';

  @override
  String recordedNowDate(String date) {
    return 'Vừa ghi nhận — $date';
  }

  @override
  String get dateLabel => 'Ngày';

  @override
  String get yyyymmddHint => 'YYYY-MM-DD';

  @override
  String get availableSlots => 'Khung giờ trống';

  @override
  String get cancel => 'Hủy';

  @override
  String get saveBooking => 'Lưu đặt lịch';

  @override
  String saveBookingWithTotal(String total) {
    return 'Lưu đặt lịch · $total';
  }

  @override
  String get addServiceTitle => 'Thêm dịch vụ';

  @override
  String get serviceNameLabel => 'Tên dịch vụ';

  @override
  String get categoryLabel => 'Danh mục';

  @override
  String get priceLabel => 'Giá';

  @override
  String get durationMinutesLabel => 'Thời lượng (phút)';

  @override
  String get deleteServiceButton => 'Xóa dịch vụ';

  @override
  String get fillServiceFields => 'Nhập tên, danh mục, giá và thời lượng';

  @override
  String get couldNotSaveService => 'Không thể lưu dịch vụ';

  @override
  String get noServicesInCatalog =>
      'Chưa có dịch vụ nào. Thêm dịch vụ đầu tiên.';

  @override
  String get searchServicesHint => 'Tìm kiếm dịch vụ';

  @override
  String get filterAllCategories => 'Tất cả';

  @override
  String get assignToStaffLabel => 'Gán cho nhân viên';

  @override
  String get anyStaffOption => 'Bất kỳ nhân viên nào';

  @override
  String get addStarterServicesButton => 'Thêm dịch vụ phổ biến';

  @override
  String get bookingLinkSectionTitle => 'Liên kết đặt lịch';

  @override
  String get bookingLinkSectionSubtitle =>
      'Chia sẻ liên kết hoặc mã QR này để khách hàng có thể đặt lịch trực tuyến';

  @override
  String get copyLinkButton => 'Sao chép';

  @override
  String get shareLinkButton => 'Chia sẻ';

  @override
  String get linkCopied => 'Đã sao chép liên kết';

  @override
  String bookingLinkShareText(String salonName, String link) {
    return 'Đặt lịch tại $salonName: $link';
  }
}
