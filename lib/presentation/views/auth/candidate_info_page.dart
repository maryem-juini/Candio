import 'package:candio/presentation/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../../widgets/app_text_field.dart';
import 'profile_picture_page.dart';

class CandidateInfoPage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController educationController;
  final TextEditingController experienceController;
  final String? profilePictureUrl;
  final Function(String) onProfilePictureUploaded;
  final Function(String) onProfilePictureError;
  final GlobalKey<FormState> formKey;

  const CandidateInfoPage({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.locationController,
    required this.educationController,
    required this.experienceController,
    this.profilePictureUrl,
    required this.onProfilePictureUploaded,
    required this.onProfilePictureError,
    required this.formKey,
  });

  @override
  State<CandidateInfoPage> createState() => _CandidateInfoPageState();
}

class _CandidateInfoPageState extends State<CandidateInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: AppTheme.heading2Bold.copyWith(
                color: AppTheme.onBackgroundColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your profile to improve your chances of being recruited',
              style: AppTheme.body1Medium.copyWith(
                // ignore: deprecated_member_use
                color: AppTheme.onBackgroundColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            AppTextField(
              controller: widget.nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person,
              prefixIconColor: AppTheme.primaryColor,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              onChanged: (value) {
                // Call the validation method when text changes
                // You'll need to pass the controller to this widget or use Get.find()
                final registrationController =
                    Get.find<RegistrationController>();
                registrationController.validateName(value);
              },
            ),
            const SizedBox(height: 16),

            // Phone field
            AppTextField(
              controller: widget.phoneController,
              label: 'Phone',
              hint: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone,
              prefixIconColor: AppTheme.primaryColor,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              onChanged: (value) {
                // Call the validation method when text changes
                final registrationController =
                    Get.find<RegistrationController>();
                registrationController.validatePhone(value);
              },
            ),
            const SizedBox(height: 16),

            // Location field
            AppTextField(
              controller: widget.locationController,
              label: 'Location',
              hint: 'Your city, country',
              prefixIcon: Icons.location_on,
              prefixIconColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),

            // Education field
            AppTextField(
              controller: widget.educationController,
              label: 'Education',
              hint: 'Your education level',
              prefixIcon: Icons.school,
              prefixIconColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 32),

            // Profile picture section
            ProfilePicturePage(
              profilePictureUrl: widget.profilePictureUrl,
              onProfilePictureUploaded: widget.onProfilePictureUploaded,
              onProfilePictureError: widget.onProfilePictureError,
            ),
          ],
        ),
      ),
    );
  }
}
