import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:salon_admin_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('salon admin owner flow works', (tester) async {
    final suffix = DateTime.now().millisecondsSinceEpoch.toString();
    final ownerPhone = '9${suffix.substring(suffix.length - 9)}';
    final staffPhone = '8${suffix.substring(suffix.length - 9)}';
    final customerPhone = '7${suffix.substring(suffix.length - 9)}';

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await _ensureSignedOut(tester);
    await _signupSalonOwner(tester, suffix, ownerPhone);
    await _openStaffTab(tester);
    await _createFirstStaff(tester, suffix, staffPhone);
    await _openManageStaff(tester);
    await _addServiceFromManageSheet(tester);
    await _returnToDashboard(tester);
    await _createManualBooking(tester, suffix, customerPhone);
    await _showAllBookings(tester);

    expect(find.textContaining('Smoke Stylist'), findsWidgets);
    expect(find.textContaining('Smoke Customer'), findsWidgets);
    expect(find.textContaining('Smoke Haircut + Beard Trim'), findsWidgets);

    // New feature coverage: Account Settings + password management.
    await _openAccountSettings(tester);
    await _verifyAccountSettings(tester, suffix);
    await _changePassword(tester);
    await _editAndSaveProfile(tester, suffix);
    await _reloginWithNewPassword(tester, ownerPhone);
  });
}

Future<void> _openAccountSettings(WidgetTester tester) async {
  final icon = find.byTooltip('Account settings');
  await tester.ensureVisible(icon);
  await tester.tap(icon);
  await _pumpUntilAny(
    tester,
    [find.text('Admin profile')],
    timeout: const Duration(seconds: 15),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

Future<void> _verifyAccountSettings(WidgetTester tester, String suffix) async {
  // Role / plan / joined summary (pill labels render as 'Role: ', 'Joined: ').
  expect(find.textContaining('Role'), findsWidgets);
  expect(find.text('Salon owner'), findsWidgets);
  expect(find.textContaining('Plan'), findsWidgets);
  expect(find.textContaining('Joined'), findsWidgets);
  // Editable profile + salon fields.
  expect(find.text('Owner name'), findsWidgets);
  expect(find.text('Phone number'), findsWidgets);
  expect(find.text('Email'), findsWidgets);
  expect(find.text('Salon name'), findsWidgets);
  expect(find.text('Salon address'), findsWidgets);
  // Values prefilled from signup.
  expect(find.text('Smoke Owner $suffix'), findsWidgets);
  expect(find.text('Smoke Salon $suffix'), findsWidgets);
  // Security section fields.
  expect(find.text('Current password'), findsWidgets);
  expect(find.text('New password'), findsWidgets);
  expect(find.text('Confirm new password'), findsWidgets);
}

Future<void> _changePassword(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextField, 'Current password'),
    'smoke123',
  );
  await tester.enterText(
    find.widgetWithText(TextField, 'New password'),
    'smoke456',
  );
  await tester.enterText(
    find.widgetWithText(TextField, 'Confirm new password'),
    'smoke456',
  );
  final button = find.byKey(const Key('account_change_password'));
  await tester.ensureVisible(button);
  await tester.tap(button);
  await _pumpUntilAny(
    tester,
    [
      find.text('Password changed'),
      find.textContaining('incorrect'),
      find.textContaining('Could not change'),
      find.textContaining('at least 6'),
    ],
    timeout: const Duration(seconds: 20),
  );
  expect(find.text('Password changed'), findsWidgets);
}

Future<void> _editAndSaveProfile(WidgetTester tester, String suffix) async {
  final ownerField = find.widgetWithText(TextField, 'Owner name');
  await tester.ensureVisible(ownerField);
  await tester.enterText(ownerField, 'Smoke Owner Edited $suffix');
  final save = find.byKey(const Key('account_save_profile'));
  await tester.ensureVisible(save);
  await tester.tap(save);
  // Sheet pops and parent shows the confirmation snackbar.
  await _pumpUntilAny(
    tester,
    [
      find.text('Account updated'),
      find.textContaining('Could not save'),
      find.textContaining('already used'),
    ],
    timeout: const Duration(seconds: 20),
  );
  expect(find.text('Account updated'), findsWidgets);
}

