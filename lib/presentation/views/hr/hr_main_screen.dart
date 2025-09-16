import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hr_controller.dart';
import '../../../core/theme/app_theme.dart';
import 'hr_dashboard_screen.dart';
import 'hr_job_posts_screen.dart';
import 'hr_applications_management_screen.dart';
import 'hr_profile_screen.dart';

class HRMainScreen extends GetView<HRController> {
  const HRMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.currentTab.value) {
          case 0:
            return const HRDashboardScreen();
          case 1:
            return HRJobPostsScreen();
          case 2:
            return const HRApplicationsManagementScreen();
          case 3:
            return const HRProfileScreen();
          default:
            return const HRDashboardScreen();
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
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'My Posts'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Applications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
