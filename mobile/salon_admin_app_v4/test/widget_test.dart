import 'package:flutter_test/flutter_test.dart';
import 'package:salon_admin_app/main.dart';

void main() {
  testWidgets('renders salon admin app', (tester) async {
    await tester.pumpWidget(const SalonAdminApp());
    expect(find.text('Salon Admin'), findsNothing);
  });
}
