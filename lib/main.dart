import 'package:flutter/material.dart';
import 'package:fotoz/ui/screens/auth.wrapper.dart';
import 'package:fotoz/ui/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:developer';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log("Firebase initialized successfully!");
    }
  } catch (e) {
    log("Failed to initialize Firebase: $e");
  }

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
      home: const AuthWrapper(),
    );
  }
}
