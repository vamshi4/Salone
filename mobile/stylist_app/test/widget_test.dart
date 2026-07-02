import 'package:flutter_test/flutter_test.dart';
import 'package:stylist_app/main.dart';

void main() {
  testWidgets('renders stylist app', (tester) async {
    await tester.pumpWidget(const StylistApp());
    expect(find.text('Stylist Dashboard'), findsNothing);
  });
}
