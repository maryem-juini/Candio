import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/entreprise_entity.dart';
import '../../domain/entities/experience_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/entreprise_usecases.dart';
import '../../domain/repositories/auth_repository.dart';
import '../routes/app_routes.dart';

class RegistrationController extends GetxController {
  final SignUpUseCase _signUpUseCase;
  final CreateEntrepriseUseCase _createEntrepriseUseCase;
  final AuthRepository _authRepository;

  RegistrationController(
    this._signUpUseCase,
    this._createEntrepriseUseCase,
    this._authRepository,
  );

  // Page controller for multi-step registration
  final PageController pageController = PageController();
  final currentStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Dynamic total steps based on role
  int get totalSteps => selectedRole.value == 'candidate' ? 4 : 3;

  // Form data
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final locationController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();

  // Enterprise controllers (for HR)
  final entrepriseNameController = TextEditingController();
  final entrepriseSectorController = TextEditingController();
  final entrepriseDescriptionController = TextEditingController();
  final entrepriseLocationController = TextEditingController();
  final entrepriseWebsiteController = TextEditingController();
  final entrepriseLinkedinController = TextEditingController();

  // Role selection
  final selectedRole = ''.obs;
  final List<String> roles = ['candidate', 'hr'];

  // Profile picture
  final profilePicturePath = Rxn<String>();
  final cvPath = Rxn<String>();

  // Experiences
  final List<ExperienceEntity> experiences = <ExperienceEntity>[].obs;

  // Enterprise data (for HR)
  final entrepriseLogoUrl = Rxn<String>();
  final selectedEntrepriseId = Rxn<String>();
  final List<Map<String, dynamic>> entreprises = <Map<String, dynamic>>[].obs;

  // Form keys for validation
  final GlobalKey<FormState> authFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> enterpriseFormKey = GlobalKey<FormState>();

