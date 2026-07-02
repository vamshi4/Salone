class CustomerBooking {
  final String id;
  final String status;
  final String serviceType;
  final DateTime slotStart;
  final int price;
  final int travelFee;
  final String serviceName;
  final String stylistName;
  final String? salonName;

  CustomerBooking({
    required this.id,
    required this.status,
    required this.serviceType,
    required this.slotStart,
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

  factory CustomerBooking.fromJson(Map<String, dynamic> json) {
    final stylist = json['stylist'];
    final user = stylist?['user'];
    final salon = json['salon'] ?? stylist?['primarySalon'];
    final service = json['service'];

    return CustomerBooking(
      id: json['id'],
      status: json['status'] ?? 'CONFIRMED',
      serviceType: json['serviceType'] ?? 'IN_SALON',
      slotStart: DateTime.parse(json['slotStart']),
      price: json['price'] ?? 0,
      travelFee: json['travelFee'] ?? 0,
      serviceName: service?['name'] ?? 'Standard Service',
      stylistName: user?['name'] ?? 'Stylist',
      salonName: salon?['name'],
    );
  }
}
