import 'package:flutter/material.dart';
import 'package:fotoz/services/auth_service.dart';
import 'package:fotoz/ui/screens/home_screen.dart';
import 'package:fotoz/ui/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Thanh trên cùng ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.blueGrey.withOpacity(0.1),
                      border: Border.all(color: AppTheme.blueGrey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Thử Locket Gold",
                      style: TextStyle(
                        color: AppTheme.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Nút nhóm bạn bè
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.group, color: AppTheme.darkBlue),
                      ),
                      // Nút cài đặt
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                      // Nút mũi tên quay lại Home
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- Thông tin người dùng ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? '@username',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                        Text(
                          user?.email ?? '@email_placeholder',
                          style: TextStyle(
                            color: AppTheme.blueGrey.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage('assets/logo.png') as ImageProvider,
                  ),
                ],
              ),

              const SizedBox(height: 25),
              Divider(color: AppTheme.beige.withOpacity(0.8), thickness: 0.5),

              const SizedBox(height: 15),

              const Text(
                'Ảnh của bạn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.beige.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Sắp ra mắt: Lưới ảnh của bạn',
                    style: TextStyle(color: AppTheme.blueGrey.withOpacity(0.8)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Thanh thống kê ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.beige.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppTheme.darkBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '1.157 Locket',
                      style: TextStyle(color: AppTheme.darkBlue),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '|',
                      style: TextStyle(
                        color: AppTheme.blueGrey.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: AppTheme.darkBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '0 ngày streak',
                      style: TextStyle(color: AppTheme.darkBlue),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
