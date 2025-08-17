import 'package:get/get.dart';
import 'theme_controller.dart';

/// Bindings for theme-related dependencies
class ThemeBindings extends Bindings {
  @override
  void dependencies() {
    // Register theme controller as a singleton
    Get.lazyPut<ThemeController>(
      () => ThemeController(),
      fenix: true, // Keep the controller alive even when not in use
    );
  }
}
