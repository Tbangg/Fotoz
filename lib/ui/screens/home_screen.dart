import 'package:flutter/material.dart';
import 'package:fotoz/services/auth_service.dart';
import 'package:fotoz/ui/theme/app_theme.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Hello, ${user?.email ?? 'user'}",
          style: TextStyle(fontSize: 22, color: AppTheme.darkBlue),
        ),
      ),
    );
  }
}
