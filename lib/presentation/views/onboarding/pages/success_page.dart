import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/index.dart';
import '../../../controllers/onboarding_controller.dart';

class SuccessPage extends GetView<OnboardingController> {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Success icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 32),

          // Success message
          CustomText.title('Welcome aboard!', textAlign: TextAlign.center),

          const SizedBox(height: 16),

          CustomText.body(
            'Your profile has been created successfully. We\'re excited to have you on board!',
            textAlign: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),

          const SizedBox(height: 40),

          // Profile summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.subtitle(
                  'Profile Summary',
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),

                // Profile details
                _buildProfileDetail(
                  'Name',
                  '${controller.firstName.value} ${controller.lastName.value}',
                ),
                _buildProfileDetail('Age', '${controller.age.value} years old'),
                _buildProfileDetail(
                  'Gender',
                  _getGenderDisplay(controller.gender.value),
                ),
                _buildProfileDetail(
                  'Country',
                  _getCountryDisplay(controller.country.value),
                ),
                _buildProfileDetail('City', controller.city.value),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: CustomText.bodySmall(label, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: CustomText.bodySmall(
              value.isNotEmpty ? value : 'Not provided',
              color: value.isNotEmpty ? null : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _getGenderDisplay(String gender) {
    switch (gender) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Not selected';
    }
  }

  String _getCountryDisplay(String country) {
    switch (country) {
      case 'fr':
        return 'France';
      case 'en':
        return 'England';
      case 'tn':
        return 'Tunisia';
      default:
        return 'Not selected';
    }
  }
}
