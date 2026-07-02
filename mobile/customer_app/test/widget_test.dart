import 'package:flutter_test/flutter_test.dart';
import 'package:salon_customer_app/main.dart';

void main() {
  testWidgets('renders customer app', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('GlamBook'), findsOneWidget);
  });
}
