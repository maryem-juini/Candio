import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip/Start button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => TextButton(
                    onPressed:
                        controller.isLastPage.value
                            ? controller.completeOnboarding
                            : controller.skipOnboarding,
                    child: Text(
                      controller.isLastPage.value ? 'Get Started' : 'Skip',
                      style: AppTheme.body1Medium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller:
                    controller.pageController, // ✅ now linked to controller
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: AppConfig.defaultSizedBox),
                        // Image
                        Image.asset(page.image, fit: BoxFit.cover),
                        SizedBox(height: AppConfig.defaultSizedBox),

                        // Title
                        Text(
                          page.title,
                          style: AppTheme.heading2Bold.copyWith(
                            color: AppTheme.onBackgroundColor,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: AppConfig.defaultSmallSizedBox),

                        // Description
                        Text(
                          page.description,
                          style: AppTheme.body1Medium.copyWith(
                            color: AppTheme.onBackgroundColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section with progress indicators
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.pages.length,
                      (index) => Obx(
                        () => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentPage.value == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                controller.currentPage.value == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
