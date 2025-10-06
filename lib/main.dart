import 'package:flutter/material.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/splash_screen.dart';
// import 'ui/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FotozApp());
}

class FotozApp extends StatelessWidget {
  const FotozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fotoz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
