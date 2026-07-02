import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/booking.dart';

final bookingsProvider = FutureProvider<List<CustomerBooking>>((ref) async {
  final res = await ApiClient().get('/v2/bookings');
  return (res.data as List).map((e) => CustomerBooking.fromJson(e)).toList();
});
