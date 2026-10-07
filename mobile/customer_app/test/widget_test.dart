import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_customer_app/main.dart';

void main() {
  testWidgets('renders customer app', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.text('Welcome to GlamBook'), findsOneWidget);
  });
}
