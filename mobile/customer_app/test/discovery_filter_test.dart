import 'package:flutter_test/flutter_test.dart';
import 'package:salon_customer_app/core/models/marketplace_salon.dart';
import 'package:salon_customer_app/core/models/stylist.dart';
import 'package:salon_customer_app/features/search/salons_tab.dart';
import 'package:salon_customer_app/features/search/stylists_tab.dart';

void main() {
  final haircut = StylistService(
    id: 'service-1',
    name: 'Haircut',
    category: 'Hair',
    duration: 30,
    basePrice: 50000,
  );
  final stylist = Stylist(
    id: 'stylist-1',
    name: 'Anu',
    avatarUrl: '',
    rating: 4.8,
    totalReviews: 12,
    registrationType: 'INDEPENDENT',
    homeServiceEnabled: true,
    independentBookingEnabled: true,
    latitude: 17.48,
    longitude: 78.55,
    services: [haircut],
  );
  final salon = MarketplaceSalon(
    id: 'salon-1',
    name: 'Chairful Studio',
    address: 'Sainikpuri',
    latitude: 17.48,
    longitude: 78.55,
    rating: 4.6,
    totalReviews: 20,
    services: [
      SalonService(
        id: haircut.id,
        name: haircut.name,
        category: haircut.category,
        duration: haircut.duration,
        basePrice: haircut.basePrice,
      ),
    ],
    staff: [stylist],
  );

  test('discovery search and chips filter both result types', () {
    expect(filterSalons([salon], 'chairful', {'haircut', 'home', 'rated'}),
        [salon]);
    expect(filterStylists([stylist], 'anu', {'haircut', 'home', 'rated'}),
        [stylist]);
    expect(filterSalons([salon], 'missing', {}), isEmpty);
    expect(filterStylists([stylist], '', {'rated'}), [stylist]);
    expect(
        filterSalons([salon], '', {'nearby'},
            latitude: 17.48, longitude: 78.55),
        [salon]);
    expect(
        filterStylists([stylist], '', {'nearby'},
            latitude: 17.48, longitude: 78.55),
        [stylist]);
  });
}
