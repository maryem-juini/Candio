// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hr_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../routes/app_routes.dart';

class HRDashboardScreen extends GetView<HRController> {
  const HRDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'HR Dashboard',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              await controller.forceRefreshApplications();
            },
            tooltip: 'Refresh Applications',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.forceRefreshApplications,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Welcome Header
              Container(
                margin: const EdgeInsets.all(AppConfig.defaultPadding),
                child: _buildWelcomeHeader(),
              ),

              // Quick Actions Section
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConfig.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Quick Actions',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onBackgroundColor,
                    ),
                    const SizedBox(height: 16),
                    _buildQuickActionsSection(),
                  ],
                ),
              ),

              // Quick Insights Section
              Container(
                margin: const EdgeInsets.all(AppConfig.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Quick Insights',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onBackgroundColor,
                    ),
                    const SizedBox(height: 16),
                    _buildQuickInsightsSection(),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildActionCard(
          'Create Job Offer',
          Icons.add_business,
          Colors.blue,
          () => controller.changeTab(1), // Go to "My Posts" tab
        ),
        _buildActionCard(
          'View Applications',
          Icons.people_outline,
          Colors.green,
          () => controller.changeTab(2), // Go to "Applications" tab
        ),
        _buildActionCard(
          'Company Profile',
          Icons.business,
          Colors.orange,
          () => Get.toNamed(AppRoutes.hrCompany),
        ),
        _buildActionCard(
          'My Profile',
          Icons.person_outline,
          Colors.purple,
          () => controller.changeTab(3), // Go to "Profile" tab (last tab)
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            CustomText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              color: AppTheme.onBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Welcome back! 👋',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const CustomText(
                  'Ready to find the perfect candidates?',
                  fontSize: 16,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const CustomText(
                    'HR Manager',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business_center,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInsightsSection() {
    return Obx(() {
      final stats = controller.statistics;
      final totalApplications = stats['applications'] ?? 0;
      final activeOffers = stats['activeOffers'] ?? 0;
      final hired = stats['hired'] ?? 0;

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  '📊',
                  'Success Rate',
                  '${totalApplications > 0 ? ((hired / totalApplications) * 100).toStringAsFixed(1) : '0'}%',
                  Colors.green,
                  'Hiring efficiency',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  '⚡',
                  'Active Offers',
                  '$activeOffers',
                  Colors.blue,
                  'Currently recruiting',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  '🎯',
                  'This Month',
                  '$totalApplications',
                  Colors.orange,
                  'New applications',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  '🏆',
                  'Total Hired',
                  '$hired',
                  Colors.purple,
                  'Successful placements',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildInsightCard(
    String emoji,
    String title,
    String value,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  title,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            value,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          const SizedBox(height: 4),
          CustomText(subtitle, fontSize: 10, color: Colors.grey[500]),
        ],
      ),
    );
  }
}
