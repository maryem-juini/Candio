// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/candidate_controller.dart';
import '../../controllers/audio_search_controller.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../routes/app_routes.dart';
import '../../../domain/entities/application_entity.dart';

class CandidateHomeScreen extends GetView<CandidateController> {
  const CandidateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Job Offers',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filters',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 26),
            onPressed: () async {
              await controller.forceRefreshApplications();
            },
            tooltip: 'Refresh Applications',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadJobOffers();
          await controller.loadApplications();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search and filter bar
              Container(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AppTextField(
                      hint: 'Search jobs, companies, or skills...',
                      prefixIcon: Icons.search_rounded,
                      suffixIcon: Icons.mic,
                      onChanged: controller.onSearchQueryChanged,
                      fillColor: Colors.white,
                      onSuffixIconTap: () => _showAudioSearchDialog(context),
                    ),
                    const SizedBox(height: 12),
                    // Active filters display
                    Obx(() {
                      final hasFilters =
                          controller.selectedLocation.value.isNotEmpty ||
                          controller.selectedContractType.value.isNotEmpty ||
                          controller.selectedCompany.value.isNotEmpty ||
                          controller.selectedSkills.isNotEmpty ||
                          controller.selectedSalaryRange.value.isNotEmpty ||
                          controller.selectedExperienceLevel.value.isNotEmpty;

                      if (!hasFilters) return const SizedBox.shrink();

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (controller.selectedLocation.value.isNotEmpty)
                            _buildFilterChip(
                              'Location: ${controller.selectedLocation.value}',
                              () {
                                controller.selectedLocation.value = '';
                                controller.searchJobOffers();
                              },
                            ),
                          if (controller.selectedContractType.value.isNotEmpty)
                            _buildFilterChip(
                              'Type: ${controller.selectedContractType.value}',
                              () {
                                controller.selectedContractType.value = '';
                                controller.searchJobOffers();
                              },
                            ),
                          if (controller.selectedCompany.value.isNotEmpty)
                            _buildFilterChip(
                              'Company: ${controller.selectedCompany.value}',
                              () {
                                controller.selectedCompany.value = '';
                                controller.searchJobOffers();
                              },
                            ),
                          ...controller.selectedSkills.map(
                            (skill) => _buildFilterChip('Skill: $skill', () {
                              controller.selectedSkills.remove(skill);
                              controller.searchJobOffers();
                            }),
                          ),
                          if (controller.selectedSalaryRange.value.isNotEmpty)
                            _buildFilterChip(
                              'Salary: ${controller.selectedSalaryRange.value}',
                              () {
                                controller.selectedSalaryRange.value = '';
                                controller.searchJobOffers();
                              },
                            ),
                          if (controller
                              .selectedExperienceLevel
                              .value
                              .isNotEmpty)
                            _buildFilterChip(
                              'Experience: ${controller.selectedExperienceLevel.value}',
                              () {
                                controller.selectedExperienceLevel.value = '';
                                controller.searchJobOffers();
                              },
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              // Recent Applications Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          'Recent Applications',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onBackgroundColor,
                        ),
                        TextButton(
                          onPressed:
                              () =>
                                  Get.toNamed(AppRoutes.candidateApplications),
                          child: const CustomText(
                            'View All',
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRecentApplicationsSection(),
                  ],
                ),
              ),

              // All Job Offers Section
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CustomText(
                          'All Job Offers',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onBackgroundColor,
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Job Offers List
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  }

                  if (controller.filteredOffers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const CustomText(
                              'No job offers found',
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            const CustomText(
                              'Try adjusting your search criteria',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Obx(() {
                    // Observe enterprise cache version to trigger rebuilds when enterprise data loads
                    controller.enterpriseCacheVersion.value;
                    return Column(
                      children:
                          controller.filteredOffers.map((jobOffer) {
                            return _buildJobOfferCard(jobOffer);
                          }).toList(),
                    );
                  });
                }),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentApplicationsSection() {
    return Obx(() {
      final recentApplications = controller.applications.take(3).toList();

      if (recentApplications.isEmpty) {
        return SizedBox(
          height: 120,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 32,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                const CustomText(
                  'No applications yet',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recentApplications.length,
          itemBuilder: (context, index) {
            final application = recentApplications[index];
            final jobOffer = controller.jobOffers.firstWhereOrNull(
              (offer) => offer.id == application.jobOfferId,
            );

            if (jobOffer == null) return const SizedBox.shrink();

            return Container(
              width: 200,
              margin: const EdgeInsets.only(right: 12),
              child: Card(
                color: const Color.fromARGB(255, 207, 233, 254),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getStatusColor(application.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            _getStatusText(application.status),
                            fontSize: 12,
                            color: _getStatusColor(application.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        jobOffer.title,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onBackgroundColor,
                      ),
                      CustomText(
                        jobOffer.company,
                        fontSize: 12,
                        color: AppTheme.onBackgroundColor,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        'Applied ${_getTimeAgo(application.appliedAt)}',
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildJobOfferCard(jobOffer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: const Color.fromARGB(255, 220, 238, 253),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.onBackgroundColor,
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          _getEnterpriseName(jobOffer),
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          jobOffer.company,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      controller.isFavorite(jobOffer.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          controller.isFavorite(jobOffer.id)
                              ? Colors.red
                              : Colors.grey,
                    ),
                    onPressed:
                        () async =>
                            await controller.toggleFavorite(jobOffer.id),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  CustomText(
                    jobOffer.location,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.work, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  CustomText(
                    jobOffer.contractType,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  CustomText(
                    jobOffer.salaryRange ?? 'Salary not specified',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          () => Get.toNamed(
                            AppRoutes.candidateJobDetail,
                            arguments: jobOffer,
                          ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const CustomText(
                        'View Details',
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.applyToJob(jobOffer.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const CustomText(
                        'Apply Now',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: CustomText(label, fontSize: 12, color: Colors.white),
      backgroundColor: AppTheme.primaryColor,
      deleteIcon: const Icon(Icons.close, color: Colors.white, size: 16),
      onDeleted: onDeleted,
    );
  }

  void _showSearchDialog(BuildContext context) {
    // Implementation for search dialog
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (context, scrollController) => FilterBottomSheet(
                  scrollController: scrollController,
                  controller: controller,
                ),
          ),
    );
  }

  void _showAudioSearchDialog(BuildContext context) {
    final audioController = Get.find<AudioSearchController>();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            await audioController.cancelListening();
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Voice Search',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        await audioController.cancelListening();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Voice wave animation with tap to start
                GestureDetector(
                  onTap: () async {
                    if (audioController.isListening.value) {
                      await audioController.stopListening();
                    } else {
                      await audioController.startListening();
                    }
                  },
                  child: Obx(() {
                    return _buildVoiceWaveAnimation(audioController);
                  }),
                ),
                const SizedBox(height: 20),
                // Real-time speech recognition display
                Obx(() {
                  final currentText = audioController.getCurrentText();
                  if (currentText.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 20),
                Obx(() {
                  String statusText;
                  Color statusColor = AppTheme.primaryColor;

                  if (audioController.isListening.value) {
                    statusText = 'Listening... Tap microphone to stop';
                  } else if (audioController.recognizedText.value.isNotEmpty) {
                    statusText = 'Processing...';
                    // Auto-close after processing
                    Future.delayed(const Duration(seconds: 1)).then((_) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        // Update search query with recognized text
                        controller.onSearchQueryChanged(
                          audioController.recognizedText.value,
                        );
                      }
                    });
                  } else if (audioController.lastError.value.isNotEmpty) {
                    statusText = 'Error: ${audioController.lastError.value}';
                    statusColor = Colors.red;
                  } else {
                    statusText = 'Tap microphone to start recording';
                  }

                  return Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  );
                }),
                const SizedBox(height: 20),
                // Start button (only show when not listening and no text)
                Obx(() {
                  if (!audioController.isListening.value &&
                      audioController.recognizedText.value.isEmpty) {
                    return ElevatedButton(
                      onPressed: () async {
                        audioController.clearText();
                        await audioController.startListening();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Start Recording',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoiceWaveAnimation(AudioSearchController audioController) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Multiple animated circles for better visual effect
          if (audioController.isListening.value) ...[
            // Outer circle
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 120 + (audioController.soundLevel.value * 80),
                height: 120 + (audioController.soundLevel.value * 80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(
                    audioController.soundLevel.value * 0.1,
                  ),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Middle circle
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                width: 100 + (audioController.soundLevel.value * 60),
                height: 100 + (audioController.soundLevel.value * 60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(
                    audioController.soundLevel.value * 0.2,
                  ),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Static circle when not listening
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey[400]!, width: 2),
              ),
            ),
          ],
          // Center microphone icon with pulse effect
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    audioController.isListening.value
                        ? AppTheme.primaryColor
                        : Colors.grey[400],
                boxShadow:
                    audioController.isListening.value
                        ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                        : null,
              ),
              child: Icon(
                audioController.isListening.value ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
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

  String _getEnterpriseName(jobOffer) {
    final enterprise = controller.getEnterpriseById(jobOffer.entrepriseId);
    return enterprise?.name ?? jobOffer.company;
  }
}

class FilterBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final CandidateController controller;

  const FilterBottomSheet({
    super.key,
    required this.scrollController,
    required this.controller,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String selectedLocation;
  late String selectedContractType;
  late String selectedCompany;
  late List<String> selectedSkills;
  late String selectedSalaryRange;
  late String selectedExperienceLevel;

  final List<String> locations = [
    'Paris',
    'Lyon',
    'Marseille',
    'Toulouse',
    'Nice',
    'Nantes',
    'Strasbourg',
    'Montpellier',
    'Bordeaux',
    'Lille',
    'Remote',
    'Hybrid',
  ];

  final List<String> contractTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Freelance',
    'Temporary',
  ];

  final List<String> salaryRanges = [
    'All salaries',
    '0€ - 30k€',
    '30k€ - 50k€',
    '50k€ - 70k€',
    '70k€ - 100k€',
    '100k€+',
  ];

  final List<String> experienceLevels = [
    'All levels',
    'Entry level (0-2 years)',
    'Mid-level (2-5 years)',
    'Senior (5-10 years)',
    'Expert (10+ years)',
  ];

  final List<String> commonSkills = [
    'JavaScript',
    'Python',
    'Java',
    'React',
    'Angular',
    'Vue.js',
    'Node.js',
    'Flutter',
    'Dart',
    'Swift',
    'Kotlin',
    'PHP',
    'C#',
    'C++',
    'SQL',
    'MongoDB',
    'AWS',
    'Docker',
    'Kubernetes',
    'Git',
    'Agile',
    'Scrum',
    'Management',
    'Design',
    'Marketing',
    'Sales',
    'Finance',
    'HR',
  ];

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.controller.selectedLocation.value;
    selectedContractType = widget.controller.selectedContractType.value;
    selectedCompany = widget.controller.selectedCompany.value;
    selectedSkills = List.from(widget.controller.selectedSkills);
    selectedSalaryRange =
        widget.controller.selectedSalaryRange.value.isEmpty
            ? 'All salaries'
            : widget.controller.selectedSalaryRange.value;
    selectedExperienceLevel =
        widget.controller.selectedExperienceLevel.value.isEmpty
            ? 'All levels'
            : widget.controller.selectedExperienceLevel.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Spacer(),
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onBackgroundColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Filter
                  _buildFilterSection(
                    title: 'Location',
                    icon: Icons.location_on,
                    child: _buildChipSelector(
                      options: locations,
                      selected: selectedLocation,
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contract Type Filter
                  _buildFilterSection(
                    title: 'Contract Type',
                    icon: Icons.work,
                    child: _buildChipSelector(
                      options: contractTypes,
                      selected: selectedContractType,
                      onChanged: (value) {
                        setState(() {
                          selectedContractType = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Salary Range Filter
                  _buildFilterSection(
                    title: 'Salary Range',
                    icon: Icons.attach_money,
                    child: _buildChipSelector(
                      options: salaryRanges,
                      selected: selectedSalaryRange,
                      onChanged: (value) {
                        setState(() {
                          selectedSalaryRange = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Experience Level Filter
                  _buildFilterSection(
                    title: 'Experience Level',
                    icon: Icons.trending_up,
                    child: _buildChipSelector(
                      options: experienceLevels,
                      selected: selectedExperienceLevel,
                      onChanged: (value) {
                        setState(() {
                          selectedExperienceLevel = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Skills Filter
                  _buildFilterSection(
                    title: 'Skills',
                    icon: Icons.code,
                    child: _buildMultiSelectChips(
                      options: commonSkills,
                      selected: selectedSkills,
                      onChanged: (skills) {
                        setState(() {
                          selectedSkills = skills;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Company Filter
                  _buildFilterSection(
                    title: 'Company',
                    icon: Icons.business,
                    child: _buildCompanyInput(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearAllFilters,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onBackgroundColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required String selected,
    required Function(String) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildMultiSelectChips({
    required List<String> options,
    required List<String> selected,
    required Function(List<String>) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () {
                final newSelected = List<String>.from(selected);
                if (isSelected) {
                  newSelected.remove(option);
                } else {
                  newSelected.add(option);
                }
                onChanged(newSelected);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(Icons.check, size: 16, color: Colors.white),
                    if (isSelected) const SizedBox(width: 4),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCompanyInput() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Company name',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onChanged: (value) {
        setState(() {
          selectedCompany = value;
        });
      },
    );
  }

  void _clearAllFilters() {
    setState(() {
      selectedLocation = '';
      selectedContractType = '';
      selectedCompany = '';
      selectedSkills.clear();
      selectedSalaryRange = 'All salaries';
      selectedExperienceLevel = 'All levels';
    });
  }

  void _applyFilters() {
    // Update controller with selected filters
    widget.controller.selectedLocation.value = selectedLocation;
    widget.controller.selectedContractType.value = selectedContractType;
    widget.controller.selectedCompany.value = selectedCompany;
    widget.controller.selectedSkills.value = selectedSkills;
    widget.controller.selectedSalaryRange.value =
        selectedSalaryRange == 'All salaries' ? '' : selectedSalaryRange;
    widget.controller.selectedExperienceLevel.value =
        selectedExperienceLevel == 'All levels' ? '' : selectedExperienceLevel;

    // Apply filters
    widget.controller.searchJobOffers();

    // Close dialog
    Navigator.pop(context);

    // Show success message
    Get.snackbar(
      'Filters Applied',
      'Filters have been applied successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.primaryColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