  // Validation states
  final isNameValid = false.obs;
  final isEmailValid = false.obs;
  final isPhoneValid = false.obs;
  final isPasswordValid = false.obs;
  final isRoleValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if role was passed from onboarding
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['role'] != null) {
      selectedRole.value = arguments['role'];
      isRoleValid.value = true;
    }

    // totalSteps is now fixed at 3 (role, auth, profile)
    pageController.addListener(_onPageChanged);
  }

  // Helper method to safely dispose a controller
  void _safeDispose(TextEditingController controller) {
    try {
      controller.dispose();
    } catch (e) {
      // Controller already disposed
    }
  }

  // Helper method to safely dispose a page controller
  void _safeDisposePageController(PageController controller) {
    try {
      controller.dispose();
    } catch (e) {
      // Controller already disposed
    }
  }

  @override
  void onClose() {
    _safeDisposePageController(pageController);
    _safeDispose(nameController);
    _safeDispose(emailController);
    _safeDispose(phoneController);
    _safeDispose(passwordController);
    _safeDispose(confirmPasswordController);
    _safeDispose(locationController);
    _safeDispose(educationController);
    _safeDispose(experienceController);
    _safeDispose(entrepriseNameController);
    _safeDispose(entrepriseSectorController);
    _safeDispose(entrepriseDescriptionController);
    _safeDispose(entrepriseLocationController);
    _safeDispose(entrepriseWebsiteController);
    _safeDispose(entrepriseLinkedinController);
    super.onClose();
  }

  void _onPageChanged() {
    if (pageController.page != null) {
      currentStep.value = pageController.page!.round();
    }
  }

  void onRoleChanged(String role) {
    selectedRole.value = role;
    isRoleValid.value = role.isNotEmpty;
  }

  void validateName(String value) {
    isNameValid.value = value.trim().isNotEmpty;
  }

  void validateEmail(String value) {
    isEmailValid.value = GetUtils.isEmail(value);
  }

  void validatePhone(String value) {
    isPhoneValid.value = value.trim().isNotEmpty;
  }

  void validatePassword(String value) {
    isPasswordValid.value =
        value.length >= 6 && value == confirmPasswordController.text;
  }

  void validateConfirmPassword(String value) {
    isPasswordValid.value =
        value == passwordController.text && passwordController.text.length >= 6;
  }

  bool get isCurrentStepValid {
    switch (currentStep.value) {
      case 0: // Role selection
        return isRoleValid.value;
      case 1: // Auth info (email, password, confirm password)
        return isEmailValid.value && isPasswordValid.value;
      case 2: // Profile completion
        if (selectedRole.value == 'candidate') {
          return isNameValid.value && isPhoneValid.value;
        } else if (selectedRole.value == 'hr') {
          // For HR managers, validate enterprise fields
          return entrepriseNameController.text.trim().isNotEmpty &&
              entrepriseSectorController.text.trim().isNotEmpty &&
              entrepriseDescriptionController.text.trim().isNotEmpty &&
              entrepriseLocationController.text.trim().isNotEmpty;
        }
        return false;
      default:
        return true;
    }
  }

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      bool canProceed = false;

      switch (currentStep.value) {
        case 0: // Role selection
          canProceed = isRoleValid.value;
          if (!canProceed) {
            Get.snackbar(
              'Erreur de validation',
              'Veuillez sélectionner votre rôle',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
          break;
        case 1: // Auth info
          canProceed = authFormKey.currentState?.validate() ?? false;
          break;
        case 2: // Profile completion
          if (selectedRole.value == 'candidate') {
            canProceed = profileFormKey.currentState?.validate() ?? false;
          } else if (selectedRole.value == 'hr') {
            // For HR managers, validate enterprise fields using form validation
            canProceed = enterpriseFormKey.currentState?.validate() ?? false;
          }
          break;
        case 3: // Experience step (only for candidates)
          if (selectedRole.value == 'candidate') {
            // Experience step is optional, so always allow proceeding
            canProceed = true;
          } else {
            // HR managers don't have experience step
            canProceed = true;
          }
          break;
      }

      if (canProceed) {
        // Special handling for HR managers - skip experience step
        if (currentStep.value == 2 && selectedRole.value == 'hr') {
          // HR managers complete registration after profile step
          completeRegistration();
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  void _showValidationError() {
    String message = '';
    switch (currentStep.value) {
      case 0: // Role selection
        message = 'Veuillez sélectionner votre rôle';
        break;
      case 1: // Auth info
        if (!isEmailValid.value) {
          message = 'Veuillez entrer une adresse email valide';
        } else if (!isPasswordValid.value) {
          message =
              'Veuillez entrer un mot de passe valide (minimum 6 caractères)';
        }
        break;
      case 2: // Profile completion
        if (selectedRole.value == 'candidate') {
          if (!isNameValid.value) {
            message = 'Veuillez entrer votre nom complet';
          } else if (!isPhoneValid.value) {
            message = 'Veuillez entrer votre numéro de téléphone';
          }
        } else if (selectedRole.value == 'hr') {
          // Check enterprise fields
          if (entrepriseNameController.text.trim().isEmpty) {
            message = 'Veuillez entrer le nom de l\'entreprise';
          } else if (entrepriseSectorController.text.trim().isEmpty) {
            message = 'Veuillez entrer le secteur d\'activité';
          } else if (entrepriseDescriptionController.text.trim().isEmpty) {
            message = 'Veuillez entrer la description de l\'entreprise';
          } else if (entrepriseLocationController.text.trim().isEmpty) {
            message = 'Veuillez entrer la localisation de l\'entreprise';
          }
        }
        break;
    }
    if (message.isNotEmpty) {
      errorMessage.value = message;
      Get.snackbar(
        'Erreur de validation',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> pickProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        profilePicturePath.value = image.path;
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
    }
  }

  Future<void> takeProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        profilePicturePath.value = image.path;
      }
    } catch (e) {
      errorMessage.value = 'Failed to take image: $e';
    }
  }

  void deleteProfilePicture() {
    profilePicturePath.value = null;
  }

  void onExperiencesChanged(List<ExperienceEntity> newExperiences) {
    experiences.clear();
    experiences.addAll(newExperiences);
  }

  Future<void> pickCV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        cvPath.value = result.files.single.path;
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick CV: $e';
    }
  }

  Future<void> completeRegistration() async {
    // Show validation errors if any fields are missing
    if (!_validateAllSteps()) {
      _showValidationError();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create user entity first (without entrepriseId)
      final userData = UserEntity(
        uid: '', // Will be set by the repository
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        location:
            selectedRole.value == 'candidate'
                ? (locationController.text.trim().isEmpty
                    ? null
                    : locationController.text.trim())
                : entrepriseLocationController.text.trim(),
        education:
            selectedRole.value == 'candidate'
                ? (educationController.text.trim().isEmpty
                    ? null
                    : educationController.text.trim())
                : null,
        experience:
            selectedRole.value == 'candidate'
                ? (experienceController.text.trim().isEmpty
                    ? null
                    : experienceController.text.trim())
                : null,
        experiences: selectedRole.value == 'candidate' ? experiences : [],
        cvUrl: cvPath.value,
        profilePictureUrl: profilePicturePath.value,
        role: selectedRole.value,
        entrepriseId: null, // Will be set after enterprise creation
      );

      // Sign up user first (this will authenticate the user)
      final user = await _signUpUseCase(
        emailController.text.trim(),
        passwordController.text,
        userData,
      );

      if (user != null) {
        // Now create enterprise if HR manager (user is now authenticated)
        if (selectedRole.value == 'hr') {
          try {
            // Upload logo to Firebase if provided
            String? logoUrl;
            if (entrepriseLogoUrl.value != null) {
              try {
                logoUrl = await _authRepository.uploadProfilePicture(
                  entrepriseLogoUrl.value!,
                );
              } catch (e) {
                debugPrint('Failed to upload logo: $e');
                // Continue without logo if upload fails
              }
            }

            final entreprise = EntrepriseEntity(
              id: '',
              name: entrepriseNameController.text.trim(),
              sector: entrepriseSectorController.text.trim(),
              description: entrepriseDescriptionController.text.trim(),
              location: entrepriseLocationController.text.trim(),
              website:
                  entrepriseWebsiteController.text.trim().isEmpty
                      ? null
                      : entrepriseWebsiteController.text.trim(),
              linkedin:
                  entrepriseLinkedinController.text.trim().isEmpty
                      ? null
                      : entrepriseLinkedinController.text.trim(),
              logoUrl: logoUrl,
              createdAt: DateTime.now(),
            );

            final entrepriseId = await _createEntrepriseUseCase(entreprise);

            // Update user with entrepriseId
            final updatedUser = UserEntity(
              uid: user.uid,
              name: user.name,
              email: user.email,
              phone: user.phone,
              location: user.location,
              education: user.education,
              experience: user.experience,
              experiences: user.experiences,
              cvUrl: user.cvUrl,
              profilePictureUrl: user.profilePictureUrl,
              role: user.role,
              entrepriseId: entrepriseId,
            );

            // Update user in Firestore with entrepriseId
            await _authRepository.updateUserInFirestore(updatedUser);
          } catch (e) {
            errorMessage.value = 'Failed to create enterprise: $e';
            Get.snackbar(
              'Erreur',
              'Échec de la création de l\'entreprise: $e',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            return;
          }
        }

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate based on role
        if (user.role == 'candidate') {
          Get.offAllNamed(AppRoutes.candidateMain);
        } else {
          Get.offAllNamed(AppRoutes.hrMain);
        }
      } else {
        errorMessage.value = 'Failed to create account';
      }
    } catch (e) {
      errorMessage.value = 'Registration failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateAllSteps() {
    if (selectedRole.value == 'candidate') {
      if (!isNameValid.value) {
        errorMessage.value = 'Veuillez entrer votre nom complet';
        return false;
      }
      if (!isEmailValid.value) {
        errorMessage.value = 'Veuillez entrer une adresse email valide';
        return false;
      }
      if (!isPhoneValid.value) {
        errorMessage.value = 'Veuillez entrer votre numéro de téléphone';
        return false;
      }
      if (!isPasswordValid.value) {
        errorMessage.value =
            'Veuillez entrer un mot de passe valide (minimum 6 caractères)';
        return false;
      }
    } else if (selectedRole.value == 'hr') {
      if (!isEmailValid.value) {
        errorMessage.value = 'Veuillez entrer une adresse email valide';
        return false;
      }
      if (!isPasswordValid.value) {
        errorMessage.value =
            'Veuillez entrer un mot de passe valide (minimum 6 caractères)';
        return false;
      }
      if (entrepriseNameController.text.trim().isEmpty) {
        errorMessage.value = 'Veuillez entrer le nom de l\'entreprise';
        return false;
      }
      if (entrepriseSectorController.text.trim().isEmpty) {
        errorMessage.value = 'Veuillez entrer le secteur d\'activité';
        return false;
      }
      if (entrepriseDescriptionController.text.trim().isEmpty) {
        errorMessage.value = 'Veuillez entrer la description de l\'entreprise';
        return false;
      }
      if (entrepriseLocationController.text.trim().isEmpty) {
        errorMessage.value = 'Veuillez entrer la localisation de l\'entreprise';
        return false;
      }
    }
    return true;
  }

  void onEntrepriseLogoUploaded(String path) {
    // Store the local path for now, will be uploaded to Firebase during registration
    entrepriseLogoUrl.value = path;
  }

  void onEntrepriseLogoError(String error) {
    errorMessage.value = error;
  }

  void clearError() {
    errorMessage.value = '';
  }

  String get currentStepTitle {
    switch (currentStep.value) {
      case 0:
        return 'Choisissez votre rôle';
      case 1:
        return 'Informations de connexion';
      case 2:
        return 'Complétez votre profil';
      case 3:
        return 'Expérience professionnelle';
      default:
        return '';
    }
  }

  String get currentStepDescription {
    switch (currentStep.value) {
      case 0:
        return 'Sélectionnez le type de compte qui correspond à votre profil';
      case 1:
        return 'Créez votre compte avec email et mot de passe';
      case 2:
        return 'Ajoutez vos informations personnelles et complétez votre profil';
      case 3:
        return 'Ajoutez vos expériences professionnelles (optionnel)';
      default:
        return '';
    }
  }
}
