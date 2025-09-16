import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/candidate_controller.dart';
import '../../../core/theme/app_theme.dart';
import 'candidate_home_screen.dart';
import 'candidate_favorites_screen.dart';
import 'candidate_profile_screen.dart';
import 'candidate_applications_screen.dart';

class CandidateMainScreen extends GetView<CandidateController> {
  const CandidateMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.currentTab.value) {
          case 0:
            return const CandidateHomeScreen();
          case 1:
            return const CandidateFavoritesScreen();
          case 2:
            return const CandidateApplicationsScreen();
          case 3:
            return const CandidateProfileScreen();
          default:
            return const CandidateHomeScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentTab.value,
          onTap: controller.changeTab,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: AppTheme.backgroundColor,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Applications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
