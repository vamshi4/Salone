import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/stylist.dart';

final stylistsProvider = FutureProvider<List<Stylist>>((ref) async {
  final res = await ApiClient().get('/api/v2/stylists');
  return (res.data as List).map((e) => Stylist.fromJson(e)).toList();
});
