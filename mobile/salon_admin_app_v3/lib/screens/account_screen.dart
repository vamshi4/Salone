import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/google_auth.dart';
import '../core/location.dart';
import '../core/prefs.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_scope.dart';
import '../core/locale_controller.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/option_picker_sheet.dart';
import '../widgets/theme_color_picker_sheet.dart';

/// Account tab — replaces v2's app-bar icons (account-settings sheet +
/// logout icon) with a proper screen. Profile/security fields are the same
/// `/api/v2/auth/me` + change-password endpoints as v2's
/// `_AccountSettingsSheet`. Theme color, country/currency, and language are
/// new — all three are device-local only (see docs/GLOBAL-READINESS.md),
/// not backend fields yet, so changing them here doesn't sync across
/// devices or change what the backend charges/displays server-side.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _salonNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = true;
  bool _savingProfile = false;
  bool _savingPassword = false;
  bool _linkingGoogle = false;
  bool _showPasswords = false;
  bool _locating = false;
  double? _lat;
  double? _lng;
  String _joined = '';
  String _plan = 'FREE';

  CountryOption _country = kCountries.first;
  LanguageOption _language = kLanguages.first;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _load();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final countryCode = await AppPrefs.getCountryCode();
    final languageCode = await AppPrefs.getLanguageCode();
    if (mounted) {
      setState(() {
        _country = countryByCode(countryCode);
        _language = languageByCode(languageCode);
      });
    }
  }

  Future<void> _load() async {
    try {
      final res = await api().get('/api/v2/auth/me');
      final user = Map<String, dynamic>.from(res.data['user'] ?? {});
      final salon = Map<String, dynamic>.from(res.data['salon'] ?? {});
      _ownerNameController.text = '${user['name'] ?? ''}';
      _phoneController.text = '${user['phone'] ?? ''}';
      _emailController.text = '${user['email'] ?? ''}';
      _salonNameController.text = '${salon['name'] ?? ''}';
      _addressController.text = '${salon['address'] ?? ''}';
      _plan = '${salon['saasPlan'] ?? 'FREE'}';
      final createdAt = user['createdAt'];
      _joined = createdAt is String ? formatFullDate(DateTime.parse(createdAt)) : '';
    } catch (e) {
      if (kDebugMode) debugPrint('Account load failed: $e');
      _show(t.couldNotLoadAccount);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    try {
      final loc = await pickCurrentLocation();
      if (loc == null) {
        _show(t.turnOnLocationPermission);
        return;
      }
      setState(() {
        _lat = loc.lat;
        _lng = loc.lng;
        if (loc.address.isNotEmpty) _addressController.text = loc.address;
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Location failed: $e');
      _show(t.couldNotGetLocation);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _saveProfile() async {
    final ownerName = _ownerNameController.text.trim();
    final phone = _phoneController.text.trim();
    final salonName = _salonNameController.text.trim();
    final address = _addressController.text.trim();
    if (ownerName.length < 2 || phone.length < 6 || salonName.length < 2 || address.length < 5) {
      _show(t.fillOwnerPhoneSalonAddress);
      return;
    }

    setState(() => _savingProfile = true);
    try {
      await api().patch('/api/v2/auth/me', data: {
        'ownerName': ownerName,
        'phone': phone,
        'email': _emailController.text.trim(),
        'salonName': salonName,
        'address': address,
        if (_lat != null) 'lat': _lat,
        if (_lng != null) 'lng': _lng,
      });
      if (mounted) await DashboardScope.of(context).load();
      _show(t.accountUpdated);
    } catch (e) {
      if (kDebugMode) debugPrint('Account save failed: $e');
      if (e is DioException && e.response?.statusCode == 409) {
        _show(t.phoneOrEmailUsed);
      } else {
        _show(t.couldNotSaveAccount);
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    final current = _currentPasswordController.text;
    final next = _newPasswordController.text;
    if (next.length < 6) {
      _show(t.newPasswordMinLength);
      return;
    }
    if (next != _confirmPasswordController.text) {
      _show(t.newPasswordsDontMatch);
      return;
    }
    setState(() => _savingPassword = true);
    try {
      await api().post('/api/v2/auth/change-password', data: {'currentPassword': current, 'newPassword': next});
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _show(t.passwordChanged);
    } catch (e) {
      if (kDebugMode) debugPrint('Password change failed: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        _show(t.currentPasswordIncorrect);
      } else {
        _show(t.couldNotChangePassword);
      }
    } finally {
      if (mounted) setState(() => _savingPassword = false);
    }
  }

  Future<void> _linkGoogle() async {
    setState(() => _linkingGoogle = true);
    try {
      final idToken = await signInWithGoogleIdToken();
      if (idToken == null) return; // user cancelled the picker
      await api().post('/api/v2/auth/link-google', data: {'idToken': idToken});
      _show(t.googleAccountLinked);
    } on GoogleAuthNotConfiguredError {
      _show(t.googleSignInNotConfigured);
    } catch (e) {
      if (kDebugMode) debugPrint('Google link failed: $e');
      _show(t.googleSignInFailed);
    } finally {
      if (mounted) setState(() => _linkingGoogle = false);
    }
  }

  Future<void> _pickThemeColor() async {
    final result = await showModalBottomSheet<AppColorSeed>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemeColorPickerSheet(initial: ThemeController.instance.seed),
    );
    if (result != null) {
      ThemeController.instance.select(result);
      await AppPrefs.setThemeColorId(result.id);
    }
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<CountryOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet<CountryOption>(
        title: t.countryAndCurrency,
        options: kCountries,
        labelOf: (c) => '${c.flagEmoji}  ${c.name} · ${c.currencyCode}',
        isSelected: (c) => c.code == _country.code,
      ),
    );
    if (selected != null) {
      setState(() => _country = selected);
      await AppPrefs.setCountryCode(selected.code);
      CurrencyController.instance.applyCountry(selected.code);
      try {
        await api().patch('/api/v2/auth/me', data: {
          'countryCode': selected.code,
          'currency': selected.currencyCode,
        });
        if (mounted) await DashboardScope.of(context).load();
      } catch (e) {
        if (kDebugMode) debugPrint('Country/currency sync failed: $e');
        // Local prefs already reflect the choice either way; the salon
        // record will just be out of date until the next successful sync.
      }
    }
  }

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
      final country = countryByCode(selected.defaultCountryCode);
      setState(() {
        _language = selected;
        _country = country;
      });
      await AppPrefs.setLanguageCode(selected.code);
      await AppPrefs.setCountryCode(country.code);
      LocaleController.instance.applyLoaded(selected.code);
      CurrencyController.instance.applyCountry(country.code);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salonNameController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
                children: [
                  Text(t.accountTitle, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.accentSoft,
                        child: Text(
                          _salonNameController.text.isEmpty ? '?' : _salonNameController.text.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_salonNameController.text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            if (_joined.isNotEmpty)
                              Text(t.ownerSinceDate(_joined), style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.planLabel(_plan), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              Text(t.retentionFreeFor6Months,
                                  style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                            ],
                          ),
                        ),
                        if (_plan.toUpperCase() == 'FREE') StatusPill(label: t.upgrade),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(t.appearance, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _row(
                    icon: null,
                    leading: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(color: ThemeController.instance.seed.color, shape: BoxShape.circle),
                    ),
                    label: t.themeColorTitle,
                    value: colorSeedLabel(t, ThemeController.instance.seed.id),
                    onTap: _pickThemeColor,
                  ),
                  const SizedBox(height: 20),
                  Text(t.salonProfile, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ownerNameController,
                    decoration: InputDecoration(labelText: t.ownerNameLabel, prefixIcon: const Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: t.phoneNumberLabel, prefixIcon: const Icon(Icons.phone_outlined)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: t.emailLabel, prefixIcon: const Icon(Icons.mail_outline)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _salonNameController,
                    decoration: InputDecoration(labelText: t.salonNameLabel, prefixIcon: const Icon(Icons.storefront_outlined)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _addressController,
                    minLines: 1,
                    maxLines: 2,
                    decoration: InputDecoration(labelText: t.salonAddressLabel, prefixIcon: const Icon(Icons.location_on_outlined)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _locating ? null : _useMyLocation,
                      icon: _locating
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(_lat != null ? Icons.check_circle : Icons.my_location,
                              size: 18, color: _lat != null ? AppColors.success : AppColors.accent),
                      label: Text(_lat != null ? t.locationUpdated : t.useMyCurrentLocation),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _row(icon: Icons.public, label: t.countryAndCurrency, value: '${_country.name} · ${_country.currencySymbol} ${_country.currencyCode}', onTap: _pickCountry),
                  const SizedBox(height: 8),
                  _row(icon: Icons.translate, label: t.language, value: _language.label, onTap: _pickLanguage),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('account_save_profile'),
                      onPressed: _savingProfile ? null : _saveProfile,
                      icon: _savingProfile
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_outlined),
                      label: Text(_savingProfile ? t.savingEllipsis : t.saveDetailsButton),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(t.security, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: !_showPasswords,
                    decoration: InputDecoration(
                      labelText: t.currentPasswordLabel,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_showPasswords ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _showPasswords = !_showPasswords),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_showPasswords,
                    decoration: InputDecoration(labelText: t.newPasswordLabel, prefixIcon: const Icon(Icons.password_outlined)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showPasswords,
                    decoration: InputDecoration(labelText: t.confirmNewPasswordLabel, prefixIcon: const Icon(Icons.verified_user_outlined)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const Key('account_change_password'),
                      onPressed: _savingPassword ? null : _changePassword,
                      icon: const Icon(Icons.lock_reset),
                      label: Text(_savingPassword ? t.changingEllipsis : t.changePasswordButton),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const Key('account_link_google'),
                      onPressed: _linkingGoogle ? null : _linkGoogle,
                      icon: const Icon(Icons.link),
                      label: Text(_linkingGoogle ? t.changingEllipsis : t.linkGoogleAccount),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.onLogout,
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: Color(0xFFF09595))),
                      icon: const Icon(Icons.logout),
                      label: Text(t.signOut),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _row({IconData? icon, Widget? leading, required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: cardDecoration(),
        child: Row(
          children: [
            leading ?? Icon(icon, color: AppColors.inkMuted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                  Text(value, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
