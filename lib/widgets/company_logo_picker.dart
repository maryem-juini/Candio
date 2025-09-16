import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_theme.dart';

class CompanyLogoPicker extends StatefulWidget {
  final String? currentImageUrl;
  final String? currentImagePath;
  final Function(String? path, String? url)? onImageSelected;
  final Function(String? url)? onImageUploaded;
  final Function()? onImageDeleted;
  final double width;
  final double height;
  final bool showEditButton;
  final bool enableFirebaseUpload;
  final String? userId;

  const CompanyLogoPicker({
    super.key,
    this.currentImageUrl,
    this.currentImagePath,
    this.onImageSelected,
    this.onImageUploaded,
    this.onImageDeleted,
    this.width = 200,
    this.height = 120,
    this.showEditButton = true,
    this.enableFirebaseUpload = true,
    this.userId,
  });

  @override
  State<CompanyLogoPicker> createState() => _CompanyLogoPickerState();
}

class _CompanyLogoPickerState extends State<CompanyLogoPicker> {
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
  void didUpdateWidget(CompanyLogoPicker oldWidget) {
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
        // Company Logo Container
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                _isUploading
                    ? Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widget.width * 0.2,
                              height: widget.width * 0.2,
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
                                fontSize: widget.width * 0.06,
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
                    AppTheme.primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business,
            size: widget.width * 0.2,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Logo',
            style: TextStyle(
              fontSize: widget.width * 0.08,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
                "Changer le logo",
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
                  _pickImage(ImageSource.camera);
                },
              ),
              _buildPhotoOption(
                context,
                icon: Icons.photo_library,
                title: "Choisir depuis la galerie",
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_hasImage())
                _buildPhotoOption(
                  context,
                  icon: Icons.delete,
                  title: "Supprimer le logo",
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
        'Erreur',
        'Impossible de sélectionner l\'image: $e',
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
          _localImagePath = null;
        });

        // Call the upload callback
        widget.onImageUploaded?.call(dataUrl);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger l\'image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _localImagePath = null;
      _currentImageUrl = null;
    });

    widget.onImageDeleted?.call();

    Get.snackbar(
      'Succès',
      'Logo supprimé',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
