// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/profile_picture_picker.dart';
import '../../../core/theme/app_theme.dart';

class HREditProfileScreen extends GetView<ProfileController> {
  const HREditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            const SizedBox(height: 24),

            // Form Section
            _buildFormSection(),
            const SizedBox(height: 32),

            // Save Button
            Obx(
              () => AppButton(
                label:
                    controller.isUpdatingProfile.value
                        ? 'Updating...'
                        : 'Save Changes',
                onPressed:
                    controller.isUpdatingProfile.value
                        ? null
                        : controller.updateProfile,
                isLoading: controller.isUpdatingProfile.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ProfilePicturePicker(
              currentImageUrl: user.profilePictureUrl,
              size: 100,
              onImageUploaded: (url) async {
                if (url != null) {
                  await controller.updateProfilePicture(url);
                }
              },
              onImageDeleted: () async {
                await controller.deleteProfilePicture();
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Tap to change profile picture',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.onBackgroundColor,
            ),
          ),
          const SizedBox(height: 20),

          // Name Field
          AppTextField(
            controller: controller.nameController,
            hint: 'Full Name',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          AppTextField(
            controller: controller.emailController,
            hint: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!GetUtils.isEmail(value.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Field
          AppTextField(
            controller: controller.phoneController,
            hint: 'Phone Number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Location Field
          AppTextField(
            controller: controller.locationController,
            hint: 'Location (Optional)',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),

          // Company Field (HR specific)
          AppTextField(
            controller: controller.educationController, // Reusing for company
            hint: 'Company Name',
            prefixIcon: Icons.business_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Company name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Position Field (HR specific)
          AppTextField(
            controller: controller.experienceController, // Reusing for position
            hint: 'Position/Title',
            prefixIcon: Icons.work_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Position is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
