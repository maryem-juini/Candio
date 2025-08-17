import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/index.dart';
import '../../../controllers/onboarding_controller.dart';

class CityPage extends GetView<OnboardingController> {
  const CityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // City Field
          Obx(
            () => AppTextField(
              label: 'City',
              hint: 'Enter your city',
              initialValue: controller.city.value,
              onChanged: controller.updateCity,
              textCapitalization: TextCapitalization.words,
              prefixIcon: Icons.location_city_outlined,
              autoScrollIntoView: false,
            ),
          ),

          const SizedBox(height: 16),

          // City info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText.bodySmall(
                    'Enter the city where you currently live',
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
