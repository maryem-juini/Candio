import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/index.dart';
import '../../../widgets/index.dart';
// import '../../routes/app_routes.dart'; // Removed unused import
import '../../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.flutter_dash,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),

            // App name
            CustomText.title('kanz App', color: Colors.white),
            const SizedBox(height: 8),

            // App description
            CustomText.body(
              'Your amazing app description',
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 60),

            // Loading indicator
            Obx(
              () =>
                  controller.isLoading.value
                      ? Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomText.body(
                            'Loading...',
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ],
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
