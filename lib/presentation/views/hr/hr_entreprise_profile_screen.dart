import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hr_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';

class HREntrepriseProfileScreen extends GetView<HRController> {
  const HREntrepriseProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'Company Profile',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Company Information',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Company Name', 'TechCorp Solutions'),
                    _buildInfoRow('Sector', 'Technology'),
                    _buildInfoRow('Location', 'Tunis, Tunisia'),
                    _buildInfoRow('Website', 'www.techcorp.com'),
                    const SizedBox(height: 16),
                    CustomText(
                      'Description',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      'TechCorp Solutions is a leading technology company specializing in mobile app development and digital solutions.',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Info',
                  'Edit company profile functionality coming soon',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const CustomText(
                'Edit Company Profile',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: CustomText(label, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(value, fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
