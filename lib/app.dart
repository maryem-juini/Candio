import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/index.dart';
import 'core/config/index.dart';
import 'core/theme/index.dart';
import 'domain/repositories/index.dart';
import 'presentation/routes/index.dart';

/// Main app widget with customizable theme and navigation setup
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App title - easily customizable
      title: AppConfig.appName,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Theme mode - controlled by ThemeController
      themeMode:
          ThemeMode
              .system, // Can be changed to ThemeMode.light, ThemeMode.dark, or ThemeMode.system
      // Initial bindings for app startup
      initialBinding: InitialBindings(),

      // Route configuration
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // Navigation settings
      defaultTransition: _getTransition(),

      // Debug banner
      debugShowCheckedModeBanner: AppConfig.showDebugBanner,

      // Error handling
      onUnknownRoute: (settings) {
        return GetPageRoute(page: () => const _ErrorPage(), settings: settings);
      },

      // Builder for custom theme handling
      builder: (context, child) {
        // Get the theme controller
        final themeController = Get.find<ThemeController>();

        // Return the app with reactive theme
        return Obx(() {
          // Update the theme based on controller state
          final currentTheme =
              themeController.isDarkMode
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme;

          // Apply theme to the existing MaterialApp
          return Theme(
            data: currentTheme,
            child: child ?? const SizedBox.shrink(),
          );
        });
      },
    );
  }

  /// Get transition based on configuration
  Transition _getTransition() {
    switch (AppConfig.defaultTransition.toLowerCase()) {
      case 'fadein':
        return Transition.fadeIn;
      case 'slide':
        return Transition.rightToLeft;
      case 'scale':
        return Transition.zoom;
      case 'rotation':
        return Transition.circularReveal;
      case 'cupertino':
        return Transition.cupertino;
      default:
        return Transition.noTransition;
    }
  }
}

/// Error page for unknown routes
class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  void _navigateToMainView() async {
    try {
      // Try to get the current user from the auth repository
      final authRepository = Get.find<AuthRepository>();
      final currentUser = await authRepository.getCurrentUser();

      if (currentUser != null) {
        // User is authenticated, navigate to main view based on role
        if (currentUser.role == 'candidate') {
          Get.offAllNamed(AppRoutes.candidateMain);
        } else if (currentUser.role == 'hr') {
          Get.offAllNamed(AppRoutes.hrMain);
        } else {
          // Fallback to auth if role is not recognized
          Get.offAllNamed(AppRoutes.auth);
        }
      } else {
        // User is not authenticated, go to auth
        Get.offAllNamed(AppRoutes.auth);
      }
    } catch (e) {
      // If there's an error, default to auth
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Page Not Found', style: AppTheme.body1Medium),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: AppTheme.body1Medium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _navigateToMainView(),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
