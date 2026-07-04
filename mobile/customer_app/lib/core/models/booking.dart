class CustomerBooking {
  final String id;
  final String status;
  final String serviceType;
  final String serviceId;
  final String? stylistId;
  final DateTime slotStart;
  final DateTime? proposedDateTime;
  final String? rescheduleProposedBy;
  final int price;
  final int travelFee;
  final String serviceName;
  final String stylistName;
  final String? salonName;

  CustomerBooking({
    required this.id,
    required this.status,
    required this.serviceType,
    required this.serviceId,
    this.stylistId,
    required this.slotStart,
    this.proposedDateTime,
    this.rescheduleProposedBy,
    required this.price,
    required this.travelFee,
    required this.serviceName,
    required this.stylistName,
    this.salonName,
  });

  int get total => price + travelFee;

  String get totalText => 'Rs ${total ~/ 100}';

  String get providerText =>
      salonName == null ? stylistName : '$stylistName at $salonName';

  bool get isPending => status == 'PENDING';
  bool get isConfirmed => status == 'CONFIRMED';
  bool get isCancelled => status == 'CANCELLED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isPendingReschedule => status == 'PENDING_RESCHEDULE';
  bool get rescheduleByCustomer =>
      isPendingReschedule && rescheduleProposedBy == 'CUSTOMER';
  bool get rescheduleByProvider =>
      isPendingReschedule && rescheduleProposedBy != 'CUSTOMER';

  String get customerStatusTitle {
    if (isPending) return 'Waiting for provider confirmation';
    if (rescheduleByCustomer) return 'Waiting for provider approval';
    if (rescheduleByProvider) return 'Provider suggested a new time';
    if (isConfirmed) return 'Booking confirmed';
    if (isCancelled) return 'Booking cancelled';
    if (isCompleted) return 'Appointment completed';
    return status;
  }

  String get customerStatusMessage {
    if (isPending) {
      return 'Your request was sent. The stylist or salon must confirm before the appointment is final.';
    }
    if (rescheduleByCustomer) {
      return 'Your new time request is waiting for the stylist or salon.';
    }
    if (rescheduleByProvider) {
      return 'Review the proposed time and accept it to update your booking.';
    }
    if (isConfirmed) {
      return 'Your appointment is confirmed. You can request a reschedule if needed.';
    }
    if (isCancelled) return 'This booking is no longer active.';
    if (isCompleted) return 'This appointment has been completed.';
    return 'Open details for the latest booking state.';
  }

  bool get needsCustomerAction => rescheduleByProvider;

  factory CustomerBooking.fromJson(Map<String, dynamic> json) {
    final stylist = json['stylist'];
    final user = stylist?['user'];
    final salon = json['salon'] ?? stylist?['primarySalon'];
    final service = json['service'];

    return CustomerBooking(
      id: json['id'],
      status: json['status'] ?? 'CONFIRMED',
      serviceType: json['serviceType'] ?? 'IN_SALON',
      serviceId: json['serviceId'] ?? service?['id'] ?? '',
      stylistId: json['stylistId'] ?? stylist?['id'],
      slotStart: DateTime.parse(json['slotStart']),
      proposedDateTime: json['proposedDateTime'] == null
          ? null
          : DateTime.parse(json['proposedDateTime']),
      rescheduleProposedBy: json['rescheduleProposedBy'],
      price: json['price'] ?? 0,
      travelFee: json['travelFee'] ?? 0,
      serviceName: service?['name'] ?? 'Standard Service',
      stylistName: user?['name'] ?? 'Stylist',
      salonName: salon?['name'],
    );
  }
}
