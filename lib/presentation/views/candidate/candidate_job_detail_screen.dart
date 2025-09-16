// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/candidate_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/job_offer_entity.dart';
import '../../../domain/entities/application_entity.dart';

class CandidateJobDetailScreen extends GetView<CandidateController> {
  const CandidateJobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobOffer = Get.arguments as JobOfferEntity;
    final application = controller.getApplicationForJob(jobOffer.id);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite(jobOffer.id)
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color:
                    controller.isFavorite(jobOffer.id)
                        ? Colors.red
                        : Colors.white,
                size: 24,
              ),
              onPressed: () => controller.toggleFavorite(jobOffer.id),
              tooltip:
                  controller.isFavorite(jobOffer.id)
                      ? 'Remove from favorites'
                      : 'Add to favorites',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Header Card
                  _buildJobHeaderCard(jobOffer),
                  const SizedBox(height: 16),

                  // Job Description
                  _buildSectionCard(
                    title: 'Job Description',
                    icon: Icons.description_rounded,
                    child: Text(
                      jobOffer.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Requirements
                  _buildSectionCard(
                    title: 'Requirements',
                    icon: Icons.checklist_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          jobOffer.requirements
                              .map(
                                (requirement) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          requirement,
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.4,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Application Status or Apply Button
                  if (application != null) _buildApplicationStatus(application),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Apply Button (if not applied)
          if (application == null) _buildApplyButton(jobOffer),
        ],
      ),
    );
  }

  Widget _buildJobHeaderCard(JobOfferEntity jobOffer) {
    return Container(
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
            Text(
              jobOffer.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackgroundColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              jobOffer.company,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.location_on_rounded, jobOffer.location),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.work_rounded, jobOffer.contractType),
            if (jobOffer.salaryRange != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(Icons.attach_money_rounded, jobOffer.salaryRange!),
            ],
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today_rounded,
              'Deadline: ${_formatDate(jobOffer.deadline)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
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
                Icon(icon, size: 22, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatus(ApplicationEntity application) {
    return Container(
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
            const Text(
              'Application Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildApplicationStatusChip(application.status),
            const SizedBox(height: 12),
            Text(
              'Applied on ${_formatDate(application.appliedAt)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatusChip(ApplicationStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case ApplicationStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange;
        text = 'Pending Review';
        icon = Icons.schedule_rounded;
        break;
      case ApplicationStatus.accepted:
        backgroundColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        text = 'Application Accepted';
        icon = Icons.check_circle_rounded;
        break;
      case ApplicationStatus.rejected:
        backgroundColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        text = 'Application Rejected';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: textColor),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(JobOfferEntity jobOffer) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await controller.applyToJob(jobOffer.id);
            // Refresh applications after applying
            await controller.loadApplications();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Apply Now',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
