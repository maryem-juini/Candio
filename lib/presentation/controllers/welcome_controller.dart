import 'package:get/get.dart';
import '../routes/app_routes.dart';

class WelcomeController extends GetxController {
  void onSignInPressed() {
    Get.toNamed(AppRoutes.login);
  }

  void onSignUpPressed() {
    Get.toNamed(AppRoutes.onboarding);
  }

  void onGoogleSignInPressed() {
    Get.snackbar(
      'Coming Soon',
      'Google Sign In will be implemented soon!',
      snackPosition: SnackPosition.TOP,
    );
  }

  void onAppleSignInPressed() {
    Get.snackbar(
      'Coming Soon',
      'Apple Sign In will be implemented soon!',
      snackPosition: SnackPosition.TOP,
    );
  }
}
