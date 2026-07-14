import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:salon_admin_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('salon admin negative paths show correct errors', (tester) async {
    final suffix = DateTime.now().millisecondsSinceEpoch.toString();
    final ownerPhone = '9${suffix.substring(suffix.length - 9)}';
    final unknownPhone = '4${suffix.substring(suffix.length - 9)}';
    const password = 'neg123456';

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await _ensureSignedOut(tester);

    // ---- Login: client-side validation ----
    await _tapAuthSubmit(tester);
    await _expectMessage(tester, 'Enter salon owner phone');

    await tester.enterText(find.byKey(const Key('auth_phone')), ownerPhone);
    await _tapAuthSubmit(tester);
    await _expectMessage(tester, 'Enter your password');

    // ---- Login: unknown account (backend 401) ----
    await tester.enterText(find.byKey(const Key('auth_phone')), unknownPhone);
    await tester.enterText(find.byKey(const Key('auth_password')), 'wrongpass1');
    await _tapAuthSubmit(tester);
    await _expectMessage(
      tester,
      'No salon owner account found for this phone.',
    );

    // ---- Signup: client-side validation ----
    await tester.tap(find.byKey(const Key('auth_toggle_mode')));
    await tester.pumpAndSettle();

    await _tapAuthSubmit(tester);
    await _expectMessage(
      tester,
      'Fill owner name, salon name, address, and phone',
    );

    await tester.enterText(
      find.byKey(const Key('signup_owner_name')),
      'Neg Owner $suffix',
    );
    await tester.enterText(
      find.byKey(const Key('signup_salon_name')),
      'Neg Salon $suffix',
    );
    await tester.enterText(
      find.byKey(const Key('signup_address')),
      'Neg Address $suffix',
    );
    await tester.enterText(find.byKey(const Key('auth_phone')), ownerPhone);
    await tester.enterText(find.byKey(const Key('auth_password')), '123');
    await _tapAuthSubmit(tester);
    await _expectMessage(tester, 'Password must be at least 6 characters');

    // ---- Signup: valid, creates the account we reuse below ----
    await tester.enterText(find.byKey(const Key('auth_password')), password);
    await _tapAuthSubmit(tester);
    await _pumpUntilAny(
      tester,
      [find.byKey(const Key('dashboard_tab_staff'))],
      timeout: const Duration(seconds: 30),
    );
    expect(find.byKey(const Key('dashboard_tab_staff')), findsOneWidget);

    // ---- Account Settings: negative cases ----
    await _openAccountSettings(tester);

    // Save profile invalid (blank owner name). Done first, while the sheet is
    // scrolled to the top and the Save button is reachable.
    await tester.enterText(find.widgetWithText(TextField, 'Owner name'), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final save = find.byKey(const Key('account_save_profile'));
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await _expectMessage(tester, 'Fill owner, phone, salon name, and address');

    // Change password: too short.
    await _fillPasswordFields(tester, current: password, next: '123', confirm: '123');
    await _tapChangePassword(tester);
    await _expectMessage(tester, 'New password must be at least 6 characters');

    // Change password: mismatched confirmation.
    await _fillPasswordFields(
      tester,
      current: password,
      next: 'abcdef',
      confirm: 'abcdefg',
    );
    await _tapChangePassword(tester);
    await _expectMessage(tester, 'New passwords do not match');

    // Change password: wrong current password (backend 401).
    await _fillPasswordFields(
      tester,
      current: 'totallywrong',
      next: 'abcdef',
      confirm: 'abcdef',
    );
    await _tapChangePassword(tester);
    await _expectMessage(tester, 'Current password is incorrect');

    // Close the sheet. It is scrolled to the bottom (Close button off-screen),
    // so pop the modal route directly instead of tapping Close.
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ---- Signup: duplicate phone (backend 409) ----
    await _signOut(tester);
    await tester.tap(find.byKey(const Key('auth_toggle_mode')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('signup_owner_name')),
      'Dup Owner $suffix',
    );
    await tester.enterText(
      find.byKey(const Key('signup_salon_name')),
      'Dup Salon $suffix',
    );
    await tester.enterText(
      find.byKey(const Key('signup_address')),
      'Dup Address $suffix',
    );
    await tester.enterText(find.byKey(const Key('auth_phone')), ownerPhone);
    await tester.enterText(find.byKey(const Key('auth_password')), password);
    await _tapAuthSubmit(tester);
    await _expectMessage(
      tester,
      'This phone is already registered. Please sign in instead.',
    );
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

Future<void> _fillPasswordFields(
  WidgetTester tester, {
  required String current,
  required String next,
  required String confirm,
}) async {
  await tester.enterText(
    find.widgetWithText(TextField, 'Current password'),
    current,
  );
  await tester.enterText(find.widgetWithText(TextField, 'New password'), next);
  await tester.enterText(
    find.widgetWithText(TextField, 'Confirm new password'),
    confirm,
  );
}

Future<void> _tapChangePassword(WidgetTester tester) async {
  final button = find.byKey(const Key('account_change_password'));
  await tester.ensureVisible(button);
  await tester.tap(button);
}

Future<void> _signOut(WidgetTester tester) async {
  final signOut = find.byTooltip('Sign out');
  await _pumpUntilAny(tester, [signOut], timeout: const Duration(seconds: 15));
  await tester.ensureVisible(signOut);
  await tester.tap(signOut);
  await _pumpUntilAny(
    tester,
    [find.byKey(const Key('auth_toggle_mode'))],
    timeout: const Duration(seconds: 20),
  );
}

/// Taps the auth submit button, scrolling it into view first. In signup mode
/// the form is tall enough that the lazy ListView may not have built the button.
Future<void> _tapAuthSubmit(WidgetTester tester) async {
  final submit = find.byKey(const Key('auth_submit'));
  if (submit.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      submit,
      300,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(submit);
  await tester.tap(submit);
  await tester.pump();
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

/// Waits for [message] to appear, asserts it, then clears the snackbar so it
/// cannot overlap (and block hit-testing on) the next interaction.
Future<void> _expectMessage(WidgetTester tester, String message) async {
  await _pumpUntilAny(
    tester,
    [find.text(message)],
    timeout: const Duration(seconds: 15),
  );
  expect(find.text(message), findsWidgets, reason: 'expected snackbar: $message');
  tester
      .firstState<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
      .clearSnackBars();
  await tester.pumpAndSettle();
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
