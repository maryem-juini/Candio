import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hr_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/application_entity.dart';
import '../../../domain/entities/job_offer_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'candidate_info_view_screen.dart';

class HRApplicationsManagementScreen extends GetView<HRController> {
  const HRApplicationsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Obx(() {
          final selectedJobId = controller.selectedJobOfferId.value;
          if (selectedJobId.isNotEmpty) {
            final jobOffer = controller.jobOffers.firstWhereOrNull(
              (job) => job.id == selectedJobId,
            );
            if (jobOffer != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    'Applications',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  CustomText(
                    jobOffer.title,
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ],
              );
            }
          }
          return const CustomText(
            'Applications Management',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          );
        }),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          if (controller.selectedJobOfferId.value.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                controller.selectedJobOfferId.value = '';
                controller.loadAllApplications();
              },
              tooltip: 'View all applications',
            ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter applications',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Statistics Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip(
                    'All',
                    'all',
                    () => _filterByStatus('all'),
                  ),
                ),
                Expanded(
                  child: _buildFilterChip(
                    'Pending',
                    'pending',
                    () => _filterByStatus('pending'),
                  ),
                ),
                Expanded(
                  child: _buildFilterChip(
                    'Accepted',
                    'accepted',
                    () => _filterByStatus('accepted'),
                  ),
                ),
                Expanded(
                  child: _buildFilterChip(
                    'Rejetées',
                    'rejected',
                    () => _filterByStatus('rejected'),
                  ),
                ),
              ],
            ),
          ),

          // Applications List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              final filteredApplications = _getFilteredApplications();

              if (filteredApplications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const CustomText(
                        'No applications',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      const CustomText(
                        'Les candidatures apparaîtront ici',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadAllApplications,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredApplications.length,
                  itemBuilder: (context, index) {
                    final application = filteredApplications[index];
                    return _buildApplicationCard(context, application);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onTap) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CustomText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      );
    });
  }

  List<ApplicationEntity> _getFilteredApplications() {
    // D'abord filtrer par poste si un poste spécifique est sélectionné
    List<ApplicationEntity> applications = controller.applications;
    if (controller.selectedJobOfferId.value.isNotEmpty) {
      applications =
          applications
              .where(
                (app) => app.jobOfferId == controller.selectedJobOfferId.value,
              )
              .toList();
    }

    // Ensuite filtrer par statut
    final filter = controller.selectedFilter.value;
    switch (filter) {
      case 'pending':
        return applications
            .where((app) => app.status == ApplicationStatus.pending)
            .toList();
      case 'accepted':
        return applications
            .where((app) => app.status == ApplicationStatus.accepted)
            .toList();
      case 'rejected':
        return applications
            .where((app) => app.status == ApplicationStatus.rejected)
            .toList();
      default:
        return applications;
    }
  }

  void _filterByStatus(String status) {
    controller.selectedFilter.value = status;
  }

  Widget _buildApplicationCard(
    BuildContext context,
    ApplicationEntity application,
  ) {
    final jobOffer = controller.jobOffers.firstWhere(
      (job) => job.id == application.jobOfferId,
      orElse:
          () => JobOfferEntity(
            id: '',
            title: 'Poste non trouvé',
            company: '',
            location: '',
            contractType: '',
            description: '',
            requirements: [],
            deadline: DateTime.now(),
            entrepriseId: '',
            createdAt: DateTime.now(),
          ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
            // Header with candidate info and status
            Row(
              children: [
                _buildCandidateAvatar(application),
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
                      const SizedBox(height: 4),
                      CustomText(
                        application.candidateEmail,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        'Postulé le ${_formatDate(application.appliedAt)}',
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(application.status),
              ],
            ),

            const SizedBox(height: 16),

            // Job offer info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Poste: ${jobOffer.title}',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onBackgroundColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        jobOffer.location,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.work, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      CustomText(
                        jobOffer.contractType,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            if (application.status == ApplicationStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          () => _viewCandidateDetails(context, application),
                      icon: const Icon(Icons.person),
                      label: const Text('View candidate profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          () => _viewCandidateDetails(context, application),
                      icon: const Icon(Icons.person),
                      label: const Text('View candidate profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          () => _viewApplicationDetails(context, application),
                      icon: const Icon(Icons.description),
                      label: const Text('Application details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _downloadCV(application),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Télécharger CV'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _contactCandidate(application),
                    icon: const Icon(Icons.email, size: 16),
                    label: const Text('Contacter'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _scheduleInterview(application),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Planifier entretien'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateAvatar(ApplicationEntity application) {
    if (application.candidateProfilePictureUrl != null &&
        application.candidateProfilePictureUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 25,
        child: _buildProfileImage(application.candidateProfilePictureUrl!),
      );
    }
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppTheme.primaryColor,
      child: CustomText(
        application.candidateName.substring(0, 1).toUpperCase(),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    if (imageUrl.startsWith('data:')) {
      // Handle base64 data URL
      try {
        final dataUrl = imageUrl;
        final base64String = dataUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => _buildDefaultProfileIcon(),
          ),
        );
      } catch (e) {
        return _buildDefaultProfileIcon();
      }
    } else {
      // Handle network URL
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => _buildDefaultProfileIcon(),
        ),
      );
    }
  }

  Widget _buildDefaultProfileIcon() {
    return Icon(Icons.person, size: 30, color: AppTheme.primaryColor);
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case ApplicationStatus.pending:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        statusText = 'Pending';
        break;
      case ApplicationStatus.accepted:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        statusText = 'Accepted';
        break;
      case ApplicationStatus.rejected:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        statusText = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomText(
        statusText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  void _viewCandidateDetails(
    BuildContext context,
    ApplicationEntity application,
  ) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Get full candidate information
      final getUserByIdUseCase = Get.find<GetUserByIdUseCase>();
      final candidate = await getUserByIdUseCase(application.candidateId);

      // Close loading dialog
      Get.back();

      if (candidate != null) {
        // Navigate to candidate info view screen
        Get.to(
          () => CandidateInfoViewScreen(
            candidate: candidate,
            application: application,
          ),
        );
      } else {
        // Show error if candidate not found
        Get.snackbar(
          'Error',
          'Candidate information not found',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Show error
      Get.snackbar(
        'Error',
        'Failed to load candidate information: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _viewApplicationDetails(
    BuildContext context,
    ApplicationEntity application,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Application Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Status', _getStatusText(application.status)),
                  _buildDetailRow(
                    'Application Date',
                    _formatDate(application.appliedAt),
                  ),
                  if (application.updatedAt != null)
                    _buildDetailRow(
                      'Last updated',
                      _formatDate(application.updatedAt!),
                    ),
                  _buildDetailRow('Candidate ID', application.candidateId),
                  _buildDetailRow('Job Offer ID', application.jobOfferId),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Filter Applications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'All',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _filterByStatus('all');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Pending',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _filterByStatus('pending');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Accepted',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _filterByStatus('accepted');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Rejected',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    _filterByStatus('rejected');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _downloadCV(ApplicationEntity application) {
    if (application.candidateCvUrl != null) {
      // Implement CV download logic
      Get.snackbar(
        'Téléchargement',
        'Téléchargement du CV en cours...',
        backgroundColor: AppTheme.primaryColor,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'CV non disponible',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _contactCandidate(ApplicationEntity application) {
    // Implement contact logic
    Get.snackbar(
      'Contact',
      'Fonctionnalité de contact à implémenter',
      backgroundColor: AppTheme.primaryColor,
      colorText: Colors.white,
    );
  }

  void _scheduleInterview(ApplicationEntity application) {
    // Implement interview scheduling logic
    Get.snackbar(
      'Planification',
      'Fonctionnalité de planification d\'entretien à implémenter',
      backgroundColor: AppTheme.primaryColor,
      colorText: Colors.white,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
