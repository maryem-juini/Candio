import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../widgets/index.dart';
import '../../../controllers/onboarding_controller.dart';

class AgePage extends GetView<OnboardingController> {
  const AgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Age Field
          Obx(
            () => AppTextField(
              label: 'Age',
              hint: 'Enter your age',
              initialValue:
                  controller.age.value > 0
                      ? controller.age.value.toString()
                      : '',
              onChanged: controller.updateAge,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.cake_outlined,
              maxLength: 3,
              autoScrollIntoView: false,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),

          const SizedBox(height: 16),

          // Age validation info
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
                    'Please enter your age between 1 and 120 years',
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
