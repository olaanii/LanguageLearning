import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

FirebaseOptions firebaseOptionsFromEnv() {
  // Web-only Firebase options. Provide values via `--dart-define=...` so
  // secrets are not committed to Git.
  const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  const appId = String.fromEnvironment('FIREBASE_APP_ID');
  const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

  if (!kIsWeb || apiKey.isEmpty) {
    throw StateError(
      'Missing Firebase web env vars. '
      'Set --dart-define=FIREBASE_API_KEY=... and the other FIREBASE_* values.',
    );
  }

  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: authDomain,
    storageBucket: storageBucket,
  );
}
