// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../core/theme/app_theme.dart';

class FileUploadWidget extends StatefulWidget {
  final String label;
  final String? hint;
  final bool isRequired;
  final FileUploadType type;
  final Function(String url)? onFileUploaded;
  final Function(String error)? onError;
  final String? initialUrl;
  final bool isLoading;
  final Function(String filePath)? onFileSelected;
  final Function(Uint8List bytes, String fileName)? onFileSelectedFromBytes;

  const FileUploadWidget({
    super.key,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.type = FileUploadType.image,
    this.onFileUploaded,
    this.onError,
    this.initialUrl,
    this.isLoading = false,
    this.onFileSelected,
    this.onFileSelectedFromBytes,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  String? _selectedFilePath;
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(widget.label, style: AppTheme.body2Semibold),
            if (widget.isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: AppTheme.body2Semibold.copyWith(
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Upload area
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Column(
            children: [
              if (widget.initialUrl != null) ...[
                _buildPreview(),
                const SizedBox(height: 16),
              ],

              if (_selectedFilePath != null || _selectedFileBytes != null) ...[
                _buildSelectedFile(),
                const SizedBox(height: 16),
              ],

              if (widget.isLoading || _isUploading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text('Uploading...', style: AppTheme.body2Medium),
              ] else ...[
                _buildUploadButtons(),
              ],
            ],
          ),
        ),

        // Hint text
        if (widget.hint != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.hint!,
            style: AppTheme.captionMedium.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }

  Widget _buildPreview() {
    if (widget.type == FileUploadType.image && widget.initialUrl != null) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.initialUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: Colors.grey),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade200,
      ),
      child: const Icon(Icons.file_present, color: Colors.grey, size: 40),
    );
  }

  Widget _buildSelectedFile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            widget.type == FileUploadType.image
                ? Icons.image
                : Icons.file_present,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedFileName ?? 'Selected file',
              style: AppTheme.body2Medium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _clearSelection,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: Text(
              'Choose ${widget.type == FileUploadType.image ? 'Image' : 'File'}',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        if (widget.type == FileUploadType.image) ...[
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      if (widget.type == FileUploadType.image) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          setState(() {
            _selectedFilePath = pickedFile.path;
            _selectedFileName = pickedFile.name;
            _selectedFileBytes = null;
          });
          _uploadFile();
        }
      } else {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        );

        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          setState(() {
            _selectedFilePath = file.path;
            _selectedFileName = file.name;
            _selectedFileBytes = file.bytes;
          });
          _uploadFile();
        }
      }
    } catch (e) {
      widget.onError?.call('Failed to pick file: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFilePath = pickedFile.path;
          _selectedFileName = pickedFile.name;
          _selectedFileBytes = null;
        });
        _uploadFile();
      }
    } catch (e) {
      widget.onError?.call('Failed to take photo: $e');
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFilePath == null && _selectedFileBytes == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      if (_selectedFilePath != null) {
        widget.onFileSelected?.call(_selectedFilePath!);
      } else if (_selectedFileBytes != null && _selectedFileName != null) {
        widget.onFileSelectedFromBytes?.call(
          _selectedFileBytes!,
          _selectedFileName!,
        );
      }

      // Clear selection after calling the callback
      _clearSelection();
    } catch (e) {
      widget.onError?.call('Upload failed: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFilePath = null;
      _selectedFileName = null;
      _selectedFileBytes = null;
    });
  }
}

enum FileUploadType { image, document }
