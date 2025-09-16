// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hr_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/application_entity.dart';

class HRApplicationsScreen extends GetView<HRController> {
  const HRApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'Applications',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (controller.applications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                CustomText(
                  'No applications yet',
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 8),
                CustomText(
                  'Applications will appear here when candidates apply to your job offers',
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.applications.length,
          itemBuilder: (context, index) {
            final application = controller.applications[index];
            return _buildApplicationCard(application);
          },
        );
      }),
    );
  }

  Widget _buildApplicationCard(ApplicationEntity application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCandidateProfilePicture(application),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        application.candidateName,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onBackgroundColor,
                      ),
                      CustomText(
                        application.candidateEmail,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                _buildApplicationStatusChip(application.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateApplicationStatus(
                        application.id,
                        ApplicationStatus.accepted,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const CustomText('Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateApplicationStatus(
                        application.id,
                        ApplicationStatus.rejected,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const CustomText('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatusChip(ApplicationStatus status) {
    Color color;
    String text;

    switch (status) {
      case ApplicationStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case ApplicationStatus.accepted:
        color = Colors.green;
        text = 'Accepted';
        break;
      case ApplicationStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: CustomText(
        text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildCandidateProfilePicture(ApplicationEntity application) {
    if (application.candidateProfilePictureUrl != null &&
        application.candidateProfilePictureUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(application.candidateProfilePictureUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default icon if image fails to load
        },
        child:
            application.candidateProfilePictureUrl == null
                ? _buildDefaultProfileIcon()
                : null,
      );
    }

    return _buildDefaultProfileIcon();
  }

  Widget _buildDefaultProfileIcon() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      child: Icon(Icons.person, color: AppTheme.primaryColor, size: 30),
    );
  }
}
