import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../shell/root_shell.dart';
import 'login_screen.dart';
import 'update_required_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _signedIn = false;
  bool _updateRequired = false;
  String _storeUrl = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _checkVersion();
    final token = await authToken();
    setState(() {
      _signedIn = token != null;
      _loading = false;
    });
  }

  /// Force-update gate: if this build is older than the backend's minimum,
  /// block the app. Fails open (never blocks) if the check can't run.
  Future<void> _checkVersion() async {
    try {
      final res = await api().get('/api/v2/app-config');
      final min = '${res.data['salonAdminMinVersion'] ?? appVersion}';
      _storeUrl = '${res.data['salonAdminStoreUrl'] ?? ''}';
      if (isVersionLower(appVersion, min)) _updateRequired = true;
    } catch (e) {
      if (kDebugMode) debugPrint('Version check skipped: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_updateRequired) {
      return UpdateRequiredScreen(storeUrl: _storeUrl);
    }

    return _signedIn
        ? RootShell(
            onLogout: () async {
              await clearAuthToken();
              setState(() => _signedIn = false);
            },
          )
        : LoginScreen(onSignedIn: () => setState(() => _signedIn = true));
  }
}
