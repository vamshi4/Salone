import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onAuthenticated});
  final VoidCallback onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _signup = false;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_phone.text.trim().length < 6 || _password.text.length < 6 ||
        (_signup && _name.text.trim().length < 2)) {
      _show('Enter valid account details. Password must be at least 6 characters.');
      return;
    }
    setState(() => _loading = true);
    try {
      if (_signup) {
        await ApiClient.signup(_name.text.trim(), _phone.text.trim(), _password.text);
      } else {
        await ApiClient.login(_phone.text.trim(), _password.text);
      }
      widget.onAuthenticated();
    } on DioException catch (e) {
      _show(e.response?.data?['error']?.toString() ?? 'Could not connect. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Icon(Icons.content_cut, size: 42, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(_signup ? 'Create your GlamBook account' : 'Welcome to GlamBook',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(_signup ? 'Book salons and stylists with one account.' : 'Sign in to manage your bookings.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF625B6B), fontWeight: FontWeight.w600)),
                const SizedBox(height: 28),
                if (_signup) ...[
                  TextField(controller: _name, textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline))),
                  const SizedBox(height: 12),
                ],
                TextField(controller: _phone, keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined))),
                const SizedBox(height: 12),
                TextField(controller: _password, obscureText: _obscure,
                    decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
                const SizedBox(height: 20),
                FilledButton(onPressed: _loading ? null : _submit,
                    child: Text(_loading ? 'Please wait…' : (_signup ? 'Create account' : 'Sign in'))),
                TextButton(onPressed: _loading ? null : () => setState(() => _signup = !_signup),
                    child: Text(_signup ? 'Already have an account? Sign in' : 'New customer? Create account')),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
