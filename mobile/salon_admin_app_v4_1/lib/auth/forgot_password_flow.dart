import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/api.dart';
import '../core/prefs.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/option_picker_sheet.dart';

/// Two-step forgot-password flow: (1) enter phone, request a WhatsApp OTP via
/// `POST /auth/forgot-password`; (2) enter the code + a new password, submit
/// via `POST /auth/reset-password-otp`. Both endpoints respond generically on
/// step 1 so this can't be used to enumerate registered phone numbers — see
/// backend/src/routes/auth.routes.ts.
class ForgotPasswordFlow extends StatefulWidget {
  const ForgotPasswordFlow({super.key});

  @override
  State<ForgotPasswordFlow> createState() => _ForgotPasswordFlowState();
}

class _ForgotPasswordFlowState extends State<ForgotPasswordFlow> {
  int _step = 0;
  CountryOption _country = kCountries.first;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final code = await AppPrefs.getCountryCode();
    if (mounted) setState(() => _country = countryByCode(code));
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
    if (selected != null) setState(() => _country = selected);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _requestCode() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 6) {
      _show(t.enterSalonOwnerPhone);
      return;
    }

    setState(() => _loading = true);
    try {
      await anonApi().post(
        '/api/v2/auth/forgot-password',
        data: {'phone': phone, 'role': 'SALON_OWNER'},
      );
      if (!mounted) return;
      _show(t.codeSentViaWhatsApp);
      setState(() => _step = 1);
    } catch (e) {
      if (kDebugMode) debugPrint('forgot-password failed: $e');
      if (e is DioException && e.response?.statusCode == 429) {
        _show(t.waitBeforeRetryingCode);
      } else {
        _show(t.loginFailedCheckBackend);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_otpController.text.trim().length != 6) {
      _show(t.enterSixDigitCode);
      return;
    }
    if (_newPasswordController.text.length < 6) {
      _show(t.passwordMinLength);
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _show(t.passwordsDoNotMatch);
      return;
    }

    setState(() => _loading = true);
    try {
      await anonApi().post(
        '/api/v2/auth/reset-password-otp',
        data: {
          'phone': _phoneController.text.trim(),
          'role': 'SALON_OWNER',
          'otp': _otpController.text.trim(),
          'newPassword': _newPasswordController.text,
        },
      );
      if (!mounted) return;
      _show(t.passwordResetSuccess);
      Navigator.of(context).pop();
    } catch (e) {
      if (kDebugMode) debugPrint('reset-password-otp failed: $e');
      if (e is DioException && e.response?.statusCode == 429) {
        _show(t.waitBeforeRetryingCode);
      } else if (e is DioException && e.response?.statusCode == 400) {
        final error = e.response?.data is Map ? e.response!.data['error'] as String? : null;
        if (error != null && error.contains('Too many attempts')) {
          _show(t.tooManyAttemptsRequestNewCode);
        } else {
          _show(t.invalidOrExpiredCode);
        }
      } else {
        _show(t.loginFailedCheckBackend);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.resetPasswordTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _step == 0 ? _buildPhoneStep() : _buildResetStep(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.resetPasswordEnterPhone, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _loading ? null : _requestCode(),
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
                      Text('${_country.flagEmoji} ${_country.dialCode}', style: const TextStyle(fontSize: 13)),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.inkFaint),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _loading ? null : _requestCode,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(t.sendCodeViaWhatsApp),
        ),
      ],
    );
  }

  Widget _buildResetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.resetPasswordEnterCode, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: t.otpCodeLabel, counterText: ''),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newPasswordController,
          obscureText: !_showPassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: t.newPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              tooltip: _showPassword ? t.hidePassword : t.showPassword,
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_showPassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _loading ? null : _resetPassword(),
          decoration: InputDecoration(
            labelText: t.confirmNewPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _loading ? null : _resetPassword,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(t.resetPasswordButton),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _loading ? null : () => setState(() => _step = 0),
              child: Text(t.changePhoneNumber),
            ),
            TextButton(
              onPressed: _loading ? null : _requestCode,
              child: Text(t.resendCode),
            ),
          ],
        ),
      ],
    );
  }
}
