import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/consts/assets.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final currentPage = 0.obs;
  final isLastPage = false.obs;
  final pageProgress = 0.0.obs;

  Timer? _timer;
  static const int pageDuration = 3; // 3 seconds per page

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to Candio',
      description:
          'The simplest and most efficient application management platform',
      image: AppAssets.onboarding1,
    ),
    OnboardingPage(
      title: 'For Candidates',
      description: 'Find job offers, apply easily and track your applications',
      image: AppAssets.onboarding2,
    ),
    OnboardingPage(
      title: 'For HR',
      description:
          'Manage your job offers, receive applications and find the best talents',
      image: AppAssets.onboarding3,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    updateLastPageStatus();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    updateLastPageStatus();
    resetTimer();
  }

  void updateLastPageStatus() {
    isLastPage.value = currentPage.value == pages.length - 1;
  }

  void startTimer() {
    _timer?.cancel();
    pageProgress.value = 0.0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (pageProgress.value < 1.0) {
        pageProgress.value += 0.05 / pageDuration; // fill in 3 seconds
      } else {
        // Page completed, move to next page or complete onboarding
        if (currentPage.value < pages.length - 1) {
          nextPage();
        } else {
          // Last page completed, automatically navigate to auth
          timer.cancel();
          completeOnboarding();
        }
      }
    });
  }

  void resetTimer() {
    pageProgress.value = 0.0;
    startTimer();
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updateLastPageStatus();
      resetTimer();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updateLastPageStatus();
      resetTimer();
    }
  }

  void skipOnboarding() async {
    // Go to next page instead of skipping to auth
    nextPage();
  }

  void completeOnboarding() async {
    await _markOnboardingComplete();
    Get.offAllNamed('/auth');
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}
