import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/candidate_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../core/theme/app_theme.dart';

class CandidateCompanyProfileScreen extends GetView<CandidateController> {
  const CandidateCompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'Companies',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Favorite Companies Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Favorite Companies',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    _buildCompanyCard(
                      'TechCorp Solutions',
                      'Technology',
                      'Tunis, Tunisia',
                      'www.techcorp.com',
                      'Leading technology company specializing in mobile app development and digital solutions.',
                      Icons.favorite,
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildCompanyCard(
                      'InnovateSoft',
                      'Software Development',
                      'Sfax, Tunisia',
                      'www.innovatesoft.com',
                      'Innovative software solutions for modern businesses.',
                      Icons.favorite,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Applied Companies Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Applied Companies',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    _buildCompanyCard(
                      'DigitalFlow',
                      'Digital Marketing',
                      'Monastir, Tunisia',
                      'www.digitalflow.com',
                      'Digital marketing agency helping businesses grow online.',
                      Icons.work,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildCompanyCard(
                      'DataTech',
                      'Data Analytics',
                      'Sousse, Tunisia',
                      'www.datatech.com',
                      'Data analytics and business intelligence solutions.',
                      Icons.work,
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Info',
                  'Browse more companies functionality coming soon',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const CustomText(
                'Browse More Companies',
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

  Widget _buildCompanyCard(
    String name,
    String sector,
    String location,
    String website,
    String description,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Sector', sector),
          _buildInfoRow('Location', location),
          _buildInfoRow('Website', website),
          const SizedBox(height: 8),
          CustomText('Description', fontSize: 14, fontWeight: FontWeight.w600),
          const SizedBox(height: 4),
          CustomText(description, fontSize: 12, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: CustomText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(value, fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
