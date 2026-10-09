import 'package:google_sign_in/google_sign_in.dart';

const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

class GoogleAuthNotConfiguredError implements Exception {}

final _googleSignIn = GoogleSignIn(
  serverClientId: googleServerClientId.isEmpty ? null : googleServerClientId,
);

Future<String?> signInWithGoogleIdToken() async {
  if (googleServerClientId.isEmpty) throw GoogleAuthNotConfiguredError();
  await _googleSignIn.signOut();
  final account = await _googleSignIn.signIn();
  if (account == null) return null;
  return (await account.authentication).idToken;
}

Future<void> signOutGoogle() async {
  if (googleServerClientId.isNotEmpty) await _googleSignIn.signOut();
}
