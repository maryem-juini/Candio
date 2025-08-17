import 'package:get/get.dart';
import '../theme/theme_bindings.dart';

/// Initial bindings for app startup
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize theme bindings
    ThemeBindings().dependencies();

    // Add other initial bindings here
    // Example:
    // Get.lazyPut<AuthController>(() => AuthController());
    // Get.lazyPut<StorageService>(() => StorageService());
  }
}
