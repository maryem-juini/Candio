// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/experience_entity.dart';
import '../../../domain/entities/application_entity.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/app_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../controllers/hr_controller.dart';

class CandidateInfoViewScreen extends StatelessWidget {
  final UserEntity candidate;
  final ApplicationEntity? application;

  const CandidateInfoViewScreen({
    super.key,
    required this.candidate,
    this.application,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Candidate Information',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  _buildProfileHeader(),
                  const SizedBox(height: 24),

                  // Personal Information
                  _buildPersonalInfo(),
                  const SizedBox(height: 24),

                  // Education
                  if (candidate.education != null) ...[
                    _buildEducation(),
                    const SizedBox(height: 24),
                  ],

                  // Experience
                  _buildExperience(),
                  const SizedBox(height: 24),

                  // Contact Information
                  _buildContactInfo(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Accept/Reject buttons for pending applications
          if (application != null &&
              application!.status == ApplicationStatus.pending)
            _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: _buildProfileImage(candidate.profilePictureUrl),
          ),
          const SizedBox(width: 20),

          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  candidate.name,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onBackgroundColor,
                ),
                const SizedBox(height: 4),
                CustomText(
                  candidate.email,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    'CANDIDATE',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _buildInfoSection(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
        _buildInfoRow('Full Name', candidate.name),
        if (candidate.location != null)
          _buildInfoRow('Location', candidate.location!),
        _buildInfoRow('Phone', candidate.phone),
      ],
    );
  }

  Widget _buildEducation() {
    return _buildInfoSection(
      title: 'Education',
      icon: Icons.school_outlined,
      children: [_buildInfoRow('Education', candidate.education!)],
    );
  }

  Widget _buildExperience() {
    return _buildInfoSection(
      title: 'Professional Experience',
      icon: Icons.work_outline,
      children: [
        if (candidate.experiences.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 8),
                CustomText(
                  'No professional experience added',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          )
        else
          ...candidate.experiences.map(
            (experience) => _buildExperienceCard(experience),
          ),
      ],
    );
  }

  Widget _buildExperienceCard(ExperienceEntity experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      experience.jobTitle,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onBackgroundColor,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      experience.company,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      experience.isCurrentJob
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText(
                  experience.isCurrentJob ? 'Current' : 'Previous',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: experience.isCurrentJob ? Colors.green : Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              CustomText(
                _formatDuration(experience),
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ],
          ),
          if (experience.description.isNotEmpty) ...[
            const SizedBox(height: 8),
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
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return _buildInfoSection(
      title: 'Contact Information',
      icon: Icons.contact_mail_outlined,
      children: [
        _buildInfoRow('Email', candidate.email),
        _buildInfoRow('Phone', candidate.phone),
        if (candidate.location != null)
          _buildInfoRow('Location', candidate.location!),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 12),
              CustomText(
                title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackgroundColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: CustomText(
              label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomText(
              value,
              fontSize: 14,
              color: AppTheme.onBackgroundColor,
            ),
          ),
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

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _acceptApplication(),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Accepter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _rejectApplication(),
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text('Rejeter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptApplication() {
    if (application == null) return;

    _showConfirmationDialog(
      'Accepter la candidature',
      'Êtes-vous sûr de vouloir accepter la candidature de ${candidate.name} ?',
      () async {
        try {
          final hrController = Get.find<HRController>();
          await hrController.updateApplicationStatus(
            application!.id,
            ApplicationStatus.accepted,
          );
          Get.snackbar(
            'Succès',
            'Candidature acceptée',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back(); // Go back to applications list
        } catch (e) {
          Get.snackbar(
            'Erreur',
            'Impossible d\'accepter la candidature: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  void _rejectApplication() {
    if (application == null) return;

    _showConfirmationDialog(
      'Rejeter la candidature',
      'Êtes-vous sûr de vouloir rejeter la candidature de ${candidate.name} ?',
      () async {
        try {
          final hrController = Get.find<HRController>();
          await hrController.updateApplicationStatus(
            application!.id,
            ApplicationStatus.rejected,
          );
          Get.snackbar(
            'Succès',
            'Candidature rejetée',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          Get.back(); // Go back to applications list
        } catch (e) {
          Get.snackbar(
            'Erreur',
            'Impossible de rejeter la candidature: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  void _showConfirmationDialog(
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: Get.context!,
      builder:
          (context) => CustomDialog(
            title: title,
            content: message,
            firstButtonLabel: 'Annuler',
            secondButtonLabel: 'Confirmer',
            onFirstButtonPressed: () => Navigator.of(context).pop(),
            onSecondButtonPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            secondButtonVariant: AppButtonVariant.primary,
            secondButtonColor:
                title.contains('Accepter') ? Colors.green : Colors.red,
          ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('data:')) {
        // Handle base64 data URL
        try {
          final dataUrl = imageUrl;
          final base64String = dataUrl.split(',')[1];
          final bytes = base64Decode(base64String);
          return ClipOval(
            child: Image.memory(
              bytes,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 40,
                  color: AppTheme.primaryColor,
                );
              },
            ),
          );
        } catch (e) {
          return Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
        }
      } else {
        // Handle network URL
        return ClipOval(
          child: Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
            },
          ),
        );
      }
    }

    return Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
  }
}
