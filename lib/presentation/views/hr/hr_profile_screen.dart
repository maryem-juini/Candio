import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/profile_controller.dart';
import '../../../widgets/profile_option.dart';
import '../../../widgets/profile_picture_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class HRProfileScreen extends GetView<ProfileController> {
  const HRProfileScreen({super.key});

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
                                  // Profile picture or Enterprise logo
                                  Obx(() {
                                    final entreprise =
                                        controller.currentEntreprise.value;
                                    if (user.role == 'hr' &&
                                        entreprise?.logoUrl != null) {
                                      // Display enterprise logo in rectangular shape with edit functionality
                                      return Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child:
                                                  entreprise!.logoUrl!
                                                          .startsWith('data:')
                                                      ? Image.memory(
                                                        base64Decode(
                                                          entreprise.logoUrl!
                                                              .split(',')[1],
                                                        ),
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) =>
                                                                _buildLogoPlaceholder(),
                                                      )
                                                      : Image.network(
                                                        entreprise.logoUrl!,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) =>
                                                                _buildLogoPlaceholder(),
                                                      ),
                                            ),
                                          ),
                                          // Edit button for enterprise logo
                                          GestureDetector(
                                            onTap:
                                                () => _showLogoUpdateDialog(
                                                  
                                                  context,
                                                ),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppTheme.primaryColor,
                                                    AppTheme.primaryColor
                                                        .withValues(alpha: 0.8),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.1),
                                                    blurRadius: 6,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      // Display profile picture
                                      return ProfilePicturePicker(
                                        currentImageUrl: user.profilePictureUrl,
                                        size: 100,
                                        onImageUploaded: (url) async {
                                          if (url != null) {
                                            await controller
                                                .updateProfilePicture(url);
                                          }
                                        },
                                        onImageDeleted: () async {
                                          await controller
                                              .deleteProfilePicture();
                                        },
                                      );
                                    }
                                  }),
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
    Get.toNamed('/hr/edit-profile');
  }

  void _navigateToChangePassword() {
    Get.toNamed('/hr/change-password');
  }

  void _navigateToCompanyProfile() {
    Get.toNamed('/hr/company-profile');
  }

  void _navigateToNotifications() {
    Get.toNamed('/hr/notifications');
  }

  void _navigateToPrivacy() {
    Get.toNamed('/hr/privacy');
  }

  void _navigateToHelp() {
    Get.toNamed('/hr/help');
  }

  void _navigateToAbout() {
    Get.toNamed('/hr/about');
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Logo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoUpdateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Modifier le logo de l'entreprise",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Options
              _buildPhotoOption(
                context,
                icon: Icons.camera_alt,
                title: "Prendre une photo",
                onTap: () {
                  Navigator.pop(context);
                  _pickLogoImage(ImageSource.camera);
                },
              ),
              _buildPhotoOption(
                context,
                icon: Icons.photo_library,
                title: "Choisir depuis la galerie",
                onTap: () {
                  Navigator.pop(context);
                  _pickLogoImage(ImageSource.gallery);
                },
              ),
              _buildPhotoOption(
                context,
                icon: Icons.delete,
                title: "Supprimer le logo",
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _deleteLogo();
                },
              ),
              const SizedBox(height: 20),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Annuler",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.primaryColor),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: color ?? AppTheme.primaryColor),
      ),
      onTap: onTap,
    );
  }

  Future<void> _pickLogoImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        await controller.updateEntrepriseLogo(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner l\'image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _deleteLogo() {
    controller.deleteEntrepriseLogo();
  }
}
