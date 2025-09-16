// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/experience_entity.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/app_button.dart';

class ExperienceSection extends StatefulWidget {
  final List<ExperienceEntity> experiences;
  final Function(List<ExperienceEntity>) onExperiencesChanged;
  final bool isRequired;

  const ExperienceSection({
    super.key,
    required this.experiences,
    required this.onExperiencesChanged,
    this.isRequired = false,
  });

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  final List<ExperienceFormData> _experienceForms = [];
  bool _skipExperience = false;

  @override
  void initState() {
    super.initState();
    if (widget.experiences.isNotEmpty) {
      for (var experience in widget.experiences) {
        _experienceForms.add(ExperienceFormData.fromEntity(experience));
      }
    } else {
      _addNewExperience();
    }
  }

  void _addNewExperience() {
    setState(() {
      _experienceForms.add(ExperienceFormData());
    });
  }

  void _removeExperience(int index) {
    setState(() {
      _experienceForms.removeAt(index);
    });
    _updateExperiences();
  }

  void _updateExperiences() {
    if (_skipExperience) {
      widget.onExperiencesChanged([]);
      return;
    }

    final experiences = <ExperienceEntity>[];
    for (int i = 0; i < _experienceForms.length; i++) {
      final form = _experienceForms[i];
      if (form.isValid()) {
        experiences.add(form.toEntity());
      }
    }
    widget.onExperiencesChanged(experiences);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skip option
        if (widget.isRequired)
          Row(
            children: [
              Checkbox(
                value: _skipExperience,
                onChanged: (value) {
                  setState(() {
                    _skipExperience = value ?? false;
                  });
                  _updateExperiences();
                },
                activeColor: AppTheme.primaryColor,
              ),
              const Text('Passer cette étape (0 expérience)'),
            ],
          ),

        if (!_skipExperience) ...[
          const SizedBox(height: 16),

          // Experience forms
          ...List.generate(_experienceForms.length, (index) {
            return _buildExperienceForm(index);
          }),

          const SizedBox(height: 16),

          // Add experience button
          AppButton(
            label: 'Ajouter une expérience',
            onPressed: _addNewExperience,
            backgroundColor: AppTheme.primaryColor,
            leadingIcon: Icons.add,
            textStyle: TextStyle(color: AppTheme.backgroundColor),
          ),
        ],
      ],
    );
  }

  Widget _buildExperienceForm(int index) {
    final form = _experienceForms[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Expérience ${index + 1}',
                style: AppTheme.heading2Bold.copyWith(
                  color: AppTheme.onBackgroundColor,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              if (_experienceForms.length > 1)
                IconButton(
                  onPressed: () => _removeExperience(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Job title
          AppTextField(
            controller: form.jobTitleController,
            label: 'Poste occupé',
            hint: 'Ex: Développeur Flutter',
            prefixIcon: Icons.work,
            prefixIconColor: AppTheme.primaryColor,
            onChanged: (_) => _updateExperiences(),
          ),
          const SizedBox(height: 16),

          // Company
          AppTextField(
            controller: form.companyController,
            label: 'Entreprise',
            hint: 'Ex: TechCorp',
            prefixIcon: Icons.business,
            prefixIconColor: AppTheme.primaryColor,
            onChanged: (_) => _updateExperiences(),
          ),
          const SizedBox(height: 16),

          // Date range
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date de début',
                      style: AppTheme.body2Medium.copyWith(
                        color: AppTheme.onBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectStartDate(index),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              form.startDate != null
                                  ? '${form.startDate!.day}/${form.startDate!.month}/${form.startDate!.year}'
                                  : 'Sélectionner',
                              style: AppTheme.body2Medium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date de fin',
                      style: AppTheme.body2Medium.copyWith(
                        color: AppTheme.onBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectEndDate(index),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              form.isCurrentJob
                                  ? 'En cours'
                                  : form.endDate != null
                                  ? '${form.endDate!.day}/${form.endDate!.month}/${form.endDate!.year}'
                                  : 'Sélectionner',
                              style: AppTheme.body2Medium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Current job checkbox
          Row(
            children: [
              Checkbox(
                value: form.isCurrentJob,
                onChanged: (value) {
                  setState(() {
                    form.isCurrentJob = value ?? false;
                    if (form.isCurrentJob) {
                      form.endDate = null;
                    }
                  });
                  _updateExperiences();
                },
                activeColor: AppTheme.primaryColor,
              ),
              const Text('J\'occupe actuellement ce poste'),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          AppTextField(
            controller: form.descriptionController,
            label: 'Description',
            hint: 'Décrivez vos responsabilités et réalisations',
            prefixIcon: Icons.description,
            prefixIconColor: AppTheme.primaryColor,
            maxLines: 3,
            onChanged: (_) => _updateExperiences(),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(int index) async {
    final form = _experienceForms[index];
    final date = await showDatePicker(
      context: context,
      initialDate: form.startDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        form.startDate = date;
      });
      _updateExperiences();
    }
  }

  Future<void> _selectEndDate(int index) async {
    final form = _experienceForms[index];
    if (form.isCurrentJob) return;

    final date = await showDatePicker(
      context: context,
      initialDate: form.endDate ?? DateTime.now(),
      firstDate: form.startDate ?? DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        form.endDate = date;
      });
      _updateExperiences();
    }
  }
}

class ExperienceFormData {
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool isCurrentJob = false;

  ExperienceFormData();

  factory ExperienceFormData.fromEntity(ExperienceEntity entity) {
    final form = ExperienceFormData();
    form.jobTitleController.text = entity.jobTitle;
    form.companyController.text = entity.company;
    form.descriptionController.text = entity.description;
    form.startDate = entity.startDate;
    form.endDate = entity.endDate;
    form.isCurrentJob = entity.isCurrentJob;
    return form;
  }

  bool isValid() {
    return jobTitleController.text.trim().isNotEmpty &&
        companyController.text.trim().isNotEmpty &&
        startDate != null &&
        (isCurrentJob || endDate != null);
  }

  ExperienceEntity toEntity() {
    return ExperienceEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobTitle: jobTitleController.text.trim(),
      company: companyController.text.trim(),
      description: descriptionController.text.trim(),
      startDate: startDate!,
      endDate: isCurrentJob ? null : endDate,
      isCurrentJob: isCurrentJob,
    );
  }
}
