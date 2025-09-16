import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../../domain/entities/experience_entity.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class ExperienceFormScreen extends StatefulWidget {
  const ExperienceFormScreen({super.key});

  @override
  State<ExperienceFormScreen> createState() => _ExperienceFormScreenState();
}

class _ExperienceFormScreenState extends State<ExperienceFormScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentJob = false;

  ExperienceEntity? _editingExperience;
  int? _editingIndex;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _editingExperience = arguments['experience'] as ExperienceEntity?;
      _editingIndex = arguments['index'] as int?;
      _isEditing = _editingExperience != null;

      if (_isEditing && _editingExperience != null) {
        _jobTitleController.text = _editingExperience!.jobTitle;
        _companyController.text = _editingExperience!.company;
        _descriptionController.text = _editingExperience!.description;
        _startDate = _editingExperience!.startDate;
        _endDate = _editingExperience!.endDate;
        _isCurrentJob = _editingExperience!.isCurrentJob;
      }
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Experience' : 'Add Experience',
          style: const TextStyle(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              CustomText(
                _isEditing ? 'Edit Experience' : 'Add New Experience',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.onBackgroundColor,
              ),
              const SizedBox(height: 8),
              CustomText(
                'Fill in your professional experience details',
                fontSize: 16,
                // ignore: deprecated_member_use
                color: AppTheme.onBackgroundColor.withOpacity(0.7),
              ),
              const SizedBox(height: 32),

              // Job Title
              AppTextField(
                controller: _jobTitleController,
                label: 'Job Title',
                hint: 'e.g., Flutter Developer',
                prefixIcon: Icons.work,
                prefixIconColor: AppTheme.primaryColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Job title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Company
              AppTextField(
                controller: _companyController,
                label: 'Company',
                hint: 'e.g., TechCorp',
                prefixIcon: Icons.business,
                prefixIconColor: AppTheme.primaryColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Company name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Date Range
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: _selectStartDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      label: 'End Date',
                      date: _endDate,
                      onTap: _isCurrentJob ? null : _selectEndDate,
                      isCurrentJob: _isCurrentJob,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Current Job Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isCurrentJob,
                    onChanged: (value) {
                      setState(() {
                        _isCurrentJob = value ?? false;
                        if (_isCurrentJob) {
                          _endDate = null;
                        }
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  const Text('I currently work here'),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              AppTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your responsibilities and achievements',
                prefixIcon: Icons.description,
                prefixIconColor: AppTheme.primaryColor,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Save Button
              AppButton(
                label: _isEditing ? 'Update Experience' : 'Add Experience',
                onPressed: _saveExperience,
                backgroundColor: AppTheme.primaryColor,
                textStyle: const TextStyle(color: Colors.white),
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback? onTap,
    bool isCurrentJob = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.onBackgroundColor,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    isCurrentJob
                        ? 'Present'
                        : date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'Select date',
                    fontSize: 16,
                    color:
                        date != null || isCurrentJob
                            ? AppTheme.onBackgroundColor
                            : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_isCurrentJob) return;

    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _saveExperience() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      Get.snackbar(
        'Error',
        'Please select a start date',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (!_isCurrentJob && _endDate == null) {
      Get.snackbar(
        'Error',
        'Please select an end date or mark as current job',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final experience = ExperienceEntity(
      id:
          _isEditing
              ? _editingExperience!.id
              : DateTime.now().millisecondsSinceEpoch.toString(),
      jobTitle: _jobTitleController.text.trim(),
      company: _companyController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate!,
      endDate: _isCurrentJob ? null : _endDate,
      isCurrentJob: _isCurrentJob,
    );

    if (_isEditing && _editingIndex != null) {
      controller.updateExperience(_editingIndex!, experience);
    } else {
      controller.addExperience(experience);
    }

    Get.back();
  }
}
