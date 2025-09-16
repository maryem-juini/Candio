import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hr_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/app_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/job_offer_entity.dart';

// ignore: must_be_immutable
class HRJobPostsScreen extends GetView<HRController> {
  HRJobPostsScreen({super.key});

  // Controllers for form fields
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _referenceController =
      TextEditingController();
  late final TextEditingController _locationController =
      TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final TextEditingController _profileController = TextEditingController();
  late final TextEditingController _technicalSkillsController =
      TextEditingController();
  late final TextEditingController _softSkillsController =
      TextEditingController();
  late final TextEditingController _educationController =
      TextEditingController();
  late final TextEditingController _experienceController =
      TextEditingController();
  late final TextEditingController _salaryController = TextEditingController();
  late final TextEditingController _benefitsController =
      TextEditingController();
  late final TextEditingController _workModeController =
      TextEditingController();
  late final TextEditingController _durationController =
      TextEditingController();

  // Values for dropdowns
  String? _contractTypeValue;
  String? _experienceLevelValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'My Posts',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddJobOfferDialog(context),
            tooltip: 'Publier un nouveau poste',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (controller.jobOffers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const CustomText(
                  'No job posts published',
                  fontSize: 18,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                const CustomText(
                  'Commencez par publier votre premier poste',
                  fontSize: 14,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showAddJobOfferDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Publier un poste'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadJobOffers,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.jobOffers.length,
            itemBuilder: (context, index) {
              final jobOffer = controller.jobOffers[index];
              return _buildJobOfferCard(context, jobOffer);
            },
          ),
        );
      }),
    );
  }

  Widget _buildJobOfferCard(BuildContext context, JobOfferEntity jobOffer) {
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        jobOffer.title,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onBackgroundColor,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
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
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected:
                      (value) =>
                          _handleJobOfferAction(context, value, jobOffer),
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(Icons.power_settings_new),
                              SizedBox(width: 8),
                              Text('Activer/Désactiver'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                  child: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomText(
              jobOffer.description,
              fontSize: 14,
              color: Colors.grey[700],
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                CustomText(
                  'Deadline: ${_formatDate(jobOffer.deadline)}',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: jobOffer.isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText(
                    jobOffer.isActive ? 'Active' : 'Inactive',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewApplications(context, jobOffer),
                    icon: const Icon(Icons.people),
                    label: const Text('View Applications'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewJobDetails(context, jobOffer),
                    icon: const Icon(Icons.visibility),
                    label: const Text('Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
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

  void _showAddJobOfferDialog(BuildContext context) {
    _resetForm();
    showDialog(
      context: context,
      builder: (context) => _buildJobOfferDialog(context, null),
    );
  }

  void _showEditJobOfferDialog(BuildContext context, JobOfferEntity jobOffer) {
    // Reset form first to ensure clean state
    _resetForm();
    // Then populate with job offer data
    _populateForm(jobOffer);
    showDialog(
      context: context,
      builder: (context) => _buildJobOfferDialog(context, jobOffer),
    );
  }

  Widget _buildJobOfferDialog(BuildContext context, JobOfferEntity? jobOffer) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header - Fixed height
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Icon(
                    jobOffer == null ? Icons.add_circle : Icons.edit,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      jobOffer == null
                          ? 'Publier un nouveau poste'
                          : 'Edit Post',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Form Content - Scrollable with flexible height
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Informations de base
                    _buildSectionHeader('Informations de base', Icons.info),
                    const SizedBox(height: 12),

                    // Responsive layout for small screens
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          // Stack vertically on small screens
                          return Column(
                            children: [
                              _buildTextField(
                                label: 'Titre du poste *',
                                hint: 'Ex: Développeur Flutter Senior',
                                controller: _titleController,
                                onChanged: (value) {
                                  // Mettre à jour le contrôleur principal pour la validation
                                  controller.jobTitle.value = value;
                                  // Le contrôleur de formulaire est déjà mis à jour automatiquement
                                },
                                icon: Icons.work,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                label: 'Référence du poste',
                                hint: 'Ex: DEV-FLUTTER-001',
                                controller: _referenceController,
                                onChanged: (value) {},
                                icon: Icons.tag,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                label: 'Location *',
                                hint: 'Ex: Paris, France',
                                controller: _locationController,
                                onChanged: (value) {
                                  // Mettre à jour le contrôleur principal pour la validation
                                  controller.jobLocation.value = value;
                                  // Le contrôleur de formulaire est déjà mis à jour automatiquement
                                },
                                icon: Icons.location_on,
                              ),
                              const SizedBox(height: 12),
                              _buildDropdownField(
                                label: 'Contract Type *',
                                value: _contractTypeValue,
                                onChanged: (value) {
                                  _contractTypeValue = value;
                                  controller.jobContractType.value =
                                      value ?? '';
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'CDI',
                                    child: Text('CDI'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'CDD',
                                    child: Text('CDD'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Stage',
                                    child: Text('Stage'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Alternance',
                                    child: Text('Alternance'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Freelance',
                                    child: Text('Freelance'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Intérim',
                                    child: Text('Intérim'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Part Time',
                                    child: Text('Part Time'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          // Row layout on larger screens
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Titre du poste *',
                                      hint: 'Ex: Développeur Flutter Senior',
                                      controller: _titleController,
                                      onChanged: (value) {
                                        // Mettre à jour le contrôleur principal pour la validation
                                        controller.jobTitle.value = value;
                                        // Le contrôleur de formulaire est déjà mis à jour automatiquement
                                      },
                                      icon: Icons.work,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Référence du poste',
                                      hint: 'Ex: DEV-FLUTTER-001',
                                      controller: _referenceController,
                                      onChanged: (value) {},
                                      icon: Icons.tag,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Location *',
                                      hint: 'Ex: Paris, France',
                                      controller: _locationController,
                                      onChanged: (value) {
                                        // Mettre à jour le contrôleur principal pour la validation
                                        controller.jobLocation.value = value;
                                        // Le contrôleur de formulaire est déjà mis à jour automatiquement
                                      },
                                      icon: Icons.location_on,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildDropdownField(
                                      label: 'Contract Type *',
                                      value: _contractTypeValue,
                                      onChanged: (value) {
                                        _contractTypeValue = value;
                                        controller.jobContractType.value =
                                            value ?? '';
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'CDI',
                                          child: Text('CDI'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'CDD',
                                          child: Text('CDD'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Stage',
                                          child: Text('Stage'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Alternance',
                                          child: Text('Alternance'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Freelance',
                                          child: Text('Freelance'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Intérim',
                                          child: Text('Intérim'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Part Time',
                                          child: Text('Part Time'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Job Details
                    _buildSectionHeader('Job Details', Icons.description),
                    const SizedBox(height: 12),

                    _buildTextField(
                      label: 'Description détaillée *',
                      hint:
                          'Décrivez en détail le poste, les responsabilités, les missions...',
                      controller: _descriptionController,
                      onChanged: (value) {
                        // Mettre à jour le contrôleur principal pour la validation
                        controller.jobDescription.value = value;
                        // Le contrôleur de formulaire est déjà mis à jour automatiquement
                      },
                      icon: Icons.description,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      label: 'Required Profile',
                      hint: 'Décrivez le profil idéal pour ce poste...',
                      controller: _profileController,
                      onChanged: (value) {},
                      icon: Icons.person_search,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Requirements and skills
                    _buildSectionHeader(
                      'Requirements and Skills',
                      Icons.psychology,
                    ),
                    const SizedBox(height: 12),

                    _buildRequirementsSection(),
                    const SizedBox(height: 20),

                    // Section 4: Conditions et rémunération
                    _buildSectionHeader(
                      'Conditions et rémunération',
                      Icons.attach_money,
                    ),
                    const SizedBox(height: 12),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return Column(
                            children: [
                              _buildTextField(
                                label: 'Fourchette salariale',
                                hint: 'Ex: 45K€ - 65K€ selon expérience',
                                controller: _salaryController,
                                onChanged: (value) {
                                  // Mettre à jour le contrôleur principal pour la validation
                                  controller.jobSalaryRange.value = value;
                                  // Le contrôleur de formulaire est déjà mis à jour automatiquement
                                },
                                icon: Icons.money,
                              ),
                              const SizedBox(height: 12),
                              _buildDropdownField(
                                label: 'Niveau d\'expérience',
                                value: _experienceLevelValue,
                                onChanged: (value) {
                                  _experienceLevelValue = value;
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'junior',
                                    child: Text('Junior (0-2 ans)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'intermediate',
                                    child: Text('Intermédiaire (3-5 ans)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'senior',
                                    child: Text('Senior (5+ ans)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'expert',
                                    child: Text('Expert (8+ ans)'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                label: 'Avantages sociaux',
                                hint: 'Ex: Mutuelle, tickets restaurant, CE...',
                                controller: _benefitsController,
                                onChanged: (value) {},
                                icon: Icons.card_giftcard,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                label: 'Modalités de travail',
                                hint: 'Ex: Télétravail, hybride, présentiel',
                                controller: _workModeController,
                                onChanged: (value) {},
                                icon: Icons.home_work,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Fourchette salariale',
                                      hint: 'Ex: 45K€ - 65K€ selon expérience',
                                      controller: _salaryController,
                                      onChanged: (value) {
                                        // Mettre à jour le contrôleur principal pour la validation
                                        controller.jobSalaryRange.value = value;
                                        // Le contrôleur de formulaire est déjà mis à jour automatiquement
                                      },
                                      icon: Icons.money,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildDropdownField(
                                      label: 'Niveau d\'expérience',
                                      value: _experienceLevelValue,
                                      onChanged: (value) {
                                        _experienceLevelValue = value;
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'junior',
                                          child: Text('Junior (0-2 ans)'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'intermediate',
                                          child: Text(
                                            'Intermédiaire (3-5 ans)',
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'senior',
                                          child: Text('Senior (5+ ans)'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'expert',
                                          child: Text('Expert (8+ ans)'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Avantages sociaux',
                                      hint:
                                          'Ex: Mutuelle, tickets restaurant, CE...',
                                      controller: _benefitsController,
                                      onChanged: (value) {},
                                      icon: Icons.card_giftcard,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      label: 'Modalités de travail',
                                      hint:
                                          'Ex: Télétravail, hybride, présentiel',
                                      controller: _workModeController,
                                      onChanged: (value) {},
                                      icon: Icons.home_work,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Section 5: Planning et dates
                    _buildSectionHeader(
                      'Planning et dates',
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return Column(
                            children: [
                              _buildDateField(
                                label: 'Date de début souhaitée',
                                value: DateTime.now().add(
                                  const Duration(days: 30),
                                ),
                                onChanged: (date) {},
                              ),
                              const SizedBox(height: 12),
                              _buildDateField(
                                label: 'Date limite de candidature *',
                                value: controller.jobDeadline.value,
                                onChanged: (date) {
                                  if (date != null) {
                                    controller.jobDeadline.value = date;
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                label: 'Durée du contrat',
                                hint: 'Ex: 6 mois, 1 an, permanent',
                                controller: _durationController,
                                onChanged: (value) {},
                                icon: Icons.schedule,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDateField(
                                      label: 'Date de début souhaitée',
                                      value: DateTime.now().add(
                                        const Duration(days: 30),
                                      ),
                                      onChanged: (date) {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildDateField(
                                      label: 'Date limite de candidature *',
                                      value: controller.jobDeadline.value,
                                      onChanged: (date) {
                                        if (date != null) {
                                          controller.jobDeadline.value = date;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                label: 'Durée du contrat',
                                hint: 'Ex: 6 mois, 1 an, permanent',
                                controller: _durationController,
                                onChanged: (value) {},
                                icon: Icons.schedule,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Footer with action buttons - Fixed height
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: AppTheme.primaryColor),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_validateForm()) {
                          await _saveJobOffer(jobOffer);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        jobOffer == null ? 'Publier le poste' : 'Edit Post',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (controller.jobTitle.value.isEmpty ||
        controller.jobLocation.value.isEmpty ||
        controller.jobContractType.value.isEmpty ||
        controller.jobDescription.value.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs obligatoires',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> _saveJobOffer(JobOfferEntity? jobOffer) async {
    try {
      if (jobOffer == null) {
        // Création d'un nouveau poste
        // Mettre à jour les valeurs du contrôleur avec les valeurs du formulaire
        controller.jobTitle.value = _titleController.text;
        controller.jobLocation.value = _locationController.text;
        controller.jobContractType.value = _contractTypeValue ?? '';
        controller.jobDescription.value = _descriptionController.text;
        controller.jobSalaryRange.value = _salaryController.text;

        await controller.createJobOffer();
        Get.snackbar(
          'Succès',
          'Poste publié avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Modification d'un poste existant
        // Create an updated post with new values
        final updatedJobOffer = jobOffer.copyWith(
          title: _titleController.text,
          location: _locationController.text,
          contractType: _contractTypeValue ?? jobOffer.contractType,
          description: _descriptionController.text,
          salaryRange:
              _salaryController.text.isNotEmpty ? _salaryController.text : null,
        );

        // Appeler updateJobOffer (le contrôleur gère déjà l'affichage du snackbar)
        await controller.updateJobOffer(updatedJobOffer);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _handleJobOfferAction(
    BuildContext context,
    String action,
    JobOfferEntity jobOffer,
  ) {
    switch (action) {
      case 'edit':
        _showEditJobOfferDialog(context, jobOffer);
        break;
      case 'toggle':
        _toggleJobOfferStatus(jobOffer);
        break;
      case 'delete':
        _showDeleteConfirmation(context, jobOffer);
        break;
    }
  }

  void _toggleJobOfferStatus(JobOfferEntity jobOffer) {
    final updatedJobOffer = jobOffer.copyWith(isActive: !jobOffer.isActive);
    controller.updateJobOffer(updatedJobOffer);
  }

  void _showDeleteConfirmation(BuildContext context, JobOfferEntity jobOffer) {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: 'Confirm Deletion',
            content:
                'Êtes-vous sûr de vouloir supprimer le poste "${jobOffer.title}" ?',
            firstButtonLabel: 'Cancel',
            secondButtonLabel: 'Delete',
            onFirstButtonPressed: () => Navigator.of(context).pop(),
            onSecondButtonPressed: () async {
              await controller.deleteJobOffer(jobOffer.id);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            secondButtonVariant: AppButtonVariant.primary,
            secondButtonColor: Colors.red,
          ),
    );
  }

  void _viewApplications(BuildContext context, JobOfferEntity jobOffer) {
    // Charger les candidatures pour ce poste spécifique
    controller.loadApplicationsForJob(jobOffer.id);
    // Switch to Applications tab (index 2)
    controller.changeTab(2);
  }

  void _viewJobDetails(BuildContext context, JobOfferEntity jobOffer) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              jobOffer.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Company', jobOffer.company),
                  _buildDetailRow('Location', jobOffer.location),
                  _buildDetailRow('Contract Type', jobOffer.contractType),
                  _buildDetailRow('Description', jobOffer.description),
                  _buildDetailRow(
                    'Requirements',
                    jobOffer.requirements.join(', '),
                  ),
                  if (jobOffer.salaryRange != null)
                    _buildDetailRow('Salary', jobOffer.salaryRange!),
                  _buildDetailRow('Deadline', _formatDate(jobOffer.deadline)),
                  _buildDetailRow(
                    'Status',
                    jobOffer.isActive ? 'Active' : 'Inactive',
                  ),
                ],
              ),
            ),
            actions: [
              AppButton(
                variant: AppButtonVariant.primary,
                label: 'Fermer',
                onPressed: () => Navigator.of(context).pop(),
                isExpanded: true,
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

  void _resetForm() {
    // Reset controller values
    controller.jobTitle.value = '';
    controller.jobLocation.value = '';
    controller.jobContractType.value = '';
    controller.jobDescription.value = '';
    controller.jobRequirements.clear();
    controller.jobSalaryRange.value = '';
    controller.jobDeadline.value = DateTime.now().add(const Duration(days: 30));

    // Reset form controllers
    _titleController.clear();
    _referenceController.clear();
    _locationController.clear();
    _descriptionController.clear();
    _profileController.clear();
    _technicalSkillsController.clear();
    _softSkillsController.clear();
    _educationController.clear();
    _experienceController.clear();
    _salaryController.clear();
    _benefitsController.clear();
    _workModeController.clear();
    _durationController.clear();

    // Reset dropdown values
    _contractTypeValue = null;
    _experienceLevelValue = null;
  }

  void _populateForm(JobOfferEntity jobOffer) {
    // Populate form controllers first
    _titleController.text = jobOffer.title;
    _referenceController.text = ''; // Set default or from jobOffer if available
    _locationController.text = jobOffer.location;
    _descriptionController.text = jobOffer.description;
    _profileController.text = ''; // Set default or from jobOffer if available
    _technicalSkillsController.text =
        jobOffer.requirements.isNotEmpty
            ? jobOffer.requirements.join(', ')
            : '';
    _softSkillsController.text =
        ''; // Set default or from jobOffer if available
    _educationController.text = ''; // Set default or from jobOffer if available
    _experienceController.text =
        ''; // Set default or from jobOffer if available
    _salaryController.text = jobOffer.salaryRange ?? '';
    _benefitsController.text = ''; // Set default or from jobOffer if available
    _workModeController.text = ''; // Set default or from jobOffer if available
    _durationController.text = ''; // Set default or from jobOffer if available

    // Populate dropdown values
    // Vérifier que le type de contrat existe dans la liste des options
    final validContractTypes = [
      'CDI',
      'CDD',
      'Stage',
      'Alternance',
      'Freelance',
      'Intérim',
      'Part Time',
    ];
    _contractTypeValue =
        validContractTypes.contains(jobOffer.contractType)
            ? jobOffer.contractType
            : null;
    _experienceLevelValue = null; // Set from jobOffer if available

    // Then populate controller values to keep them in sync
    controller.jobTitle.value = jobOffer.title;
    controller.jobLocation.value = jobOffer.location;
    controller.jobContractType.value = jobOffer.contractType;
    controller.jobDescription.value = jobOffer.description;
    controller.jobRequirements.value = List.from(jobOffer.requirements);
    controller.jobSalaryRange.value = jobOffer.salaryRange ?? '';
    controller.jobDeadline.value = jobOffer.deadline;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper methods for the enhanced form
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 18),
        const SizedBox(width: 8),
        CustomText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.onBackgroundColor,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.onBackgroundColor,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.onBackgroundColor,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
          ),
          items: items,
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppTheme.primaryColor,
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required Function(DateTime?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.onBackgroundColor,
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: value,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
                const SizedBox(width: 10),
                Text(
                  _formatDate(value),
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Stack vertically on small screens
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Compétences techniques',
                hint: 'Ex: Flutter, Dart, Firebase...',
                controller: _technicalSkillsController,
                onChanged: (value) {},
                icon: Icons.code,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Compétences soft skills',
                hint: 'Ex: Communication, travail d\'équipe...',
                controller: _softSkillsController,
                onChanged: (value) {},
                icon: Icons.people,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Required Education',
                hint: 'Ex: Bac+5 en informatique ou équivalent',
                controller: _educationController,
                onChanged: (value) {},
                icon: Icons.school,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Minimum Experience',
                hint: 'Ex: 3 ans d\'expérience en développement mobile',
                controller: _experienceController,
                onChanged: (value) {},
                icon: Icons.timeline,
              ),
            ],
          );
        } else {
          // Row layout on larger screens
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Compétences techniques',
                      hint: 'Ex: Flutter, Dart, Firebase...',
                      controller: _technicalSkillsController,
                      onChanged: (value) {},
                      icon: Icons.code,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Compétences soft skills',
                      hint: 'Ex: Communication, travail d\'équipe...',
                      controller: _softSkillsController,
                      onChanged: (value) {},
                      icon: Icons.people,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Required Education',
                      hint: 'Ex: Bac+5 en informatique ou équivalent',
                      controller: _educationController,
                      onChanged: (value) {},
                      icon: Icons.school,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Minimum Experience',
                      hint: 'Ex: 3 ans d\'expérience en développement mobile',
                      controller: _experienceController,
                      onChanged: (value) {},
                      icon: Icons.timeline,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
