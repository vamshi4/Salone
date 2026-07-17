import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/google_auth.dart';
import '../core/locale_controller.dart';
import '../core/location.dart';
import '../core/prefs.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/google_icon.dart';
import '../widgets/option_picker_sheet.dart';

/// Three-step signup: (1) country/language/phone/password — country drives
/// the default currency and dial code (see docs/GLOBAL-READINESS.md), (2)
/// salon details, (3) pick a theme color. All three steps end with a single
/// POST to the existing `/api/v2/auth/salon-signup` endpoint — country,
/// language, and theme color are saved locally via [AppPrefs] only, since
/// the backend doesn't have fields for them yet.
class SignupFlow extends StatefulWidget {
  const SignupFlow({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<SignupFlow> createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlow> {
  final _pageController = PageController();
  int _step = 0;

  // Step 1
  CountryOption _country = kCountries.first;
  LanguageOption _language = kLanguages.first;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _googleIdToken;
  String? _googleEmail;
  bool _googleLoading = false;

  // Step 2
  final _ownerNameController = TextEditingController();
  final _salonNameController = TextEditingController();
  final _addressController = TextEditingController();
  double? _lat;
  double? _lng;
  bool _locating = false;

  // Step 3
  AppColorSeed _colorSeed = kAppColorSeeds.first;

  bool _saving = false;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ownerNameController.dispose();
    _salonNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onCountryChanged(CountryOption country) {
    setState(() {
      _country = country;
      _language = languageByCode(country.defaultLanguageCode);
    });
  }

  bool _validateStep1() {
    if (_phoneController.text.trim().length < 6) {
      _show(t.enterPhoneNumber);
      return false;
    }
    if (_googleIdToken == null && _passwordController.text.length < 6) {
      _show(t.passwordMinLength);
      return false;
    }
    return true;
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _googleLoading = true);
    try {
      final idToken = await signInWithGoogleIdToken();
      if (idToken == null) return; // user cancelled the picker
      // Decoding the JWT payload just to prefill the UI (email chip, owner
      // name); the backend independently verifies the token itself, so a
      // failure to decode here just means those fields stay blank.
      final payload = _decodeIdTokenPayload(idToken);
      setState(() {
        _googleIdToken = idToken;
        _googleEmail = payload?['email'] as String?;
      });
      final name = payload?['name'] as String?;
      if (name != null && name.trim().isNotEmpty && _ownerNameController.text.trim().isEmpty) {
        _ownerNameController.text = name.trim();
      }
    } on GoogleAuthNotConfiguredError {
      _show(t.googleSignInNotConfigured);
    } catch (e) {
      if (kDebugMode) debugPrint('Google sign-in failed: $e');
      _show(t.googleSignInFailed);
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Map<String, dynamic>? _decodeIdTokenPayload(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return null;
      final normalized = base64Url.normalize(parts[1]);
      return jsonDecode(utf8.decode(base64Url.decode(normalized))) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  void _useCredentialsInstead() {
    setState(() {
      _googleIdToken = null;
      _googleEmail = null;
    });
  }

  bool _validateStep2() {
    if (_ownerNameController.text.trim().length < 2 ||
        _salonNameController.text.trim().length < 2 ||
        _addressController.text.trim().length < 5) {
      _show(t.fillOwnerSalonAddress);
      return false;
    }
    return true;
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

  void _next() {
    if (_step == 0 && !_validateStep1()) return;
    if (_step == 1 && !_validateStep2()) return;
    if (_step == 2) {
      _submit();
      return;
    }
    setState(() => _step += 1);
    _pageController.animateToPage(_step,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _step -= 1);
    _pageController.animateToPage(_step,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final res = await anonApi().post(
        '/api/v2/auth/salon-signup',
        data: {
          'ownerName': _ownerNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          if (_googleIdToken != null)
            'googleIdToken': _googleIdToken
          else
            'password': _passwordController.text,
          'salonName': _salonNameController.text.trim(),
          'address': _addressController.text.trim(),
          if (_lat != null) 'lat': _lat,
          if (_lng != null) 'lng': _lng,
          'countryCode': _country.code,
          'currency': _country.currencyCode,
        },
      );
      await saveAuthToken(res.data['token'] as String);

      // Country/language/theme have no backend fields yet — save locally.
      await AppPrefs.setCountryCode(_country.code);
      await AppPrefs.setLanguageCode(_language.code);
      await AppPrefs.setThemeColorId(_colorSeed.id);
      CurrencyController.instance.applyCountry(_country.code);
      LocaleController.instance.applyLoaded(_language.code);
      ThemeController.instance.select(_colorSeed);

      widget.onSignedIn();
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (kDebugMode) debugPrint('Salon admin signup failed: $e');
      if (e is DioException && e.response?.statusCode == 409) {
        _show(t.phoneAlreadyRegisteredSignIn);
      } else if (e is DioException) {
        _show(t.signupFailedCheckBackend);
      } else {
        _show(t.signupFailedTryAgain);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back),
        title: Text(t.stepOfTotal(_step + 1, 3)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _step1(),
                  _step2(),
                  _step3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FilledButton(
                onPressed: _saving ? null : _next,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_step == 2 ? t.createAccountButton : t.continueButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.createYourAccount, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(t.basics, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Text(t.country, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: _pickCountry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Text(_country.flagEmoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_country.name)),
                  Text('${_country.currencyCode} · ${_country.currencySymbol} · ${_country.dialCode}',
                      style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.inkFaint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(t.countryHelperText,
              style: const TextStyle(color: AppColors.inkFaint, fontSize: 11)),
          const SizedBox(height: 18),
          Text(t.language, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: _pickLanguage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(_language.label)),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.inkFaint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            key: const Key('signup_phone'),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: t.phoneNumberLabel,
              prefixIcon: SizedBox(
                width: 56,
                child: Center(child: Text(_country.dialCode, style: const TextStyle(fontSize: 13))),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (_googleIdToken != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.accent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _googleEmail == null
                          ? t.signedInWithGoogle
                          : t.signedInWithGoogleAs(_googleEmail!),
                    ),
                  ),
                  TextButton(onPressed: _useCredentialsInstead, child: Text(t.usePasswordInstead)),
                ],
              ),
            )
          else ...[
            TextField(
              key: const Key('signup_password'),
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: t.passwordLabel,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: const Key('signup_google'),
              onPressed: _googleLoading ? null : _signInWithGoogle,
              icon: _googleLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const GoogleIcon(),
              label: Text(t.continueWithGoogle),
            ),
          ],
        ],
      ),
    );
  }

  Widget _step2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.yourSalon, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(t.salonDetailsSubtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          TextField(
            key: const Key('signup_owner_name'),
            controller: _ownerNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: t.ownerNameLabel, prefixIcon: const Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('signup_salon_name'),
            controller: _salonNameController,
            textInputAction: TextInputAction.next,
            decoration:
                InputDecoration(labelText: t.salonNameLabel, prefixIcon: const Icon(Icons.storefront_outlined)),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('signup_address'),
            controller: _addressController,
            minLines: 1,
            maxLines: 2,
            decoration:
                InputDecoration(labelText: t.salonAddressLabel, prefixIcon: const Icon(Icons.location_on_outlined)),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _locating ? null : _useMyLocation,
              icon: _locating
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_lat != null ? Icons.check_circle : Icons.my_location,
                      size: 18, color: _lat != null ? AppColors.success : AppColors.accent),
              label: Text(_lat != null ? t.locationSet : t.useMyCurrentLocation),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.pickYourColor, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            t.colorPreviewHelp,
            style: const TextStyle(color: AppColors.inkMuted),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (final seed in kAppColorSeeds) _colorSwatch(seed)],
          ),
          const SizedBox(height: 28),
          Text(t.previewLabel, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: cardDecoration(),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.periodToday, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                            const SizedBox(height: 2),
                            const Text('6', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.periodWeek, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text(formatMoney(513000), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _colorSeed.color),
                    onPressed: () {},
                    child: Text(t.newBooking),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorSwatch(AppColorSeed seed) {
    final selected = seed.id == _colorSeed.id;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _colorSeed = seed),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: seed.color,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: seed.color, width: 2) : null,
              boxShadow: selected
                  ? [BoxShadow(color: seed.color.withValues(alpha: 0.25), blurRadius: 0, spreadRadius: 3)]
                  : null,
            ),
            child: selected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(colorSeedLabel(t, seed.id), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
      ],
    );
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<CountryOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet<CountryOption>(
        title: t.country,
        options: kCountries,
        labelOf: (c) => '${c.flagEmoji}  ${c.name}',
        isSelected: (c) => c.code == _country.code,
      ),
    );
    if (selected != null) _onCountryChanged(selected);
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
      setState(() {
        _language = selected;
        _country = countryByCode(selected.defaultCountryCode);
      });
    }
  }
}
