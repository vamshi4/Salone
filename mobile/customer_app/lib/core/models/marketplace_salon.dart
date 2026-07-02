import 'stylist.dart';

class MarketplaceSalon {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int totalReviews;
  final List<SalonService> services;
  final List<Stylist> staff;

  MarketplaceSalon({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.totalReviews,
    required this.services,
    required this.staff,
  });

  String get priceRange {
    if (services.isEmpty) return 'Services available';
    final prices = services.map((service) => service.basePrice).toList()
      ..sort();
    return 'Rs ${prices.first ~/ 100} - Rs ${prices.last ~/ 100}';
  }

  factory MarketplaceSalon.fromJson(Map<String, dynamic> json) {
    final relationships = (json['stylists'] ?? []) as List;

    return MarketplaceSalon(
      id: json['id'],
      name: json['name'] ?? 'Salon',
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      services: ((json['services'] ?? []) as List)
          .map((service) => SalonService.fromJson(service))
          .toList(),
      staff: relationships
          .map((relationship) => relationship['stylist'])
          .where((stylist) => stylist != null)
          .map((stylist) => Stylist.fromJson(stylist))
          .toList(),
    );
  }
}

class SalonService {
  final String id;
  final String name;
  final String category;
  final int duration;
  final int basePrice;

  SalonService({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.basePrice,
  });

  String get priceText => 'Rs ${basePrice ~/ 100}';

  factory SalonService.fromJson(Map<String, dynamic> json) {
    return SalonService(
      id: json['id'],
      name: json['name'] ?? 'Service',
      category: json['category'] ?? 'Salon',
      duration: json['duration'] ?? 60,
      basePrice: json['basePrice'] ?? 0,
    );
  }
}
