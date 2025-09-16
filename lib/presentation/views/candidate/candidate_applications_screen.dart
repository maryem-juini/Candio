// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/candidate_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/app_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../../domain/entities/application_entity.dart';

class CandidateApplicationsScreen extends GetView<CandidateController> {
  const CandidateApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'My Applications',
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
                Icon(Icons.work_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                CustomText(
                  'No applications yet',
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 8),
                CustomText(
                  'Start applying to jobs to see your applications here',
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.changeTab(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const CustomText(
                    'Browse Jobs',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadApplications,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.applications.length,
            itemBuilder: (context, index) {
              final application = controller.applications[index];
              final jobOffer = controller.jobOffers.firstWhereOrNull(
                (offer) => offer.id == application.jobOfferId,
              );

              return _buildApplicationCard(application, jobOffer);
            },
          ),
        );
      }),
    );
  }

  Widget _buildApplicationCard(ApplicationEntity application, jobOffer) {
    if (jobOffer == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: const CustomText(
          'Job offer not found',
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap:
              () => Get.toNamed(
                AppRoutes.candidateJobDetail,
                arguments: jobOffer,
              ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Company logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildCompanyLogo(jobOffer),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            jobOffer.title,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.onBackgroundColor,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            jobOffer.company,
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    _buildApplicationStatusChip(application.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    CustomText(
                      jobOffer.location,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.work, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    CustomText(
                      jobOffer.contractType,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    CustomText(
                      'Applied on ${_formatDate(application.appliedAt)}',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                if (application.updatedAt != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.update, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      CustomText(
                        'Updated on ${_formatDate(application.updatedAt!)}',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed:
                            () => Get.toNamed(
                              AppRoutes.candidateJobDetail,
                              arguments: jobOffer,
                            ),
                        child: const CustomText(
                          'View Job Details',
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    if (application.status == ApplicationStatus.pending) ...[
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          Get.dialog(
                            CustomDialog(
                              title: 'Withdraw Application',
                              content:
                                  'Are you sure you want to withdraw your application for this position?',
                              firstButtonLabel: 'Cancel',
                              secondButtonLabel: 'Withdraw',
                              onFirstButtonPressed: () => Get.back(),
                              onSecondButtonPressed: () {
                                Get.back();
                                Get.snackbar(
                                  'Info',
                                  'Withdraw functionality coming soon',
                                );
                              },
                              secondButtonVariant: AppButtonVariant.primary,
                              secondButtonColor: Colors.red,
                            ),
                          );
                        },
                        child: const CustomText(
                          'Withdraw',
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationStatusChip(ApplicationStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ApplicationStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case ApplicationStatus.accepted:
        color = Colors.green;
        text = 'Accepted';
        icon = Icons.check_circle;
        break;
      case ApplicationStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          CustomText(
            text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildCompanyLogo(jobOffer) {
    // Try to get the enterprise logo URL from the controller
    final enterprise = controller.getEnterpriseById(jobOffer.entrepriseId);

    if (enterprise?.logoUrl != null && enterprise!.logoUrl!.isNotEmpty) {
      return _buildLogoImage(enterprise.logoUrl!);
    }

    return _buildDefaultCompanyIcon();
  }

  Widget _buildLogoImage(String logoUrl) {
    if (logoUrl.startsWith('data:')) {
      // Handle base64 data URL
      try {
        final dataUrl = logoUrl;
        final base64String = dataUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultCompanyIcon();
          },
        );
      } catch (e) {
        return _buildDefaultCompanyIcon();
      }
    } else {
      // Handle network URL
      return Image.network(
        logoUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultCompanyIcon();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                strokeWidth: 2,
                color: AppTheme.primaryColor,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildDefaultCompanyIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.business, color: AppTheme.primaryColor, size: 24),
    );
  }
}
