import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/index.dart';
import '../../../controllers/onboarding_controller.dart';

class NamePage extends GetView<OnboardingController> {
  const NamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // First Name Field
          Obx(
            () => AppTextField(
              label: 'First Name',
              hint: 'Enter your first name',
              initialValue: controller.firstName.value,
              onChanged: controller.updateFirstName,
              textCapitalization: TextCapitalization.words,
              prefixIcon: Icons.person_outline,
              autoScrollIntoView: false,
            ),
          ),

          const SizedBox(height: 24),

          // Last Name Field
          Obx(
            () => AppTextField(
              label: 'Last Name',
              hint: 'Enter your last name',
              initialValue: controller.lastName.value,
              onChanged: controller.updateLastName,
              textCapitalization: TextCapitalization.words,
              prefixIcon: Icons.person_outline,
              autoScrollIntoView: false,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
