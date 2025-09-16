import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/experience_entity.dart';
import '../../../widgets/custom_text.dart';
import 'experience_section.dart';

class ExperienceStepPage extends StatefulWidget {
  final List<ExperienceEntity> experiences;
  final Function(List<ExperienceEntity>) onExperiencesChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;

  const ExperienceStepPage({
    super.key,
    required this.experiences,
    required this.onExperiencesChanged,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
  });

  @override
  State<ExperienceStepPage> createState() => _ExperienceStepPageState();
}

class _ExperienceStepPageState extends State<ExperienceStepPage> {
  bool _skipExperience = false;

  @override
  Widget build(BuildContext context) {
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
            'Add your professional experiences (optional)',
            style: AppTheme.body1Medium.copyWith(
              // ignore: deprecated_member_use
              color: AppTheme.onBackgroundColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),

          // Skip option
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _skipExperience,
                  onChanged: (value) {
                    setState(() {
                      _skipExperience = value ?? false;
                    });
                    if (_skipExperience) {
                      widget.onExperiencesChanged([]);
                    }
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Skip this step',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onBackgroundColor,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        'You can add your experiences later in your profile',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (!_skipExperience) ...[
            const SizedBox(height: 24),

            // Experience section
            ExperienceSection(
              experiences: widget.experiences,
              onExperiencesChanged: widget.onExperiencesChanged,
              isRequired: false,
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
