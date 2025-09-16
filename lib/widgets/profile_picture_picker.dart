// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_theme.dart';

class ProfilePicturePicker extends StatefulWidget {
  final String? currentImageUrl;
  final String? currentImagePath;
  final Function(String? path, String? url)? onImageSelected;
  final Function(String? url)? onImageUploaded;
  final Function()? onImageDeleted;
  final double size;
  final bool showEditButton;
  final bool enableFirebaseUpload;
  final String? userId;

  const ProfilePicturePicker({
    super.key,
    this.currentImageUrl,
    this.currentImagePath,
    this.onImageSelected,
    this.onImageUploaded,
    this.onImageDeleted,
    this.size = 120,
    this.showEditButton = true,
    this.enableFirebaseUpload = true,
    this.userId,
  });

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  String? _localImagePath;
  String? _currentImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _localImagePath = widget.currentImagePath;
    _currentImageUrl = widget.currentImageUrl;
  }

  @override
  void didUpdateWidget(ProfilePicturePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentImagePath != widget.currentImagePath) {
      _localImagePath = widget.currentImagePath;
    }
    if (oldWidget.currentImageUrl != widget.currentImageUrl) {
      _currentImageUrl = widget.currentImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Profile Picture Container
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child:
                _isUploading
                    ? Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widget.size * 0.3,
                              height: widget.size * 0.3,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Uploading...',
                              style: TextStyle(
                                fontSize: widget.size * 0.08,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : _buildImageWidget(),
          ),
        ),

        // Edit Button
        if (widget.showEditButton)
          GestureDetector(
            onTap:
                _isUploading
                    ? null
                    : () => _showImagePickerBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _isUploading ? Icons.hourglass_empty : Icons.edit,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageWidget() {
    // Show local image if available
    if (_localImagePath != null) {
      return Image.file(
        File(_localImagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    // Show image from URL (network or data URL)
    if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      if (_currentImageUrl!.startsWith('data:')) {
        // Handle base64 data URL
        try {
          final dataUrl = _currentImageUrl!;
          final base64String = dataUrl.split(',')[1];
          final bytes = base64Decode(base64String);
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          );
        } catch (e) {
          return _buildPlaceholder();
        }
      } else {
        // Handle network URL
        return Image.network(
          _currentImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      }
    }

    // Show placeholder
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: widget.size * 0.4,
        color: Colors.grey[400],
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
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
                color: Colors.black.withOpacity(0.2),
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
                "Change Profile Picture",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Options
              _buildPhotoOption(
                context,
                icon: Icons.camera_alt,
                title: "Take a photo",
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              _buildPhotoOption(
                context,
                icon: Icons.photo_library,
                title: "Choose from gallery",
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_hasImage())
                _buildPhotoOption(
                  context,
                  icon: Icons.delete,
                  title: "Delete photo",
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _deleteImage();
                  },
                ),
              const SizedBox(height: 20),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
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

  bool _hasImage() {
    return _localImagePath != null ||
        (_currentImageUrl != null && _currentImageUrl!.isNotEmpty);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        // Update local state immediately for UI feedback
        setState(() {
          _localImagePath = image.path;
        });

        // Call the callback for immediate UI update
        widget.onImageSelected?.call(image.path, null);

        // Upload to Firebase if enabled
        if (widget.enableFirebaseUpload) {
          await _uploadToFirebase(image.path);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadToFirebase(String imagePath) async {
    try {
      setState(() {
        _isUploading = true;
      });

      // Convert image to base64 data URL
      final file = File(imagePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);
        final dataUrl = 'data:image/jpeg;base64,$base64String';

        // Update state with the data URL
        setState(() {
          _currentImageUrl = dataUrl;
          _localImagePath = null; // Clear local path since we now have URL
          _isUploading = false;
        });

        // Call the upload callback
        widget.onImageUploaded?.call(dataUrl);

        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _deleteImage() async {
    try {
      setState(() {
        _localImagePath = null;
        _currentImageUrl = null;
      });

      // Call the delete callback
      widget.onImageDeleted?.call();

      Get.snackbar(
        'Success',
        'Profile picture deleted',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
