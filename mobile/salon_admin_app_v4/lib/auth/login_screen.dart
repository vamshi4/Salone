import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/google_auth.dart';
import '../core/locale_controller.dart';
import '../core/prefs.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/google_icon.dart';
import '../widgets/option_picker_sheet.dart';
import 'forgot_password_flow.dart';
import 'signup_flow.dart';

/// The WhatsApp OTP delivery behind "Forgot password?" needs a Meta
/// WhatsApp Business API account that isn't set up yet — hidden for this
/// release so nobody hits a dead end. "Continue with Google" is the
/// account-recovery path in the meantime. Flip back on once
/// WHATSAPP_ACCESS_TOKEN is configured (see docs/HANDOFF.md); the flow
/// itself (forgot_password_flow.dart) is untouched and ready to go.
const kForgotPasswordEnabled = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _googleLoading = false;
  bool _showPassword = false;
  CountryOption _country = kCountries.first;
  LanguageOption _language = kLanguages.first;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadCountry();
    _loadLanguage();
  }

  Future<void> _loadCountry() async {
    final code = await AppPrefs.getCountryCode();
    if (mounted) setState(() => _country = countryByCode(code));
  }

  Future<void> _loadLanguage() async {
    final code = await AppPrefs.getLanguageCode();
    if (mounted) setState(() => _language = languageByCode(code));
  }

  /// Lets a returning user fix the display language before signing in — the
  /// on-first-launch auto-detect (GPS/device locale) can guess wrong, and
  /// until now there was no way to correct it without first creating an
  /// account. Deliberately doesn't touch [_country]/currency: someone
  /// reading the app in French isn't necessarily dialing a French number.
  Future<void> _pickLanguage() async {
    final selected = await showModalBottomSheet<LanguageOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet<LanguageOption>(
        title: t.language,
        options: kLanguages,
        labelOf: (l) => l.label,
        isSelected: (l) => l.code == _language.code,
      ),
    );
    if (selected != null) {
      setState(() => _language = selected);
      await AppPrefs.setLanguageCode(selected.code);
      LocaleController.instance.applyLoaded(selected.code);
    }
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<CountryOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet<CountryOption>(
        title: t.country,
        options: kCountries,
        labelOf: (c) => '${c.flagEmoji}  ${c.name}  ${c.dialCode}',
        isSelected: (c) => c.code == _country.code,
      ),
    );
    if (selected != null) {
      setState(() => _country = selected);
      await AppPrefs.setCountryCode(selected.code);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 6) {
      _show(t.enterSalonOwnerPhone);
      return;
    }
    if (_passwordController.text.length < 6) {
      _show(t.enterYourPassword);
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await anonApi().post(
        '/api/v2/auth/login',
        data: {
          'phone': phone,
          'password': _passwordController.text,
          'role': 'SALON_OWNER',
        },
      );
      await saveAuthToken(res.data['token'] as String);
      widget.onSignedIn();
    } catch (e) {
      if (kDebugMode) debugPrint('Salon admin login failed: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        _show(t.noSalonOwnerFound);
      } else if (e is DioException) {
        _show(t.loginFailedCheckBackend);
      } else {
        _show(t.loginFailedTryAgain);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _googleLoading = true);
    try {
      final idToken = await signInWithGoogleIdToken();
      if (idToken == null) return; // user cancelled the picker
      final res = await anonApi().post(
        '/api/v2/auth/google-login',
        data: {'idToken': idToken, 'role': 'SALON_OWNER'},
      );
      await saveAuthToken(res.data['token'] as String);
      widget.onSignedIn();
    } on GoogleAuthNotConfiguredError {
      _show(t.googleSignInNotConfigured);
    } catch (e) {
      if (kDebugMode) debugPrint('Google login failed: $e');
      if (e is DioException && e.response?.statusCode == 404) {
        _show(t.googleNoAccountFound);
      } else {
        _show(t.googleSignInFailed);
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  void _goToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SignupFlow(onSignedIn: widget.onSignedIn),
      ),
    );
  }

  void _goToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordFlow()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      key: const Key('auth_pick_language'),
                      onPressed: _pickLanguage,
                      icon: const Icon(Icons.language, size: 18),
                      label: Text(_language.label),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(14),
                      child: Image.asset('assets/icon/icon_fg.png', color: AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(t.welcomeBack,
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(t.signInToDashboard,
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 32),
                  TextField(
                    key: const Key('auth_phone'),
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: t.phoneNumberLabel,
                      prefixIcon: InkWell(
                        onTap: _pickCountry,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: SizedBox(
                          width: 74,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${_country.flagEmoji} ${_country.dialCode}',
                                    style: const TextStyle(fontSize: 13)),
                                const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.inkFaint),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const Key('auth_password'),
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _loading ? null : _login(),
                    decoration: InputDecoration(
                      labelText: t.passwordLabel,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        tooltip: _showPassword ? t.hidePassword : t.showPassword,
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),
                  if (kForgotPasswordEnabled)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        key: const Key('auth_forgot_password'),
                        onPressed: _loading ? null : _goToForgotPassword,
                        child: Text(t.forgotPassword),
                      ),
                    ),
                  const SizedBox(height: kForgotPasswordEnabled ? 8 : 24),
                  FilledButton(
                    key: const Key('auth_submit'),
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(t.signIn),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    key: const Key('auth_google'),
                    onPressed: (_loading || _googleLoading) ? null : _loginWithGoogle,
                    icon: _googleLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const GoogleIcon(),
                    label: Text(t.continueWithGoogle),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.newHere, style: Theme.of(context).textTheme.bodyMedium),
                      TextButton(
                        key: const Key('auth_go_signup'),
                        onPressed: _loading ? null : _goToSignup,
                        child: Text(t.createAccount),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
