// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/candidate_controller.dart';
import '../../../widgets/profile_item.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_routes.dart';

class HomePage extends GetView<ProfileController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverAppBar(
              expandedHeight: 120.0,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Statistics Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Your Overview',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    _buildStatisticsSection(user.role),
                  ],
                ),
              ),
            ),

            // Quick Actions Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Quick Actions',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    _buildQuickActionsSection(user.role),
                  ],
                ),
              ),
            ),

            // Recent Activity Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Recent Activity',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    _buildRecentActivitySection(user.role),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      }),
    );
  }

  Widget _buildStatisticsSection(String role) {
    if (role.toLowerCase() == 'candidate') {
      return Obx(() {
        // Get candidate controller for statistics
        final candidateController = Get.find<CandidateController>();
        final stats = candidateController.statistics;

        return SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 8),
              ProfileItem(
                itemColor: Colors.blue,
                itemText: 'Applications',
                itemCount: stats['applications'] ?? 0,
              ),
              const SizedBox(width: 12),
              ProfileItem(
                itemColor: Colors.green,
                itemText: 'Accepted',
                itemCount: stats['accepted'] ?? 0,
              ),
              const SizedBox(width: 12),
              ProfileItem(
                itemColor: Colors.orange,
                itemText: 'Pending',
                itemCount: stats['pending'] ?? 0,
              ),
              const SizedBox(width: 12),
              ProfileItem(
                itemColor: Colors.purple,
                itemText: 'Favorites',
                itemCount: stats['favorites'] ?? 0,
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      });
    } else {
      // For HR users, use the profile controller statistics
      return SizedBox(
        height: 100,
        child: Obx(() {
          final stats = controller.profileStatistics;
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 8),
              ProfileItem(
                itemColor: Colors.blue,
                itemText: 'Job Offers',
                itemCount: stats['jobOffers'] ?? 0,
              ),
              const SizedBox(width: 12),
              ProfileItem(
                itemColor: Colors.green,
                itemText: 'Active',
                itemCount: stats['activeOffers'] ?? 0,
              ),
              const SizedBox(width: 12),
              ProfileItem(
                itemColor: Colors.orange,
                itemText: 'Applications',
                itemCount: stats['applications'] ?? 0,
              ),
              const SizedBox(width: 12),
              ProfileItem(
                itemColor: Colors.purple,
                itemText: 'Hired',
                itemCount: stats['hired'] ?? 0,
              ),
              const SizedBox(width: 8),
            ],
          );
        }),
      );
    }
  }

  Widget _buildQuickActionsSection(String role) {
    if (role.toLowerCase() == 'candidate') {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildActionCard(
            'Search Jobs',
            Icons.search,
            Colors.blue,
            () => Get.toNamed(AppRoutes.candidateHome),
          ),
          _buildActionCard(
            'My Applications',
            Icons.work_outline,
            Colors.green,
            () => Get.toNamed(AppRoutes.candidateApplications),
          ),
          _buildActionCard(
            'Favorites',
            Icons.favorite_outline,
            Colors.red,
            () => Get.toNamed(AppRoutes.candidateFavorites),
          ),
          _buildActionCard(
            'Profile',
            Icons.person_outline,
            Colors.purple,
            () => Get.toNamed(AppRoutes.candidateProfile),
          ),
        ],
      );
    } else {
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
            () => Get.toNamed(AppRoutes.hrDashboard),
          ),
          _buildActionCard(
            'View Applications',
            Icons.people_outline,
            Colors.green,
            () => Get.toNamed(AppRoutes.hrApplications),
          ),
          _buildActionCard(
            'Company Profile',
            Icons.business,
            Colors.orange,
            () => Get.toNamed(AppRoutes.hrCompany),
          ),
          _buildActionCard(
            'Profile',
            Icons.person_outline,
            Colors.purple,
            () => Get.toNamed(AppRoutes.hrProfile),
          ),
        ],
      );
    }
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(String role) {
    if (role.toLowerCase() == 'candidate') {
      return Container(
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
          children: [
            _buildActivityItem(
              'Applied to Senior Developer at TechCorp',
              '2 hours ago',
              Icons.work_outline,
              Colors.blue,
            ),
            _buildActivityItem(
              'Application accepted at InnovateSoft',
              '1 day ago',
              Icons.check_circle_outline,
              Colors.green,
            ),
            _buildActivityItem(
              'Added Flutter Developer to favorites',
              '2 days ago',
              Icons.favorite_outline,
              Colors.red,
            ),
          ],
        ),
      );
    } else {
      return Container(
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
          children: [
            _buildActivityItem(
              'New application for Senior Developer',
              '1 hour ago',
              Icons.person_add_outlined,
              Colors.blue,
            ),
            _buildActivityItem(
              'Job offer "Flutter Developer" published',
              '3 hours ago',
              Icons.publish_outlined,
              Colors.green,
            ),
            _buildActivityItem(
              'Application status updated to "Hired"',
              '1 day ago',
              Icons.check_circle_outline,
              Colors.orange,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, fontSize: 14, fontWeight: FontWeight.w500),
                const SizedBox(height: 2),
                CustomText(time, fontSize: 12, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
