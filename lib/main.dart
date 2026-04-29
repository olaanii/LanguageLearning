import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'core/theme/app_theme.dart';
import 'core/config/firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/state/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Keep Firebase secrets out of the repository.
  // - Web: options come from `--dart-define` (env).
  // - Android/iOS: Firebase is initialized from platform config.
  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseOptionsFromEnv());
  } else {
    await Firebase.initializeApp();
  }

  await di.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>())],
      child: const LinguaLearnApp(),
    ),
  );
}

class LinguaLearnApp extends StatelessWidget {
  const LinguaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LinguaLearn',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
