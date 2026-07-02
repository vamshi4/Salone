class Stylist {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final int totalReviews;
  final String registrationType;
  final bool homeServiceEnabled;
  final bool independentBookingEnabled;
  final int? salonPrice;
  final int? minPrice;
  final Salon? primarySalon;
  final List<StylistService> services;

  Stylist({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.totalReviews,
    required this.registrationType,
    required this.homeServiceEnabled,
    required this.independentBookingEnabled,
    this.salonPrice,
    this.minPrice,
    this.primarySalon,
    this.services = const [],
  });

  String get displayName =>
      registrationType == 'SALON_EXCLUSIVE' && primarySalon != null
          ? '$name at ${primarySalon!.name}'
          : name;

  int get fallbackPrice => registrationType == 'SALON_EXCLUSIVE'
      ? salonPrice ?? 0
      : minPrice ?? salonPrice ?? 0;

  String get priceText => registrationType == 'SALON_EXCLUSIVE'
      ? 'Rs ${(salonPrice ?? 0) ~/ 100}'
      : 'Rs ${(minPrice ?? 0) ~/ 100} onwards';

  List<StylistService> get bookableServices {
    if (services.isNotEmpty) return services;

    return [
      StylistService(
        id: 'standard-service',
        name: 'Standard Styling Session',
        category: 'Salon',
        duration: 60,
        basePrice: fallbackPrice,
      ),
    ];
  }

  factory Stylist.fromJson(Map<String, dynamic> json) {
    return Stylist(
      id: json['id'],
      name: json['user']['name'],
      avatarUrl: json['user']['avatarUrl'] ?? 'https://i.pravatar.cc/150',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      registrationType: json['registrationType'],
      homeServiceEnabled: json['homeServiceEnabled'] ?? false,
      independentBookingEnabled: json['independentBookingEnabled'] ?? true,
      salonPrice: json['salonPrice'],
      minPrice: json['minPrice'],
      primarySalon: json['primarySalon'] != null
          ? Salon.fromJson(json['primarySalon'])
          : null,
      services: ((json['services'] ?? []) as List)
          .map((service) => StylistService.fromJson(service))
          .toList(),
    );
  }
}

class Salon {
  final String id;
  final String name;

  Salon({required this.id, required this.name});

  factory Salon.fromJson(Map<String, dynamic> json) =>
      Salon(id: json['id'], name: json['name']);
}

class StylistService {
  final String id;
  final String name;
  final String category;
  final int duration;
  final int basePrice;

  StylistService({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.basePrice,
  });

  String get priceText => 'Rs ${basePrice ~/ 100}';

  factory StylistService.fromJson(Map<String, dynamic> json) {
    return StylistService(
      id: json['id'],
      name: json['name'] ?? 'Standard Service',
      category: json['category'] ?? 'Salon',
      duration: json['duration'] ?? 60,
      basePrice: json['basePrice'] ?? 0,
    );
  }
}
