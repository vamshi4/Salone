import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/marketplace_salon.dart';

final salonsProvider = FutureProvider<List<MarketplaceSalon>>((ref) async {
  final res = await ApiClient().get('/api/v2/salons');
  return (res.data as List).map((e) => MarketplaceSalon.fromJson(e)).toList();
});
