import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  // Page controller for the page view
  final PageController pageController = PageController();

  // Current page index
  final RxInt currentPage = 0.obs;

  // Total number of pages
  final int totalPages = 6; // name, age, gender, country, city, success

  // Form data
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxInt age = 0.obs;
  final RxString gender = ''.obs;
  final RxString country = ''.obs;
  final RxString city = ''.obs;

  // Validation states
  final RxBool isNameValid = false.obs;
  final RxBool isAgeValid = false.obs;
  final RxBool isGenderValid = false.obs;
  final RxBool isCountryValid = false.obs;
  final RxBool isCityValid = false.obs;

  // User creation simulation
  final RxBool isCreatingUser = false.obs;

  // Gender options
  final List<Map<String, dynamic>> genderOptions = [
    {'value': 'male', 'title': 'Male', 'icon': Icons.male},
    {'value': 'female', 'title': 'Female', 'icon': Icons.female},
    {'value': 'other', 'title': 'Other', 'icon': Icons.person},
  ];

  // Country options
  final List<Map<String, dynamic>> countryOptions = [
    {
      'value': 'fr',
      'title': 'France',
      'subtitle': 'French Republic',
      'icon': Icons.flag,
    },
    {
      'value': 'en',
      'title': 'England',
      'subtitle': 'United Kingdom',
      'icon': Icons.flag,
    },
    {
      'value': 'tn',
      'title': 'Tunisia',
      'subtitle': 'Tunisian Republic',
      'icon': Icons.flag,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Listen to page changes
    pageController.addListener(_onPageChanged);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _onPageChanged() {
    if (pageController.page != null) {
      currentPage.value = pageController.page!.round();
      // Dismiss keyboard when page changes
      _dismissKeyboard();
    }
  }

  /// Dismiss keyboard by unfocusing current focus
  void _dismissKeyboard() {
    FocusScope.of(Get.context!).unfocus();
  }

  /// Get progress percentage (0.0 to 1.0)
  double get progress => (currentPage.value + 1) / totalPages;

  /// Check if current page is valid
  bool get isCurrentPageValid {
    switch (currentPage.value) {
      case 0: // Name page
        return isNameValid.value;
      case 1: // Age page
        return isAgeValid.value;
      case 2: // Gender page
        return isGenderValid.value;
      case 3: // Country page
        return isCountryValid.value;
      case 4: // City page
        return isCityValid.value;
      default:
        return true;
    }
  }

  /// Update first name and validate
  void updateFirstName(String value) {
    firstName.value = value;
    _validateName();
  }

  /// Update last name and validate
  void updateLastName(String value) {
    lastName.value = value;
    _validateName();
  }

  /// Update age and validate
  void updateAge(String value) {
    final ageValue = int.tryParse(value);
    age.value = ageValue ?? 0;
    isAgeValid.value = ageValue != null && ageValue > 0 && ageValue <= 120;
  }

  /// Select gender
  void selectGender(String value) {
    gender.value = value;
    isGenderValid.value = value.isNotEmpty;
  }

  /// Select country
  void selectCountry(String value) {
    country.value = value;
    isCountryValid.value = value.isNotEmpty;
  }

  /// Update city and validate
  void updateCity(String value) {
    city.value = value;
    isCityValid.value = value.trim().isNotEmpty;
  }

  /// Validate name fields
  void _validateName() {
    isNameValid.value =
        firstName.value.trim().isNotEmpty && lastName.value.trim().isNotEmpty;
  }

  /// Go to next page
  void nextPage() {
    if (currentPage.value < totalPages - 1 && isCurrentPageValid) {
      // Dismiss keyboard before navigation
      _dismissKeyboard();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Go to previous page
  void previousPage() {
    if (currentPage.value > 0) {
      // Dismiss keyboard before navigation
      _dismissKeyboard();
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Go back to welcome page
  void goBack() {
    Get.back();
  }

  /// Simulate user creation process
  Future<void> _simulateUserCreation() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate user data processing
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate database save
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Complete onboarding with user creation simulation
  Future<void> completeOnboarding() async {
    if (isCreatingUser.value) return; // Prevent multiple calls

    isCreatingUser.value = true;

    try {
      // Show loading snackbar
      Get.snackbar(
        'Creating your profile...',
        'Please wait while we set up your account',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.white.withOpacity(0.3),
        progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
      );

      // Simulate user creation process
      await _simulateUserCreation();

      // Show success message
      Get.snackbar(
        'Welcome!',
        'Your profile has been created successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home page after a short delay
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      // Handle any errors
      Get.snackbar(
        'Error',
        'Failed to create profile. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingUser.value = false;
    }
  }

  /// Get page title based on current page
  String get currentPageTitle {
    switch (currentPage.value) {
      case 0:
        return 'What\'s your name?';
      case 1:
        return 'How old are you?';
      case 2:
        return 'What\'s your gender?';
      case 3:
        return 'Where are you from?';
      case 4:
        return 'Which city do you live in?';
      case 5:
        return 'Success!';
      default:
        return '';
    }
  }

  /// Get page subtitle based on current page
  String get currentPageSubtitle {
    switch (currentPage.value) {
      case 0:
        return 'Please enter your first and last name';
      case 1:
        return 'We need this to personalize your experience';
      case 2:
        return 'This helps us provide better recommendations';
      case 3:
        return 'Select your country of residence';
      case 4:
        return 'Enter your current city';
      case 5:
        return 'You\'re all set! Welcome to our app';
      default:
        return '';
    }
  }
}
