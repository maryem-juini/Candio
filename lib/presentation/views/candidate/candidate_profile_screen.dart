import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../../widgets/profile_option.dart';
import '../../../widgets/profile_picture_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class CandidateProfileScreen extends GetView<ProfileController> {
  const CandidateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        // Check if profile controller is available
        if (!Get.isRegistered<ProfileController>()) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading profile...'),
              ],
            ),
          );
        }

        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading user data...'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshProfileData();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar with Profile Header
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                elevation: 0,
                automaticallyImplyLeading: false,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _showLogoutDialog(context),
                    tooltip: 'Sign Out',
                  ),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Profile content
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  // Profile picture with shadow only
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ProfilePicturePicker(
                                      currentImageUrl: user.profilePictureUrl,
                                      size: 100,
                                      onImageUploaded: (url) async {
                                        if (url != null) {
                                          await controller.updateProfilePicture(
                                            url,
                                          );
                                        }
                                      },
                                      onImageDeleted: () async {
                                        await controller.deleteProfilePicture();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // User name
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // User email
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Role badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Profile Options
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppConfig.defaultPadding,
                    vertical: AppConfig.defaultPadding,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        ProfileOption(
                          onPressed: () => _navigateToEditProfile(),
                          label: 'Edit Profile',
                          icon: Icons.edit_outlined,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToExperienceManagement(),
                          label: 'Manage Experience',
                          icon: Icons.work_outline,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToChangePassword(),
                          label: 'Change Password',
                          icon: Icons.lock_outline,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToCompanyProfile(),
                          label: 'Company Profile',
                          icon: Icons.business_outlined,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToNotifications(),
                          label: 'Notifications',
                          icon: Icons.notifications_outlined,
                          trailing: Switch(
                            value: controller.isNotificationsEnabled.value,
                            onChanged:
                                (value) => controller.toggleNotifications(),
                            activeColor: AppTheme.primaryColor,
                            activeTrackColor: AppTheme.primaryColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToPrivacy(),
                          label: 'Privacy & Security',
                          icon: Icons.security_outlined,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToHelp(),
                          label: 'Help & Support',
                          icon: Icons.help_outline,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _navigateToAbout(),
                          label: 'About',
                          icon: Icons.info_outline,
                          showDivider: true,
                        ),
                        ProfileOption(
                          onPressed: () => _showDeleteAccountDialog(context),
                          label: 'Delete Account',
                          icon: Icons.delete_outline,
                          iconColor: Colors.red,
                          textColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    controller.showLogoutDialog();
  }

  void _showDeleteAccountDialog(BuildContext context) {
    controller.showDeleteAccountDialog();
  }

  void _navigateToEditProfile() {
    Get.toNamed('/candidate/edit-profile');
  }

  void _navigateToExperienceManagement() {
    Get.toNamed('/candidate/experience-management');
  }

  void _navigateToChangePassword() {
    Get.toNamed('/candidate/change-password');
  }

  void _navigateToCompanyProfile() {
    Get.toNamed('/candidate/company-profile');
  }

  void _navigateToNotifications() {
    Get.toNamed('/candidate/notifications');
  }

  void _navigateToPrivacy() {
    Get.toNamed('/candidate/privacy');
  }

  void _navigateToHelp() {
    Get.toNamed('/candidate/help');
  }

  void _navigateToAbout() {
    Get.toNamed('/candidate/about');
  }
}
