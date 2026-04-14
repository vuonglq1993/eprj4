import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/token_service.dart';
import '../splash/splash_screen.dart';

/// Placeholder — Flow 2 sẽ thay thế màn hình này.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.layers_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'LinguaNext',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: AppColors.textSecondary, size: 22),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              await TokenService.clearTokens();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (r) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.construction_rounded,
                  size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Home Screen',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flow 2 sẽ được xây dựng tiếp theo...',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
