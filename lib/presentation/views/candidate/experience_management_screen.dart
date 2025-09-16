import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../../domain/entities/experience_entity.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class ExperienceManagementScreen extends GetView<ProfileController> {
  const ExperienceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Manage Experience',
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
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final experiences = user.experiences;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Professional Experience',
                style: AppTheme.heading2Bold.copyWith(
                  color: AppTheme.onBackgroundColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your work experience to showcase your skills',
                style: AppTheme.body1Medium.copyWith(
                  // ignore: deprecated_member_use
                  color: AppTheme.onBackgroundColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),

              // Add Experience Button
              AppButton(
                label: 'Add New Experience',
                onPressed: () => _navigateToExperienceForm(),
                leadingIcon: Icons.add,
                backgroundColor: AppTheme.primaryColor,
                textStyle: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),

              // Experience List
              if (experiences.isEmpty)
                _buildEmptyState()
              else
                ...experiences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final experience = entry.value;
                  return _buildExperienceCard(experience, index);
                }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(Icons.work_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          CustomText(
            'No Experience Added',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          CustomText(
            'Add your professional experience to showcase your skills',
            fontSize: 14,
            color: Colors.grey.shade500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceEntity experience, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with job title and actions
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      experience.jobTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onBackgroundColor,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      experience.company,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected:
                    (value) =>
                        _handleExperienceAction(value, experience, index),
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                child: Icon(Icons.more_vert, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Duration
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              CustomText(
                _formatDuration(experience),
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          if (experience.description.isNotEmpty) ...[
            CustomText(
              'Description:',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 4),
            CustomText(
              experience.description,
              fontSize: 14,
              color: Colors.grey.shade600,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(ExperienceEntity experience) {
    final startDate = experience.startDate;
    final endDate = experience.endDate;

    final startStr = '${startDate.month}/${startDate.year}';
    final endStr =
        experience.isCurrentJob
            ? 'Present'
            : '${endDate!.month}/${endDate.year}';

    return '$startStr - $endStr';
  }

  void _handleExperienceAction(
    String action,
    ExperienceEntity experience,
    int index,
  ) {
    switch (action) {
      case 'edit':
        _navigateToExperienceForm(experience: experience, index: index);
        break;
      case 'delete':
        _showDeleteConfirmation(experience, index);
        break;
    }
  }

  void _navigateToExperienceForm({ExperienceEntity? experience, int? index}) {
    Get.toNamed(
      '/candidate/experience-form',
      arguments: {'experience': experience, 'index': index},
    );
  }

  void _showDeleteConfirmation(ExperienceEntity experience, int index) {
    Get.dialog(
      CustomDialog(
        title: 'Delete Experience',
        content:
            'Are you sure you want to delete "${experience.jobTitle}" at ${experience.company}?',
        firstButtonLabel: 'Cancel',
        secondButtonLabel: 'Delete',
        onFirstButtonPressed: () => Get.back(),
        onSecondButtonPressed: () {
          controller.deleteExperience(index);
          Get.back();
        },
        secondButtonVariant: AppButtonVariant.primary,
        secondButtonColor: Colors.red,
      ),
    );
  }
}
