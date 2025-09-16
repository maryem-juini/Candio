import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/company_logo_picker.dart';

class EnterpriseInfoPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController sectorController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final TextEditingController websiteController;
  final TextEditingController linkedinController;
  final String? logoUrl;
  final Function(String)? onLogoUploaded;
  final Function(String)? onLogoError;
  final GlobalKey<FormState>? formKey;

  const EnterpriseInfoPage({
    super.key,
    required this.nameController,
    required this.sectorController,
    required this.descriptionController,
    required this.locationController,
    required this.websiteController,
    required this.linkedinController,
    this.logoUrl,
    this.onLogoUploaded,
    this.onLogoError,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Company Information',
            style: AppTheme.heading2Bold.copyWith(
              color: AppTheme.onBackgroundColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in your company information to complete your profile',
            style: AppTheme.body1Medium.copyWith(
              color: AppTheme.onBackgroundColor,
            ),
          ),
          const SizedBox(height: 32),

          // Logo upload section with improved styling
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Logo',
                  style: AppTheme.body1Medium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onBackgroundColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your company logo (optional)',
                  style: AppTheme.body2Medium.copyWith(
                    color: AppTheme.onBackgroundColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CompanyLogoPicker(
                    currentImageUrl: logoUrl,
                    width: 150,
                    height: 90,
                    enableFirebaseUpload:
                        false, // Don't upload during onboarding
                    onImageSelected: (path, url) {
                      if (onLogoUploaded != null && path != null) {
                        onLogoUploaded!(path);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Form(
            key: formKey,
            child: Column(
              children: [
                // Company name
                AppTextField(
                  controller: nameController,
                  label: 'Company Name',
                  hint: 'Enter your company name',
                  prefixIcon: Icons.business,
                  prefixIconColor: colorScheme.primary,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Sector
                AppTextField(
                  controller: sectorController,
                  label: 'Business Sector',
                  hint: 'Ex: Technology, Finance, Healthcare...',
                  prefixIcon: Icons.category,
                  prefixIconColor: colorScheme.primary,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the business sector';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location
                AppTextField(
                  controller: locationController,
                  label: 'Location',
                  hint: 'City, Country',
                  prefixIcon: Icons.location_on,
                  prefixIconColor: colorScheme.primary,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the company location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                AppTextField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Briefly describe your company',
                  prefixIcon: Icons.description,
                  prefixIconColor: colorScheme.primary,
                  maxLines: 4,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the company description';
                    }
                    if (value.trim().length < 20) {
                      return 'Description must contain at least 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Website
                AppTextField(
                  controller: websiteController,
                  label: 'Website (optional)',
                  hint: 'https://www.your-company.com',
                  prefixIcon: Icons.language,
                  prefixIconColor: colorScheme.primary,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),

                // LinkedIn
                AppTextField(
                  controller: linkedinController,
                  label: 'LinkedIn (optional)',
                  hint: 'https://linkedin.com/company/your-company',
                  prefixIcon: Icons.link,
                  prefixIconColor: colorScheme.primary,
                  keyboardType: TextInputType.url,
                ),
              ],
            ),
          ),

          // Additional information text
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This information will be visible to candidates when you publish job offers.',
                    style: AppTheme.body2Medium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
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
}
