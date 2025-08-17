import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/index.dart';
import '../../controllers/onboarding_controller.dart';
import 'pages/name_page.dart';
import 'pages/age_page.dart';
import 'pages/gender_page.dart';
import 'pages/country_page.dart';
import 'pages/city_page.dart';
import 'pages/success_page.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle native back button
        if (controller.currentPage.value > 0) {
          // If not on first page, go to previous page
          controller.previousPage();
          return false; // Prevent default back behavior
        } else {
          // If on first page, allow normal back navigation
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header with progress bar and back button
              _buildHeader(context),

              // Page view content
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    NamePage(),
                    AgePage(),
                    GenderPage(),
                    CountryPage(),
                    CityPage(),
                    SuccessPage(),
                  ],
                ),
              ),

              // Bottom navigation
              _buildBottomNavigation(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Top row with back button and progress
          Row(
            children: [
              // Back button
              Obx(
                () =>
                    controller.currentPage.value > 0
                        ? IconButton(
                          onPressed: controller.previousPage,
                          icon: const Icon(Icons.arrow_back),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                        : const SizedBox(width: 48),
              ),

              const SizedBox(width: 16),

              // Progress bar
              Expanded(
                child: Obx(
                  () => LinearProgressIndicator(
                    value: controller.progress,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Page title and subtitle
          Obx(
            () => Column(
              children: [
                CustomText.title(
                  controller.currentPageTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                CustomText.body(
                  controller.currentPageSubtitle,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Obx(() {
        final isLastPage =
            controller.currentPage.value == controller.totalPages - 1;
        final isCurrentPageValid = controller.isCurrentPageValid;
        final isCreatingUser = controller.isCreatingUser.value;

        return AppButton(
          label:
              isLastPage
                  ? (isCreatingUser ? 'Creating Profile...' : 'Get Started')
                  : 'Continue',
          isExpanded: true,
          variant: AppButtonVariant.primary,
          isActive: isCurrentPageValid && !isCreatingUser,
          isLoading: isCreatingUser,
          onPressed:
              (isCurrentPageValid && !isCreatingUser)
                  ? (isLastPage
                      ? controller.completeOnboarding
                      : controller.nextPage)
                  : null,
        );
      }),
    );
  }
}
