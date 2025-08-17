import 'package:get/get.dart';
import '../routes/app_routes.dart';

class WelcomeController extends GetxController {
  void onSignInPressed() {
    Get.toNamed(AppRoutes.signIn);
  }

  void onSignUpPressed() {
    Get.toNamed(AppRoutes.onboarding);
  }

  void onGoogleSignInPressed() {
    // TODO: Implement Google Sign In
    Get.snackbar(
      'Coming Soon',
      'Google Sign In will be implemented soon!',
      snackPosition: SnackPosition.TOP,
    );
  }

  void onAppleSignInPressed() {
    // TODO: Implement Apple Sign In
    Get.snackbar(
      'Coming Soon',
      'Apple Sign In will be implemented soon!',
      snackPosition: SnackPosition.TOP,
    );
  }
}
