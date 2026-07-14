import 'package:google_sign_in/google_sign_in.dart';

/// The Web OAuth client ID from Google Cloud Console — must match the
/// backend's GOOGLE_CLIENT_ID env var, since that's the audience it verifies
/// the ID token against. Passed at build/run time
/// (`--dart-define=GOOGLE_SERVER_CLIENT_ID=...`), same pattern as API_URL in
/// api.dart, so nothing here needs editing once the value exists — see
/// docs/HANDOFF.md for how to obtain it.
const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

class GoogleAuthNotConfiguredError implements Exception {}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: googleServerClientId.isEmpty ? null : googleServerClientId,
);

/// Runs the native Google account picker and returns the ID token to send to
/// the backend. Returns null if the user closed the picker without choosing
/// an account (not an error — just don't proceed). Throws
/// [GoogleAuthNotConfiguredError] if the app wasn't built with a server
/// client ID yet.
///
/// Signs out of any cached Google session first — otherwise `signIn()`
/// silently re-authenticates with whichever account was last used instead of
/// showing the picker, which is a real problem for anyone (like a salon
/// owner) with more than one Google account on their phone.
Future<String?> signInWithGoogleIdToken() async {
  if (googleServerClientId.isEmpty) throw GoogleAuthNotConfiguredError();
  await _googleSignIn.signOut();
  final account = await _googleSignIn.signIn();
  if (account == null) return null;
  final auth = await account.authentication;
  return auth.idToken;
}

Future<void> signOutGoogle() async {
  if (googleServerClientId.isEmpty) return;
  await _googleSignIn.signOut();
}
