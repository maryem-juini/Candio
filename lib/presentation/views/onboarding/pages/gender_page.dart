import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/index.dart';
import '../../../controllers/onboarding_controller.dart';

class GenderPage extends GetView<OnboardingController> {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Gender options
          Expanded(
            child: ListView.separated(
              itemCount: controller.genderOptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final option = controller.genderOptions[index];
                return Obx(
                  () => SelectableCard(
                    title: option['title'],
                    icon: option['icon'],
                    isSelected: controller.gender.value == option['value'],
                    onTap: () => controller.selectGender(option['value']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
