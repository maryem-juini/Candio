import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/selectable_card.dart';
import '../../controllers/registration_controller.dart';
import 'enterprise_info_page.dart';
import 'candidate_info_page.dart';
import 'experience_step_page.dart';

class RegisterScreen extends GetView<RegistrationController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: AppTheme.heading1Medium.copyWith(
            color: AppTheme.onBackgroundColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.onBackgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConfig.defaultPadding,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                // Step indicator
                Obx(
                  () => Text(
                    'Step ${controller.currentStep.value + 1} of ${controller.totalSteps}',
                    style: AppTheme.body2Medium.copyWith(
                      color: AppTheme.onBackgroundColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Progress indicator
                Obx(
                  () => LinearProgressIndicator(
                    value:
                        (controller.currentStep.value + 1) /
                        controller.totalSteps,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.15,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 15,
                  ),
                ),
              ],
            ),
          ),

          // PageView content
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildRoleStep(context),
                _buildAuthStep(context),
                _buildProfileStep(context),
                _buildExperienceStep(context),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                Obx(
                  () =>
                      controller.currentStep.value > 0
                          ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: controller.previousStep,
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.backgroundColor,
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          )
                          : const SizedBox(width: 48),
                ),

                // Next/Complete button
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor,
                    ),
                    child: IconButton(
                      onPressed:
                          controller.currentStep.value ==
                                  controller.totalSteps - 1
                              ? controller.completeRegistration
                              : controller.nextStep,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: AppTheme.onPrimaryColor,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.currentStepTitle,
            style: AppTheme.heading2Bold.copyWith(
              color: AppTheme.onBackgroundColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.currentStepDescription,
            style: AppTheme.body1Medium.copyWith(
              color: AppTheme.onBackgroundColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          Obx(
            () => Column(
              children:
                  controller.roles.map((role) {
                    final isSelected = controller.selectedRole.value == role;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SelectableCard(
                        title: role == 'candidate' ? 'Candidate' : 'HR Manager',
                        subtitle:
                            role == 'candidate'
                                ? 'I am looking for a job and want to apply to offers'
                                : 'I recruit candidates for my company',
                        icon:
                            role == 'candidate' ? Icons.person : Icons.business,
                        isSelected: isSelected,
                        onTap: () => controller.onRoleChanged(role),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.currentStepTitle,
            style: AppTheme.heading2Bold.copyWith(
              color: AppTheme.onBackgroundColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.currentStepDescription,
            style: AppTheme.body1Medium.copyWith(
              color: AppTheme.onBackgroundColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          Form(
            key: controller.authFormKey,
            child: Column(
              children: [
                AppTextField(
                  controller: controller.emailController,
                  label: 'Email Address',
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  prefixIconColor: AppTheme.primaryColor,
                  onChanged: controller.validateEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  hint: 'Create a password',
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  prefixIconColor: AppTheme.primaryColor,
                  onChanged: controller.validatePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must contain at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: controller.confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  prefixIconColor: AppTheme.primaryColor,
                  onChanged: controller.validateConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != controller.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password confirmation indicator removed - will be handled by form validation
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStep(BuildContext context) {
    return Obx(
      () =>
          controller.selectedRole.value == 'candidate'
              ? CandidateInfoPage(
                nameController: controller.nameController,
                phoneController: controller.phoneController,
                locationController: controller.locationController,
                educationController: controller.educationController,
                experienceController: controller.experienceController,
                profilePictureUrl: controller.profilePicturePath.value,
                onProfilePictureUploaded: (url) {
                  controller.profilePicturePath.value = url;
                },
                onProfilePictureError: (error) {
                  controller.errorMessage.value = error;
                },
                formKey: controller.profileFormKey,
              )
              : EnterpriseInfoPage(
                nameController: controller.entrepriseNameController,
                sectorController: controller.entrepriseSectorController,
                descriptionController:
                    controller.entrepriseDescriptionController,
                locationController: controller.entrepriseLocationController,
                websiteController: controller.entrepriseWebsiteController,
                linkedinController: controller.entrepriseLinkedinController,
                logoUrl: controller.entrepriseLogoUrl.value,
                onLogoUploaded: controller.onEntrepriseLogoUploaded,
                onLogoError: controller.onEntrepriseLogoError,
                formKey: controller.enterpriseFormKey,
              ),
    );
  }

  Widget _buildExperienceStep(BuildContext context) {
    return Obx(
      () =>
          controller.selectedRole.value == 'candidate'
              ? ExperienceStepPage(
                experiences: controller.experiences,
                onExperiencesChanged: controller.onExperiencesChanged,
                onNext: () {
                  // This is the last step, so complete registration
                  controller.completeRegistration();
                },
                onPrevious: () {
                  controller.previousStep();
                },
                onSkip: () {
                  // Skip experience and complete registration
                  controller.completeRegistration();
                },
              )
              : Container(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                child: const Center(child: Text('HR registration completed')),
              ),
    );
  }
}
