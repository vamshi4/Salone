/// Small shared pure helpers used across screens/sheets (moved out of the
/// old monolithic main.dart so more than one file can use them).
library;

/// Groups a booking's customer by user id (preferred) or phone, matching
/// the same-customer logic used for repeat/unique customer counts.
String? customerKey(Map<String, dynamic> booking) {
  final customer = booking['customer'];
  if (customer is! Map) return null;
  final id = customer['id'];
  final phone = customer['phone'];
  if (id is String && id.isNotEmpty) return id;
  if (phone is String && phone.isNotEmpty) return phone;
  return null;
}

T? firstOrNull<T>(List<T> items) => items.isEmpty ? null : items.first;

/// `yyyy-MM-dd`, the shape the availability endpoint expects for `date`.
String dateInput(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// A booking's effective "when it happened" timestamp: the completion time
/// if it's been logged as done, otherwise its scheduled slot start. Used to
/// group bookings by day and to compute today/week/month totals.
DateTime effectiveBookingTime(Map<String, dynamic> booking) {
  final completedAt = booking['completedAt'];
  if (completedAt is String && completedAt.isNotEmpty) {
    return DateTime.parse(completedAt).toLocal();
  }
  return DateTime.parse(booking['slotStart'] as String).toLocal();
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
