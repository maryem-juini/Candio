import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  // Form keys
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Validation functions
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Sign in method
  Future<void> signIn() async {
    if (signInFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // TODO: Add your actual sign-in logic here
        // Example: await authService.signIn(emailController.text, passwordController.text);

        Get.snackbar(
          'Success',
          'Signed in successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home and clear the navigation stack
        Get.offAllNamed(AppRoutes.home);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Sign in failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Sign up method
  Future<void> signUp() async {
    if (signUpFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // TODO: Add your actual sign-up logic here
        // Example: await authService.signUp(nameController.text, emailController.text, passwordController.text);

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to sign in page
        Get.offAllNamed(AppRoutes.signIn);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Sign up failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Navigate to sign up page
  void goToSignUp() {
    Get.toNamed(AppRoutes.signUp);
  }

  // Navigate to sign in page
  void goToSignIn() {
    Get.toNamed(AppRoutes.signIn);
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Clear form data
  void clearSignInForm() {
    emailController.clear();
    passwordController.clear();
  }

  void clearSignUpForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
