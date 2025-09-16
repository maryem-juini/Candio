// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/entreprise_entity.dart';
import '../../domain/entities/experience_entity.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../domain/usecases/entreprise_usecases.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/app_button.dart';
import 'auth_controller.dart';

class ProfileController extends AuthController {
  ProfileController(
    super.signInUseCase,
    super.signUpUseCase,
    super.signOutUseCase,
    super.forgotPasswordUseCase,
    super.getCurrentUserUseCase,
    this.updateProfileUseCase,
    this.changePasswordUseCase,
    this.deleteAccountUseCase,
    this.getProfileStatisticsUseCase,
    this.updatePreferencesUseCase,
    this.getPreferencesUseCase,
    this.getEntrepriseUseCase,
  );

  // Profile use cases
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final GetProfileStatisticsUseCase getProfileStatisticsUseCase;
  final UpdatePreferencesUseCase updatePreferencesUseCase;
  final GetPreferencesUseCase getPreferencesUseCase;
  final GetEntrepriseUseCase getEntrepriseUseCase;

  // Profile form controllers
  @override
  final nameController = TextEditingController();
  @override
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();

  // Password change controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  @override
  final confirmPasswordController = TextEditingController();

  // Observable variables
  final isUpdatingProfile = false.obs;
  final isChangingPassword = false.obs;
  final isDeletingAccount = false.obs;
  final isNotificationsEnabled = true.obs;
  final profileStatistics = <String, int>{}.obs;
  final currentEntreprise = Rxn<EntrepriseEntity>();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    // Delay loading statistics and preferences to ensure current user is available
    ever(currentUser, (UserEntity? user) {
      if (user != null) {
        _loadProfileStatistics();
        _loadPreferences();
        _loadEntrepriseData();
      }
    });
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
    _safeDispose(phoneController);
    _safeDispose(locationController);
    _safeDispose(educationController);
    _safeDispose(experienceController);
    _safeDispose(currentPasswordController);
    _safeDispose(newPasswordController);
    _safeDispose(confirmPasswordController);
    super.onClose();
  }

  void _initializeControllers() {
    ever(currentUser, (UserEntity? user) {
      if (user != null) {
        nameController.text = user.name;
        emailController.text = user.email;
        phoneController.text = user.phone;
        locationController.text = user.location ?? '';
        educationController.text = user.education ?? '';
        experienceController.text = user.experience ?? '';
      } else {
        // Clear controllers if user is null
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        locationController.clear();
        educationController.clear();
        experienceController.clear();
      }
    });
  }

  Future<void> refreshProfileData() async {
    try {
      await checkCurrentUser(shouldNavigate: false);
      if (currentUser.value != null) {
        await _loadProfileStatistics();
        await _loadPreferences();
        await _loadEntrepriseData();
      }
    } catch (e) {
      debugPrint('Failed to refresh profile data: $e');
    }
  }

  Future<void> _loadProfileStatistics() async {
    try {
      final user = currentUser.value;
      if (user != null) {
        final stats = await getProfileStatisticsUseCase(user.uid, user.role);
        profileStatistics.value = stats;
      } else {
        // Initialize with empty statistics if user is null
        profileStatistics.value = {
          'applications': 0,
          'accepted': 0,
          'pending': 0,
          'favorites': 0,
          'jobOffers': 0,
          'activeOffers': 0,
          'hired': 0,
        };
      }
    } catch (e) {
      debugPrint('Failed to load profile statistics: $e');
      // Initialize with empty statistics on error
      profileStatistics.value = {
        'applications': 0,
        'accepted': 0,
        'pending': 0,
        'favorites': 0,
        'jobOffers': 0,
        'activeOffers': 0,
        'hired': 0,
      };
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final user = currentUser.value;
      if (user != null) {
        final preferences = await getPreferencesUseCase(user.uid);
        isNotificationsEnabled.value = preferences['notifications'] ?? true;
      } else {
        // Set default preferences if user is null
        isNotificationsEnabled.value = true;
      }
    } catch (e) {
      debugPrint('Failed to load preferences: $e');
      // Set default preferences on error
      isNotificationsEnabled.value = true;
    }
  }

  Future<void> _loadEntrepriseData() async {
    try {
      final user = currentUser.value;
      if (user != null && user.role == 'hr' && user.entrepriseId != null) {
        final entreprise = await getEntrepriseUseCase(user.entrepriseId!);
        currentEntreprise.value = entreprise;
      } else {
        currentEntreprise.value = null;
      }
    } catch (e) {
      debugPrint('Failed to load entreprise data: $e');
      currentEntreprise.value = null;
    }
  }

  Future<void> updateProfile() async {
    if (currentUser.value == null) return;

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      // Create updated user object
      final updatedUser = currentUser.value!.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        location:
            locationController.text.trim().isEmpty
                ? null
                : locationController.text.trim(),
        education:
            educationController.text.trim().isEmpty
                ? null
                : educationController.text.trim(),
        experience:
            experienceController.text.trim().isEmpty
                ? null
                : experienceController.text.trim(),
      );

      // Call use case to update profile
      final result = await updateProfileUseCase(updatedUser);
      currentUser.value = result;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update profile: $e';
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> updateProfilePicture(String imageUrl) async {
    if (currentUser.value == null) return;

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      debugPrint(
        'Updating profile picture with URL: ${imageUrl.substring(0, 50)}...',
      );

      // Create updated user object with new profile picture URL
      final updatedUser = currentUser.value!.copyWith(
        profilePictureUrl: imageUrl,
      );

      debugPrint('Updating user profile with new image URL');

      // Call use case to update profile
      final result = await updateProfileUseCase(updatedUser);
      currentUser.value = result;

      debugPrint(
        'Profile updated successfully. New user: ${result.profilePictureUrl}',
      );

      Get.snackbar(
        'Success',
        'Profile picture updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error updating profile picture: $e');
      errorMessage.value = 'Failed to update profile picture: $e';
      Get.snackbar(
        'Error',
        'Failed to update profile picture: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> deleteProfilePicture() async {
    if (currentUser.value == null) return;

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      // Create updated user object with null profile picture URL
      final updatedUser = currentUser.value!.copyWith(profilePictureUrl: null);

      // Call use case to update profile
      final result = await updateProfileUseCase(updatedUser);
      currentUser.value = result;

      Get.snackbar(
        'Success',
        'Profile picture deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete profile picture: $e';
      Get.snackbar(
        'Error',
        'Failed to delete profile picture: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // Experience Management Methods
  Future<void> addExperience(ExperienceEntity experience) async {
    if (currentUser.value == null) return;

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      final updatedExperiences = List<ExperienceEntity>.from(
        currentUser.value!.experiences,
      );
      updatedExperiences.add(experience);

      final updatedUser = currentUser.value!.copyWith(
        experiences: updatedExperiences,
      );
      final result = await updateProfileUseCase(updatedUser);
      currentUser.value = result;

      Get.snackbar(
        'Success',
        'Experience added successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to add experience: $e';
      Get.snackbar(
        'Error',
        'Failed to add experience: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> updateExperience(int index, ExperienceEntity experience) async {
    if (currentUser.value == null) return;

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      final updatedExperiences = List<ExperienceEntity>.from(
        currentUser.value!.experiences,
      );
      if (index >= 0 && index < updatedExperiences.length) {
        updatedExperiences[index] = experience;
      }

      final updatedUser = currentUser.value!.copyWith(
        experiences: updatedExperiences,
      );
      final result = await updateProfileUseCase(updatedUser);
      currentUser.value = result;

      Get.snackbar(
        'Success',
        'Experience updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update experience: $e';
      Get.snackbar(
        'Error',
        'Failed to update experience: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> deleteExperience(int index) async {
    if (currentUser.value == null) return;

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      final updatedExperiences = List<ExperienceEntity>.from(
        currentUser.value!.experiences,
      );
      if (index >= 0 && index < updatedExperiences.length) {
        updatedExperiences.removeAt(index);
      }

      final updatedUser = currentUser.value!.copyWith(
        experiences: updatedExperiences,
      );
      final result = await updateProfileUseCase(updatedUser);
      currentUser.value = result;

      Get.snackbar(
        'Success',
        'Experience deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete experience: $e';
      Get.snackbar(
        'Error',
        'Failed to delete experience: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> updateEntrepriseLogo(String imagePath) async {
    if (currentUser.value == null || currentUser.value!.entrepriseId == null) {
      return;
    }

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      // Upload image to Firebase
      final authRepository = Get.find<AuthRepository>();
      final logoUrl = await authRepository.uploadProfilePicture(imagePath);

      // Update enterprise with new logo URL
      final entreprise = currentEntreprise.value;
      if (entreprise != null) {
        final updatedEntreprise = entreprise.copyWith(logoUrl: logoUrl);
        await Get.find<UpdateEntrepriseUseCase>()(updatedEntreprise);

        // Refresh enterprise data
        await _loadEntrepriseData();

        Get.snackbar(
          'Success',
          'Logo de l\'entreprise mis à jour avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to update enterprise logo: $e';
      Get.snackbar(
        'Error',
        'Échec de la mise à jour du logo: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> deleteEntrepriseLogo() async {
    if (currentUser.value == null || currentUser.value!.entrepriseId == null) {
      return;
    }

    try {
      isUpdatingProfile.value = true;
      errorMessage.value = '';

      // Update enterprise with null logo URL
      final entreprise = currentEntreprise.value;
      if (entreprise != null) {
        final updatedEntreprise = entreprise.copyWith(logoUrl: null);
        await Get.find<UpdateEntrepriseUseCase>()(updatedEntreprise);

        // Refresh enterprise data
        await _loadEntrepriseData();

        Get.snackbar(
          'Success',
          'Logo de l\'entreprise supprimé avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to delete enterprise logo: $e';
      Get.snackbar(
        'Error',
        'Échec de la suppression du logo: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isChangingPassword.value = true;
      errorMessage.value = '';

      // Call use case to change password
      await changePasswordUseCase(
        currentPasswordController.text,
        newPasswordController.text,
      );

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear password fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Show success dialog
      _showPasswordChangedDialog();
    } catch (e) {
      errorMessage.value = 'Failed to change password: $e';
      Get.snackbar(
        'Error',
        'Failed to change password: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isDeletingAccount.value = true;
      errorMessage.value = '';

      // For now, we'll just sign out since we need password confirmation
      // In a real implementation, you would show a dialog asking for password
      await signOut();
    } catch (e) {
      errorMessage.value = 'Failed to delete account: $e';
      Get.snackbar(
        'Error',
        'Failed to delete account: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeletingAccount.value = false;
    }
  }

  Future<void> deleteAccountWithPassword(String password) async {
    try {
      isDeletingAccount.value = true;
      errorMessage.value = '';

      // Call use case to delete account
      await deleteAccountUseCase(password);

      // Sign out after successful deletion
      await signOut();
    } catch (e) {
      errorMessage.value = 'Failed to delete account: $e';
      Get.snackbar(
        'Error',
        'Failed to delete account: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeletingAccount.value = false;
    }
  }

  Future<void> toggleNotifications() async {
    try {
      final user = currentUser.value;
      if (user != null) {
        isNotificationsEnabled.value = !isNotificationsEnabled.value;

        // Update preferences in backend
        await updatePreferencesUseCase(user.uid, {
          'notifications': isNotificationsEnabled.value,
        });
      }
    } catch (e) {
      // Revert the toggle if update failed
      isNotificationsEnabled.value = !isNotificationsEnabled.value;
      Get.snackbar(
        'Error',
        'Failed to update notification settings',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showPasswordChangedDialog() {
    Get.dialog(
      CustomDialog(
        title: 'Password Updated!',
        content:
            'Your password has been changed successfully. You can now use your new password to log in.',
        firstButtonLabel: 'Got it',
        onFirstButtonPressed: () => Get.back(),
        icon: Icons.lock_outline,
        iconColor: Colors.blue,
        titleColor: Colors.blue,
        firstButtonColor: Colors.blue,
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      CustomDialog(
        title: 'Sign Out',
        content: 'Are you sure you want to sign out?',
        firstButtonLabel: 'Cancel',
        secondButtonLabel: 'Sign Out',
        onFirstButtonPressed: () => Get.back(),
        onSecondButtonPressed: () {
          Get.back();
          signOut();
        },
        icon: Icons.logout,
        iconColor: Colors.red,
        titleColor: Colors.red,
        secondButtonVariant: AppButtonVariant.primary,
        secondButtonColor: Colors.red,
      ),
    );
  }

  void showDeleteAccountDialog() {
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_forever, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter your password to confirm',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.secondary,
                    label: 'Cancel',
                    onPressed: () => Get.back(),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.primary,
                    label: 'Delete',
                    onPressed: () {
                      if (passwordController.text.isNotEmpty) {
                        Get.back();
                        deleteAccountWithPassword(passwordController.text);
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter your password',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    backgroundColor: Colors.red,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