Future<void> _reloginWithNewPassword(
  WidgetTester tester,
  String ownerPhone,
) async {
  final signOut = find.byTooltip('Sign out');
  await _pumpUntilAny(tester, [signOut], timeout: const Duration(seconds: 15));
  await tester.ensureVisible(signOut);
  await tester.tap(signOut);
  await _pumpUntilAny(
    tester,
    [find.byKey(const Key('auth_toggle_mode'))],
    timeout: const Duration(seconds: 20),
  );
  // Default auth screen is login mode: sign in with the NEW password.
  await tester.enterText(find.byKey(const Key('auth_phone')), ownerPhone);
  await tester.enterText(find.byKey(const Key('auth_password')), 'smoke456');
  await tester.tap(find.byKey(const Key('auth_submit')));
  await _pumpUntilAny(
    tester,
    [
      find.byKey(const Key('dashboard_tab_staff')),
      find.textContaining('failed'),
      find.textContaining('Check backend connection'),
    ],
    timeout: const Duration(seconds: 30),
  );
  expect(find.byKey(const Key('dashboard_tab_staff')), findsOneWidget);
}

Future<void> _ensureSignedOut(WidgetTester tester) async {
  await _pumpUntilAny(
    tester,
    [
      find.byTooltip('Sign out'),
      find.byKey(const Key('auth_toggle_mode')),
    ],
    timeout: const Duration(seconds: 20),
  );

  final signOut = find.byTooltip('Sign out');
  if (signOut.evaluate().isNotEmpty) {
    await tester.ensureVisible(signOut);
    await tester.tap(signOut);
    await _pumpUntilAny(
      tester,
      [find.byKey(const Key('auth_toggle_mode'))],
      timeout: const Duration(seconds: 20),
    );
  }
}

Future<void> _signupSalonOwner(
  WidgetTester tester,
  String suffix,
  String ownerPhone,
) async {
  await tester.tap(find.byKey(const Key('auth_toggle_mode')));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('signup_owner_name')),
    'Smoke Owner $suffix',
  );
  await tester.enterText(
    find.byKey(const Key('signup_salon_name')),
    'Smoke Salon $suffix',
  );
  await tester.enterText(
    find.byKey(const Key('signup_address')),
    'Smoke Address $suffix',
  );
  await tester.enterText(find.byKey(const Key('auth_phone')), ownerPhone);
  await tester.enterText(find.byKey(const Key('auth_password')), 'smoke123');
  await tester.tap(find.byKey(const Key('auth_submit')));
  await _pumpUntilAny(
    tester,
    [
      find.byKey(const Key('dashboard_tab_staff')),
      find.textContaining('failed'),
      find.textContaining('registered'),
      find.textContaining('Check backend connection'),
      find.textContaining('No salon'),
    ],
    timeout: const Duration(seconds: 30),
  );

  if (find.byKey(const Key('dashboard_tab_staff')).evaluate().isEmpty) {
    final visibleText = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>()
        .where((text) => text.trim().isNotEmpty)
        .take(20)
        .toList();
    // ignore: avoid_print
    print('Visible texts after signup: $visibleText');
    fail('Signup did not reach dashboard staff tab.');
  }
}

