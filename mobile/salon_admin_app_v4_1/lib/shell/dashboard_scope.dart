import 'package:flutter/widgets.dart';

import 'dashboard_data.dart';

/// Makes the shared [DashboardData] available to every tab under
/// [RootShell] without adding a state-management package. Access with
/// `DashboardScope.of(context)`.
class DashboardScope extends InheritedNotifier<DashboardData> {
  const DashboardScope({super.key, required DashboardData data, required super.child})
      : super(notifier: data);

  static DashboardData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DashboardScope>();
    assert(scope != null, 'DashboardScope.of() called outside of a RootShell');
    return scope!.notifier!;
  }
}
