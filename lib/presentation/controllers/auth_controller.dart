import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthController(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._forgotPasswordUseCase,
    this._getCurrentUserUseCase,
  );

  // Observable variables
  final isLoading = false.obs;
  final currentUser = Rxn<UserEntity>();
  final errorMessage = ''.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Form controllers
  final signUpFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Only check current user without auto-navigation
    checkCurrentUser(shouldNavigate: false);
  }

  // Helper method to safely dispose a controller
  void _safeDispose(TextEditingController controller) {
    try {
      controller.dispose();
    } catch (e) {
      // Controller already disposed
    }
  }

  @override
  void onClose() {
    _safeDispose(nameController);
    _safeDispose(emailController);
    _safeDispose(passwordController);
    _safeDispose(confirmPasswordController);
    super.onClose();
  }

  Future<void> checkCurrentUser({bool shouldNavigate = true}) async {
    try {
      isLoading.value = true;
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        currentUser.value = user;
        if (shouldNavigate) {
          navigateBasedOnRole(user.role);
        }
      }
    } catch (e) {
      errorMessage.value = 'Failed to check current user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn() async {
    if (!_validateSignInForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _signInUseCase(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        currentUser.value = user;
        navigateBasedOnRole(user.role);
        _clearForm();
      } else {
        errorMessage.value = 'Invalid email or password';
      }
    } catch (e) {
      errorMessage.value = 'Sign in failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _signOutUseCase();
      currentUser.value = null;
      _clearForm();
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      errorMessage.value = 'Sign out failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    final emailText = _getControllerText(emailController);
    if (emailText == null) {
      errorMessage.value = 'Form error';
      return;
    }

    if (emailText.trim().isEmpty) {
      errorMessage.value = 'Please enter your email address';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _forgotPasswordUseCase(emailText.trim());

      Get.snackbar(
        'Password Reset',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send reset email: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void navigateBasedOnRole(String role) {
    switch (role.toLowerCase()) {
      case 'candidate':
        Get.offAllNamed(AppRoutes.candidateMain);
        break;
      case 'hr':
        Get.offAllNamed(AppRoutes.hrMain);
        break;
      default:
        Get.offAllNamed(AppRoutes.auth);
    }
  }

  bool _validateSignInForm() {
    final emailText = _getControllerText(emailController);
    final passwordText = _getControllerText(passwordController);

    if (emailText == null || passwordText == null) {
      errorMessage.value = 'Form validation error';
      return false;
    }

    if (emailText.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (passwordText.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    return true;
  }

  void _clearForm() {
    try {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      errorMessage.value = '';
    } catch (e) {
      // Controllers might be disposed, ignore the error
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper method to safely get controller text
  String? _getControllerText(TextEditingController controller) {
    try {
      return controller.text;
    } catch (e) {
      return null;
    }
  }

  // Navigation methods
  void goToSignIn() {
    Get.offAllNamed('/auth/signin');
  }

  void goToSignUp() {
    Get.offAllNamed('/auth/signup');
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    final passwordText = _getControllerText(passwordController);
    if (passwordText == null) return null; // Controller disposed
    if (value != passwordText) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Sign up method for the form
  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    final nameText = _getControllerText(nameController);
    final emailText = _getControllerText(emailController);
    final passwordText = _getControllerText(passwordController);

    if (nameText == null || emailText == null || passwordText == null) {
      errorMessage.value = 'Form error';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userData = UserEntity(
        uid: '',
        name: nameText.trim(),
        email: emailText.trim(),
        phone: '',
        role: 'candidate', // Default role for sign up
      );

      final user = await _signUpUseCase(
        emailText.trim(),
        passwordText,
        userData,
      );

      if (user != null) {
        currentUser.value = user;
        navigateBasedOnRole(user.role);
        _clearForm();
      } else {
        errorMessage.value = 'Failed to create account';
      }
    } catch (e) {
      errorMessage.value = 'Sign up failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