Future<void> _openStaffTab(WidgetTester tester) async {
  final staffTab = find.byKey(const Key('dashboard_tab_staff'));
  await tester.ensureVisible(staffTab);
  await tester.tap(staffTab);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> _createFirstStaff(
  WidgetTester tester,
  String suffix,
  String staffPhone,
) async {
  Finder addStaff = find.byKey(const Key('staff_empty_add_button'));
  if (addStaff.evaluate().isEmpty) {
    addStaff = find.byKey(const Key('staff_add_button'));
  }
  await tester.ensureVisible(addStaff);
  await tester.tap(addStaff);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.enterText(
    find.byKey(const Key('staff_setup_name')),
    'Smoke Stylist $suffix',
  );
  await tester.enterText(
    find.byKey(const Key('staff_setup_phone')),
    staffPhone,
  );
  await tester.enterText(
    find.byKey(const Key('staff_setup_service')),
    'Smoke Haircut',
  );
  await tester.enterText(
    find.byKey(const Key('staff_setup_price')),
    '499',
  );
  await tester.ensureVisible(find.byKey(const Key('staff_setup_submit')));
  await tester.tap(find.byKey(const Key('staff_setup_submit')));
  await tester.pumpAndSettle(const Duration(seconds: 8));
}

Future<void> _openManageStaff(WidgetTester tester) async {
  final editButton = find.text('Edit').first;
  await tester.ensureVisible(editButton);
  await tester.tap(editButton);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> _addServiceFromManageSheet(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('staff_manage_new_service_name')),
    'Beard Trim',
  );
  await tester.enterText(
    find.byKey(const Key('staff_manage_new_service_price')),
    '299',
  );
  await tester.ensureVisible(find.byKey(const Key('staff_manage_add_service')));
  await tester.tap(find.byKey(const Key('staff_manage_add_service')));
  await tester.pumpAndSettle(const Duration(seconds: 5));
  await tester.ensureVisible(find.byKey(const Key('staff_manage_done')));
  await tester.tap(find.byKey(const Key('staff_manage_done')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> _returnToDashboard(WidgetTester tester) async {
  final signOut = find.byTooltip('Sign out');
  await _pumpUntilAny(
    tester,
    [
      find.byTooltip('Sign out'),
      find.byKey(const Key('dashboard_tab_bookings')),
    ],
    timeout: const Duration(seconds: 20),
  );
  if (signOut.evaluate().isNotEmpty) {
    return;
  }
  fail('Did not return to dashboard after staff manage flow.');
}

Future<void> _createManualBooking(
  WidgetTester tester,
  String suffix,
  String customerPhone,
) async {
  final bookingsTab = find.byKey(const Key('dashboard_tab_bookings'));
  await tester.ensureVisible(bookingsTab);
  await tester.tap(bookingsTab);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.tap(find.byTooltip('New booking'));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.enterText(
    find.byKey(const Key('booking_customer_name')),
    'Smoke Customer $suffix',
  );
  await tester.enterText(
    find.byKey(const Key('booking_customer_phone')),
    customerPhone,
  );
  final beardTrim =
      find.byKey(const Key('booking_service_name_Beard Trim'))
      .evaluate()
      .isNotEmpty;
  if (beardTrim) {
    await tester.tap(find.byKey(const Key('booking_service_name_Beard Trim')));
    await tester.pump(const Duration(milliseconds: 500));
  }

  await tester.enterText(
    find.byKey(const Key('booking_date')),
    _dateInput(DateTime.now().add(const Duration(days: 1))),
  );
  await _pumpUntilAny(
    tester,
    [
      find.byKey(const Key('booking_slot_0')),
      find.textContaining('No available slots'),
      find.textContaining('Could not load slots'),
    ],
    timeout: const Duration(seconds: 20),
  );
  if (find.byKey(const Key('booking_slot_0')).evaluate().isEmpty) {
    final visibleText = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>()
        .where((text) => text.trim().isNotEmpty)
        .take(25)
        .toList();
    // ignore: avoid_print
    print('Visible texts before booking create: $visibleText');
    fail('No available smoke-test slot was loaded.');
  }

  await tester.ensureVisible(find.byKey(const Key('booking_create')));
  await tester.tap(find.byKey(const Key('booking_create')));
  await _pumpUntilAny(
    tester,
    [
      find.byKey(const Key('booking_filter_ALL')),
      find.textContaining('Could not create booking'),
      find.textContaining('Choose an available slot'),
    ],
    timeout: const Duration(seconds: 30),
  );
  if (find.byKey(const Key('booking_filter_ALL')).evaluate().isEmpty) {
    final visibleText = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>()
        .where((text) => text.trim().isNotEmpty)
        .take(25)
        .toList();
    // ignore: avoid_print
    print('Visible texts after booking create: $visibleText');
    fail('Booking sheet did not close after create.');
  }
}

Future<void> _showAllBookings(WidgetTester tester) async {
  final allFilter = find.byKey(const Key('booking_filter_ALL'));
  await tester.ensureVisible(allFilter);
  await tester.tap(allFilter);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

String _dateInput(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

Future<void> _pumpUntilAny(
  WidgetTester tester,
  List<Finder> finders, {
  Duration timeout = const Duration(seconds: 20),
  Duration step = const Duration(milliseconds: 500),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finders.any((finder) => finder.evaluate().isNotEmpty)) {
      return;
    }
  }
}
