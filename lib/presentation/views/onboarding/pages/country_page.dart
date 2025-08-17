import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/index.dart';
import '../../../controllers/onboarding_controller.dart';

class CountryPage extends GetView<OnboardingController> {
  const CountryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Country options
          Expanded(
            child: ListView.separated(
              itemCount: controller.countryOptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final option = controller.countryOptions[index];
                return Obx(
                  () => SelectableCard(
                    title: option['title'],
                    subtitle: option['subtitle'],
                    icon: option['icon'],
                    isSelected: controller.country.value == option['value'],
                    onTap: () => controller.selectCountry(option['value']),
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
