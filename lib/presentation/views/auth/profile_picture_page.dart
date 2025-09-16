import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/profile_picture_picker.dart';

class ProfilePicturePage extends StatelessWidget {
  final String? profilePictureUrl;
  final Function(String)? onProfilePictureUploaded;
  final Function(String)? onProfilePictureError;

  const ProfilePicturePage({
    super.key,
    this.profilePictureUrl,
    this.onProfilePictureUploaded,
    this.onProfilePictureError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header
          Column(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Photo de profil',
                style: AppTheme.heading2Bold.copyWith(
                  color: AppTheme.onBackgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Ajoutez une photo pour personnaliser votre compte et faire une meilleure première impression',
                style: AppTheme.body1Medium.copyWith(
                  color: AppTheme.onBackgroundColor.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Profile picture upload with circular container
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ProfilePicturePicker(
                currentImageUrl: profilePictureUrl,
                size: 100,
                enableFirebaseUpload: false, // Don't upload during onboarding
                onImageSelected: (path, url) {
                  if (onProfilePictureUploaded != null && path != null) {
                    onProfilePictureUploaded!(path);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 40), 
        ],
      ),
    );
  }

}
